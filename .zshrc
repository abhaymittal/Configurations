export TERM="xterm-256color"
export EDITOR="emacs -nw"
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile 
HISTSIZE=1000 
SAVEHIST=2000
# Append history to file instead of overwriting and notify when background processes change status
setopt appendhistory notify 
unsetopt autocd extendedglob nomatch

# Set emacs as the editor and bind its keybindings
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/abhay/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall


## BASH CONFIGS COPIED
# PROMPT='%F{red}%n%f@%F{blue}%m%f %F{yellow}%1~%f %# '
# autoload -Uz run-help
# unalias run-help
alias help=run-help


## Key bindings for file manager like syntax (Alt + left) or (Alt+up)
cdUndoKey() {
  popd
  zle       reset-prompt
  echo
  ls
  zle       reset-prompt
}

cdParentKey() {
  pushd ..
  zle      reset-prompt
  echo
  ls
  zle       reset-prompt
}

zle -N                 cdParentKey
zle -N                 cdUndoKey
bindkey '^[[1;3A'      cdParentKey
bindkey '^[[1;3D'      cdUndoKey

## Some common aliases
alias p=pwd
alias psef="ps -ef"
alias grepi="grep -i"

## ttyctl is used to freeze the shell state and avoid changes. This keeps the state of the terminal equal to when it was initialized even when it crashes. I am not sure if I'll need it but putting it here for experimental purposes
ttyctl -f


# load zgen
source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
    echo "Creating a zgen save"
    # plugins
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen oh-my-zsh plugins/zsh-autosuggestions
    zgen oh-my-zsh plugins/autojump

    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search

    # completions
    zgen load zsh-users/zsh-completions src
    # theme
    # zgen load bhilburn/powerlevel9k powerlevel9k
    zgen load romkatv/powerlevel10k powerlevel10k
    
    # Alias tips for remembering aliases
    zgen load djui/alias-tips

    #Better search
    zgen load psprint/history-search-multi-word
    
    # save all to init script
    zgen save
    
fi

# Theme settings
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir rbenv vcs)
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND='039' #blue
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND='000' #alpha
POWERLEVEL9K_DIR_HOME_BACKGROUND='039' ##blue
POWERLEVEL9K_DIR_HOME_FOREGROUND='000' #alpha
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND='039' #blue
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND='000' #alpha
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_BACKGROUND='196' #red
POWERLEVEL9K_DIR_WRITABLE_FORBIDDEN_FOREGROUND='226' #yellow


# Alias for jupyter
alias jn="jupyter notebook"
alias l='ls -lah'
alias la='ls -lAh'
alias ll='ls -lh'
alias ls='ls --color=tty'
alias lsa='ls -lah'
alias md='mkdir -p'
alias p=pwd
alias psef='ps -ef'
alias rd=rmdir
alias run-help=man



# Copy the history file part from oh_my_zsh
## History wrapper
function omz_history {
  local clear list
  zparseopts -E c=clear l=list

  if [[ -n "$clear" ]]; then
    # if -c provided, clobber the history file
    echo -n >| "$HISTFILE"
    echo >&2 History file deleted. Reload the session to see its effects.
  elif [[ -n "$list" ]]; then
    # if -l provided, run as if calling `fc' directly
    builtin fc "$@"
  else
    # unless a number is provided, show all history events (starting from 1)
    [[ ${@[-1]-} = *[0-9]* ]] && builtin fc -l "$@" || builtin fc -l "$@" 1
  fi
}

# Timestamp format
case ${HIST_STAMPS-} in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  "") alias history='omz_history' ;;
  *) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac

## History file configuration
[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000

## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt hist_ignore_dups       # ignore duplicated commands history list
setopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
setopt inc_append_history     # add commands to HISTFILE in order of execution
setopt share_history          # share command history data

alias history=omz_history