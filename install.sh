#!/usr/bin/env bash

# This install script was largely inspired by https://github.com/nicknisi/dotfiles

DOTFILES="$(pwd)"
COLOR_GRAY="\033[1;38;5;243m"
COLOR_BLUE="\033[1;34m"
COLOR_GREEN="\033[1;32m"
COLOR_RED="\033[1;31m"
COLOR_PURPLE="\033[1;35m"
COLOR_YELLOW="\033[1;33m"
COLOR_NONE="\033[0m"

PLATFORM="$(uname)"

title() {
    echo -e "\n${COLOR_PURPLE}$1${COLOR_NONE}"
    echo -e "${COLOR_GRAY}==============================${COLOR_NONE}\n"
}

error() {
    echo -e "${COLOR_RED}Error: ${COLOR_NONE}$1"
    exit 1
}

warning() {
    echo -e "${COLOR_YELLOW}Warning: ${COLOR_NONE}$1"
}

info() {
    echo -e "${COLOR_BLUE}Info: ${COLOR_NONE}$1"
}

success() {
    echo -e "${COLOR_GREEN}$1${COLOR_NONE}"
}

get_linkables() {
    find -H "$DOTFILES" -maxdepth 3 -name '*.symlink'
}

backup() {
    BACKUP_DIR=$HOME/dotfiles-backup

    echo "Creating backup directory at $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"

    for file in $(get_linkables); do
        filename=".$(basename "$file" '.symlink')"
        target="$HOME/$filename"
        if [ -f "$target" ]; then
            echo "backing up $filename"
            cp "$target" "$BACKUP_DIR"
        else
            warning "$filename does not exist at this location or is a symlink"
        fi
    done

    for filename in "$HOME/.config/nvim" "$HOME/.vim" "$HOME/.vimrc"; do
        if [ ! -L "$filename" ]; then
            echo "backing up $filename"
            cp -rf "$filename" "$BACKUP_DIR"
        else
            warning "$filename does not exist at this location or is a symlink"
        fi
    done
}

setup_symlinks() {
    title "Creating symlinks"
	
    stowFolders=$(find "$DOTFILES/stow" -mindepth 1 -maxdepth 1 -type d)

    for file in $stowFolders ; do
	    info "Creating symlink for $file"
	    fileName="$(basename "$file")"
	    stow --dir=$DOTFILES/stow --target=$HOME $fileName
    done
}

setup_git() {
    title "Setting up Git"

    defaultName=$(git config user.name)
    defaultEmail=$(git config user.email)
    defaultGithub=$(git config github.user)

    read -rp "Name [$defaultName] " name
    read -rp "Email [$defaultEmail] " email
    read -rp "Github username [$defaultGithub] " github

    git config -f ~/.gitconfig-local user.name "${name:-$defaultName}"
    git config -f ~/.gitconfig-local user.email "${email:-$defaultEmail}"
    git config -f ~/.gitconfig-local github.user "${github:-$defaultGithub}"

    if [[ "$(uname)" == "Darwin" ]]; then
        git config --global credential.helper "osxkeychain"
    else
        read -rn 1 -p "Save user and password to an unencrypted file to avoid writing? [y/N] " save
        if [[ $save =~ ^([Yy])$ ]]; then
            git config --global credential.helper "store"
        else
            git config --global credential.helper "cache --timeout 3600"
        fi
    fi
}

install_brew_apps() {
    info "Installing applications in Brewfile"

    if test ! "$(command -v brew)"; then
        info "Homebrew not installed. Installing."
        # Run as a login shell (non-interactive) so that the script doesn't pause for user input
        curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh | bash --login
    fi

    if [ "$(uname)" == "Linux" ]; then
        test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
        test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        test -r ~/.bash_profile && echo "eval \$($(brew --prefix)/bin/brew shellenv)" >>~/.bash_profile
    fi

    # install brew dependencies from Brewfile
    brew bundle

    # install fzf
    echo -e
    info "Installing fzf"
    "$(brew --prefix)"/opt/fzf/install --key-bindings --completion --no-update-rc --no-bash --no-fish
}

# For now let's only support distros with apt-get
install_apt_apps() {
    info "Installing application in LinuxApps"

    # check that apt is installed, and exit function if we can't find it.
    if test ! "$(command -v apt)"; then
        warming "Thought we were on Linux but can't find apt binary"
        return 1
    fi 

    # update & upgrade packages
    apt update && apt upgrade

    # loop over LinuxApps file and install each item
    while read -r line;
    do
        sudo apt -y install "$line";
    done < $DOTFILES/LinuxApps
}

install_apps() {
    title "Installing Applications"

    if [ "$(uname)" == "Darwin" ]; then
        install_brew_apps
    else
        install_apt_apps
    fi
}

setup_doom(){
    title "Installing Doom Emacs"

    if ! emacs_loc="$(type -p "emacs")" || [[ -z $emacs_loc ]]; then
        info "Emacs not installed. Install emacs first, then run ./install.sh doom"

       return
    fi

    info "Installing DOOM emacs"
    git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
    ~/.config/emacs/bin/doom install

    info "Adding ~/.config/emacs/bin to PATH"
    export PATH=$PATH:~/.config/emacs/bin

    info "Running doom sync"
    doom sync
}

fetch_kitty_themes() {
    for palette in frappe latte macchiato mocha; do
        curl -o "$DOTFILES/config/kitty/themes/catppuccin-$palette.conf" "https://raw.githubusercontent.com/catppuccin/kitty/main/$palette.conf"
    done
}

setup_shell() {
    title "Configuring shell"

    [[ -n "$(command -v brew)" ]] && zsh_path="$(brew --prefix)/bin/zsh" || zsh_path="$(which zsh)"
    if ! grep "$zsh_path" /etc/shells; then
        info "adding $zsh_path to /etc/shells"
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi
 
    if [[ "$SHELL" != "$zsh_path" ]]; then
        chsh -s "$zsh_path"
        info "default shell changed to $zsh_path"
    fi
}

function setup_terminfo() {
    title "Configuring terminfo"

    info "adding tmux.terminfo"
    tic -x "$DOTFILES/resources/tmux.terminfo"

    info "adding xterm-256color-italic.terminfo"
    tic -x "$DOTFILES/resources/xterm-256color-italic.terminfo"
}

setup_macos() {
  title "Configuring macOS"

  if [[ "$(uname)" == "Darwin" ]]; then
  
    echo "Set a blazingly fast keyboard repeat rate"
    defaults write NSGlobalDomain KeyRepeat -int 1

    echo "Set a shorter delay until key repeat"
    defaults write NSGlobalDomain InitialKeyRepeat -int 15
    
    echo "expand save dialog by default"
    defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
    
    echo "Enable subpixel font rendering on non-Apple LCDs"
    defaults write NSGlobalDomain AppleFontSmoothing -int 2
    
    echo "Use current directory as default search scope in Finder"
    defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
    
    echo "Show Path bar in Finder"
    defaults write com.apple.finder ShowPathbar -bool true
    
    echo "Kill affected applications"

    for app in Safari Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done
    else
        warning "macOS not detected. Skipping."
    fi
}

case "$1" in
  backup)
    backup
    ;;
  link)
    setup_symlinks
    ;;
  git)
    setup_git
    ;;
  apps)
    setup_homebrew
    ;;
  shell)
    setup_shell
    ;;
  terminfo)
    setup_terminfo
    ;;
  doom)
    setup_doom
    ;;
  macos)
    setup_macos
    ;;
  kittyThemes)
    fetch_catppuccin_theme
    ;;
  all)
    setup_symlinks
    setup_terminfo
    install_apps
    setup_shell
    setup_git
    setup_macos
    ;;
  *)
    echo -e $"\nUsage: $(basename "$0") {backup|link|git|homebrew|shell|terminfo|doom|macos|all}\n"
    exit 1
    ;;
esac

echo -e
success "Done."
