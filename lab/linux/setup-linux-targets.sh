#!/usr/bin/env bash
# =============================================================================
# Zero to LPT Certified — Vulnerable Linux targets (Docker-based)
# Spins up intentionally vulnerable apps/services for practice.
#   sudo ./setup-linux-targets.sh up      # start all
#   sudo ./setup-linux-targets.sh down    # stop/remove
#   sudo ./setup-linux-targets.sh status
#
# ⚠️  ISOLATED LAB ONLY. These are deliberately insecure. Never expose to a
#     network you don't fully control. Bind to localhost / host-only by default.
# =============================================================================
set -uo pipefail
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log(){ echo -e "${GREEN}[+]${NC} $*"; }
warn(){ echo -e "${YELLOW}[!]${NC} $*"; }
err(){ echo -e "${RED}[-]${NC} $*"; }

if ! command -v docker &>/dev/null; then
  err "Docker not installed. Install: apt install -y docker.io && systemctl enable --now docker"
  exit 1
fi

ACTION="${1:-up}"
# Bind to localhost by default so these never leak onto a real network.
BIND="${BIND:-127.0.0.1}"

declare -A TARGETS=(
  [dvwa]="-p ${BIND}:8081:80 vulnerables/web-dvwa"
  [juiceshop]="-p ${BIND}:8082:3000 bkimminich/juice-shop"
  [bwapp]="-p ${BIND}:8083:80 raesene/bwapp"
  [webgoat]="-p ${BIND}:8084:8080 -p ${BIND}:9090:9090 webgoat/webgoat"
  [crapi]="" # crAPI uses compose; see note below
  [vampi]="-p ${BIND}:8085:5000 erev0s/vampi"
)

up() {
  log "Starting vulnerable targets (bound to ${BIND})..."
  for name in dvwa juiceshop bwapp webgoat vampi; do
    if docker ps -a --format '{{.Names}}' | grep -q "^lpt-${name}$"; then
      docker start "lpt-${name}" >/dev/null && log "started lpt-${name}"
    else
      # shellcheck disable=SC2086
      docker run -d --name "lpt-${name}" ${TARGETS[$name]} >/dev/null 2>&1 \
        && log "created lpt-${name}" || warn "failed lpt-${name} (image pull/network?)"
    fi
  done
  echo
  log "Endpoints:"
  cat <<EOF
  DVWA          http://${BIND}:8081       (admin/password; LFI, SQLi, upload, command injection)
  Juice Shop    http://${BIND}:8082       (modern web/API, OWASP Top 10)
  bWAPP         http://${BIND}:8083       (bee/bug; huge vuln catalog)
  WebGoat       http://${BIND}:8084/WebGoat
  VAmPI (API)   http://${BIND}:8085       (vulnerable REST API + JWT)
EOF
  warn "crAPI (API+JWT lab) uses docker-compose. Get it from: github.com/OWASP/crAPI"
  warn "For OS-level practice (SSH/SMB privesc, pivoting), use the Vagrant range or VulnHub VMs."
}

down() {
  log "Stopping/removing lab targets..."
  for name in dvwa juiceshop bwapp webgoat vampi; do
    docker rm -f "lpt-${name}" >/dev/null 2>&1 && log "removed lpt-${name}" || true
  done
}

status() {
  docker ps -a --filter "name=lpt-" --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'
}

case "$ACTION" in
  up) up ;;
  down) down ;;
  status) status ;;
  *) echo "Usage: $0 {up|down|status}   (BIND=10.0.10.20 to bind elsewhere)";;
esac
