@flo.md

# Memory
- After each task, before ending the turn, ask whether to save anything to memory; suggest 1-3 concrete candidates (decisions, corrections, non-obvious findings). Save only after confirmation.
- Never store secrets, tokens, or credentials.

# Engineering
- KISS/YAGNI: smallest change that solves the problem; no speculative abstractions or unrequested config options.
- DRY only once a third real use appears.
- Fail loudly: handle errors at the boundary, never swallow them; shell scripts use `set -euo pipefail`.
- Verify with the project's test/lint tooling before declaring done.
- Never hardcode credentials; validate external input.

# Inkscape
- When working with Inkscape or `.svg` files, read `~/.claude/designer.inkscape.md` first, unless it is already in your system prompt (`desclaude` appends it).

# SSH
- Never run SSH yourself (`ssh`, `scp`, `sftp`, `rsync -e ssh`, git over SSH remotes). Print the command and let the user decide.
- Only exception: the user requests SSH explicitly twice (request + confirmation after your warning).
