#!/usr/bin/env bash

set -e

DOTFILES="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

export PATH="$HOME/.local/bin:$HOME/.fzf/bin:$HOME/.npm-global/bin:$PATH"

backup_path() {
    local target="$1"

    if [ -e "$target" ] || [ -L "$target" ]; then
        mkdir -p "$BACKUP_DIR$(dirname "${target#$HOME}")"
        mv "$target" "$BACKUP_DIR/${target#$HOME/}"
        echo "Backed up $target"
    fi
}

link_path() {
    local source="$1"
    local target="$2"

    if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
        echo "Symlink already exists for $target"
        return
    fi

    backup_path "$target"
    mkdir -p "$(dirname "$target")"
    ln -s "$source" "$target"
    echo "Linked $target -> $source"
}

copy_path() {
    local source="$1"
    local target="$2"

    backup_path "$target"
    mkdir -p "$(dirname "$target")"
    cp -r "$source" "$target"
    echo "Copied $target"
}

echo "Copying dotfiles from $DOTFILES to system..."

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.tmuxifier"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config/tmux"

link_path "$DOTFILES/.zshrc" "$HOME/.zshrc"
link_path "$DOTFILES/.config/starship.toml" "$HOME/.config/starship.toml"
link_path "$DOTFILES/.config/nvim" "$HOME/.config/nvim"
link_path "$DOTFILES/.config/lazygit" "$HOME/.config/lazygit"
link_path "$DOTFILES/.config/tmux" "$HOME/.config/tmux"
link_path "$DOTFILES/.config/composer" "$HOME/.config/composer"
link_path "$DOTFILES/scripts" "$HOME/.local/bin/scripts"
link_path "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"

if [ -f "$HOME/.bashrc" ] && ! grep -q "dotfiles/.bashrc" "$HOME/.bashrc"; then
    mkdir -p "$BACKUP_DIR"
    cp "$HOME/.bashrc" "$BACKUP_DIR/.bashrc"
    echo "Backed up $HOME/.bashrc"
    {
        echo ""
        echo "# Load server-friendly dotfiles config."
        echo "[ -r \"\$HOME/dotfiles/.bashrc\" ] && . \"\$HOME/dotfiles/.bashrc\""
    } >> "$HOME/.bashrc"
    echo "Added dotfiles Bash config to ~/.bashrc"
fi

if command -v php >/dev/null 2>&1 && command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null; then
    PHP_VERSION="$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;' 2>/dev/null || true)"
    if [ -n "$PHP_VERSION" ] && [ -d "/etc/php/$PHP_VERSION" ]; then
        for sapi in cli fpm apache2; do
            if [ -d "/etc/php/$PHP_VERSION/$sapi/conf.d" ]; then
                sudo cp "$DOTFILES/php.ini" "/etc/php/$PHP_VERSION/$sapi/conf.d/99-dotfiles.ini"
                echo "Installed PHP config for $sapi"
            fi
        done
    fi
elif command -v php >/dev/null 2>&1; then
    echo "Skipping PHP system config because sudo is not available noninteractively."
fi

echo "Dotfiles copied successfully"

if command -v zsh >/dev/null 2>&1; then
    echo "Changing to zsh shell"
    ZSH_PATH=$(command -v zsh)

    if command -v sudo >/dev/null 2>&1 && sudo -n true 2>/dev/null && ! grep -q "$ZSH_PATH" /etc/shells; then
        echo "Adding $ZSH_PATH to /etc/shells..."
        echo "$ZSH_PATH" | sudo tee -a /etc/shells
    fi

    if [ "$SHELL" != "$ZSH_PATH" ] && grep -q "$ZSH_PATH" /etc/shells; then
        chsh -s "$ZSH_PATH" || echo "Could not change shell automatically; run: chsh -s $ZSH_PATH"
    elif [ "$SHELL" != "$ZSH_PATH" ]; then
        echo "Using Bash handoff to zsh because $ZSH_PATH is not listed in /etc/shells."
    fi
    echo "zsh is available at $ZSH_PATH"
else
    echo "zsh is not installed yet; run scripts/install-packages.sh first."
fi
