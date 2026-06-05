#!/usr/bin/env bash
# =============================================================================
# Zero to LPT Certified — Attacker toolkit installer (Debian/Kali/Parrot)
# Installs the core pentest toolkit via apt, pipx, go, and git.
# Idempotent-ish: safe to re-run. Run as root (sudo).
#   sudo ./install-tools.sh           # full install
#   sudo ./install-tools.sh --minimal # apt essentials only
# AUTHORIZED USE ONLY. Build/lab machines only.
# =============================================================================
set -uo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
log()  { echo -e "${GREEN}[+]${NC} $*"; }
warn() { echo -e "${YELLOW}[!]${NC} $*"; }
err()  { echo -e "${RED}[-]${NC} $*"; }

if [[ $EUID -ne 0 ]]; then err "Run as root (sudo)."; exit 1; fi

MINIMAL=0
[[ "${1:-}" == "--minimal" ]] && MINIMAL=1

# Real (non-root) user so pipx/go tools land in their home
REAL_USER="${SUDO_USER:-$USER}"
REAL_HOME="$(eval echo "~${REAL_USER}")"
run_user() { sudo -u "$REAL_USER" -H bash -lc "$*"; }

export DEBIAN_FRONTEND=noninteractive

log "Updating package lists..."
apt-get update -y

# ----------------------------------------------------------------------------
# 1. APT packages (most are preinstalled on Kali, but this covers Parrot/Debian)
# ----------------------------------------------------------------------------
APT_PKGS=(
  # core
  git curl wget build-essential python3 python3-pip python3-venv pipx
  golang-go ruby ruby-dev unzip jq net-tools dnsutils tmux rlwrap proxychains4
  # recon / scanning
  nmap masscan netdiscover arp-scan whatweb nikto dnsrecon
  # smb / ad / windows
  smbclient smbmap ldap-utils crackmapexec enum4linux polenum
  # web
  ffuf gobuster feroxbuster wfuzz sqlmap wpscan seclists
  # creds / cracking
  hydra john hashcat hashid hash-identifier medusa
  # binary / re
  gdb radare2 binwalk foremost ltrace strace patchelf
  # misc
  socat ncat tcpdump tshark wireshark hping3 sshuttle iodine
  responder
)

log "Installing apt packages (this can take a while)..."
for pkg in "${APT_PKGS[@]}"; do
  if dpkg -s "$pkg" &>/dev/null; then
    :
  else
    apt-get install -y "$pkg" 2>/dev/null && log "apt: $pkg" || warn "apt: $pkg not available (skipping)"
  fi
done

if [[ $MINIMAL -eq 1 ]]; then
  log "Minimal install complete."
  exit 0
fi

# ----------------------------------------------------------------------------
# 2. pipx tools (isolated Python apps)
# ----------------------------------------------------------------------------
log "Configuring pipx for ${REAL_USER}..."
run_user "pipx ensurepath" || true

# Isolated Python apps. (netexec = nxc, successor to crackmapexec;
# bloodhound = the python collector; certipy-ad = AD CS tooling.)
for t in impacket netexec certipy-ad bloodhound mitm6 ldapdomaindump name-that-hash arjun; do
  run_user "pipx install $t" 2>/dev/null && log "pipx: $t" || warn "pipx: $t failed/exists"
done

# ----------------------------------------------------------------------------
# 3. Go tools (recon)
# ----------------------------------------------------------------------------
log "Installing Go tools for ${REAL_USER}..."
for g in \
  "github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest" \
  "github.com/projectdiscovery/httpx/cmd/httpx@latest" \
  "github.com/projectdiscovery/nuclei/v3/cmd/nuclei@latest" \
  "github.com/ffuf/ffuf/v2@latest" \
  "github.com/OJ/gobuster/v3@latest" \
  "github.com/ropnop/kerbrute@latest" ; do
  run_user "GOBIN=$REAL_HOME/go/bin go install $g" 2>/dev/null && log "go: $g" || warn "go: $g failed"
done

# ----------------------------------------------------------------------------
# 4. Git-cloned tools / binaries into /opt
# ----------------------------------------------------------------------------
log "Cloning extra tooling into /opt/tools ..."
mkdir -p /opt/tools && cd /opt/tools

clone() { # repo dir
  if [[ -d "$2/.git" ]]; then (cd "$2" && git pull -q) && log "updated $2";
  else git clone -q --depth 1 "$1" "$2" && log "cloned $2" || warn "clone $2 failed"; fi
}

clone https://github.com/carlospolop/PEASS-ng.git              PEASS-ng        # linpeas/winpeas
clone https://github.com/rebootuser/LinEnum.git                LinEnum
clone https://github.com/PowerShellMafia/PowerSploit.git       PowerSploit
clone https://github.com/int0x33/nc.exe.git                    ncexe
clone https://github.com/swisskyrepo/PayloadsAllTheThings.git  PayloadsAllTheThings
clone https://github.com/BloodHoundAD/BloodHound.git           BloodHoundGUI
clone https://github.com/dirkjanm/ROADtools.git                ROADtools
clone https://github.com/t3l3machus/Villain.git                Villain

# Ligolo-ng (pivoting) — fetch latest release binaries
log "Fetching Ligolo-ng + chisel binaries..."
mkdir -p /opt/tools/ligolo-ng && cd /opt/tools/ligolo-ng
LIGOLO_VER="$(curl -fsSL https://api.github.com/repos/nicocha30/ligolo-ng/releases/latest | jq -r .tag_name 2>/dev/null)"
if [[ -n "${LIGOLO_VER:-}" && "$LIGOLO_VER" != "null" ]]; then
  base="https://github.com/nicocha30/ligolo-ng/releases/download/${LIGOLO_VER}"
  v="${LIGOLO_VER#v}"
  curl -fsSL -o proxy.tar.gz   "${base}/ligolo-ng_proxy_${v}_linux_amd64.tar.gz" 2>/dev/null && tar xzf proxy.tar.gz 2>/dev/null && log "ligolo proxy"
  curl -fsSL -o agent.tar.gz   "${base}/ligolo-ng_agent_${v}_linux_amd64.tar.gz" 2>/dev/null && tar xzf agent.tar.gz 2>/dev/null && log "ligolo agent (linux)"
  warn "Grab Windows ligolo agent from: ${base}"
else
  warn "Could not resolve Ligolo-ng release (network?). Download manually from github.com/nicocha30/ligolo-ng/releases"
fi

cd /opt/tools
clone https://github.com/jpillora/chisel.git chisel-src || true

chown -R "$REAL_USER":"$REAL_USER" /opt/tools

# ----------------------------------------------------------------------------
# 5. Wordlists
# ----------------------------------------------------------------------------
if [[ ! -f /usr/share/wordlists/rockyou.txt ]]; then
  if [[ -f /usr/share/wordlists/rockyou.txt.gz ]]; then
    gunzip -k /usr/share/wordlists/rockyou.txt.gz && log "rockyou unpacked"
  else
    warn "rockyou.txt not found; install 'wordlists' pkg or download SecLists."
  fi
fi
[[ -d /usr/share/seclists ]] && log "SecLists present" || warn "Install SecLists: apt install seclists"

# ----------------------------------------------------------------------------
log "Done. Open a NEW shell so PATH updates (pipx/go bin) take effect."
log "Verify with: nmap --version; nxc --version; impacket-secretsdump -h; ffuf -V"
warn "Reminder: authorized, legal, lab/contracted use ONLY."
