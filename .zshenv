# .zshenv — sourced for EVERY zsh invocation (interactive, scripts, subshells).
# Keep this fast and minimal. Interactive-only setup belongs in .zshrc.

# --- Homebrew (must come early so PATH/MANPATH are set for everything below) ---
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# --- PATH ---
typeset -U path PATH                                      # dedupe
path=(
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  $path
)

# Android SDK (preserved from prior config; harmless if missing)
if [[ -d "$HOME/Library/Android/sdk" ]]; then
  export ANDROID_HOME="$HOME/Library/Android/sdk"
  path=(
    "$ANDROID_HOME/emulator"
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/cmdline-tools/latest/bin"
    $path
  )
fi

# --- Editor ---
export EDITOR="emacsclient -a '' -nw"
export VISUAL="$EDITOR"

# --- Locale ---
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# --- XDG ---
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"

# --- bat (themed Catppuccin Mocha) ---
export BAT_THEME="Catppuccin Mocha"

# --- LS_COLORS (themed via vivid; falls back gracefully if vivid not yet installed) ---
if command -v vivid >/dev/null 2>&1; then
  export LS_COLORS="$(vivid generate catppuccin-mocha 2>/dev/null)"
fi

# --- fzf (themed Catppuccin Mocha + rounded UI) ---
export FZF_DEFAULT_OPTS="
  --height=50%
  --layout=reverse
  --border=rounded
  --preview-window=right:60%:wrap
  --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8
  --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc
  --color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8
  --color=selected-bg:#45475a,border:#6c7086,label:#cdd6f4
"
export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --follow --exclude .git"
