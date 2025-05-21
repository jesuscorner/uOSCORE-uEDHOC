#!/bin/bash

SESSION_NAME="edhoc"

# Lanzar los contenedores
echo "Lanzando contenedores Docker..."
docker compose up -d

sleep 5

# Comprobar si ya existe una sesión tmux anterior
if tmux has-session -t $SESSION_NAME 2>/dev/null; then
    echo "Sesión tmux '$SESSION_NAME' ya existe. Cerrándola primero..."
    tmux kill-session -t $SESSION_NAME
fi

# Crear nueva sesión tmux
echo "Creando nueva sesión tmux '$SESSION_NAME'..."
tmux new-session -d -s $SESSION_NAME

# Activar modo ratón en tmux
tmux set-option -g mouse on

# Dividir en dos paneles verticalmente
tmux split-window -h

# Enviar comandos a cada panel
tmux select-pane -t 0
tmux send-keys "docker exec -it edhoc-responder-1 bash -c 'cd /tmp && bash'" C-m

tmux select-pane -t 1
tmux send-keys "docker exec -it edhoc-initiator-1 bash -c 'cd /tmp && bash'" C-m

# Adjuntar a la sesión
tmux attach-session -t $SESSION_NAME
