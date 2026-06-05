#!/usr/bin/env bash
# =============================================================================
# Zero to LPT Certified — GOAD (Game of Active Directory) deployer wrapper
# GOAD is a free, deliberately vulnerable multi-domain AD lab by Orange
# Cyberdefense. This wrapper installs prerequisites and clones GOAD, then
# hands off to GOAD's own installer (which uses Vagrant/VMware/VirtualBox or
# Proxmox/Ludus, plus Ansible provisioning).
#
# Project: https://github.com/Orange-Cyberdefense/GOAD
#
#   ./deploy-goad.sh
#
# ⚠️  GOAD is INTENTIONALLY VULNERABLE. Deploy only on an ISOLATED lab network.
#     It needs significant resources (recommended 24-32 GB RAM for full GOAD).
# =============================================================================
set -uo pipefail
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; CYAN='\033[0;36m'; NC='\033[0m'
log(){ echo -e "${GREEN}[+]${NC} $*"; }
warn(){ echo -e "${YELLOW}[!]${NC} $*"; }
ask(){ echo -e "${CYAN}[?]${NC} $*"; }

GOAD_DIR="${GOAD_DIR:-$HOME/GOAD}"

cat <<'BANNER'
  ____  ___    _    ____    _ _      _ _
 / ___|/ _ \  / \  |  _ \  | | | __ ( | )  Game of Active Directory
| |  _| | | |/ _ \ | | | | | | |/ _ \V V   (vulnerable AD lab)
| |_| | |_| / ___ \| |_| | | | | (_) |     deploy wrapper
 \____|\___/_/   \_\____/  |_|_|\___/
BANNER

warn "GOAD is intentionally vulnerable — ISOLATED LAB ONLY. Recommended 24-32GB RAM."
echo

# 1. Prereqs
log "Checking prerequisites..."
need_apt=()
for c in git python3 pip3 ansible vagrant; do
  command -v "$c" >/dev/null 2>&1 || need_apt+=("$c")
done
if (( ${#need_apt[@]} )); then
  warn "Missing: ${need_apt[*]}"
  ask "Install missing prerequisites via apt now? [y/N]"
  read -r yn
  if [[ "$yn" =~ ^[Yy]$ ]]; then
    sudo apt-get update -y
    sudo apt-get install -y git python3 python3-pip ansible vagrant
    # ansible collections GOAD needs
    pip3 install --user ansible-core 2>/dev/null || true
  else
    warn "Install them manually, then re-run. (Vagrant also needs a provider: VirtualBox/VMware/libvirt.)"
  fi
fi

# 2. Choose a virtualization provider (GOAD supports several)
echo
ask "Pick your lab backend:"
cat <<EOF
   1) VirtualBox + Vagrant   (free, simplest on a workstation)
   2) VMware + Vagrant       (better Windows perf; needs vagrant-vmware plugin + license)
   3) Proxmox / Ludus        (best for a dedicated lab server / team)
   4) AWS (GOAD on cloud)    (no local RAM needed; costs money)
EOF
read -r provider

case "$provider" in
  1) LAB_PROVIDER="virtualbox" ;;
  2) LAB_PROVIDER="vmware" ;;
  3) LAB_PROVIDER="ludus";   warn "Ludus/Proxmox: follow GOAD's docs after clone." ;;
  4) LAB_PROVIDER="aws";     warn "AWS: follow GOAD's terraform/aws docs after clone." ;;
  *) LAB_PROVIDER="virtualbox"; warn "Defaulting to VirtualBox." ;;
esac
log "Provider: $LAB_PROVIDER"

# 3. Clone GOAD
if [[ -d "$GOAD_DIR/.git" ]]; then
  log "Updating existing GOAD at $GOAD_DIR"; git -C "$GOAD_DIR" pull -q || true
else
  log "Cloning GOAD into $GOAD_DIR"
  git clone --depth 1 https://github.com/Orange-Cyberdefense/GOAD.git "$GOAD_DIR" || {
    warn "Clone failed (network?). Clone manually: git clone https://github.com/Orange-Cyberdefense/GOAD.git"
    exit 1
  }
fi

# 4. Hand off to GOAD's own installer
echo
log "Prerequisites staged. GOAD ships its own installer (goad.sh / install.sh)."
cat <<EOF

${CYAN}Next steps (run inside $GOAD_DIR):${NC}

  cd "$GOAD_DIR"
  # Recommended labs to progress through:
  #   GOAD-Light  -> smaller, fewer VMs (good first target)
  #   GOAD        -> full multi-domain forest with trusts
  #   SCCM / others -> advanced topics

  # Using the unified launcher (recent GOAD):
  ./goad.sh -t install -l GOAD-Light -p $LAB_PROVIDER

  # (older versions: ./install.sh  or follow README per provider)

Once deployed, point your attacker box at the lab network and begin with:
  - docs/cheatsheets/active-directory.md  (the full chain)
  - docs/domains/08-active-directory.md   (theory + workflow)

Practice order: GOAD-Light -> GOAD full -> add trusts/AD CS scenarios.
EOF
warn "Read GOAD's README for the current command syntax — the project evolves."
log "Wrapper finished."
