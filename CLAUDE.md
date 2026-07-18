# CLAUDE.md

Chezmoi source repo for personal dotfiles (target: `~`). Machines: Arch Linux
(primary, Hyprland desktop), Debian/Ubuntu, Fedora/RHEL, macOS — servers and
containers included.

## Conventions

- `dot_<name>` → `~/.<name>`; `executable_` prefix sets +x; `.tmpl` files are Go
  templates (sprig functions available, data from `chezmoi data`).
- **All install scripts live in `.chezmoiscripts/`** — never in the repo root.
- `run_onchange_install-packages-<distro>.sh.tmpl` renders the package list from
  `.chezmoidata/packages.yaml`; any edit to that file re-runs the script on the
  next apply. `run_once_*` is for tools without repo packages; run_once state is
  keyed by content hash, so renaming a script does not re-run it.
- **Adding a program**: put it in `packages.common` (all machines) or
  `packages.desktop` (only where the `desktop` prompt was answered yes). A
  distro-specific package name goes in `packages.<distro>.rename`, distro-only
  packages in `.extra`/`.aur`, unavailable ones in `.skip`. Every distro key
  (`extra`, `desktopExtra`, `aur`, `aurDesktop`, `rename`, `skip`) must exist,
  even if empty — the templates index them unconditionally.
- The `desktop` flag is set once by `.chezmoi.toml.tmpl` (`promptBoolOnce`).
  Non-interactive: `chezmoi init --promptBool desktop=false`. Templates must
  read it as `default false .desktop` (machines that never re-ran init have no
  value).
- `.chezmoiignore` keeps Claude runtime state out of the repo and hides GUI
  configs (hypr, ghostty) on non-desktop machines. Ignored ≠ deleted: already
  applied files stay on the target.
- `dotfiles/` (target `~/dotfiles`) holds the modular zsh/tmux configs sourced
  by `dot_zshrc`/`dot_tmux.conf`. Long-term goal: migrate into `dot_config/`
  (see Todo).

## Testing / verification

- `tests/test.sh` — shellcheck over scripts and rendered templates, plus
  `chezmoi doctor`.
- `tests/docker/Dockerfile.<distro>` — real end-to-end bootstrap
  (`chezmoi init --apply` in a container). CI runs the matrix on every push.
- On a live machine always check `chezmoi status` / `chezmoi diff` before
  `chezmoi apply` — the package scripts call sudo and a full apply runs every
  pending script.

## Goals

1. One-command bootstrap on fresh Arch/Debian/Fedora/macOS.
2. CI green on all distros.
3. One package list as single source of truth — no duplicates, no dead files.
