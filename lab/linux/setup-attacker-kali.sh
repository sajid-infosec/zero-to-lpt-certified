#!/usr/bin/env bash
# =============================================================================
# Zero to LPT Certified — Attacker box convenience setup
# Creates an engagement workspace, helper aliases, proxychains config check,
# and stages pivot binaries. Run as your normal user (NOT root).
#   ./setup-attacker-kali.sh
# =============================================================================
set -uo pipefail
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
log(){ echo -e "${GREEN}[+]${NC} $*"; }
warn(){ echo -e "${YELLOW}[!]${NC} $*"; }

if [[ $EUID -eq 0 ]]; then warn "Run as your normal user, not root."; fi

# 1. Engagement workspace scaffold
WS="$HOME/engagements/lab"
mkdir -p "$WS"/{scans,loot,web,exploits,notes,screenshots,reports}
log "Workspace: $WS"
cat > "$WS/notes/target-template.md" <<'EOF'
# HOST: 10.x.x.x   role:        in-scope: Y
## Open ports/services
## Enumeration highlights
## Foothold (how)              creds:
## PrivEsc (how)
## Loot (creds/keys/hashes)
## Pivot reach (new subnets)
## Proof (flag/hash)
## ATT&CK: [Txxxx]
## Remediation
EOF

# 2. Helper aliases / functions
ALIASES="$HOME/.lpt_aliases"
cat > "$ALIASES" <<'EOF'
# --- Zero to LPT helpers ---
alias ll='ls -alh'
alias serve='python3 -m http.server 80'
alias listen='rlwrap nc -lvnp 443'
alias myip='ip -4 -br addr | grep -v lo'
# quick full scan then service scan: scanme <ip>
scanme(){ local ip="$1"; local p; p=$(nmap -p- --min-rate 2000 -T4 "$ip" | awk -F/ "/open/{print \$1}" | paste -sd,); echo "[+] open: $p"; nmap -sC -sV -p"$p" "$ip" -oA "scan_${ip}"; }
# tty upgrade reminder
ttyup(){ echo "python3 -c 'import pty;pty.spawn(\"/bin/bash\")'; Ctrl+Z; stty raw -echo; fg; export TERM=xterm"; }
EOF
grep -q ".lpt_aliases" "$HOME/.bashrc" || echo "source $ALIASES" >> "$HOME/.bashrc"
log "Aliases added (source ~/.bashrc): serve, listen, scanme, ttyup, myip"

# 3. proxychains config sanity
PCONF="/etc/proxychains4.conf"
if [[ -f "$PCONF" ]]; then
  grep -q "^socks5 127.0.0.1 9050" "$PCONF" 2>/dev/null && log "proxychains: socks5 :9050 set" \
    || warn "Add 'socks5 127.0.0.1 9050' under [ProxyList] in $PCONF (needs sudo)."
else
  warn "proxychains4 not installed; run install-tools.sh"
fi

# 4. Pivot binaries reminder
[[ -x /opt/tools/ligolo-ng/proxy ]] && log "Ligolo proxy at /opt/tools/ligolo-ng/proxy" \
  || warn "Ligolo not staged; see install-tools.sh or download from github.com/nicocha30/ligolo-ng"

# 5. Stage linpeas/winpeas to web dir for easy serving
if [[ -d /opt/tools/PEASS-ng ]]; then
  find /opt/tools/PEASS-ng -name 'linpeas.sh' -exec cp {} "$WS/web/" \; 2>/dev/null && log "linpeas staged in web/"
fi

log "Attacker setup complete. cd $WS and start hacking (authorized targets only)."
