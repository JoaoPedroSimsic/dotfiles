#!/usr/bin/env bash
set -e

echo "Installing packages..."

PACKAGES=(
	# general
	zsh
	which
	lazygit
	tmux
	neovim
	starship
	fzf
	ripgrep
	xclip
	fd
	diffutils
	openssh

	#
	gcc
	make
	
	# typescript
	nodejs
	npm

	# python
	python
	python-pip

	# lua
	lua
	luarocks
	stylua

	#php
	php
	composer 
	php-apache 
	php-fpm
	php-gd

	go
)

if command -v pacman &>/dev/null; then
	echo "Detected pacman"
	sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}"
elif command -v apt &>/dev/null; then
	echo "Detected apt"
	sudo apt install -y "${PACKAGES[@]}"
else
	echo "No suppoted package manager found"
	exit 1
fi

SSH_KEY="$HOME/.ssh/setup_key"


if [ ! -f "$SSH_KEY" ]; then
	echo "Generating a SSH key"
	read -p "Enter the ssh key email: " EMAIL
	ssh-keygen -t ed25519 -C "$EMAIL" -f "$SSH_KEY" -N ""
	echo "SSH key generated successfully"

	echo
	echo "Copy the following public key and add it to your GitHub account:"
	echo "https://github.com/settings/ssh/new"
	echo
	cat "${SSH_KEY}.pub"
	echo
	read -p "Press Enter after adding the key to GitHub..."
else
	echo "SSH key already exists at $SSH_KEY, skipping generation"
fi

eval "$(ssh-agent -s)"
ssh-add "$SSH_KEY"

echo
echo "Testing SSH connection to GitHub..."
ssh -T git@github.com || true

echo "Packages installed successfully"

NPM_MODULES=(
	typescript
	eslint
	prettier
	neovim
	blade-formatter
)

echo "Installing global npm modules"
sudo npm install -g "${NPM_MODULES[@]}"
echo "NPM modules installed successfully"

COMPOSER_MODULES=(
	laravel/pint
)

echo "Installing global composer modules"
sudo composer global require "${COMPOSER_MODULES[@]}"
echo "Composer modules installed successfully"

echo "Installing tmuxifier"
git clone git@github.com:jimeh/tmuxifier.git ~/.tmuxifier
echo "Tmuxifier installed successfully"

echo "Installing oh-my-zsh"
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
echo "oh-my-zsh installed successfully"

echo "Installing zsh-autosuggestions plugin"
git clone git@github.com:zsh-users/zsh-autosuggestions.git $HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions
echo "zsh-autosuggestions installed"

