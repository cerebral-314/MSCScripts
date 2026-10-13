"""Reading .script files the way CScript::ParseScriptFile does.

The engine splits on '\\n', strips leading ' \\t\\v', cuts the line at the first
'//' (even inside quotes) or '\\r', and skips lines that are only whitespace.
The transpiler needs the same code text, plus the comment it threw away so the
comment can be carried into the AngelScript output.
"""

from __future__ import annotations

from dataclasses import dataclass
from pathlib import Path

ENCODING = "latin-1"  # scripts are 8-bit; latin-1 round-trips every byte


@dataclass
class SourceLine:
    number: int      # 1-based, as the engine counts
    code: str        # what ParseLine sees ('' when the line has no code)
    comment: str     # text after '//' without the slashes ('' if none)
    raw: str         # the original line


def split_line(raw: str) -> tuple[str, str]:
    """Return (code, comment) for one physical line, mirroring ParseScriptFile."""
    line = raw.lstrip(" \t\v")
    code_end = len(line)
    comment = ""
    for i, ch in enumerate(line):
        if ch == "/" and line[i + 1:i + 2] == "/":
            code_end = i
            comment = line[i + 2:]
            break
        if ch == "\r":
            code_end = i
            break
    comment = comment.split("\r", 1)[0]
    return line[:code_end], comment.strip()


def read_lines(text: str) -> list[SourceLine]:
    lines = []
    for number, raw in enumerate(text.split("\n"), start=1):
        code, comment = split_line(raw)
        if not code.strip(" \r\t"):
            code = ""
        lines.append(SourceLine(number, code, comment, raw.rstrip("\r")))
    return lines


def read_file(path: Path) -> list[SourceLine]:
    return read_lines(path.read_text(encoding=ENCODING))
