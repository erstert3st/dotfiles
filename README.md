# dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/).

## Install (one command)

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply erstert3st
```

Supported: **Arch Linux** (primary), **Debian/Ubuntu**, **Fedora/RHEL**, **macOS**.

During `chezmoi init` you are asked once whether this machine is a *desktop*
(GUI packages and configs like Hyprland/Ghostty) or a headless box.
Non-interactive (CI, containers): `chezmoi init --apply --promptBool desktop=false erstert3st`

## Goals

1. **One-command bootstrap** — the install line above works on a fresh machine of every supported distro.
2. **CI green on all distros** — every push runs the full bootstrap in a Docker matrix.
3. **Single source of truth** — one package list, no duplicates, no dead files.

## Structure

| Path | Purpose |
|---|---|
| `.chezmoidata/packages.yaml` | THE program list — all distros, incl. per-distro renames |
| `.chezmoiscripts/` | install scripts: `run_onchange_install-packages-<distro>` + `run_once_*` for tools without repo packages |
| `dot_config/` | `~/.config` (k9s, lazydocker, ccstatusline, hypr, ghostty, …) |
| `dotfiles/` | modular zsh/tmux config, sourced by `~/.zshrc` / `~/.tmux.conf` |
| `tests/` | lint + Docker bootstrap tests (`tests/test.sh`) |

## Programs

The complete list of installed programs lives in
[`.chezmoidata/packages.yaml`](.chezmoidata/packages.yaml).
Edit it and run `chezmoi apply` — the matching distro script re-runs automatically.

## Testing

```sh
tests/test.sh                                   # shellcheck + template render + chezmoi doctor
docker build -f tests/docker/Dockerfile.arch .  # full bootstrap end-to-end
```

CI (`.github/workflows/ci.yml`) runs both for Arch, Debian and Fedora on every push.
