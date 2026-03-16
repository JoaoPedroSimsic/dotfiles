#!/usr/bin/env bash
set -e

DOTFILES="$HOME/dotfiles"

echo "Copying dotfiles from $DOTFILES to system..."

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.tmuxifier"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/tmux"

cp "$DOTFILES/.zshrc" "$HOME/.zshrc"
cp "$DOTFILES/.config/starship.toml" "$HOME/.config/"

# --- Improved PHP Logic ---
if command -v php &>/dev/null; then
    PHP_VER=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;')
    echo "Installing php.ini for version $PHP_VER..."
    sudo mkdir -p "/etc/php/$PHP_VER/cli"
    sudo cp "$DOTFILES/php.ini" "/etc/php/$PHP_VER/cli/php.ini"
else
    echo "PHP not found, skipping php.ini copy."
fi
# --------------------------

TARGET="$HOME/.config/nvim"
if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "Removing existing folder (not a symlink)..."
    rm -rf "$TARGET"
fi

if [ ! -L "$TARGET" ]; then
    ln -s "$DOTFILES/.config/nvim" "$TARGET"
    echo "Symlink created for Neovim."
else
    echo "Symlink already exists for Neovim."
fi

cp -r "$DOTFILES/.config/lazygit" "$HOME/.config/"
cp -r "$DOTFILES/.config/tmux" "$HOME/.config/"
cp -r "$DOTFILES/.config/composer" "$HOME/.config/"
cp -r "$DOTFILES/scripts" "$HOME/.local/bin/"
cp "$DOTFILES/.tmux.conf" "$HOME/.config/tmux/tmux.conf"

if [ -f "$HOME/.tmux.conf" ]; then
    rm "$HOME/.tmux.conf"
fi

echo "Dotfiles copied successfully"

echo "Changing to zsh shell"
ZSH_PATH=$(which zsh)

if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "Adding $ZSH_PATH to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

sudo chsh -s "$ZSH_PATH" "$USER"
echo "Shell changed successfully. Log out and back in to see the changes."
