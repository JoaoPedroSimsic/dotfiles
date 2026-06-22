export ZSH="$HOME/.oh-my-zsh"
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export EDITOR="nvim"
export TMUX_CONF="$HOME/.config/tmux/.tmux.conf"
export LANG="${LANG:-C.UTF-8}"
export LC_ALL="${LC_ALL:-C.UTF-8}"

typeset -U path
path=(
  "$HOME/.tmuxifier/bin"
  "$HOME/.config/composer/vendor/bin"
  "$HOME/.composer/vendor/bin"
  "$HOME/.local/bin/scripts"
  "$HOME/.fzf/bin"
  "$HOME/.npm-global/bin"
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  "$GOBIN"
  "/usr/local/bin"
  $path 
)
export PATH

ZSH_THEME=""
plugins=(zsh-navigation-tools git kitty z zsh-autosuggestions)

if [ -z "$SSH_AUTH_SOCK" ]; then
    eval "$(ssh-agent -s)" > /dev/null
fi

ssh-add -l > /dev/null || {
    ssh-add ~/.ssh/server_key 2>/dev/null
    ssh-add ~/.ssh/personal_key 2>/dev/null
    ssh-add ~/.ssh/work_key 2>/dev/null
}

if command -v tmuxifier >/dev/null 2>&1; then
    eval "$(tmuxifier init -)"
fi

if [ -r "$ZSH/oh-my-zsh.sh" ]; then
    source "$ZSH/oh-my-zsh.sh"
fi

if [ "${TERM:-}" != "dumb" ] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init zsh)"
fi

alias zs="nvim ~/.zshrc"
alias rb="reboot"
alias sd="sudo shutdown now"

[[ $- == *i* && -t 0 ]] && stty -ixon

bindkey -r '^S'
bindkey -r -M emacs '^S'
bindkey -r -M viins '^S'
