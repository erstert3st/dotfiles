@RTK.md

# Memory Management

- Actively maintain the auto-memory directory: save durable facts (preferences, decisions, project constraints), update stale entries, delete wrong ones.
- After finishing each task, before ending the turn, ask: "Soll ich etwas davon ins Memory übernehmen?" — suggest 1-3 concrete candidates (decisions made, corrections received, non-obvious findings). Only save after confirmation.
- Never store secrets, tokens, or credentials in memory.

# Best Practices & Architecture

- KISS/YAGNI: smallest change that solves the problem; no speculative abstractions or config options nobody asked for.
- DRY with judgment: extract shared logic once a real third use appears, not before.
- Separation of concerns: small, single-purpose functions/modules; clear boundaries between config, logic, and I/O.
- Explicit over clever: descriptive names, no magic values, obvious control flow.
- Fail loudly: handle errors at the boundary, don't swallow them; scripts use `set -euo pipefail`.
- Match existing conventions of the repo (style, naming, structure) before introducing new ones.
- Keep things testable: prefer pure functions, inject dependencies, verify changes with the project's test/lint tooling before declaring done.
- Security basics: least privilege, validate external input, never hardcode credentials.

# Kommunikation

- Antworte immer auf Deutsch, auch wenn der User auf Englisch schreibt.
- IT-/Fachbegriffe, Kommandos, Flags und Code-Identifier bleiben in ihrer englischen Originalform (kein Eindeutschen von z. B. "commit", "pipefail", "least privilege").

# SSH

- Benutze niemals SSH (`ssh`, `scp`, `sftp`, `rsync -e ssh`, `git` über SSH-Remotes) von dir aus.
- Wenn eine Aufgabe SSH erfordert: nicht ausführen, sondern den nötigen Befehl nennen und den User entscheiden lassen.
- Einzige Ausnahme: Der User fordert SSH **zweimal explizit** an (erste Aufforderung + Bestätigung nach dem Hinweis). Erst dann ausführen.
