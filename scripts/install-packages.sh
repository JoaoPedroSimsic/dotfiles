#!/usr/bin/env bash
set -e

echo "--- Starting System Setup ---"

PACKAGES=(
    # general
    zsh which lazygit tmux neovim starship fzf ripgrep xclip fd diffutils openssh
    # docker
    docker docker-compose lazydocker
    # c
    gcc make bear
    # typescript
    nodejs npm
    # python
    python python-pip
    # lua
    lua luarocks stylua
    # php
    php composer php-apache php-fpm php-gd
    # go
    go
    # java
    jdk21-openjdk maven
    # k8s
    skaffold minikube kubectl
)

# 1. Package Installation
if command -v pacman &>/dev/null; then
    echo "Detected pacman"
    sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}"
elif command -v apt &>/dev/null; then
    echo "Detected apt"
    sudo apt update
    sudo apt install -y "${PACKAGES[@]}"
else
    echo "No supported package manager found"
    exit 1
fi

echo "Packages installed successfully."

# 2. SSH Key Setup
echo -e "\n--- SSH Key Setup ---"
echo "1) Generate a new SSH key"
echo "2) Use an existing key (specify path)"
echo "3) Skip SSH setup"
read -p "Choose an option [1-3]: " SSH_CHOICE

SELECTED_SSH_KEY=""

case $SSH_CHOICE in
    1)
        read -p "Enter the ssh key email: " EMAIL
        SELECTED_SSH_KEY="$HOME/.ssh/id_ed25519_setup"
        if [ ! -f "$SELECTED_SSH_KEY" ]; then
            ssh-keygen -t ed25519 -C "$EMAIL" -f "$SELECTED_SSH_KEY" -N ""
            echo "SSH key generated successfully."
        else
            echo "Key already exists at $SELECTED_SSH_KEY."
        fi
        
        echo -e "\nCopy the following public key to GitHub: https://github.com/settings/ssh/new\n"
        cat "${SELECTED_SSH_KEY}.pub"
        echo ""
        read -p "Press Enter after adding the key to GitHub..."
        ;;

    2)
        read -e -p "Enter the full path to your existing private key: " EXISTING_PATH
        # Expand tilde if present
        SELECTED_SSH_KEY="${EXISTING_PATH/#\~/$HOME}"
        
        if [ ! -f "$SELECTED_SSH_KEY" ]; then
            echo "Error: File $SELECTED_SSH_KEY not found. Skipping SSH setup."
            SELECTED_SSH_KEY=""
        fi
        ;;

    *)
        echo "Skipping SSH setup."
        ;;
esac

# Add key to agent and test if a key was selected/created
if [ -n "$SELECTED_SSH_KEY" ]; then
    eval "$(ssh-agent -s)"
    ssh-add "$SELECTED_SSH_KEY"
    echo "Testing SSH connection to GitHub..."
    ssh -T git@github.com || true
fi

# 3. Global Language Modules
echo -e "\n--- Installing Language Modules ---"

NPM_MODULES=(typescript eslint prettier neovim blade-formatter)
sudo npm install -g "${NPM_MODULES[@]}"
echo "NPM modules installed."

COMPOSER_MODULES=(laravel/pint)
composer global require "${COMPOSER_MODULES[@]}"
echo "Composer modules installed."

# 4. Git Clones with directory checks (Prevents crash if exists)
echo -e "\n--- Setting up Tools & Shell ---"

if [ ! -d "$HOME/.tmuxifier" ]; then
    echo "Installing tmuxifier..."
    git clone git@github.com:jimeh/tmuxifier.git ~/.tmuxifier
else
    echo "Tmuxifier already installed."
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    export RUNZSH=no
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh already installed."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone git@github.com:zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed."
fi

echo -e "\n--- Setup Complete! ---"
