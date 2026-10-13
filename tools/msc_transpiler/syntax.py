"""The parsed form of a .script file, shaped like the engine's own structures.

`parser.py` builds these by replaying CScript::ParseLine, so every quirk of the
interpreter (guard ifs, single-command bodies, else chains, load-time
const/setvar) is represented exactly as the engine would run it. Later stages
turn this into readable AngelScript.
"""

from __future__ import annotations

from dataclasses import dataclass, field


@dataclass
class Token:
    text: str
    quoted: bool = False  # came from "..." (the engine drops the quotes)


@dataclass
class Cmd:
    """One stored command (LegacyScriptCmd)."""
    name: str                     # command word as written ("if()" for parenthesised ifs)
    args: list[Token]
    line: int
    conditional: bool = False     # if / if() / see
    new_style: bool = False       # if ( ... ) - has a body; old-style `if a op b` is a guard
    if_list: CmdList | None = None
    else_lists: list[CmdList] = field(default_factory=list)
    comment: str = ""             # trailing comment on the same source line
    leading_comments: list[str] = field(default_factory=list)


@dataclass
class CmdList:
    """A command list (legacy_scriptcmd_list); `single` lists hold one braceless body line."""
    cmds: list[Cmd] = field(default_factory=list)
    single: bool = False


@dataclass
class LoadOp:
    """Something the parser does at load time instead of (or as well as) storing a command."""
    kind: str        # const, setvar, removeconst, const_ovrd, precache
    name: str        # variable name, or the command that precaches
    value: str       # raw value text (const/setvar) or resource tokens joined by spaces
    line: int
    quoted: bool = False
    in_command_list: CmdList | None = None   # where it appeared (for ordering with runtime commands)
    comment: str = ""
    leading_comments: list[str] = field(default_factory=list)


@dataclass
class Event:
    name: str | None                 # None for unnamed blocks
    explicit_scope: str | None       # from [server]/[client]/[shared]
    override: bool
    line: int
    commands: CmdList = field(default_factory=CmdList)
    load_ops: list[LoadOp] = field(default_factory=list)
    repeat_delay: str | None = None  # raw token of the first repeatdelay
    header_comment: str = ""
    leading_comments: list[str] = field(default_factory=list)
    trailing_comments: list[str] = field(default_factory=list)


@dataclass
class Include:
    path: str
    line: int
    server_only: bool = False
    client_only: bool = False
    casual: bool = False
    allow_duplicate: bool = False
    comment: str = ""
    leading_comments: list[str] = field(default_factory=list)


@dataclass
class ScopeDirective:
    scope: str
    line: int


@dataclass
class Problem:
    line: int
    message: str
    dropped_command: str = ""   # set when the engine silently drops an unknown command


@dataclass
class ParsedFile:
    name: str                                  # pak-relative, without .script ("monsters/orc_flayer")
    items: list[Event | Include | ScopeDirective] = field(default_factory=list)
    problems: list[Problem] = field(default_factory=list)
    header_comments: list[str] = field(default_factory=list)   # comments before the first item

    @property
    def events(self) -> list[Event]:
        return [i for i in self.items if isinstance(i, Event)]

    @property
    def includes(self) -> list[Include]:
        return [i for i in self.items if isinstance(i, Include)]
