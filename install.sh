#!/usr/bin/env bash
# install.sh — idempotent bootstrap for the Configurations repo.
# Safe to re-run.
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TS="$(date +%Y%m%d-%H%M%S)"

# --- Pretty output ----------------------------------------------------------
c_blue=$'\033[1;34m'; c_green=$'\033[1;32m'; c_yellow=$'\033[1;33m'; c_red=$'\033[1;31m'; c_reset=$'\033[0m'
say()  { printf '%s==> %s%s\n' "$c_blue"   "$*" "$c_reset"; }
ok()   { printf '%s ✓ %s%s\n' "$c_green"  "$*" "$c_reset"; }
warn() { printf '%s ! %s%s\n' "$c_yellow" "$*" "$c_reset"; }
die()  { printf '%s ✗ %s%s\n' "$c_red"    "$*" "$c_reset" >&2; exit 1; }

# --- 1. macOS only ----------------------------------------------------------
[[ "$(uname)" == "Darwin" ]] || die "This installer is macOS-only. Linux configs live in archive/."

# --- 2. Homebrew ------------------------------------------------------------
if ! command -v brew >/dev/null 2>&1; then
  say "Installing Homebrew (will prompt for sudo)…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$(/opt/homebrew/bin/brew shellenv)"
ok "Homebrew available"

# --- 3. Confirm before heavy installs ---------------------------------------
say "About to 'brew bundle' the Brewfile."
say "Notable: emacs-plus@30 builds with native-comp on first install (~10–15 min)."
read -r -p "Proceed? [y/N] " reply
[[ "$reply" =~ ^[Yy]$ ]] || die "Aborted by user."

# --- 4. brew bundle ---------------------------------------------------------
say "Running brew bundle…"
brew bundle install --file="$REPO_DIR/Brewfile"
ok "Brewfile installed"

# --- 5. Clone zgenom --------------------------------------------------------
if [[ ! -d "$HOME/.zgenom" ]]; then
  say "Cloning zgenom…"
  git clone --depth=1 https://github.com/jandamm/zgenom.git "$HOME/.zgenom"
else
  say "Updating zgenom…"
  git -C "$HOME/.zgenom" pull --ff-only --quiet || warn "zgenom update skipped"
fi
ok "zgenom ready"

# --- 6. Clone tpm -----------------------------------------------------------
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  say "Cloning tmux plugin manager…"
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  say "Updating tpm…"
  git -C "$HOME/.tmux/plugins/tpm" pull --ff-only --quiet || warn "tpm update skipped"
fi
ok "tpm ready"

# --- 7. Symlink dotfiles ----------------------------------------------------
# link_file <repo_relative_path> <target_in_home>
link_file() {
  local src="$REPO_DIR/$1"
  local dst="$HOME/$2"
  local dst_dir
  dst_dir="$(dirname "$dst")"
  mkdir -p "$dst_dir"

  if [[ -L "$dst" ]]; then
    if [[ "$(readlink "$dst")" == "$src" ]]; then
      ok "linked: ~/$2"
      return
    fi
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    mv "$dst" "${dst}.bak.${TS}"
    warn "backed up existing ~/$2 → ${dst}.bak.${TS}"
  fi
  ln -s "$src" "$dst"
  ok "linked: ~/$2"
}

say "Symlinking dotfiles (existing files backed up to *.bak.${TS})…"
link_file ".zshenv"   ".zshenv"
link_file ".zshrc"    ".zshrc"
link_file ".p10k.zsh" ".p10k.zsh"
link_file ".tmux.conf" ".tmux.conf"
link_file ".gitconfig" ".gitconfig"
link_file ".config/wezterm/wezterm.lua" ".config/wezterm/wezterm.lua"
link_file ".config/git/ignore"          ".config/git/ignore"
link_file ".emacs.d/init.el"            ".emacs.d/init.el"
link_file ".emacs.d/config.org"         ".emacs.d/config.org"

# --- 8. Catppuccin bat themes ----------------------------------------------
say "Installing Catppuccin themes for bat…"
BAT_THEMES_DIR="$HOME/.config/bat/themes"
mkdir -p "$BAT_THEMES_DIR"
for flavor in Latte Frappe Macchiato Mocha; do
  out="$BAT_THEMES_DIR/Catppuccin ${flavor}.tmTheme"
  if [[ ! -f "$out" ]]; then
    if curl -fsSL "https://raw.githubusercontent.com/catppuccin/bat/main/themes/Catppuccin%20${flavor}.tmTheme" -o "$out"; then
      ok "downloaded $(basename "$out")"
    else
      warn "failed to download $(basename "$out") — bat will fall back to default"
    fi
  fi
done
if command -v bat >/dev/null 2>&1; then
  bat cache --build >/dev/null && ok "bat theme cache built"
fi

# --- 9. Bootstrap tmux plugins ---------------------------------------------
# install_plugins needs the TMUX_PLUGIN_MANAGER_PATH env var, which is now
# set explicitly in .tmux.conf. We start a detached session so source-file
# has somewhere to attach, then run the installer.
if command -v tmux >/dev/null 2>&1; then
  say "Bootstrapping tmux plugins…"
  tmux kill-session -t _bootstrap 2>/dev/null || true
  tmux new-session -d -s _bootstrap   2>/dev/null || true
  tmux source-file "$HOME/.tmux.conf" 2>/dev/null || true
  if "$HOME/.tmux/plugins/tpm/bin/install_plugins" >/dev/null 2>&1; then
    ok "tmux plugins installed"
  else
    warn "tpm install_plugins exited non-zero (may already be installed)"
  fi
  tmux kill-session -t _bootstrap 2>/dev/null || true
fi

# --- 10. Build zgenom plugin cache -----------------------------------------
say "Building zgenom plugin cache (first interactive shell)…"
zsh -i -c 'echo "zsh ready"' >/dev/null 2>&1 || warn "zsh init reported issues — check manually"
ok "zgenom cache built"

# --- 11. Done --------------------------------------------------------------
cat <<EOF

${c_green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${c_reset}
${c_green} Done.${c_reset}
${c_green}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${c_reset}

Next:
  1. Open WezTerm (or restart it if already open).
  2. Inside, you should see the new Catppuccin theme + Pure-style prompt.
  3. To verify speed:        time zsh -i -c exit
  4. Try: bat README.md ; eza --tree ; z confi<TAB> ; ^R for fzf history.
  5. Open emacs:             emacs    (first launch will compile straight.el packages — ~3 min)

If something looks wrong, the previous configs are backed up at:
  ~/<file>.bak.${TS}
EOF
