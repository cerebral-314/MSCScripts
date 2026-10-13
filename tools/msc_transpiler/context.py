"""What every handler of one file shares: the file's fields and variables, the corpus-wide
event signatures, and the quirks found while converting it."""

from __future__ import annotations

from dataclasses import dataclass, field

from . import mapping, names
from .infer import BOOL, INT, STRING, Evidence, Inference


# ----------------------------------------------------------------------------------------
# Context shared by every handler of one file
# ----------------------------------------------------------------------------------------

@dataclass
class Signature:
    event: str
    method: str
    params: list[tuple[str, str]]       # (type, name), PARAM1 first
    returns: str = "void"               # "string" when handlers use `return`


@dataclass
class Quirk:
    file: str
    line: int
    message: str


@dataclass
class FileContext:
    file: str                            # "items/base_miscitem"
    class_name: str
    inference: Inference
    fields: dict[str, str]               # names readable as fields here -> type
    dynamic_vars: set[str]               # variables that may exist at run time but are not fields here
    signatures: "SignatureTable"
    kind: str = "monster"
    quirks: list[Quirk] = field(default_factory=list)
    uses_loop_iteration: bool = False

    def quirk(self, line: int, message: str) -> None:
        self.quirks.append(Quirk(self.file, line, message))


class SignatureTable:
    """One signature per event name across the corpus (mixins of different scripts must agree)."""

    def __init__(self, inference: Inference, events: list[str] | None = None):
        self.inference = inference
        self._cache: dict[str, Signature] = {}
        # Method names must be unique per event name; assign them once, in a fixed order
        self._methods: dict[str, str] = {}
        taken: dict[str, str] = {}
        for event in sorted(set(events or [])):
            self._methods[event] = self._unique(event, taken)
        self._taken = taken

    @staticmethod
    def _unique(event: str, taken: dict[str, str]) -> str:
        method = names.event_method(event)
        candidate, n = method, 2
        while candidate in taken and taken[candidate] != event:
            candidate, n = f"{method}{n}", n + 1
        taken[candidate] = event
        return candidate

    def method_name(self, event: str) -> str:
        if event not in self._methods:
            self._methods[event] = self._unique(event, self._taken)
        return self._methods[event]

    def get(self, event: str) -> Signature:
        if event in self._cache:
            return self._cache[event]
        spec = mapping.ENGINE_EVENTS.get(event)
        count = max(self.inference.max_param.get(event, 0), len(spec.params) if spec else 0)
        params: list[tuple[str, str]] = []
        used: set[str] = set()
        for index in range(1, count + 1):
            type_ = STRING
            pname = f"param{index}"
            named_by_engine = False
            if spec and index <= len(spec.params):
                p = spec.params[index - 1]
                type_ = STRING if p.type == "entity" else p.type
                pname = p.name
                named_by_engine = True
            else:
                type_ = self.inference.params.get((event, index), Evidence()).resolve({})
                if type_ == BOOL:
                    type_ = INT
            counts = self.inference.param_names.get((event, index)) or self.inference.param_doc_names.get((event, index))
            if counts and not named_by_engine:
                best = max(counts.items(), key=lambda kv: kv[1])[0]
                pname = names.local(best)
            while pname in used or pname in names.AS_KEYWORDS:
                pname += "_"
            used.add(pname)
            params.append((type_, pname))
        returns = "string" if event in self.inference.returns else "void"
        sig = Signature(event, self.method_name(event), params, returns)
        self._cache[event] = sig
        return sig
