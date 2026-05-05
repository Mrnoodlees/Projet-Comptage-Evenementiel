#!/usr/bin/env bash
set -euo pipefail

# Gestion centralisée des tunnels SSH du projet :
# - tunnel local vers la BDD
# - tunnel inversé vers la VPS
# Le script supporte ssh, autossh, clés SSH et sshpass.
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

get_env() {
  # Lit une variable dans .env sans charger tout le fichier comme script Bash.
  local key="$1"
  local fallback="${2:-}"
  local value=""

  if [[ -f "$ENV_FILE" ]]; then
    value="$(grep -E "^${key}=" "$ENV_FILE" | tail -n 1 | cut -d '=' -f2- | tr -d '\r' || true)"
  fi

  if [[ -z "${value:-}" ]]; then
    value="$fallback"
  fi

  echo "$value"
}

ensure_sudo() {
  if ! command -v sudo >/dev/null 2>&1; then
    return 0
  fi

  if sudo -n true 2>/dev/null; then
    return 0
  fi

  echo "[tunnel] Besoin du mot de passe sudo pour libérer les ports."
  if ! sudo -k -v; then
    echo "[tunnel] Sudo refusé. Abandon."
    exit 1
  fi
}

free_port() {
  # Évite les conflits quand un ancien tunnel écoute encore sur le même port.
  local port="$1"
  local pids=""

  if command -v lsof >/dev/null 2>&1; then
    pids="$(lsof -t -iTCP:"$port" -sTCP:LISTEN -Pn 2>/dev/null || true)"
  elif command -v fuser >/dev/null 2>&1; then
    pids="$(fuser -n tcp "$port" 2>/dev/null | tr -d '\n' | sed 's/^[[:space:]]*//')"
  fi

  if [[ -z "$pids" ]]; then
    return 0
  fi

  echo "[tunnel] Port $port occupé par PID: $pids. Tentative d'arrêt..."
  if ! kill -TERM $pids 2>/dev/null; then
    ensure_sudo
    sudo kill -TERM $pids 2>/dev/null || true
  fi

  sleep 1
  if command -v lsof >/dev/null 2>&1; then
    pids="$(lsof -t -iTCP:"$port" -sTCP:LISTEN -Pn 2>/dev/null || true)"
  elif command -v fuser >/dev/null 2>&1; then
    pids="$(fuser -n tcp "$port" 2>/dev/null | tr -d '\n' | sed 's/^[[:space:]]*//')"
  fi

  if [[ -n "$pids" ]]; then
    echo "[tunnel] Arrêt forcé des PID: $pids..."
    if ! kill -KILL $pids 2>/dev/null; then
      ensure_sudo
      sudo kill -KILL $pids 2>/dev/null || true
    fi
  fi
}

SSH_BIN="ssh"
SSH_PREFIX=()
if command -v autossh >/dev/null 2>&1; then
  SSH_BIN="autossh"
  SSH_PREFIX=(-M 0)
fi

ALLOW_PROMPT="$(get_env "TUNNEL_ALLOW_PASSWORD_PROMPT" "false")"

build_ssh_opts() {
  # Options communes pour rendre les tunnels plus fiables et détecter les échecs.
  local identity="$1"
  local allow_prompt="$2"
  local -a opts

  opts=(
    -o "ExitOnForwardFailure yes"
    -o "ServerAliveInterval 30"
    -o "ServerAliveCountMax 3"
  )

  if [[ -n "$identity" ]]; then
    opts+=(-i "$identity" -o "IdentitiesOnly yes")
  fi

  if [[ "$allow_prompt" != "true" ]]; then
    opts+=(-o "BatchMode yes" -o "PreferredAuthentications=publickey")
  fi

  printf '%s\n' "${opts[@]}"
}

start_tunnel() {
  # Démarre un tunnel et renvoie son PID pour pouvoir l’arrêter ensuite.
  local name="$1"
  local password="$2"
  shift 2
  local -a cmd=("$@")

  echo "[tunnel] Démarrage ${name}..."

  if [[ -n "$password" ]]; then
    if ! command -v sshpass >/dev/null 2>&1; then
      echo "[tunnel] sshpass requis pour ${name}. Installe: sudo apt install sshpass"
      exit 1
    fi
    SSH_ASKPASS_REQUIRE=force SSH_ASKPASS=/bin/true sshpass -p "$password" "${cmd[@]}" &
  else
    "${cmd[@]}" &
  fi

  echo $!
}

PIDS=()

cleanup() {
  # Ferme tous les tunnels ouverts par ce script.
  for pid in "${PIDS[@]:-}"; do
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
    fi
  done
}

trap 'cleanup; exit 0' INT TERM
trap cleanup EXIT

SSH_TUNNEL_ENABLED="$(get_env "SSH_TUNNEL_ENABLED" "false")"
if [[ "$SSH_TUNNEL_ENABLED" == "true" ]]; then
  # Tunnel local : l’API croit parler à une BDD locale, SSH transmet à la BDD distante.
  SSH_TUNNEL_HOST="$(get_env "SSH_TUNNEL_HOST" "")"
  SSH_TUNNEL_LOCAL_PORT="$(get_env "SSH_TUNNEL_LOCAL_PORT" "25432")"
  SSH_TUNNEL_REMOTE_HOST="$(get_env "SSH_TUNNEL_REMOTE_HOST" "127.0.0.1")"
  SSH_TUNNEL_REMOTE_PORT="$(get_env "SSH_TUNNEL_REMOTE_PORT" "5432")"
  SSH_TUNNEL_PASSWORD="$(get_env "SSH_TUNNEL_PASSWORD" "")"
  SSH_TUNNEL_IDENTITY="$(get_env "SSH_TUNNEL_IDENTITY" "")"

  if [[ -z "$SSH_TUNNEL_HOST" ]]; then
    echo "[tunnel] SSH_TUNNEL_HOST manquant dans .env"
    exit 1
  fi

  free_port "$SSH_TUNNEL_LOCAL_PORT"

  mapfile -t SSH_OPTS < <(build_ssh_opts "$SSH_TUNNEL_IDENTITY" "$ALLOW_PROMPT")

  pid="$(start_tunnel \
    "local -> DB" \
    "$SSH_TUNNEL_PASSWORD" \
    "$SSH_BIN" "${SSH_PREFIX[@]}" \
    "${SSH_OPTS[@]}" \
    -N -L "${SSH_TUNNEL_LOCAL_PORT}:${SSH_TUNNEL_REMOTE_HOST}:${SSH_TUNNEL_REMOTE_PORT}" \
    "$SSH_TUNNEL_HOST")"
  PIDS+=("$pid")
fi

REVERSE_SSH_ENABLED="$(get_env "REVERSE_SSH_ENABLED" "false")"
if [[ "$REVERSE_SSH_ENABLED" == "true" ]]; then
  # Tunnel inversé : un port de la VPS renvoie vers un service de cette machine.
  REVERSE_SSH_HOST="$(get_env "REVERSE_SSH_HOST" "")"
  REVERSE_SSH_REMOTE_PORT="$(get_env "REVERSE_SSH_REMOTE_PORT" "15432")"
  REVERSE_SSH_LOCAL_HOST="$(get_env "REVERSE_SSH_LOCAL_HOST" "127.0.0.1")"
  REVERSE_SSH_LOCAL_PORT="$(get_env "REVERSE_SSH_LOCAL_PORT" "25432")"
  REVERSE_SSH_REMOTE_BIND="$(get_env "REVERSE_SSH_REMOTE_BIND" "127.0.0.1")"
  REVERSE_SSH_PASSWORD="$(get_env "REVERSE_SSH_PASSWORD" "")"
  REVERSE_SSH_IDENTITY="$(get_env "REVERSE_SSH_IDENTITY" "")"

  if [[ -z "$REVERSE_SSH_HOST" ]]; then
    echo "[tunnel] REVERSE_SSH_HOST manquant dans .env"
    exit 1
  fi

  # Ensure reverse port isn't already taken locally (rare, but avoids conflicts).
  if [[ "$REVERSE_SSH_LOCAL_HOST" == "127.0.0.1" ]]; then
    free_port "$REVERSE_SSH_LOCAL_PORT"
  fi

  mapfile -t REVERSE_OPTS < <(build_ssh_opts "$REVERSE_SSH_IDENTITY" "$ALLOW_PROMPT")

  pid="$(start_tunnel \
    "reverse -> VPS" \
    "$REVERSE_SSH_PASSWORD" \
    "$SSH_BIN" "${SSH_PREFIX[@]}" \
    "${REVERSE_OPTS[@]}" \
    -N -R "${REVERSE_SSH_REMOTE_BIND}:${REVERSE_SSH_REMOTE_PORT}:${REVERSE_SSH_LOCAL_HOST}:${REVERSE_SSH_LOCAL_PORT}" \
    "$REVERSE_SSH_HOST")"
  PIDS+=("$pid")
fi

if [[ "${#PIDS[@]}" -eq 0 ]]; then
  echo "[tunnel] Aucun tunnel activé (vérifie SSH_TUNNEL_ENABLED / REVERSE_SSH_ENABLED)."
  exit 0
fi

echo "[tunnel] Tunnels actifs. Ctrl+C pour arrêter."
wait "${PIDS[@]}"
