# Dotfiles

## How to use if on macOS
1. Download and install Homebrew:  `/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`
2. Run `brew bundle`
3. Use stow to create symlinks: (be in dotfiles dir) `stow --dotfiles bash` and/or `stow --dotfiles nvim` etc.

**NOTE** the *--dotfiles* flag is to enable stow to preprocess files and folders that have 'dot-' prefix which will be replaced with a literal '.' for the file name. This makes it easier to work with files and folders in the dotfiles because they won't be hidden. See the stow man pages for more information.

