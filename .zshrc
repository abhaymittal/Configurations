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
    zgen oh-my-zsh
    # plugins
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/sudo
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search

    # completions
    zgen load zsh-users/zsh-completions src

    # theme
    zgen load bhilburn/powerlevel9k powerlevel9k
    
    # Alias tips for remembering aliases
    zgen load djui/alias-tips

    #Better search
    zgen load psprint/history-search-multi-word
    
    # save all to init script
    zgen save
    
fi

# Theme settings
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(anaconda context dir rbenv vcs)
POWERLEVEL9K_ANACONDA_BACKGROUND="yellow"

PATH="/home/abhay/anaconda2/bin:$PATH"

# Alias for jupyter
alias jn="jupyter notebook"


# IntelliJ
PATH="/mnt/lindata/software/idea-IC-172.4155.36/bin:$PATH"

# Google cloud SDK
# PATH="/mnt/lindata/software/google-cloud-sdk/bin:$PATH"

#MATLAB
MATLABPATH="/home/abhay/.config/matlab"
