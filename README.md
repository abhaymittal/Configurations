# Configurations

Personal dotfiles for macOS (Apple Silicon). Modernized 2026-05.

## What's here

| File / dir | Tool | Notes |
|---|---|---|
| `.zshenv` | zsh | Env vars + PATH only. Loaded for every shell. Keep fast. |
| `.zshrc` | zsh | Interactive shell. zgenom + deferred plugins + lazy conda + fzf. |
| `.p10k.zsh` | powerlevel10k | Pure-style two-line prompt, transient, Catppuccin colors. |
| `.tmux.conf` | tmux | Backtick prefix, slim Catppuccin status, tpm + resurrect. |
| `.gitconfig` | git | Modern defaults, delta pager, side-by-side diffs. |
| `.config/wezterm/wezterm.lua` | WezTerm | Catppuccin Mocha, translucent, JetBrains Mono. |
| `.config/git/ignore` | git | Global gitignore. |
| `.emacs.d/init.el`, `.emacs.d/config.org` | Emacs | straight.el bootstrap; vertico/corfu/eglot/magit/doom-modeline. |
| `archive/` | — | Linux-only configs (i3, compton, xkb). Not deployed. |
| `Brewfile` | brew | Declarative dependency list. |
| `install.sh` | — | Idempotent installer. Run this. |

## Install

```bash
cd ~/claude_projects/abhay_claude_projects/Configurations
./install.sh
```

The installer:
1. Checks you're on macOS.
2. Installs Homebrew if missing.
3. Confirms before installing brew packages (warns about emacs-plus build time).
4. Runs `brew bundle` against `Brewfile`.
5. Clones zgenom and tpm.
6. Symlinks each dotfile into `~`. Existing files are backed up to `<file>.bak.<timestamp>`.
7. Downloads Catppuccin themes for `bat` and rebuilds its cache.
8. Bootstraps tmux plugins.
9. Builds the zgenom plugin cache by spawning one interactive zsh.

Safe to re-run anytime — it re-points missing symlinks, refreshes brew, updates plugin managers.

## Daily use

- **Edit a config in this repo** → it takes effect in `~` immediately (symlinks).
- **Add a new brew dep** → add to `Brewfile`, re-run `./install.sh`.
- **Update plugins** → `zsh -i -c 'zgenom update'` and `prefix + U` inside tmux.
- **Restore a backed-up config** → `mv ~/<file>.bak.<timestamp> ~/<file>`.

## Restoring removed features

- **LaTeX (AUCTeX)** is commented out in `.emacs.d/config.org` under "COMMENTED FOR LATER".
  To restore: uncomment the block, then `brew install --cask tinytex skim`.
- **Atuin** (richer history search): `brew install atuin && atuin init zsh`,
  then add `eval "$(atuin init zsh)"` to `.zshrc`.
- **Theme swap (Monokai instead of Catppuccin)** in Emacs: see the commented
  block at the top of the `Theme` section in `config.org`.

## Speed targets

- `time zsh -i -c exit` < 300ms
- Visible prompt (p10k instant prompt) < 100ms
