export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export EDITOR="nvim"
export TMUX_CONF="$HOME/.config/tmux/.tmux.conf"
export LANG="${LANG:-C.UTF-8}"
export LC_ALL="${LC_ALL:-C.UTF-8}"

export PATH="$HOME/.tmuxifier/bin:$HOME/.config/composer/vendor/bin:$HOME/.composer/vendor/bin:$HOME/.local/bin/scripts:$HOME/.fzf/bin:$HOME/.npm-global/bin:$HOME/.local/bin:$HOME/.cargo/bin:$GOBIN:/usr/local/bin:$PATH"

if [[ $- == *i* && -t 0 && -z "${DOTFILES_STAY_IN_BASH:-}" ]] && command -v zsh >/dev/null 2>&1; then
    exec zsh
fi

if command -v tmuxifier >/dev/null 2>&1; then
    eval "$(tmuxifier init -)"
fi

if [ "${TERM:-}" != "dumb" ] && command -v starship >/dev/null 2>&1; then
    eval "$(starship init bash)"
fi

alias zs="nvim ~/.zshrc"

[[ $- == *i* && -t 0 ]] && stty -ixon
