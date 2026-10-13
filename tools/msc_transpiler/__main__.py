"""msc_transpiler - convert MS-Script (.script) files to AngelScript.

Usage (run from MSCScripts/tools):
  python -m msc_transpiler convert [--scripts DIR] [--out DIR] [--all | --family NAME | NAME ...]
      Writes scripts/angelscript/converted/<name>.as for each script (and the files it includes).
  python -m msc_transpiler runtime [--out DIR]
      Regenerates the wrapper files in scripts/angelscript/runtime/ from mapping.py.
  python -m msc_transpiler report [--scripts DIR] [--all | NAME ...]
      Prints the legacy quirks found while converting.

Defaults: --scripts ../scripts, --out ../scripts/angelscript
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

HERE = Path(__file__).resolve().parent
DEFAULT_SCRIPTS = HERE.parent.parent / "scripts"
DEFAULT_OUT = DEFAULT_SCRIPTS / "angelscript"


def _targets(project, args) -> list[str]:
    if args.all:
        return list(project.all_names)
    if args.family:
        family = args.family.lower()
        leaves = [n for n in project.all_names if not project.is_library(n)
                  and any(f.lower() == family for f in project.closure_files(n))]
        return leaves
    return [project.canonical(n) for n in args.names]


def _with_closures(project, targets: list[str]) -> list[str]:
    out: list[str] = []
    seen: set[str] = set()
    for t in targets:
        for f in project.closure_files(t):
            if f.lower() not in seen:
                seen.add(f.lower())
                out.append(f)
    return out


def cmd_convert(args) -> int:
    from .corpus import Corpus
    from .generate import Project, output_path
    project = Project(Corpus(Path(args.scripts)))
    files = _with_closures(project, _targets(project, args))
    out_root = Path(args.out)
    failures = 0
    for name in files:
        try:
            text = project.generate(name)
        except Exception as exc:  # keep going: report every file that fails
            failures += 1
            print(f"FAILED {name}: {exc!r}", file=sys.stderr)
            if args.verbose:
                raise
            continue
        path = out_root / output_path(name)
        path.parent.mkdir(parents=True, exist_ok=True)
        path.write_text(text, encoding="latin-1", newline="\n")
        if args.verbose:
            print(path)
    print(f"converted {len(files) - failures} file(s), {failures} failed, {len(project.quirks)} quirk(s)")
    if args.list:
        Path(args.list).write_text("\n".join(output_path(n) for n in files) + "\n", encoding="utf-8")
    return 1 if failures else 0


def cmd_runtime(args) -> int:
    from .runtime_gen import write_runtime
    for path in write_runtime(Path(args.out)):
        print(path)
    return 0


def cmd_report(args) -> int:
    from .corpus import Corpus
    from .generate import Project
    project = Project(Corpus(Path(args.scripts)))
    for name in _with_closures(project, _targets(project, args)):
        project.generate(name)
    seen = set()
    for q in project.quirks:
        key = (q.file, q.line, q.message)
        if key not in seen:
            seen.add(key)
            print(f"{q.file}.script({q.line}): {q.message}")
    return 0


def main(argv: list[str]) -> int:
    parser = argparse.ArgumentParser(prog="msc_transpiler", description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    sub = parser.add_subparsers(dest="command", required=True)
    for name in ("convert", "report"):
        p = sub.add_parser(name)
        p.add_argument("names", nargs="*")
        p.add_argument("--scripts", default=str(DEFAULT_SCRIPTS))
        p.add_argument("--out", default=str(DEFAULT_OUT))
        p.add_argument("--all", action="store_true")
        p.add_argument("--family", help="convert every script that includes this file")
        p.add_argument("--list", help="write the converted file paths here (for as_check --list)")
        p.add_argument("-v", "--verbose", action="store_true")
    p = sub.add_parser("runtime")
    p.add_argument("--out", default=str(DEFAULT_OUT))
    args = parser.parse_args(argv)
    return {"convert": cmd_convert, "runtime": cmd_runtime, "report": cmd_report}[args.command](args)


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))
