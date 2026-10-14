"""A line-for-line port of CScript::ParseLine (game/shared/ms/script.cpp).

The goal is fidelity, not elegance: the interpreter's structure depends on
details such as which commands it recognises (unknown commands are dropped
*before* a braceless if-body is closed, so the next line becomes the body),
that msstring::findchar_str returns the whole string when it finds nothing,
and that `}` closes a block and then also closes an enclosing single-line
body. Everything here mirrors the C++ so later stages can trust the tree.

Constants are *not* substituted here; tokens keep their names so the output
can refer to them symbolically. Load-time effects (const, setvar, precache,
eventname, repeatdelay) are recorded on the event in source order.
"""

from __future__ import annotations

from typing import Callable

from .source import SourceLine
from .syntax import Cmd, CmdList, Event, Include, LoadOp, ParsedFile, Problem, ScopeDirective, Token

C_SPACE = " \t\n\v\f\r"   # isspace() / scanf("%s") separators
SKIP_STR = " \t"          # iscript.h SKIP_STR
PRECACHE_COMMANDS = {"setmodel", "setviewmodel", "setworldmodel", "setpmodel", "setshield", "attachsprite",
                     "svplaysound", "svplayrandomsound", "svsound.play3d", "precache", "say"}

# Decides whether the engine keeps a command it does not know globally: returns
# (found, conditional) for the entity's own command list (case-insensitive).
EntityCommandLookup = Callable[[str], tuple[bool, bool]]


# --- msstring / sscanf helpers ------------------------------------------------

def scan_token(text: str, pos: int = 0) -> tuple[str | None, int]:
    """sscanf(text+pos, "%s"): skip whitespace, read a run of non-whitespace."""
    i = pos
    while i < len(text) and text[i] in C_SPACE:
        i += 1
    j = i
    while j < len(text) and text[j] not in C_SPACE:
        j += 1
    return (text[i:j], j) if j > i else (None, pos)


def thru_char(text: str, chars: str) -> str:
    for i, ch in enumerate(text):
        if ch in chars:
            return text[:i]
    return text


def findchar_str(text: str, chars: str) -> str:
    """Substring from the first char in `chars`; the WHOLE string if none is found."""
    for i, ch in enumerate(text):
        if ch in chars:
            return text[i:]
    return text


def skip(text: str, chars: str) -> str:
    i = 0
    while i < len(text) and text[i] in chars:
        i += 1
    return text[i:]


def leading_ws_len(text: str, chars: str = " \t\n\r") -> int:
    i = 0
    while i < len(text) and text[i] in chars:
        i += 1
    return i


class Parser:
    def __init__(self, name: str, global_commands: dict[str, bool], entity_lookup: EntityCommandLookup):
        self.file = ParsedFile(name)
        self.global_commands = global_commands   # name -> conditional (case-sensitive map, like m_GlobalCmdHash)
        self.entity_lookup = entity_lookup
        self.event: Event | None = None
        self.cmds: CmdList | None = None
        self.parents: list[CmdList] = []
        self.pending_comments: list[str] = []
        self.pending_blank = False      # an empty line since the last command
        self.line_comment = ""
        self.line_number = 0
        self.first_cmd_on_line: Cmd | None = None

    # -- entry -----------------------------------------------------------------

    def parse(self, lines: list[SourceLine]) -> ParsedFile:
        for line in lines:
            self.line_number = line.number
            self.line_comment = line.comment
            self.first_cmd_on_line = None
            if not line.code:
                if line.comment:
                    self._comment_only(line.comment)
                elif not line.raw.strip():
                    self.pending_blank = True
                continue
            items_before = len(self.file.items)
            loads_before = len(self.event.load_ops) if self.event else 0
            self.parse_line(line.code)
            consumed = (self.first_cmd_on_line is not None or len(self.file.items) != items_before
                        or (self.event is not None and len(self.event.load_ops) != loads_before))
            if line.comment and not consumed:
                self.pending_comments.append(line.comment)
            if self.first_cmd_on_line is None:
                self.pending_blank = False     # braces and load-time lines end a paragraph too
        if self.event is not None:
            self.problem("event is not closed with }")
        if self.pending_comments and self.event is None and self.file.items:
            last = self.file.items[-1]
            if isinstance(last, Event):
                last.trailing_comments.extend(self.pending_comments)
        return self.file

    def problem(self, message: str) -> None:
        self.file.problems.append(Problem(self.line_number, message))

    def _comment_only(self, comment: str) -> None:
        if not self.file.items and self.event is None:
            self.file.header_comments.append(comment)
        else:
            self.pending_comments.append(comment)

    def _take_comments(self) -> list[str]:
        taken, self.pending_comments = self.pending_comments, []
        return taken

    # -- ParseLine ---------------------------------------------------------------

    def parse_line(self, line: str) -> int:
        test_command, end = scan_token(line)
        if test_command is None:
            return 0
        test_command = test_command[:127]
        offset = end + leading_ws_len(line[end:])
        rest = line[offset:]
        lower = test_command.lower()

        if lower == "{":
            return self._open_brace(rest)
        if lower == "#include":
            self._include(rest)
            return 1
        if lower == "#scope":
            scope = thru_char(rest, SKIP_STR)
            if scope in ("client", "server", "shared"):
                self.file.items.append(ScopeDirective(scope, self.line_number))
            else:
                self.problem(f"#scope '{scope}' is not valid")
            return 1

        if self.event is None:
            self.problem("command outside of an event (missing {)")
            return 0

        keep = False
        if lower == "}":
            self._close_brace()
        elif lower[:2] == "if":
            if "(" not in test_command and not rest.startswith("("):
                keep = True
            else:
                result = self._new_if(test_command, rest)
                if result == 2:
                    return 2
        elif lower == "else":
            result = self._else(rest)
            if result == 2:
                return 2
        elif lower == "eventname":
            name, _ = scan_token(rest)
            if name:
                self.event.name = name
                self.event.load_ops.append(LoadOp("eventname", name, "", self.line_number))
        elif lower == "repeatdelay":
            delay, _ = scan_token(rest)
            if self.event.repeat_delay is None and delay:
                self.event.repeat_delay = delay
            self.event.load_ops.append(LoadOp("repeatdelay", delay or "", "", self.line_number))
            keep = True
        elif lower in ("setvar", "const"):
            self._load_time_var(lower, rest)
            if lower == "setvar":
                keep = True
        elif lower == "removeconst":
            self.event.load_ops.append(LoadOp("removeconst", thru_char(rest, SKIP_STR), "", self.line_number,
                                              in_command_list=self.cmds))
        elif lower == "setvard":
            test_command = "setvar"
            keep = True
        elif lower == "const_ovrd":
            name = thru_char(rest, SKIP_STR)
            value_text = skip(rest[len(name):], SKIP_STR)
            value, quoted = self._load_value(value_text)
            self.event.load_ops.append(LoadOp("const_ovrd", name, value, self.line_number, quoted, self.cmds))
            keep = True
        elif lower in PRECACHE_COMMANDS:
            self.event.load_ops.append(LoadOp("precache", lower, rest, self.line_number, in_command_list=self.cmds))
            if lower != "precache":
                keep = True
        else:
            keep = True

        if keep:
            if not self._store_command(test_command, rest):
                return 0

        self._end_of_line()
        return 1

    # -- pieces of ParseLine -----------------------------------------------------

    def _open_brace(self, rest: str) -> int:
        if self.event is None:
            scope = None
            override = False
            name = None
            words = rest.split()
            for word in words:
                if word == "[client]":
                    scope = "client"
                elif word == "[server]":
                    scope = "server"
                elif word == "[shared]":
                    scope = "shared"
                elif word == "[override]":
                    override = True
                else:
                    name = word
            event = Event(name, scope, override, self.line_number)
            event.header_comment = self.line_comment
            event.leading_comments = self._take_comments()
            self.file.items.append(event)
            self.event = event
            self.cmds = event.commands
            self.parents = []
            return 1
        if not self.parents:
            self.problem('"{" following a command that is not a conditional - the block is ignored')
            return 0
        self.cmds.single = False
        return 1

    def _close_brace(self) -> None:
        if not self.parents:
            if self.pending_comments:
                self.event.trailing_comments.extend(self._take_comments())
            self.event = None
            self.cmds = None
        else:
            self.cmds = self.parents.pop()

    def _include(self, rest: str) -> None:
        file_name = thru_char(rest, SKIP_STR)
        include = Include("", self.line_number)
        line = rest
        if file_name.startswith("["):
            include.server_only = "[server]" in file_name
            include.client_only = "[client]" in file_name and not include.server_only
            include.casual = "[casual]" in file_name
            line = skip(line[len(file_name):], SKIP_STR)
            file_name = thru_char(line, SKIP_STR)
        include.path = file_name
        after = thru_char(skip(line[len(file_name):], SKIP_STR), SKIP_STR)
        include.allow_duplicate = "allowduplicate" in after
        include.comment = self.line_comment
        include.leading_comments = self._take_comments()
        self.file.items.append(include)

    def _new_if(self, test_command: str, rest: str) -> int:
        cmd = self._add_cmd("if()", True)
        cmd.new_style = True
        param_str = rest[1:] if rest.startswith("(") else rest
        param_str = skip(param_str, SKIP_STR)
        for i in range(3):
            cmd.args.append(Token(thru_char(param_str, SKIP_STR)))
            param_str = skip(findchar_str(param_str, SKIP_STR), SKIP_STR)
            if i == 0 and param_str.startswith(")"):
                break

        if not param_str.startswith(")"):
            self.problem("if() statement missing ')' - the condition has no body")
            return 1

        self.parents.append(self.cmds)
        cmd.if_list = CmdList(single=True)
        self.cmds = cmd.if_list
        param_str = skip(findchar_str(param_str, SKIP_STR), SKIP_STR)
        if not param_str or param_str.startswith(")"):
            return 2
        return 2 if self.parse_line(param_str) == 2 else 1

    def _else(self, rest: str) -> int:
        if not self.cmds.cmds or not self.cmds.cmds[-1].conditional:
            self.problem('"else" following a command that is not a conditional')
            return 1
        parent = self.cmds.cmds[-1]
        self.parents.append(self.cmds)
        else_list = CmdList(single=True)
        parent.else_lists.append(else_list)
        self.cmds = else_list
        if rest and rest[0] not in C_SPACE:
            return 2 if self.parse_line(rest) == 2 else 1
        return 2

    def _load_value(self, text: str) -> tuple[str, bool]:
        if text.startswith('"'):
            return thru_char(text[1:], '"'), True
        return thru_char(text, SKIP_STR), False

    def _load_time_var(self, kind: str, rest: str) -> None:
        name = thru_char(rest, SKIP_STR)
        value, quoted = self._load_value(skip(rest[len(name):], SKIP_STR))
        op = LoadOp(kind, name, value, self.line_number, quoted, self.cmds)
        if kind == "const":
            # setvar is also stored as a command, which carries the comment
            op.comment = self.line_comment
            op.leading_comments = self._take_comments()
        self.event.load_ops.append(op)

    def _lookup(self, name: str) -> tuple[bool, bool]:
        if name in self.global_commands:
            return True, self.global_commands[name]
        return self.entity_lookup(name)

    def _add_cmd(self, name: str, conditional: bool) -> Cmd:
        cmd = Cmd(name, [], self.line_number, conditional)
        if self.first_cmd_on_line is None:
            self.first_cmd_on_line = cmd
            cmd.comment = self.line_comment
            cmd.leading_comments = self._take_comments()
            cmd.blank_before, self.pending_blank = self.pending_blank, False
        self.cmds.cmds.append(cmd)
        return cmd

    def _store_command(self, name: str, rest: str) -> bool:
        found, conditional = self._lookup(name)
        if not found:
            self.file.problems.append(Problem(self.line_number, f"unknown command '{name}' - the engine drops this line", name))
            return False
        cmd = self._add_cmd(name, conditional)
        cmd.args = parse_params(rest)
        return True

    def _end_of_line(self) -> None:
        if self.cmds is not None and self.cmds.single:
            if self.parents:
                self.cmds = self.parents.pop()
            else:
                self.problem("single-line body returned to a parent list that does not exist")


def parse_params(text: str) -> list[Token]:
    """The command parameter loop at the end of ParseLine."""
    tokens: list[Token] = []
    pos = leading_ws_len(text)
    while True:
        token, end = scan_token(text, pos)
        if token is None:
            break
        if token.startswith("//"):
            break
        if token.startswith('"'):
            close = text.find('"', pos + 1)
            if close == pos + 1:                  # "" - sscanf("%[^\"]") fails, the token stays as typed
                tokens.append(Token('""'))
                pos = close + 1
            else:
                if close == -1:
                    close = len(text)
                tokens.append(Token(text[pos + 1:close], quoted=True))
                pos = close + 1
        else:
            tokens.append(Token(token))
            pos = end
        pos += leading_ws_len(text[pos:])
    return tokens


def parse_file(name: str, lines: list[SourceLine], global_commands: dict[str, bool],
               entity_lookup: EntityCommandLookup) -> ParsedFile:
    return Parser(name, global_commands, entity_lookup).parse(lines)
