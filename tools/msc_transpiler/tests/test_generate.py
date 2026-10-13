"""End-to-end conversion of small scripts: structure, semantics and readability of the output."""

import tempfile
import unittest
from pathlib import Path

from msc_transpiler.corpus import Corpus
from msc_transpiler.generate import Project


def convert(files: dict[str, str], target: str) -> tuple[str, Project]:
    with tempfile.TemporaryDirectory() as tmp:
        root = Path(tmp)
        for name, text in files.items():
            path = root / f"{name}.script"
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text, encoding="latin-1")
        project = Project(Corpus(root))
        return project.generate(target), project


def squash(text: str) -> str:
    return "\n".join(line.strip() for line in text.splitlines() if line.strip())


class GenerateTests(unittest.TestCase):
    def test_top_level_guard_becomes_early_return(self):
        out, _ = convert({"npc/a": "{ game_spawn\n if PARAM1 equals x\n hp 5\n}"}, "npc/a")
        self.assertIn('if (param1 != "x")\nreturn;\nSetHealth(5.0f);', squash(out))

    def test_nested_guard_wraps_the_rest_of_its_block(self):
        out, _ = convert({"npc/a": "{ ev\n if ( A_SET )\n {\n if B_SET\n hp 5\n }\n gold 1\n}\n"
                                   "{ x\n setvard A_SET 1\n setvard B_SET 1\n}"}, "npc/a")
        self.assertIn("if (A_SET && B_SET)\nSetHealth(5.0f);\nSetGold(1);", squash(out))

    def test_else_if_chain(self):
        out, _ = convert({"npc/a": "{ ev\n local L 2\n if ( L == 1 ) hp 1\n else if ( L == 2 ) hp 2\n else hp 3\n}"},
                         "npc/a")
        self.assertIn("if (l == 1)\nSetHealth(1.0f);\nelse if (l == 2)\nSetHealth(2.0f);\nelse\nSetHealth(3.0f);",
                      squash(out))

    def test_local_assigned_in_a_block_is_declared_once_at_the_top(self):
        out, _ = convert({"npc/a": "{ ev\n if ( PARAM1 equals a ) local L_FLAG 1\n if L_FLAG\n hp 1\n}"}, "npc/a")
        text = squash(out)
        self.assertIn("bool flag = false;", text)
        self.assertIn('if (param1 == "a")\nflag = true;', text)
        self.assertEqual(text.count("bool flag"), 1)

    def test_text_is_folded(self):
        out, _ = convert({"npc/a": "{ ev\n name Bertold the Fletcher\n}"}, "npc/a")
        self.assertIn('SetName("Bertold the Fletcher");', out)

    def test_stradd_builds_one_string(self):
        out, _ = convert({"npc/a": '{ ev\n local L_T "a"\n stradd L_T PARAM1\n saytext L_T\n}'}, "npc/a")
        self.assertIn('string t = "a";\nt += param1;\nSayText(t);', squash(out))

    def test_return_clear_typo_is_reported_and_kept(self):
        out, project = convert({"npc/a": "{ f\n return **clear**\n return 5\n}\n{ ev\n local X $func(f)\n}"}, "npc/a")
        self.assertIn('AppendResult(result, "**clear**")', out)
        self.assertTrue(any("**clear**" in q.message for q in project.quirks))

    def test_delayed_and_runtime_callevent(self):
        out, _ = convert({"npc/a": "{ ev\n callevent 1.5 other\n callevent PARAM1 other\n}\n{ other\n hp 1\n}"},
                         "npc/a")
        self.assertIn('CallEventDelayed(1.5f, "other");', out)
        self.assertIn('CallEventOrDelay(param1, { "other" });', out)

    def test_calleventloop_passes_the_iteration(self):
        out, _ = convert({"npc/a": "{ ev\n calleventloop 3 step\n}\n{ step\n local I game.script.iteration\n}"},
                         "npc/a")
        self.assertIn("for (loopIteration = 0; loopIteration < 3; loopIteration++)", out)
        self.assertIn("int i = loopIteration;", out)

    def test_self_call_is_ignored_like_the_engine(self):
        out, project = convert({"npc/a": "{ ev\n callevent ev\n}"}, "npc/a")
        self.assertIn("(no effect in .script: an event cannot call itself)", out)

    def test_include_becomes_mixin_and_handlers_run_in_parse_order(self):
        files = {
            "npc/base": "{\n const SOUND a.wav\n}\n{ game_spawn\n hp 10\n}",
            "npc/child": "{\n const SOUND b.wav\n}\n#include npc/base\n{ game_spawn\n gold 5\n}",
        }
        base, _ = convert(files, "npc/base")
        child, _ = convert(files, "npc/child")
        self.assertIn("mixin class Base", base)
        self.assertIn("void Base_OnGameSpawn()", base)
        text = squash(child)
        self.assertIn('[script "npc/base"]\nshared class BaseScript : ScriptEntity, Base', squash(base))
        self.assertIn("class Child : BaseScript", text)
        self.assertIn('Child()\n{\nSOUND = "b.wav";\n}', text)    # first definition wins
        self.assertIn("void OnGameSpawn()\n{\nBase_OnGameSpawn(); // npc/base\nSetGold(5);", text)

    def test_override_drops_earlier_handlers(self):
        files = {
            "npc/base": "{ game_spawn\n hp 10\n}",
            "npc/child": "#include npc/base\n{ [override] game_spawn\n gold 5\n}",
        }
        child, _ = convert(files, "npc/child")
        self.assertNotIn("Base_OnGameSpawn();", child)

    def test_latin1_text_keeps_its_bytes(self):
        out, _ = convert({"npc/a": "{ ev\n saytext \xafNONE\xaf\n}"}, "npc/a")
        self.assertIn('SayText("\\xAFNONE\\xAF");', out)
        out.encode("ascii")     # nothing that is not plain ASCII reaches the source

    def test_capvar_clamps_as_floats(self):
        out, _ = convert({"npc/a": "{\n const TURN 4\n}\n{ ev\n local L_YAW $neg(TURN)\n capvar L_YAW $neg(TURN) TURN\n"
                                   " local L_N 2\n capvar L_N 1 3\n setvard COUNT L_N\n}"}, "npc/a")
        self.assertIn("Clamp(yaw, -TURN, TURN)", out)    # one float overload: no int truncation to choose
        self.assertNotIn("int Clamp", out)

    def test_nothing_is_written_after_a_return(self):
        from msc_transpiler.emit import emit_method
        from msc_transpiler.ir import Line, Method, Return
        method = Method("F", [], "string", [Line("A()"), Return("result"), Return("result")])
        self.assertEqual(squash("\n".join(emit_method(method))), "string F()\n{\nA();\nreturn result;\n}")

    def test_unset_variable_condition_is_reported(self):
        out, project = convert({"npc/a": "{ ev\n if NEVER_SET\n hp 1\n}"}, "npc/a")
        self.assertTrue(any("NEVER_SET is never set" in q.message for q in project.quirks))

    def test_dispatch_and_variables_by_name(self):
        out, _ = convert({"npc/a": "{\n setvard COUNT 0\n}\n{ game_touch\n add COUNT 1\n}"}, "npc/a")
        self.assertIn('if (name == "game_touch") { OnGameTouch(Param(params, 0)); return true; }', out)
        # variables are reached by name through the engine (fields keep their .script names)
        self.assertNotIn("GetLegacyVar", out)
        self.assertIn("float COUNT = 0.0f;", out)

    LIBRARY = {
        "npc/base": "{ game_spawn\n hp 10\n}\n{ npc_struck\n callevent flinch\n callevent maybe\n}\n{ flinch\n hp 1\n}",
        "npc/plain": "#include npc/base\n{ game_think\n gold 1\n}",
    }

    def test_library_declares_its_events_and_dispatches_them(self):
        base, _ = convert(self.LIBRARY, "npc/base")
        text = squash(base)
        self.assertIn("void OnGameSpawn() { Base_OnGameSpawn(); } // game_spawn", text)
        self.assertIn("void OnMaybe() {} // maybe", text)       # called here, handled nowhere
        self.assertIn("bool Base_DispatchEvent(const string &in name, const array<string> &in params)", text)
        self.assertIn('if (name == "flinch") { OnFlinch(); return true; }', text)

    def test_leaf_uses_the_included_event_methods(self):
        leaf, _ = convert(self.LIBRARY, "npc/plain")
        self.assertNotIn("OnGameSpawn", leaf)
        self.assertNotIn("OnFlinch", leaf)
        text = squash(leaf)
        self.assertIn("class Plain : BaseScript", text)
        self.assertIn('if (name == "game_think") { OnGameThink(); return true; }\n'
                      'return BaseScript::DispatchEvent(name, params);', text)

    def test_leaf_declares_events_two_includes_handle(self):
        files = dict(self.LIBRARY, **{
            "npc/other": "{ game_spawn\n gold 2\n}",
            "npc/both": "#include npc/base\n#include npc/other",
        })
        leaf, _ = convert(files, "npc/both")
        text = squash(leaf)
        self.assertIn("void OnGameSpawn()\n{\nBase_OnGameSpawn(); // npc/base\nOther_OnGameSpawn(); // npc/other\n}", text)
        self.assertNotIn("void OnFlinch", text)
        self.assertIn("class Both : BaseScript, Other", text)
        self.assertIn("return Other_DispatchEvent(name, params)\n|| BaseScript::DispatchEvent(name, params);", text)

    def test_override_wins_over_the_first_mixin(self):
        files = {
            "npc/a": "{ game_spawn\n hp 1\n}",
            "npc/b": "#include npc/a\n{ [override] game_spawn\n hp 2\n}",
            "npc/c": "{ game_think\n hp 3\n}",
            "npc/b_first": "#include npc/b",
            "npc/a_first": "#include npc/c\n#include npc/a\n#include npc/b",
        }
        b, _ = convert(files, "npc/b")
        self.assertIn("shared class BScript : AScript, B", b)  # B's mixin method overrides A's inherited one
        b_first, _ = convert(files, "npc/b_first")
        self.assertNotIn("void OnGameSpawn", b_first)
        # mixin semantics alone: C's and A's methods come before B's, so the override needs declaring
        a_first, project = convert(files, "npc/a_first")
        self.assertIn("class AFirst : BScript, C", a_first)
        self.assertNotIn("void OnGameSpawn", a_first)
        self.assertEqual(project.wiring.class_resolved("npc/a_first")["game_spawn"], ["B_OnGameSpawn"])

    def test_inherited_field_with_another_value_is_set_in_the_constructor(self):
        files = {
            "npc/base": "{\n const SPEED 10\n}\n{ game_spawn\n hp SPEED\n}",
            "npc/fast": "{\n const SPEED 50\n}\n#include npc/base",
            "npc/same": "#include npc/base",
        }
        fast, _ = convert(files, "npc/fast")
        self.assertIn("Fast()\n{\nSPEED = 50;\n}", squash(fast))
        self.assertNotIn("int SPEED", fast)                    # inherited fields are never declared again
        same, _ = convert(files, "npc/same")
        self.assertNotIn("SPEED", same)


if __name__ == "__main__":
    unittest.main()
