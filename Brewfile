# Brewfile — declarative dependency list. Run `brew bundle install --file=./Brewfile`
# (or simply run install.sh, which calls it).

# --- Taps ---
tap "d12frosted/emacs-plus"

# --- Formulae ---
brew "zsh"
brew "tmux"
brew "emacs-plus@30"   # native-comp is enabled by default in @30+
brew "git"
brew "git-delta"            # syntax-highlighted git pager
brew "bat"
brew "eza"
brew "fd"
brew "fzf"
brew "zoxide"
brew "ripgrep"
brew "vivid"                # generates themed LS_COLORS
brew "jq"

# --- Casks ---
# Note: WezTerm is installed manually (drag-to-Applications). Brew can't
# adopt an existing /Applications/WezTerm.app without sudo, so we don't
# manage it here. Remove the existing app and uncomment if you want
# brew to manage updates.
# cask "wezterm"
cask "font-jetbrains-mono"
cask "font-jetbrains-mono-nerd-font"   # all-in-one (icons + ligatures); for terminals that don't do font fallback (iTerm2)
cask "font-symbols-only-nerd-font"     # icons-only fallback used by WezTerm config
