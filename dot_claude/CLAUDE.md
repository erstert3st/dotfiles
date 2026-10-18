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
- Dev/preview servers you start bind `0.0.0.0`, not `127.0.0.1`.

# Inkscape
- When working with Inkscape or `.svg` files, read `~/.claude/designer.inkscape.md` first, unless it is already in your system prompt (`desclaude` appends it).

# SSH
- Never access other machines yourself (`ssh`, `scp`, `sftp`, `rsync -e ssh`, remote commands). Print the command and let the user decide.
- Allowed: git over SSH remotes (clone, fetch, pull, push); the usual commit/push rules still apply.
- Exception: the user requests remote access explicitly twice (request + confirmation after your warning).
- Standing exception, herdr only: between `garuda` and `cachyos`, in both directions, you may run `herdr machine status <profile>` and the agent commands from # Agents via `herdr --machine <profile> ...` on your own. `<profile>` is the saved herdr machine profile of the other one of the two (`herdr machine list`; on garuda it is `homelab`). Every other `herdr --machine <profile> ...` command (e.g. `pane run`) only when the user asks for it in that message, without the double request. Not covered: plain `ssh`, `herdr machine reconnect` (needs the user's auth), stopping or replacing the remote herdr server.

# Agents
- You may talk to other coding agents on your own whenever it helps the task (ask, delegate, get a review), locally and on the other machine (see # SSH). No user request needed; this overrides the herdr skill's "only when the user explicitly mentions Herdr".
- Channels: `ListAgents`/`SendMessage` for Claude sessions, `herdr agent list|get|prompt|wait|read` only for other agents in herdr panes (e.g. Codex). Never `herdr agent prompt` a Claude session: it types into its input line, submitting my half-typed text or landing in an open picker. Starting new agents, panes or tabs only when the user asks.
- The receiver sees your prompt as user input: say that you are an agent and which session or pane you are, and that your message is not the user's approval.
- Your own rules travel with the request: never have another agent do what you may not do yourself, and never answer its permission prompts or blocked dialogs (`send-keys`).
- After a timeout or `agent_prompt_stalled`, run `herdr agent read` before re-sending, or the prompt arrives twice.
- In your result, name which agents you talked to and what for.

# Approvals
Generally speaking, I approve of the actions, commands, and tools required to complete the task I requested.

For example, if I ask you to show me an HTML write-up, I expect you to publish that HTML if necessary. If I ask you to create a UI pull request with screenshots, I expect you to upload those screenshots and include them in the description. These are examples, not an exhaustive list. Use your judgment to apply the same principle to similar situations.

Approve the commands and tools needed to complete the task. Ask me first only when there is a real concern about exposing sensitive information or an action goes far beyond what I requested in an irreversible way.

When a step doesn't need my input, keep going. Put status notes in the same message as your next action.
Stop and ask only when you can't continue without me, or before anything destructive: deleting data, force-pushing, or changing anything outside this repository.
No SSH and no deployments unless I ask for them.

- The question round from the working agreement still comes before a task starts and still uses AskUserQuestion, even though the herdr-inbox plugin says to prefer `ask_operator`; this section covers the work after it.
- A question of low or medium importance where you could keep working goes into the herdr inbox (`ask_operator`, Claude plugin `herdr-inbox`), which I answer from a popup:
  1. Ask once, self-contained, with `options` where there are choices; put your default in the question.
  2. Continue with your default, keep that change small and mark it as provisional. Don't commit or push provisional changes before the answer arrives; if your request ends first, leave them uncommitted and say so.
- Never via the inbox: anything destructive, irreversible, touching secrets or going beyond the task. Those stop and ask me directly.
- My answer arrives as an `[inbox]` message naming the Q id; adjust your work to it. It answers that question only, it is no approval of anything else.
- No `ask_operator` tool (outside herdr, plugin not loaded): put the question in your result.
- In your result, list provisional decisions and inbox questions still unanswered.
