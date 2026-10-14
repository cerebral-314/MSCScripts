"""End-to-end conversion of small scripts: structure, semantics and readability of the output."""

import re
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
        out, _ = convert({"npc/a": "{ test_event_without_names\n if PARAM1 equals x\n hp 5\n}"}, "npc/a")
        self.assertIn('if (param1 != "x")\nreturn;\nSetHealth(5.0f);', squash(out))

    def test_writing_a_parameter_changes_the_parameter(self):
        out, _ = convert({"npc/a": "{ test_event_without_names\n local L_ORIG PARAM1\n multiply PARAM1 0.5\n"
                                   " hp PARAM1\n gold L_ORIG\n $get(ent_me,PARAM2)\n saytext $get(ent_me,PARAM2)\n}"},
                         "npc/a")
        text = squash(out)
        m = re.search(r"void OnTestEventWithoutNames\(float (\w+) = 0\.0f", text)
        first = m.group(1)
        self.assertIn(f"{first} *= 0.5f;", text)
        self.assertNotIn('LegacyCommand("multiply"', text)
        self.assertRegex(text, rf"float \w+ = {first};")     # the copy is a real local: PARAM1 changes later
        self.assertIn("GetProp(ENT_ME, param2)", text)       # the property named by PARAM2's value

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
        self.assertIn('string t = "a" + param1;\nSayText(t);', squash(out))

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
        self.assertIn("float yaw = Clamp(-TURN, -TURN, TURN);", out)   # one float overload: nothing truncated
        self.assertNotIn("int Clamp", out)

    def test_blank_lines_of_the_source_are_kept(self):
        out, _ = convert({"npc/a": "{ ev\n hp 1\n gold 2\n\n // then\n name x\n}"}, "npc/a")
        self.assertIn('\t\tSetGold(2);\n\n\t\t// then\n\t\tSetName("x");', out)

    def test_step_by_step_updates_become_one_expression(self):
        out, _ = convert({"npc/a": "{ ev\n setvard STEP 359\n divide STEP PARAM1\n local L_D 10\n add L_D PARAM2\n"
                                   " multiply L_D 2\n hp L_D\n}\n{ x\n hp STEP\n}"}, "npc/a")
        text = squash(out)
        self.assertIn("void OnEv(float param1 = 0.0f, float param2 = 0.0f)", text)   # typed by the math they feed
        self.assertIn("STEP = Divide(359.0f, param1);", text)
        self.assertIn("float d = (10.0f + param2) * 2.0f;", text)

    def test_a_variable_set_only_by_math_is_a_field(self):
        out, _ = convert({"npc/a": "{ ev\n add COUNT 1\n local L_N COUNT\n if ( COUNT > 1 ) hp 1\n saytext L_N\n}"},
                         "npc/a")
        self.assertIn("COUNT += 1.0f;", out)
        self.assertIn("if (COUNT > 1", out)
        self.assertNotIn('"COUNT"', out.split("void OnEv")[1])

    def test_vector_commands_on_a_text_variable_convert_it(self):
        out, _ = convert({"npc/a": "{ ev\n local L_P PARAM1\n vectoradd L_P $relpos(0,10,0)\n setvard POS L_P\n"
                                   " setvard POS none\n}"}, "npc/a")
        self.assertNotIn("LegacyCommand", out)
        self.assertIn("Vec(", out)

    def test_vectormultiply_on_one_axis_keeps_only_that_axis(self):
        out, project = convert({"npc/a": "{ ev\n local L_V $relpos(1,2,3)\n vectormultiply L_V x 2\n setvard V L_V\n}"},
                               "npc/a")
        self.assertIn("Scale(", out)
        self.assertIn("Vector3(2.0f, 0.0f, 0.0f)", out)
        self.assertTrue(any("keeps only the x component" in q.message for q in project.quirks))

    def test_a_local_set_on_every_path_needs_no_starting_value(self):
        out, _ = convert({"npc/a": "{ ev\n if ( PARAM1 equals a )\n {\n local L_M 1\n }\n else\n {\n local L_M 2\n }\n"
                                   " saytext L_M\n local L_N 5\n if ( PARAM2 equals b ) local L_N 6\n saytext L_N\n}"}, "npc/a")
        self.assertRegex(out, r"\n\t\t(int|float|string) m;\n")        # both branches set it
        self.assertNotRegex(out, r"\b(int|float|string) n;")           # one branch only: keeps its value

    def test_a_test_for_an_omitted_parameter_is_an_emptiness_test(self):
        out, _ = convert({"npc/a": "{ ev\n local L_MIN PARAM2\n if ( L_MIN equals 'PARAM2' ) local L_MIN 1\n"
                                   " if ( PARAM3 startswith PARAM ) hp 2\n if PARAM4 isnot 'PARAM4'\n hp 3\n"
                                   " saytext L_MIN\n}"}, "npc/a")
        self.assertNotIn('"PARAM', out)                 # no "PARAM2" defaults or comparisons
        text = squash(out)
        self.assertIn(".isEmpty())", text)
        self.assertRegex(text, r"if \(\w+\.isEmpty\(\)\)\n\w+ = \"1\";")
        self.assertRegex(text, r"if \(\w+\.isEmpty\(\)\)\nreturn;")    # isnot 'PARAM4' guard

    def test_relpos_forms(self):
        out, _ = convert({"npc/a": "{ ev\n local L_A $relpos(0,10,0)\n local L_B $relpos($vec(0,PARAM1,0),$vec(0,5,40))\n"
                                   " setvard A L_A\n setvard B L_B\n}"}, "npc/a")
        self.assertIn("RelativePosition(Vector3(0.0f, 10.0f, 0.0f))", out)
        # the offset of the two-vector form is kept; PARAM1 is a float because $vec takes numbers
        self.assertIn("RelativePosition(Vector3(0.0f, param1, 0.0f), Vector3(0.0f, 5.0f, 40.0f))", out)

    def test_parameter_types_follow_their_uses(self):
        files = {"npc/a": "{ ev\n setvard SPEED PARAM1\n local L_N PARAM2\n add L_N 1\n if ( PARAM3 > 5 ) hp 1\n"
                          " local L_P PARAM4\n vectoradd L_P $relpos(0,1,0)\n setvard POS L_P\n saytext PARAM5\n}\n"
                          "{ x\n add SPEED 2\n callevent ev 1 2 3 (0,0,0) hello\n}"}
        out, _ = convert(files, "npc/a")
        self.assertRegex(out, r"void OnEv\(float \w+ = 0\.0f, float \w+ = 0\.0f, (int \w+ = 0|float \w+ = 0\.0f), "
                              r"Vector3 \w+ = Vector3\(\), string \w+ = \"\"\)")

    def test_local_named_like_a_parameter_sets_the_parameter(self):
        out, _ = convert({"npc/a": "{ test_event_without_names\n if ( PARAM2 equals 'PARAM2' ) local PARAM2 5\n"
                                   " saytext PARAM2\n}"}, "npc/a")
        self.assertNotIn('"PARAM2"', out)
        self.assertRegex(squash(out), r"if \((\w+)\.isEmpty\(\)\)\n\1 = \"5\";\nSayText\(\1\);")

    def test_a_parameter_tested_for_omission_stays_text(self):
        out, _ = convert({"npc/a": "{ test_event_without_names\n if ( PARAM1 !startswith PARAM )\n {\n setvard SIZE PARAM1\n"
                                   " }\n}\n{ x\n add SIZE 1\n callevent test_event_without_names 15\n}"}, "npc/a")
        self.assertIn('OnTestEventWithoutNames(string param1 = "")', out)
        self.assertIn("if (!param1.isEmpty())", out)

    def test_entity_ids_stay_text(self):
        files = {"npc/a": "{\n setvard THE_PLAYER 0\n}\n{ test_event_without_names\n setvard THE_PLAYER PARAM1\n"
                          " hp $get(PARAM2,hp)\n}\n{ x\n callevent test_event_without_names 0 1\n}"}
        out, _ = convert(files, "npc/a")
        self.assertIn("string THE_PLAYER", out)        # reset with 0, but it holds what callers pass
        self.assertIn('OnTestEventWithoutNames(string param1 = "", string param2 = "")', out)   # $get(PARAM2,...)

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
