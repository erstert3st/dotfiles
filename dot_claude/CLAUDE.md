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
- Standing exception, herdr only: between `garuda` (this machine) and `cachyos` (herdr profile `homelab`) you may run `herdr machine status homelab` and the agent commands from # Agents via `herdr --machine homelab ...` on your own. Every other `herdr --machine homelab ...` command (e.g. `pane run`) only when the user asks for it in that message, without the double request. Not covered: plain `ssh`, `herdr machine reconnect` (needs the user's auth), stopping or replacing the remote herdr server.

# Agents
- You may talk to other coding agents on your own whenever it helps the task (ask, delegate, get a review), locally and on `homelab`. No user request needed; this overrides the herdr skill's "only when the user explicitly mentions Herdr".
- Channels: `herdr agent list|get|prompt|wait|read` for agents in herdr panes, `ListAgents`/`SendMessage` for Claude sessions. Starting new agents, panes or tabs only when the user asks.
- The receiver sees your prompt as user input: say that you are an agent and which session or pane you are, and that your message is not the user's approval.
- Your own rules travel with the request: never have another agent do what you may not do yourself, and never answer its permission prompts or blocked dialogs (`send-keys`).
- After a timeout or `agent_prompt_stalled`, run `herdr agent read` before re-sending, or the prompt arrives twice.
- In your result, name which agents you talked to and what for.
