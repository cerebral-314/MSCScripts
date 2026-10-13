"""The parser must build the same structure as CScript::ParseLine, quirks included."""

import unittest

from msc_transpiler import engine
from msc_transpiler.parser import parse_file, parse_params
from msc_transpiler.source import read_lines


def parse(text: str, kind: str = engine.MONSTER):
    return parse_file("test", read_lines(text), engine.global_commands(), engine.entity_lookup(kind))


def names(cmd_list):
    return [c.name for c in cmd_list.cmds]


class ParserTests(unittest.TestCase):
    def test_comment_ends_line_even_inside_quotes(self):
        pf = parse('{ ev\n saytext "see http://x.com"\n}')
        cmd = pf.events[0].commands.cmds[0]
        self.assertEqual(cmd.args[0].text, "see http:")

    def test_old_style_if_is_a_guard_without_body(self):
        pf = parse("{ ev\n if X equals 1\n hp 5\n}")
        cmds = pf.events[0].commands.cmds
        self.assertEqual(names(pf.events[0].commands), ["if", "hp"])
        self.assertTrue(cmds[0].conditional)
        self.assertFalse(cmds[0].new_style)

    def test_new_style_if_takes_next_line_as_body(self):
        pf = parse("{ ev\n if ( X )\n hp 5\n gold 1\n}")
        top = pf.events[0].commands.cmds
        self.assertEqual([c.name for c in top], ["if()", "gold"])
        self.assertEqual(names(top[0].if_list), ["hp"])

    def test_nested_braceless_ifs_absorb_the_following_line(self):
        # only one level is popped after the inner body, so `gold` belongs to the outer if
        pf = parse("{ ev\n if ( A )\n if ( B )\n hp 5\n gold 1\n stepsize 3\n}")
        outer = pf.events[0].commands.cmds[0]
        self.assertEqual(names(outer.if_list), ["if()", "gold"])
        self.assertEqual(names(pf.events[0].commands), ["if()", "stepsize"])

    def test_closing_brace_also_closes_a_single_line_parent(self):
        pf = parse("{ ev\n if ( A )\n if ( B )\n {\n hp 5\n }\n gold 1\n}")
        self.assertEqual(names(pf.events[0].commands), ["if()", "gold"])

    def test_else_if_chain_is_flat_on_the_first_if(self):
        pf = parse("{ ev\n if ( A ) hp 1\n else if ( B ) hp 2\n else hp 3\n}")
        cmds = pf.events[0].commands.cmds
        self.assertEqual(len(cmds), 1)
        self.assertEqual(len(cmds[0].else_lists), 2)
        self.assertEqual(names(cmds[0].else_lists[0]), ["if()"])
        self.assertEqual(names(cmds[0].else_lists[1]), ["hp"])

    def test_unknown_command_is_dropped_before_the_body_closes(self):
        pf = parse("{ ev\n if ( A )\n notacommand x\n hp 5\n}")
        cmds = pf.events[0].commands.cmds
        self.assertEqual(names(cmds[0].if_list), ["hp"])
        self.assertTrue(any(p.dropped_command == "notacommand" for p in pf.problems))

    def test_item_commands_only_exist_for_items(self):
        monster = parse("{ ev\n sethudsprite trade letter\n}", engine.MONSTER)
        item = parse("{ ev\n sethudsprite trade letter\n}", engine.ITEM)
        self.assertEqual(names(monster.events[0].commands), [])
        self.assertEqual(names(item.events[0].commands), ["sethudsprite"])

    def test_quoted_parameters_keep_spaces(self):
        tokens = parse_params('PARAM1 "Item Restricted" OUT_MSG')
        self.assertEqual([t.text for t in tokens], ["PARAM1", "Item Restricted", "OUT_MSG"])
        self.assertTrue(tokens[1].quoted)

    def test_malformed_if_repeats_its_operand(self):
        # msstring::findchar_str returns the whole string when no space follows
        pf = parse("{ ev\n if ( X)\n hp 1\n}")
        cmd = pf.events[0].commands.cmds[0]
        self.assertEqual([t.text for t in cmd.args], ["X)", "X)", "X)"])

    def test_load_time_operations(self):
        pf = parse("{\n const A 5\n setvar B \"x y\"\n setvard C 1\n}")
        ops = [(o.kind, o.name, o.value) for o in pf.events[0].load_ops]
        self.assertEqual(ops, [("const", "A", "5"), ("setvar", "B", "x y")])
        self.assertEqual(names(pf.events[0].commands), ["setvar", "setvar"])   # setvar + setvard (renamed)

    def test_event_header_modifiers_and_eventname(self):
        pf = parse("{ [server] [override] first\n eventname second\n}")
        event = pf.events[0]
        self.assertEqual(event.name, "second")
        self.assertEqual(event.explicit_scope, "server")
        self.assertTrue(event.override)

    def test_include_flags(self):
        pf = parse("#include [server][casual] monsters/base allowduplicate\n")
        inc = pf.includes[0]
        self.assertEqual(inc.path, "monsters/base")
        self.assertTrue(inc.server_only and inc.casual and inc.allow_duplicate)

    def test_include_reads_only_one_flag_token(self):
        # the engine takes the token after the first [..] as the file name
        pf = parse("#include [server] [casual] monsters/base\n")
        self.assertEqual(pf.includes[0].path, "[casual]")


if __name__ == "__main__":
    unittest.main()
