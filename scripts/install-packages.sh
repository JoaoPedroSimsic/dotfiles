#!/usr/bin/env bash
set -e

echo "--- Starting System Setup (Linux Mint) ---"

# 1. Package Installation
# Removed kubectl from here as it requires a separate repo/binary
APT_PACKAGES=(
    # general
    zsh tmux neovim fzf ripgrep xclip fd-find diffutils openssh-client curl git unzip
    # docker
    docker.io docker-compose
    # c
    gcc make bear build-essential
    # typescript
    nodejs npm
    # python
    python3 python3-pip
    # lua
    lua5.4 luarocks
    # php
    php php-cli php-fpm php-gd libapache2-mod-php composer
    # go
    golang-go
    # java
    openjdk-21-jdk maven
)

echo "Updating repositories and installing base packages..."
sudo apt update
sudo apt install -y "${APT_PACKAGES[@]}"

# Fix for 'fd' (Mint names the binary fdfind)
if ! command -v fd &>/dev/null; then
    sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
fi

# 2. External Binaries (Not in Mint Repos)
echo -e "\n--- Installing External Tools ---"

# Kubectl (Manual binary install for Mint)
if ! command -v kubectl &>/dev/null; then
    echo "Installing kubectl..."
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
    rm kubectl
fi

# Starship
if ! command -v starship &>/dev/null; then
    echo "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

# Lazygit
if ! command -v lazygit &>/dev/null; then
    echo "Installing Lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz lazygit
fi

# Lazydocker
if ! command -v lazydocker &>/dev/null; then
    echo "Installing Lazydocker..."
    curl https://raw.githubusercontent.com/jesseduffield/lazydocker/master/scripts/install_update_linux.sh | bash
fi

# Stylua
if ! command -v stylua &>/dev/null; then
    echo "Installing Stylua..."
    curl -Lo stylua.zip https://github.com/JohnnyMorganz/StyLua/releases/latest/download/stylua-linux-x86_64.zip
    unzip stylua.zip
    sudo install stylua /usr/local/bin
    rm stylua.zip stylua
fi

# Minikube
if ! command -v minikube &>/dev/null; then
    echo "Installing Minikube..."
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube
    rm minikube-linux-amd64
fi

# Skaffold
if ! command -v skaffold &>/dev/null; then
    echo "Installing Skaffold..."
    curl -Lo skaffold https://storage.googleapis.com/skaffold/releases/latest/skaffold-linux-amd64
    sudo install skaffold /usr/local/bin/skaffold
    rm skaffold
fi

echo "Packages and binaries installed successfully."
