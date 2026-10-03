#!/usr/bin/env python3
"""Searchable cheatsheet of the herdr keybindings defined in config.toml.

Lists only what the user configured: [keys] overrides and [[keys.command]]
entries (plugin actions, popups, shell commands). herdr's built-in defaults
are left out on purpose; prefix+? shows those.

Bound to a herdr popup (prefix+h). `--print` writes the table to stdout
instead of opening fzf.
"""
import os
import shutil
import subprocess
import sys
import tomllib
from pathlib import Path

CONFIG = Path(os.environ.get("HERDR_CONFIG_PATH", "~/.config/herdr/config.toml")).expanduser()


def as_list(value):
    return value if isinstance(value, list) else [value]


def source_of(cmd):
    """Plugin id for plugin bindings, else the command type."""
    command = cmd.get("command", "")
    if cmd.get("type") == "plugin_action":
        return command.rsplit(".", 1)[0]
    words = command.split()
    if "--plugin" in words[:-1]:
        return words[words.index("--plugin") + 1]
    return cmd.get("type", "shell")


def collect(config):
    keys = config.get("keys", {})
    prefix = as_list(keys.get("prefix", "ctrl+b"))
    rows = []
    for action, binding in keys.items():
        if action in ("prefix", "command") or not isinstance(binding, (str, list)):
            continue
        rows.append((as_list(binding), action.replace("_", " "), "herdr"))
    for cmd in keys.get("command", []):
        if not cmd.get("command"):
            continue  # herdr disables entries with an empty command
        rows.append((as_list(cmd["key"]), cmd.get("description") or cmd["command"], source_of(cmd)))
    # herdr overrides first, then plugins, then popup/shell commands.
    rank = {"herdr": 0, "popup": 2, "pane": 2, "shell": 2}
    rows.sort(key=lambda r: (rank.get(r[2], 1), r[2], r[0]))
    return prefix, rows


def render(prefix, rows):
    def show(key):
        return key.replace("prefix+", f"{prefix[0]} ", 1)

    table = [(", ".join(show(k) for k in keys), what, src) for keys, what, src in rows]
    w_key = max(len(r[0]) for r in table)
    w_what = max(len(r[1]) for r in table)
    lines = [f"{'KEY':<{w_key}}  {'ACTION':<{w_what}}  SOURCE"]
    lines += [f"{k:<{w_key}}  {w:<{w_what}}  {s}" for k, w, s in table]
    return lines


def main():
    prefix, rows = collect(tomllib.loads(CONFIG.read_text()))
    if not rows:
        raise SystemExit(f"no custom keybindings in {CONFIG}")
    lines = render(prefix, rows)
    if "--print" in sys.argv or not sys.stdout.isatty() or not shutil.which("fzf"):
        print("\n".join(lines))
        return
    header = f"prefix = {' / '.join(prefix)} | defaults: prefix+? | esc closes"
    subprocess.run(
        ["fzf", "--layout=reverse", "--no-sort", "--header-lines=1", f"--header={header}",
         "--prompt=keys> ", "--no-info"],
        input="\n".join(lines), text=True, check=False,
    )


if __name__ == "__main__":
    try:
        main()
    except (OSError, tomllib.TOMLDecodeError, KeyError, SystemExit) as err:
        print(f"cheatsheet: {err}", file=sys.stderr)
        if sys.stdin.isatty():
            input("press enter to close")  # the popup closes as soon as we exit
        sys.exit(1)
