# .p10k.zsh — Pure-inspired, two lines, transient, Catppuccin Mocha colors.
# Hand-rolled minimal config (no p10k configure walkthrough required).

'builtin' 'local' '-a' 'p10k_config_opts'
[[ ! -o 'aliases'         ]] || p10k_config_opts+=('aliases')
[[ ! -o 'sh_glob'         ]] || p10k_config_opts+=('sh_glob')
[[ ! -o 'no_brace_expand' ]] || p10k_config_opts+=('no_brace_expand')
'builtin' 'setopt' 'no_aliases' 'no_sh_glob' 'brace_expand'

() {
  emulate -L zsh -o extended_glob

  # Wipe any prior settings so this file is self-contained.
  unset -m '(POWERLEVEL9K_*|DEFAULT_USER)~POWERLEVEL9K_GITSTATUS_DIR'

  # ----------------------------------------------------------------------------
  # Prompt anatomy: two lines.
  #   line 1 (left):  current directory
  #   line 1 (right): git status when present
  #   line 2 (left):  ❯
  # ----------------------------------------------------------------------------
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir prompt_char)
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(vcs)
  typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
  typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=true     # prompt_char on its own line
  typeset -g POWERLEVEL9K_RPROMPT_ON_NEWLINE=false   # vcs on the same line as dir
  typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

  # No segment separators or backgrounds — keep it Pure-like and quiet.
  typeset -g POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=''
  typeset -g POWERLEVEL9K_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_RIGHT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''
  typeset -g POWERLEVEL9K_BACKGROUND=''   # transparent everywhere
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=''
  typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=' '

  # ----------------------------------------------------------------------------
  # Colors (Catppuccin Mocha — using xterm-256 numerics that approximate the hex)
  #   183 ≈ lavender (#b4befe)        — prompt char
  #   147 ≈ mauve    (#cba6f7)        — git branch
  #   216 ≈ peach    (#fab387)        — git dirty
  #   146 ≈ surface2 (#585b70)        — dim accents
  #   189 ≈ text     (#cdd6f4)        — dir
  # ----------------------------------------------------------------------------

  # Directory: clean, slightly dim, truncate from middle when long.
  typeset -g POWERLEVEL9K_DIR_FOREGROUND=189
  typeset -g POWERLEVEL9K_DIR_SHORTENED_FOREGROUND=146
  typeset -g POWERLEVEL9K_DIR_ANCHOR_FOREGROUND=189
  typeset -g POWERLEVEL9K_DIR_ANCHOR_BOLD=true
  typeset -g POWERLEVEL9K_SHORTEN_STRATEGY=truncate_to_unique
  typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
  typeset -g POWERLEVEL9K_SHORTEN_DELIMITER=
  typeset -g POWERLEVEL9K_DIR_HYPERLINK=true   # cmd-click in compatible terminals

  # Prompt char: green ❯ on success, red ❯ on failure, blue when in vi-cmd mode.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_OK_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=183
  typeset -g POWERLEVEL9K_PROMPT_CHAR_ERROR_{VIINS,VICMD,VIVIS,VIOWR}_FOREGROUND=210
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIINS_CONTENT_EXPANSION='❯'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VICMD_CONTENT_EXPANSION='❮'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIVIS_CONTENT_EXPANSION='V'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_{OK,ERROR}_VIOWR_CONTENT_EXPANSION='▶'
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=''
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_FIRST_SEGMENT_START_SYMBOL=''

  # Git: branch in mauve, peach when dirty, no detail noise.
  typeset -g POWERLEVEL9K_VCS_BRANCH_ICON=' '
  typeset -g POWERLEVEL9K_VCS_CLEAN_FOREGROUND=147
  typeset -g POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=216
  typeset -g POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=216
  typeset -g POWERLEVEL9K_VCS_CONFLICTED_FOREGROUND=210
  typeset -g POWERLEVEL9K_VCS_LOADING_FOREGROUND=146

  # ----------------------------------------------------------------------------
  # Transient prompt: when a command is submitted, collapse the previous prompt
  # to just the prompt char + command. Scrollback reads as a clean log.
  # ----------------------------------------------------------------------------
  typeset -g POWERLEVEL9K_TRANSIENT_PROMPT=always

  # Instant prompt: silent on shell startup.
  typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

  # Show prompt on the second line as a single char with a space after.
  typeset -g POWERLEVEL9K_PROMPT_CHAR_LEFT_PROMPT_LAST_SEGMENT_END_SYMBOL=
  typeset -g POWERLEVEL9K_MULTILINE_FIRST_PROMPT_GAP_CHAR=' '
}

(( ${#p10k_config_opts} )) && setopt ${p10k_config_opts[@]}
'builtin' 'unset' 'p10k_config_opts'
