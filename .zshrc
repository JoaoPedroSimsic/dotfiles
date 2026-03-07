export ZSH="$HOME/.oh-my-zsh"
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH="$HOME/.tmuxifier/bin:$HOME/.config/composer/vendor/bin:$HOME/.local/bin/scripts:$HOME/.npm-global/bin:$GOBIN:$PATH"
export TMUX_CONF="$HOME/.config/tmux/.tmux.conf"
export EDITOR="${EDITOR:-nvim}"

ZSH_THEME="robbyrussell"

# --- Improved SSH Agent Logic ---
# This ensures it finds the agent even if you source ~/.zshrc multiple times
if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

# Add keys if they aren't already in the agent
ssh-add -l > /dev/null || {
    ssh-add ~/.ssh/personal_key 2>/dev/null
    ssh-add ~/.ssh/work_key 2>/dev/null
}

# --- Plugins & Initialization ---
eval "$(tmuxifier init -)"
plugins=(zsh-navigation-tools git kitty z zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

# --- Aliases ---
alias zs="nvim ~/.zshrc"
alias rb="reboot"
alias sd="sudo shutdown now"
alias hy="nvim ~/.config/hypr/hyprland.conf"

# --- Terminal & Key Fixes (The "Final Word") ---
# Disable flow control (XON/XOFF) to free up Ctrl+S
[[ $- == *i* ]] && stty -ixon

# Bind the keys to ZLE (Zsh Line Editor)
bindkey -r '^S'
bindkey -r -M emacs '^S'
bindkey -r -M viins '^S'
