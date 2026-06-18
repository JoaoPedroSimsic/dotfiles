#!/usr/bin/env bash

set -euo pipefail

HOST_WORKSPACE_ROOT="${HOME}/ezVoice"
CONTAINER_WORKSPACE_ROOT="/workspace/ezVoice"
PROJECT_NAME="shared-dev-env"
CONTAINER_NAME="shared-dev-env"
BUILD_DIR="${TMPDIR:-/tmp}/${PROJECT_NAME}.build"
COMPOSE_FILE="${TMPDIR:-/tmp}/${PROJECT_NAME}.compose.yml"
DOTFILES_REPO="git@github.com:joaosimsic/dotfiles.git"
DOTFILES_REF="base"
DOCKERFILE_URL="https://raw.githubusercontent.com/joaosimsic/dotfiles/base/Dockerfile.dev-env"

usage() {
    cat <<EOF
Usage: $(basename "$0") [up|shell|down|restart|logs|ps]

Commands:
  up       Build/start the shared dev env and open zsh (default)
  shell    Open zsh in the running shared dev env
  down     Stop and remove the shared dev env
  restart  Recreate the shared dev env and open zsh
  logs     Follow shared dev env logs
  ps       Show shared dev env status

Repos are mounted in two places:
  $CONTAINER_WORKSPACE_ROOT
  $HOST_WORKSPACE_ROOT

Use the original host path when running a repo's docker compose files:
  cd ~/ezVoice/ezIntelligence/backend
  docker compose up -d

Use the workspace path when you only need to edit/browse files:
  cd /workspace/ezVoice/ezIntelligence/backend
EOF
}

write_compose_file() {
    if [[ ! -d "$HOST_WORKSPACE_ROOT" ]]; then
        echo "Workspace root does not exist: $HOST_WORKSPACE_ROOT" >&2
        exit 1
    fi

    mkdir -p "$BUILD_DIR"
    if ! git archive --remote="$DOTFILES_REPO" "$DOTFILES_REF" Dockerfile.dev-env | tar -x -C "$BUILD_DIR" 2>/dev/null; then
        if ! curl -fsSL "$DOCKERFILE_URL" -o "$BUILD_DIR/Dockerfile.dev-env"; then
            cat >&2 <<EOF
Could not download Dockerfile.dev-env.

Make sure Dockerfile.dev-env is committed and pushed to:
  $DOTFILES_REPO
  branch: $DOTFILES_REF

Then run this script again.
EOF
            exit 1
        fi
    fi

    cat > "$COMPOSE_FILE" <<EOF
services:
  dev-env:
    build:
      context: $BUILD_DIR
      dockerfile: Dockerfile.dev-env
      args:
        USER_ID: \${USER_ID:-1000}
        GROUP_ID: \${GROUP_ID:-1000}
    container_name: $CONTAINER_NAME
    user: root
    environment:
      TERM: xterm-256color
      EDITOR: nvim
      SHELL: /usr/bin/zsh
      HOME: /home/joao
      ZDOTDIR: /home/joao
      SSH_AUTH_SOCK: \${SSH_AUTH_SOCK:-}
    volumes:
      - $HOST_WORKSPACE_ROOT:$HOST_WORKSPACE_ROOT
      - $HOST_WORKSPACE_ROOT:$CONTAINER_WORKSPACE_ROOT
      - /var/run/docker.sock:/var/run/docker.sock
      - \${HOME}/.ssh:/home/joao/.ssh:ro
      - \${SSH_AUTH_SOCK:-/dev/null}:\${SSH_AUTH_SOCK:-/dev/null}
    working_dir: $HOST_WORKSPACE_ROOT
    tty: true
    stdin_open: true
    command: tail -f /dev/null
EOF
}

compose() {
    docker compose -f "$COMPOSE_FILE" -p "$PROJECT_NAME" "$@"
}

open_shell() {
    compose exec dev-env /bin/zsh
}

main() {
    local command="${1:-up}"

    case "$command" in
        up)
            write_compose_file
            compose up -d --build
            open_shell
            ;;
        shell)
            write_compose_file
            open_shell
            ;;
        down)
            write_compose_file
            compose down
            ;;
        restart)
            write_compose_file
            compose down
            compose up -d --build
            open_shell
            ;;
        logs)
            write_compose_file
            compose logs -f
            ;;
        ps)
            write_compose_file
            compose ps
            ;;
        -h|--help|help)
            usage
            ;;
        *)
            usage >&2
            exit 1
            ;;
    esac
}

main "$@"
