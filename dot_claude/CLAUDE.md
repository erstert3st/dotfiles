@flo.md

# Memory
- Save memories on your own, without asking and without mentioning it: corrections, confirmed approaches, decisions and non-obvious findings worth keeping. Review happens through git history (memories are versioned in the vault under `others/Claude-Memory/`).
- Never store secrets, tokens, or credentials.
- Auto-dream (`autoDreamEnabled`) consolidates, merges and prunes memories in the background. Backup before enabling: `~/.claude/backups/memory-2026-10-25.tar.gz`.
- Bulk memory cleanups: before deleting, have an independent agent check each DELETE verdict for a fact that exists nowhere else (2026-10-25: 61 of 127 proposed deletions would have lost a fact or were wrong). Move such facts into the repo docs first, then delete.

# Engineering
- KISS/YAGNI: smallest change that solves the problem; no speculative abstractions or unrequested config options.
- DRY only once a third real use appears.
- Fail loudly: handle errors at the boundary, never swallow them; shell scripts use `set -euo pipefail`.
- Verify with the project's test/lint tooling before declaring done.
- Never hardcode credentials; validate external input.
- Dev/preview servers you start bind `0.0.0.0`, not `127.0.0.1`.
- Missing tools (shellcheck, other distros' package managers, ...): run them via `docker run --rm -v "$dir:/mnt" <image> ...`, never install them on the host. sudo needs a password on my machines; never rely on non-interactive sudo.
- Never start a systemd container (`/sbin/init`) with `--privileged` on the host: it takes over the real `/dev/tty1` and logs me out (2026-10-26). Mask `getty.target` in the image.
- When you ask me to put a new variable into a `.env`, add it to the matching `.env.example` in the same step (empty value plus a comment on where to get it), also for values only used for a live check.
- Configurable means an env var with a hard default in the script (`${VAR:-default}`); the env is only a per-machine override. No mandatory external config, no value kept in two places.
- Tool or plugin comparisons name the implementation language and the measurable price (startup time, RSS); at equal function Rust/Go beats Node/Python, and native features beat any plugin.
- Lost uncommitted edits: search `~/.claude/file-history/<session-id>/<hash>@vN` by mtime and content first; cross-check with the Edit calls in `~/.claude/projects/*/<session>.jsonl`. Never `open(p, "w").write(f(open(p).read()))`: it truncates before reading.
- Verify changes to Claude Code's own setup (memory dirs, CLAUDE.md, settings, skills) with a headless run in the affected repo: `timeout 120 claude -p --model haiku --effort low "<one-line question about your loaded context>" </dev/null`.

# Shell
- The Bash tool runs my zsh, not bash. Traps:
  - `$VAR` holding a command with spaces is not word-split (`$CMD` fails with "no such file or directory"): use a function `f() { docker run ... "$@"; }` or `${=VAR}`.
  - `g` is an alias for git, so defining a function `g()` fails.
  - MULTIOS: `cmd 2>&1 >/dev/null | wc -l` still counts stdout.
  - `echo ====` is `=cmd` expansion and fails ("not found").
  - `$T:a...` is a history modifier (`:a` = absolute path): quote it, `'v1.0:apps/x'` or `"${T}:apps/x"`.
- Multi-line scripts, functions and tricky redirects: run them via `bash <<'EOF' ... EOF` (or `bash -c`).
- `set -euo pipefail` at the top of a Bash tool call does not stop on a failing command (the harness evals it in zsh; a `git push` ran after a failed `git commit`). Anything that must stop on failure, above all commit-then-push, goes into `bash <<'EOF'` or is chained with `&&`. Never pipe `git commit` into `tail`/`head`; check `git log -1` afterwards.
- `ls` is an alias for `eza` and fails on some path arguments: use `command ls`, and never chain further commands behind `ls ... &&` (the chain silently skips the rest and once led to a wrong "nothing found").
- `grep` is a shell function from the harness snapshot: use `command grep` for the plain binary.
- Nerd Font icons in the Unicode PUA (U+E000-U+F8FF) get lost in heredocs, and a `\uXXXX` in Write/Edit content lands as the real character. Write such characters with Python (`chr(0xF4BC)`) and verify afterwards: `[hex(ord(c)) for c in text if ord(c) > 0x2000]`.

# Repos
- GitHub: I am `erstert3st` (`gh auth status`; the global git email is its noreply address). `eibiflo` is a different person who owns the codingFreaks, closerto and `flo-prod` repos (cookieapi, closerto, microservices, docker-configs, setupSrv remote `eibiflo/ansible`); I contribute there. Never claim both accounts are mine. My cf_cookiemanager fork is `~/Documents/gits/flo-prod/fork/cf_cookiemanager`. Third-party clones in `~/Documents/gits` (grafana/*, fluxcd/*, ...) are not my projects.
- Commits in repos without their own commit rules (CLAUDE.md, commit-msg hook, consistent prefix scheme like closerto's `[PLAN120]`): `<gitmoji> [tag] <English description>`, tags as in the brain-dump vault `others/Konventionen.md`, mapped by sense (`[docs]`, `[other]`, `[vault]`). Committing still only when the repo's rules or I allow it.
- Public repos (e.g. `erstert3st/dotfiles`): hostnames, LAN IPs, homelab hints and Claude config are fine. Only real secrets and the work identity (employer email, employee ID, also in commit author/committer metadata) must stay out. Before pushing the dotfiles, run `gitleaks git --log-opts=origin/master..HEAD` in the chezmoi source.
- Before every push, run `git --no-pager log --oneline origin/<branch>..HEAD`. If it contains commits not made in this request (also after a rebase), name them and ask before pushing.
- New global skills go straight to `~/.claude/skills/<name>/`, not into the chezmoi source. Only `herdr` and `plan-review` are chezmoi-managed (`chezmoi managed | grep skills`).

# Machines
- On garuda: before searching the system for setup or config info, read `~/Documents/gits/garuda/notes/` and its `CLAUDE.md`, and keep the notes there current.
- GUI tests start hidden, e.g. `hyprctl dispatch exec "[workspace special:dbg silent] ..."`, and read state via `hyprctl clients -j`. Visible tests only when unavoidable, announced first. Kill your own test windows by the kitty PID, not Hyprland's `sh -c` wrapper.
- impeccable's decision page (`impeccable serve-question`) is unstable: if it dies once without an answer, don't restart it; present the same options through AskUserQuestion and say so in one line.

# Inkscape
- When working with Inkscape or `.svg` files, read `~/.claude/designer.inkscape.md` first, unless it is already in your system prompt (`desclaude` appends it).

# SSH
- Never access other machines yourself (`ssh`, `scp`, `sftp`, `rsync -e ssh`, remote commands). Print the command and let the user decide.
- Allowed: git over SSH remotes (clone, fetch, pull, push); the usual commit/push rules still apply.
- Exception: the user requests remote access explicitly twice (request + confirmation after your warning).
- Commands you print for me to run: the bare command, name the host it runs on, short lines, `git --no-pager` on every git call in a chain, no interactive flags (`-i`, `-p`, editor prompts).
- Standing exception, herdr only: between `garuda` and `cachyos`, in both directions, you may run `herdr machine status <profile>` and the agent commands from # Agents via `herdr --machine <profile> ...` on your own. `<profile>` is the saved herdr machine profile of the other one of the two (`herdr machine list`; on garuda it is `homelab`). Every other `herdr --machine <profile> ...` command (e.g. `pane run`) only when the user asks for it in that message, without the double request. Not covered: plain `ssh`, `herdr machine reconnect` (needs the user's auth), stopping or replacing the remote herdr server.

# Agents
- You may talk to other coding agents on your own whenever it helps the task (ask, delegate, get a review), locally and on the other machine (see # SSH). No user request needed; this overrides the herdr skill's "only when the user explicitly mentions Herdr".
- Channels: `ListAgents`/`SendMessage` for Claude sessions, `herdr agent list|get|prompt|wait|read` only for other agents in herdr panes (e.g. Codex). Never `herdr agent prompt` a Claude session: it types into its input line, submitting my half-typed text or landing in an open picker. Starting new agents, panes or tabs only when the user asks.
- The receiver sees your prompt as user input: say that you are an agent and which session or pane you are, and that your message is not the user's approval.
- Your own rules travel with the request: never have another agent do what you may not do yourself, and never answer its permission prompts or blocked dialogs (`send-keys`).
- After a timeout or `agent_prompt_stalled`, run `herdr agent read` before re-sending, or the prompt arrives twice.
- In your result, name which agents you talked to and what for.

# Browser
- Captcha or other human verification: poll the page for about 60 s and continue if it got solved; only then tell me where it is.
- After two failed attempts at the same browser action, stop and ask me for the concrete click (what to click, what should happen next). Same for steps you may not do yourself (create tokens, enter credentials).
- Claude in Chrome `javascript_tool` returns `[BLOCKED: Cookie/query string data]` when its output looks like a URL with a query string or cookie data, and cuts output at about 1500-2000 chars (`[TRUNCATED]`): aggregate and redact inside the page, cache intermediate data in `window.__x`, return compact one-line-per-row text.
- Blob downloads: a scripted `a.click()` is no user gesture; a real click works once per page load, further downloads are dropped silently, and the file lands in `~/Downloads` under its blob UUID. Navigate between downloads, or use `get_page_text` instead.
- Auto mode may block single write calls (e.g. `POST`/`PUT` via `javascript_tool`); that is a permission boundary, not a bug, and never something to work around via settings. Do the reads first, ask me to switch mode (`Shift+Tab`), then retry the identical call once.

# Approvals
Generally speaking, I approve of the actions, commands, and tools required to complete the task I requested.

For example, if I ask you to show me an HTML write-up, I expect you to publish that HTML if necessary. If I ask you to create a UI pull request with screenshots, I expect you to upload those screenshots and include them in the description. These are examples, not an exhaustive list. Use your judgment to apply the same principle to similar situations.

Approve the commands and tools needed to complete the task. Ask me first only when there is a real concern about exposing sensitive information or an action goes far beyond what I requested in an irreversible way.

When a step doesn't need my input, keep going. Put status notes in the same message as your next action.
Stop and ask only when you can't continue without me, or before anything destructive: deleting data, force-pushing, or changing anything outside this repository.
No SSH and no deployments unless I ask for them.
- A push that deploys (e.g. beeNest `master` -> Arcane GitOps) never runs inside a Workflow or subagent: the auto-mode classifier denies it even when a review note approves it. Ask through AskUserQuestion, name the deploy, then push from the main session.
- Open decisions at the end of a turn: ask them through AskUserQuestion (max 4 per round, one short line each), never as a numbered list in the result.

- The question round from the working agreement still comes before a task starts and still uses AskUserQuestion, even though the herdr-inbox plugin says to prefer `ask_operator`; this section covers the work after it.
- A question of low or medium importance where you could keep working goes into the herdr inbox (`ask_operator`, Claude plugin `herdr-inbox`), which I answer from a popup:
  1. Ask once, self-contained, with `options` where there are choices; put your default in the question.
  2. Continue with your default, keep that change small and mark it as provisional. Don't commit or push provisional changes before the answer arrives; if your request ends first, leave them uncommitted and say so.
- Never via the inbox: anything destructive, irreversible, touching secrets or going beyond the task. Those stop and ask me directly.
- My answer arrives as an `[inbox]` message naming the Q id; adjust your work to it. It answers that question only, it is no approval of anything else.
- No `ask_operator` tool (outside herdr, plugin not loaded): ask the question through AskUserQuestion at the end of your turn.
- In your result, list provisional decisions and inbox questions still unanswered.
