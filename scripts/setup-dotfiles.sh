#!/usr/bin/env bash

set -e

# npm related things: neovim prettier eslint etc...

DOTFILES="$HOME/dotfiles"

echo "Copying dotfiles from $DOTFILES to system..."

if [ ! -d "$HOME/.config" ]; then
	echo "Creating .config directory..."
	mkdir -p "$HOME/.config"
fi

if [ ! -d "$HOME/.tmuxifier" ]; then
	echo "Creating .tmuxifier directory..."
	mkdir -p "$HOME/.tmuxifier"
fi

if [ ! -d "$HOME/.local/bin" ]; then
	echo "Creating .local/bin directory..."
	mkdir -p "$HOME/.local/bin"
fi

cp "$DOTFILES/.zshrc" "$HOME/.zshrc"
cp "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
cp "$DOTFILES/.config/starship.toml" "$HOME/.config/"
sudo cp "$DOTFILES/php.ini" "/etc/php/"

TARGET="$HOME/.config/nvim"

if [ -e "$TARGET" ] && [ ! -L "$TARGET" ]; then
    echo "Removing existing folder (not a symlink)..."
    rm -rf "$TARGET"
fi

if [ ! -L "$TARGET" ]; then
		ln -s "$DOTFILES/.config/nvim" "$TARGET"
    echo "Symlink created."
else
    echo "Symlink already exists."
fi

cp -r "$DOTFILES/.config/lazygit" "$HOME/.config/"
cp -r "$DOTFILES/.config/tmux" "$HOME/.config/"
cp -r "$DOTFILES/.config/composer" "$HOME/.config/"
cp -r "$DOTFILES/.config/go" "$HOME/.config/"
cp -r "$DOTFILES/.config/rclone" "$HOME/.config/"
cp -r "$DOTFILES/scripts" "$HOME/.local/bin/"

echo "Dotfiles copied successfully"

echo "Changing to zsh shell"

ZSH_PATH=$(which zsh)

if ! grep -q "$ZSH_PATH" /etc/shells; then
    echo "Adding $ZSH_PATH to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
fi

chsh -s "$ZSH_PATH"

echo "Shell changed successfully"

