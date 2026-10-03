@flo.md

# Memory
- Ask whether to save anything to memory only when both hold: the work is really finished (nothing waiting on me or on running agents), and you found something you consider important enough. Never in question rounds or intermediate turns; otherwise skip the question. Suggest 1-3 concrete candidates (decisions, corrections, non-obvious findings). Save only after confirmation.
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
- Never access other machines yourself (`ssh`, `scp`, `sftp`, `rsync -e ssh`, remote commands). Print the command and let the user decide.
- Allowed: git over SSH remotes (clone, fetch, pull, push); the usual commit/push rules still apply.
- Exception: the user requests remote access explicitly twice (request + confirmation after your warning).
- Standing exception, herdr only: between `garuda` (this machine) and `cachyos` (herdr profile `homelab`) you may run `herdr --machine homelab ...` and `herdr machine status homelab` without the double request, but only when the user asks for it in that message. Not covered: plain `ssh`, `herdr machine reconnect` (needs the user's auth), stopping or replacing the remote herdr server.
