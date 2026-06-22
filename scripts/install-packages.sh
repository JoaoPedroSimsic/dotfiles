#!/usr/bin/env bash
set -e

echo "--- Starting System Setup ---"

export PATH="$HOME/.local/bin:$HOME/.fzf/bin:$HOME/.npm-global/bin:$PATH"

install_zsh() {
    if command -v zsh >/dev/null 2>&1; then
        return
    fi

    echo "Installing user-local zsh..."
    printf '2\nn\n' | sh -c "$(curl -fsSL https://raw.githubusercontent.com/romkatv/zsh-bin/master/install)" || true

    if ! command -v zsh >/dev/null 2>&1; then
        echo "zsh install did not complete successfully."
        exit 1
    fi
}

install_neovim() {
    if command -v nvim >/dev/null 2>&1; then
        return
    fi

    echo "Installing latest Neovim..."
    mkdir -p "$HOME/.local/bin" "$HOME/.local/opt"
    curl -fL https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz -o /tmp/nvim-linux-x86_64.tar.gz
    rm -rf "$HOME/.local/opt/nvim-linux-x86_64"
    tar -xzf /tmp/nvim-linux-x86_64.tar.gz -C "$HOME/.local/opt"
    ln -sf "$HOME/.local/opt/nvim-linux-x86_64/bin/nvim" "$HOME/.local/bin/nvim"
}

install_starship() {
    if command -v starship >/dev/null 2>&1; then
        return
    fi

    echo "Installing Starship..."
    mkdir -p "$HOME/.local/bin"
    curl -fsSL https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
}

install_lazygit() {
    if command -v lazygit >/dev/null 2>&1; then
        return
    fi

    echo "Installing lazygit..."
    mkdir -p "$HOME/.local/bin"
    LAZYGIT_VERSION="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep -oP '"tag_name": "\K[^"]+')"
    curl -fL "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz" -o /tmp/lazygit.tar.gz
    tar -xzf /tmp/lazygit.tar.gz -C /tmp lazygit
    mv /tmp/lazygit "$HOME/.local/bin/lazygit"
    chmod +x "$HOME/.local/bin/lazygit"
}

install_lazydocker() {
    if command -v lazydocker >/dev/null 2>&1; then
        return
    fi

    echo "Installing lazydocker..."
    mkdir -p "$HOME/.local/bin"
    LAZYDOCKER_VERSION="$(curl -fsSL https://api.github.com/repos/jesseduffield/lazydocker/releases/latest | grep -oP '"tag_name": "\K[^"]+')"
    curl -fL "https://github.com/jesseduffield/lazydocker/releases/download/${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION#v}_Linux_x86_64.tar.gz" -o /tmp/lazydocker.tar.gz
    tar -xzf /tmp/lazydocker.tar.gz -C /tmp lazydocker
    mv /tmp/lazydocker "$HOME/.local/bin/lazydocker"
    chmod +x "$HOME/.local/bin/lazydocker"
}

install_ripgrep() {
    if command -v rg >/dev/null 2>&1; then
        return
    fi

    echo "Installing ripgrep..."
    mkdir -p "$HOME/.local/bin"
    RG_VERSION="$(curl -fsSL https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | grep -oP '"tag_name": "\K[^"]+')"
    curl -fL "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION#v}-x86_64-unknown-linux-musl.tar.gz" -o /tmp/ripgrep.tar.gz
    tar -xzf /tmp/ripgrep.tar.gz -C /tmp
    cp "/tmp/ripgrep-${RG_VERSION#v}-x86_64-unknown-linux-musl/rg" "$HOME/.local/bin/rg"
    chmod +x "$HOME/.local/bin/rg"
}

install_fd() {
    if command -v fd >/dev/null 2>&1; then
        return
    fi

    echo "Installing fd..."
    mkdir -p "$HOME/.local/bin"
    FD_VERSION="$(curl -fsSL https://api.github.com/repos/sharkdp/fd/releases/latest | grep -oP '"tag_name": "\K[^"]+')"
    curl -fL "https://github.com/sharkdp/fd/releases/download/${FD_VERSION}/fd-${FD_VERSION}-x86_64-unknown-linux-gnu.tar.gz" -o /tmp/fd.tar.gz
    tar -xzf /tmp/fd.tar.gz -C /tmp
    cp "/tmp/fd-${FD_VERSION}-x86_64-unknown-linux-gnu/fd" "$HOME/.local/bin/fd"
    chmod +x "$HOME/.local/bin/fd"
}

install_fzf() {
    if command -v fzf >/dev/null 2>&1; then
        return
    fi

    echo "Installing fzf..."
    if [ ! -d "$HOME/.fzf/.git" ]; then
        rm -rf "$HOME/.fzf"
        git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    fi
    "$HOME/.fzf/install" --bin
}

# 1. Package Installation
if command -v pacman &>/dev/null; then
    echo "Detected pacman"
    PACKAGES=(
        zsh which git curl unzip tmux fzf ripgrep xclip fd diffutils openssh bc
        docker docker-compose
        gcc make bear
        nodejs npm
        python python-pip
        lua luarocks stylua
        php composer php-apache php-fpm php-gd php-intl php-sqlite php-pgsql
        go
        jdk21-openjdk maven
    )
    sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}"
elif command -v apt &>/dev/null; then
    echo "Detected apt"
    PACKAGES=(
        ca-certificates curl git unzip tar gzip zsh tmux fzf ripgrep fd-find xclip diffutils openssh-client bc
        build-essential make gcc
        python3 python3-pip
        lua5.4 luarocks
        php-cli php-fpm php-common php-curl php-mbstring php-xml php-zip php-gd php-intl php-bcmath php-mysql php-pgsql php-sqlite3 composer
        default-jdk maven
    )
    if sudo -n true 2>/dev/null; then
        sudo apt update
        if ! command -v node >/dev/null 2>&1; then
            PACKAGES+=(nodejs)
        fi

        if ! command -v docker >/dev/null 2>&1; then
            if apt-cache show docker-ce >/dev/null 2>&1; then
                PACKAGES+=(docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin)
            else
                PACKAGES+=(docker.io docker-compose-plugin)
            fi
        elif ! docker compose version >/dev/null 2>&1; then
            PACKAGES+=(docker-compose-plugin)
        fi

        sudo apt install -y "${PACKAGES[@]}"

        mkdir -p "$HOME/.local/bin"
        if command -v fdfind >/dev/null 2>&1 && ! command -v fd >/dev/null 2>&1; then
            ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
        fi
    else
        echo "Skipping apt packages because sudo is not available noninteractively."
    fi
else
    echo "No supported package manager found"
    exit 1
fi

install_zsh
install_neovim
install_starship
install_lazygit
install_lazydocker
install_ripgrep
install_fd
install_fzf

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

mkdir -p "$HOME/.npm-global"
npm config set prefix "$HOME/.npm-global"
NPM_MODULES=(
    typescript
    typescript-language-server
    eslint
    eslint_d
    prettier
    @fsouza/prettierd
    neovim
    intelephense
    blade-formatter
    tree-sitter-cli
)
npm install -g "${NPM_MODULES[@]}"
echo "NPM modules installed."

COMPOSER_MODULES=(laravel/pint)
composer global require "${COMPOSER_MODULES[@]}"
echo "Composer modules installed."

# 4. Git Clones with directory checks (Prevents crash if exists)
echo -e "\n--- Setting up Tools & Shell ---"

if [ ! -d "$HOME/.tmuxifier/.git" ]; then
    echo "Installing tmuxifier..."
    rm -rf "$HOME/.tmuxifier"
    git clone https://github.com/jimeh/tmuxifier.git "$HOME/.tmuxifier"
else
    echo "Tmuxifier already installed."
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    export RUNZSH=no
    export CHSH=no
    export KEEP_ZSHRC=yes
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "oh-my-zsh already installed."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed."
fi

if [ ! -d "$ZSH_CUSTOM/plugins/zsh-navigation-tools" ]; then
    echo "Installing zsh-navigation-tools..."
    git clone https://github.com/psprint/zsh-navigation-tools.git "$ZSH_CUSTOM/plugins/zsh-navigation-tools"
else
    echo "zsh-navigation-tools already installed."
fi

echo -e "\n--- Setup Complete! ---"
