export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export EDITOR="nvim"
export TMUX_CONF="$HOME/.config/tmux/.tmux.conf"

typeset -U path
path=(
  "$HOME/.tmuxifier/bin"
  "$HOME/.config/composer/vendor/bin"
  "$HOME/.local/bin/scripts"
  "$HOME/.npm-global/bin"
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$GOBIN"
  $path 
)
export PATH

ZSH_THEME=""
plugins=(zsh-navigation-tools git kitty z zsh-autosuggestions)

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

ssh-add -l > /dev/null || {
    ssh-add ~/.ssh/personal_key 2>/dev/null
    ssh-add ~/.ssh/work_key 2>/dev/null
}

eval "$(tmuxifier init -)"

source $ZSH/oh-my-zsh.sh
eval "$(starship init zsh)"

alias zs="nvim ~/.zshrc"
alias rb="reboot"
alias sd="sudo shutdown now"
alias hy="nvim ~/.config/hypr/hyprland.conf"

[[ $- == *i* ]] && stty -ixon

bindkey -r '^S'
bindkey -r -M emacs '^S'
bindkey -r -M viins '^S'
