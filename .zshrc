# .zshrc — interactive shell only.
# Speed targets: visible prompt < 100ms (p10k instant prompt), full ready < 300ms.

# ============================================================================
# 1. Powerlevel10k instant prompt — MUST stay at the top.
#    Renders the prompt before plugins finish loading.
# ============================================================================
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ============================================================================
# 2. History
# ============================================================================
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

setopt extended_history          # timestamps in history file
setopt hist_expire_dups_first    # drop dupes first when trimming
setopt hist_ignore_dups          # don't record consecutive dupes
setopt hist_ignore_space         # leading-space commands are private
setopt hist_verify               # show !! expansion before running
setopt inc_append_history        # append to file as you go (not on exit)
setopt share_history             # share across sessions
setopt notify                    # report background job status immediately

# ============================================================================
# 3. Keybindings — emacs mode
# ============================================================================
bindkey -e

# ============================================================================
# 4. Completion — compinit with daily cache validation (the slow part skipped
#    on most invocations).
# ============================================================================
autoload -Uz compinit
() {
  local zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
  # Run a full security check at most once per day; otherwise fast path.
  if [[ -n "$zcompdump"(#qN.mh+24) ]]; then
    compinit
    touch "$zcompdump"
  else
    compinit -C
  fi
}

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # case-insensitive
zstyle ':completion:*:descriptions' format '%F{cyan}-- %d --%f'
zstyle ':completion:*' group-name ''

# ============================================================================
# 5. Plugins via zgenom
# ============================================================================
if [[ ! -d "$HOME/.zgenom" ]]; then
  echo "First run: clone zgenom with the install.sh script in the Configurations repo."
else
  source "$HOME/.zgenom/zgenom.zsh"

  if ! zgenom saved; then
    echo "Building zgenom plugin cache..."

    # zsh-defer (lets us defer expensive plugins until the prompt is interactive)
    zgenom load romkatv/zsh-defer

    # Standalone plugins (no oh-my-zsh framework — too heavy)
    zgenom load hcgraf/zsh-sudo                    # ESC-ESC to prepend sudo
    zgenom load Aloxaf/fzf-tab                     # tab completion via fzf

    # Deferred (sourced after prompt is ready)
    zgenom load zsh-users/zsh-completions          # extra completions
    zgenom load zdharma-continuum/fast-syntax-highlighting
    zgenom load zsh-users/zsh-autosuggestions
    zgenom load djui/alias-tips

    # Theme — last so it takes effect immediately
    zgenom load romkatv/powerlevel10k powerlevel10k

    zgenom save
    zgenom compile "$HOME/.zshrc"
  fi
fi

# ============================================================================
# 6. zsh-autosuggestions config (must be set before plugin loads its widgets)
# ============================================================================
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20

# ============================================================================
# 7. Tool initialization (zoxide, fzf, etc.)
# ============================================================================
# zoxide — smarter cd. `z foo` jumps to most-frecent dir matching foo.
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# fzf shell integration — provides ^R history widget, ^T file picker, Alt-C cd.
# Homebrew installs fzf shell scripts under $(brew --prefix)/opt/fzf/shell/.
if [[ -n "$HOMEBREW_PREFIX" && -d "$HOMEBREW_PREFIX/opt/fzf/shell" ]]; then
  source "$HOMEBREW_PREFIX/opt/fzf/shell/key-bindings.zsh"
  source "$HOMEBREW_PREFIX/opt/fzf/shell/completion.zsh"
fi

# ============================================================================
# 8. Aliases
# ============================================================================
# Modern replacements (only aliased where the old name is safe to override).
if command -v bat >/dev/null 2>&1; then
  alias cat='bat --paging=never'
fi

if command -v eza >/dev/null 2>&1; then
  alias ls='eza --icons --git --group-directories-first --time-style=relative'
  alias ll='eza -l --icons --git --group-directories-first --time-style=relative'
  alias la='eza -la --icons --git --group-directories-first --time-style=relative'
  alias tree='eza --tree --icons --git'
fi

# Quality-of-life
alias l='ls'
alias md='mkdir -p'
alias rd=rmdir
alias p=pwd
alias psef='ps -ef'
alias grepi='grep -i'

# ============================================================================
# 9. Long-running command notification
#    For any foreground command that takes > 30s, post a native macOS
#    notification when it finishes.
# ============================================================================
typeset -g _NOTIFY_THRESHOLD=30
typeset -g _NOTIFY_LAST_CMD=""
typeset -g _NOTIFY_START_TS=0

_notify_before() {
  _NOTIFY_LAST_CMD="$1"
  _NOTIFY_START_TS=$EPOCHSECONDS
}

_notify_after() {
  local last_status=$?
  if (( _NOTIFY_START_TS > 0 )); then
    local elapsed=$(( EPOCHSECONDS - _NOTIFY_START_TS ))
    if (( elapsed >= _NOTIFY_THRESHOLD )) && command -v osascript >/dev/null 2>&1; then
      local title="done in ${elapsed}s"
      (( last_status != 0 )) && title="failed (status ${last_status}) after ${elapsed}s"
      local cmd_display="${_NOTIFY_LAST_CMD:0:80}"
      osascript -e "display notification \"${cmd_display//\"/\\\"}\" with title \"${title}\"" 2>/dev/null &!
    fi
    _NOTIFY_START_TS=0
    _NOTIFY_LAST_CMD=""
  fi
}

zmodload zsh/datetime
autoload -Uz add-zsh-hook
add-zsh-hook preexec _notify_before
add-zsh-hook precmd  _notify_after

# ============================================================================
# 10. Lazy conda — first invocation runs the real init, then re-runs the call.
#     Saves ~200ms on every shell that doesn't touch conda.
# ============================================================================
conda() {
  unset -f conda
  local conda_root="$HOME/miniconda3"
  if [[ -f "$conda_root/etc/profile.d/conda.sh" ]]; then
    source "$conda_root/etc/profile.d/conda.sh"
  elif [[ -x "$conda_root/bin/conda" ]]; then
    eval "$("$conda_root/bin/conda" shell.zsh hook)"
  else
    echo "conda not found at $conda_root" >&2
    return 127
  fi
  conda "$@"
}

# ============================================================================
# 11. Powerlevel10k personal config (pre-baked, symlinked from repo)
# ============================================================================
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# ============================================================================
# 12. ttyctl — freeze tty state across crashes (kept from prior config)
# ============================================================================
ttyctl -f 2>/dev/null
