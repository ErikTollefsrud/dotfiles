# vim:ft=ruby

if OS.mac?
  # taps
  tap "homebrew/cask"
  tap "homebrew/cask-fonts"
  tap "koekeishiya/formulae"
  tap "d12frosted/emacs-plus"

  brew "noti" # utility to display notifications from scripts
  brew "trash" # rm, but put in the trash rather than completely delete

  # Applications
  cask "kitty" # a better terminal emulator
  cask "1password/tap/1password-cli"
  brew "emacs-plus --with-native-comp --with-imagemagick --with-modern-doom3-icon" # emacs for mac

elsif OS.linux?
  brew "xclip" # access to clipboard (similar to pbcopy/pbpaste)
  cask "kitty"

  brew "emacs"
end

# Fonts
cask "font-fira-code"
cask "font-jetbrains-mono"
cask "font-cascadia-mono"
cask "font-symbols-only-nerd-font"
brew "font-hack-nerd-font"

tap "homebrew/bundle"
tap "homebrew/core"

# packages
brew "bat" # better cat
brew "git" # Git version control (latest version)
brew "lazygit" # A better git UI
brew "glow" # markdown viewer
brew "neovim" # A better vim
brew "tmux" # terminal multiplexer
brew "tree" # pretty-print directory contents
brew "wget" # internet file retriever
brew "fzf" # Fuzzy file searcher, used in scripts and in vim
brew "exa" # ls alternative
brew "entr" # file watcher /command runner
brew "zsh" #install latest version of zsh
