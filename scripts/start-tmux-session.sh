#!/bin/bash

SESSION_NAME="my_auto_tmux_session"

# Verifica se a sessão já está criada
tmux has-session -t $SESSION_NAME 2>/dev/null

# Se a sessão não existir, cria uma nova
if [ $? != 0 ]; then
    # Inicia uma nova sessão tmux em segundo plano
    tmux new-session -d -s $SESSION_NAME

    # Divide a janela inicial em dois painéis verticais
    tmux split-window -h

    # Divida o painel esquerdo horizontalmente
    tmux split-window -v -t $SESSION_NAME:0.0

    # Mude para o painel inferior
    tmux select-pane -t $SESSION_NAME:0.2

    # Abrir vim no painel esquerdo
    tmux send-keys -t $SESSION_NAME:0.0 "vim" C-m

    # Abrir htop no painel da direita
    tmux send-keys -t $SESSION_NAME:0.1 "htop" C-m

    # Voltar para o painel inferior
    tmux select-pane -t $SESSION_NAME:0.2

    # Iniciar um terminal no painel inferior
    tmux send-keys -t $SESSION_NAME:0.2 "bash" C-m

    # Renomear a janela
    tmux rename-window -t $SESSION_NAME:0 "Workspace"

    # Anexar à sessão
    tmux attach-session -t $SESSION_NAME
else
    # Se a sessão já existe, apenas a anexa
    tmux attach-session -t $SESSION_NAME
fi

