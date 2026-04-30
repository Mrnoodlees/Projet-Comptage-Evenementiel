#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

AUTOSSH_PID=""
TUNNELS_PID=""

cleanup() {
  if [[ -n "${AUTOSSH_PID:-}" ]] && kill -0 "$AUTOSSH_PID" 2>/dev/null; then
    kill "$AUTOSSH_PID" 2>/dev/null || true
  fi
  if [[ -n "${TUNNELS_PID:-}" ]] && kill -0 "$TUNNELS_PID" 2>/dev/null; then
    kill "$TUNNELS_PID" 2>/dev/null || true
  fi
}

trap cleanup EXIT
trap 'cleanup; exit 0' INT TERM

read_env_port() {
  local env_file="$SCRIPT_DIR/.env"
  local value=""

  if [[ -f "$env_file" ]]; then
    value="$(grep -E '^PORT=' "$env_file" | tail -n 1 | cut -d '=' -f2- | tr -d '\r' || true)"
  fi

  if [[ -z "${value:-}" ]]; then
    value="3001"
  fi

  echo "$value"
}

get_env_value() {
  local key="$1"
  local fallback="${2:-}"
  local env_file="$SCRIPT_DIR/.env"
  local value=""

  if [[ -f "$env_file" ]]; then
    value="$(grep -E "^${key}=" "$env_file" | tail -n 1 | cut -d '=' -f2- | tr -d '\r' || true)"
  fi

  if [[ -z "${value:-}" ]]; then
    value="$fallback"
  fi

  echo "$value"
}

list_port_pids() {
  local port="$1"
  local pids=""
  local sudo_pids=""

  if command -v lsof >/dev/null 2>&1; then
    pids="$(lsof -t -iTCP:"$port" -sTCP:LISTEN -Pn 2>/dev/null || true)"
    if [[ -z "$pids" ]] && command -v sudo >/dev/null 2>&1; then
      sudo_pids="$(sudo lsof -t -iTCP:"$port" -sTCP:LISTEN -Pn 2>/dev/null || true)"
    fi
  elif command -v fuser >/dev/null 2>&1; then
    pids="$(fuser -n tcp "$port" 2>/dev/null | tr -d '\n' | sed 's/^[[:space:]]*//')"
    if [[ -z "$pids" ]] && command -v sudo >/dev/null 2>&1; then
      sudo_pids="$(sudo fuser -n tcp "$port" 2>/dev/null | tr -d '\n' | sed 's/^[[:space:]]*//')"
    fi
  fi

  if [[ -n "$sudo_pids" ]]; then
    echo "$sudo_pids"
  else
    echo "$pids"
  fi
}

kill_pids() {
  local pids="$1"

  if [[ -z "$pids" ]]; then
    return 0
  fi

  if ! kill -TERM $pids 2>/dev/null; then
    if command -v sudo >/dev/null 2>&1; then
      sudo kill -TERM $pids || true
    fi
  fi
}

force_kill_pids() {
  local pids="$1"

  if [[ -z "$pids" ]]; then
    return 0
  fi

  if ! kill -KILL $pids 2>/dev/null; then
    if command -v sudo >/dev/null 2>&1; then
      sudo kill -KILL $pids || true
    fi
  fi
}

ensure_sudo() {
  echo "[run] Besoin du mot de passe sudo pour libérer le port."
  echo "[run] Saisis le mot de passe quand il est demandé."
  if ! sudo -k -v; then
    echo "[run] Sudo refusé. Abandon."
    exit 1
  fi
}

force_kill_port_with_sudo() {
  local port="$1"

  if ! command -v sudo >/dev/null 2>&1; then
    return 0
  fi

  ensure_sudo

  if command -v fuser >/dev/null 2>&1; then
    sudo fuser -k -n tcp "$port" >/dev/null 2>&1 || true
  elif command -v lsof >/dev/null 2>&1; then
    local sudo_pids
    sudo_pids="$(sudo lsof -t -iTCP:"$port" -sTCP:LISTEN -Pn 2>/dev/null || true)"
    if [[ -n "$sudo_pids" ]]; then
      sudo kill -KILL $sudo_pids || true
    fi
  fi
}

free_port() {
  local port="$1"
  local pids=""

  pids="$(list_port_pids "$port")"
  if [[ -z "$pids" ]]; then
    return 0
  fi

  echo "[run] Port $port occupé par PID: $pids. Tentative d'arrêt..."
  kill_pids "$pids"
  sleep 1
  local pids_after
  pids_after="$(list_port_pids "$port")"
  if [[ -n "$pids_after" ]]; then
    echo "[run] Arrêt forcé des PID: $pids_after..."
    force_kill_pids "$pids_after"
    sleep 1
    local pids_final
    pids_final="$(list_port_pids "$port")"
    if [[ -n "$pids_final" ]]; then
      echo "[run] Forçage via sudo pour libérer le port $port..."
      force_kill_port_with_sudo "$port"
    fi
  fi
}

PORT="$(read_env_port)"

free_port "$PORT"

# Free tunnel ports before starting tunnels.sh (avoids "Address already in use").
SSH_TUNNEL_ENABLED_ENV="$(get_env_value "SSH_TUNNEL_ENABLED" "false")"
if [[ "$SSH_TUNNEL_ENABLED_ENV" == "true" ]]; then
  SSH_TUNNEL_LOCAL_PORT_ENV="$(get_env_value "SSH_TUNNEL_LOCAL_PORT" "")"
  if [[ -n "$SSH_TUNNEL_LOCAL_PORT_ENV" ]]; then
    free_port "$SSH_TUNNEL_LOCAL_PORT_ENV"
  fi
fi

REVERSE_SSH_ENABLED_ENV="$(get_env_value "REVERSE_SSH_ENABLED" "false")"
if [[ "$REVERSE_SSH_ENABLED_ENV" == "true" ]]; then
  REVERSE_SSH_LOCAL_PORT_ENV="$(get_env_value "REVERSE_SSH_LOCAL_PORT" "")"
  if [[ -n "$REVERSE_SSH_LOCAL_PORT_ENV" ]]; then
    free_port "$REVERSE_SSH_LOCAL_PORT_ENV"
  fi
fi

# Tunnels auto-setup (local DB + reverse VPS).
if [[ -x "$SCRIPT_DIR/tunnels.sh" ]]; then
  "$SCRIPT_DIR/tunnels.sh" &
  TUNNELS_PID="$!"
else
  echo "[run] tunnels.sh introuvable. Relance après l'avoir créé."
  exit 1
fi

# Lance le front + l'API dans ce terminal.
node run.js
