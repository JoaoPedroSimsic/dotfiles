#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="/root/ezVoice/ezIntelligence/backend"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$(cd -- "$SCRIPT_DIR/.." && pwd)"
PROJECT_NAME="ezintelligence-dev"
CONTAINER_NAME="ezintelligence-dev-env"
COMPOSE_FILE="${TMPDIR:-/tmp}/${PROJECT_NAME}.compose.yml"

usage() {
    cat <<EOF
Usage: $(basename "$0") [up|shell|down|restart|logs|ps]

Commands:
  up       Build/start the dev env and open zsh (default)
  shell    Open zsh in the running dev env
  down     Stop and remove the dev env
  restart  Recreate the dev env and open zsh
  logs     Follow dev env logs
  ps       Show dev env status
EOF
}

write_compose_file() {
    if [[ ! -d "$REPO_DIR" ]]; then
        echo "Repo path does not exist: $REPO_DIR" >&2
        exit 1
    fi

    cat > "$COMPOSE_FILE" <<EOF
services:
  dev-env:
    build:
      context: $DOTFILES_DIR
      dockerfile: Dockerfile.dev-env
      args:
        USER_ID: \${USER_ID:-1000}
        GROUP_ID: \${GROUP_ID:-1000}
    container_name: $CONTAINER_NAME
    environment:
      TERM: xterm-256color
      EDITOR: nvim
      SSH_AUTH_SOCK: \${SSH_AUTH_SOCK:-}
    volumes:
      - $REPO_DIR:/workspace
      - /var/run/docker.sock:/var/run/docker.sock
      - \${HOME}/.ssh:/home/joao/.ssh:ro
      - \${SSH_AUTH_SOCK:-/dev/null}:\${SSH_AUTH_SOCK:-/dev/null}
    working_dir: /workspace
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
