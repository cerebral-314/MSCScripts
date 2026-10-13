"""Locating and parsing scripts by their pak name ("monsters/orc_flayer")."""

from __future__ import annotations

from functools import lru_cache
from pathlib import Path

from . import engine
from .parser import parse_file
from .source import read_file
from .syntax import ParsedFile

SCRIPT_EXT = ".script"


def normalize(name: str) -> str:
    name = name.replace("\\", "/").strip()
    if name.lower().endswith(SCRIPT_EXT):
        name = name[: -len(SCRIPT_EXT)]
    return name


class Corpus:
    """The scripts folder (MSCScripts/scripts) the pak is built from."""

    def __init__(self, root: Path):
        self.root = Path(root)
        self._index: dict[str, Path] | None = None

    @property
    def index(self) -> dict[str, Path]:
        if self._index is None:
            self._index = {}
            for path in self.root.rglob("*" + SCRIPT_EXT):
                name = normalize(path.relative_to(self.root).as_posix())
                self._index[name.lower()] = path
        return self._index

    def names(self) -> list[str]:
        return sorted(normalize(p.relative_to(self.root).as_posix()) for p in self.index.values())

    def path(self, name: str) -> Path | None:
        # The pak lookup is case-insensitive in practice (names are lower-cased when packed)
        return self.index.get(normalize(name).lower())

    def exists(self, name: str) -> bool:
        return self.path(name) is not None

    @lru_cache(maxsize=None)
    def parse(self, name: str, kind: str) -> ParsedFile | None:
        path = self.path(name)
        if path is None:
            return None
        canonical = normalize(path.relative_to(self.root).as_posix())
        return parse_file(canonical, read_file(path), engine.global_commands(), engine.entity_lookup(kind))
