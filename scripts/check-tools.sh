#!/usr/bin/env bash
# =============================================================================
# Zero to LPT Certified — verify your attacker toolkit is present.
# Prints OK/MISSING for each expected tool. Non-destructive.
#   ./check-tools.sh
# =============================================================================
set -uo pipefail
GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok=0; miss=0

check(){ # name [command-to-test]
  local name="$1"; local cmd="${2:-$1}"
  if command -v "$cmd" >/dev/null 2>&1; then
    printf "  ${GREEN}OK${NC}      %s\n" "$name"; ((ok++))
  else
    printf "  ${RED}MISSING${NC} %s\n" "$name"; ((miss++))
  fi
}

echo "== Recon / scanning =="
check nmap; check masscan; check subfinder; check httpx; check whatweb; check nikto

echo "== SMB / AD =="
check "netexec (nxc)" nxc; check "impacket-secretsdump" impacket-secretsdump
check "GetUserSPNs" impacket-GetUserSPNs; check enum4linux-ng; check smbclient
check "bloodhound-python" bloodhound-python; check certipy; check kerbrute; check responder

echo "== Web =="
check ffuf; check feroxbuster; check gobuster; check sqlmap; check wpscan; check nuclei

echo "== Creds / cracking =="
check hydra; check john; check hashcat

echo "== Binary / RE =="
check gdb; check radare2 r2; check binwalk; check "ROPgadget" ROPgadget; check checksec

echo "== Pivoting =="
check proxychains4; check sshuttle
[[ -x /opt/tools/ligolo-ng/proxy ]] && { echo -e "  ${GREEN}OK${NC}      ligolo-ng proxy"; ((ok++)); } || { echo -e "  ${YELLOW}NOTE${NC}    ligolo-ng not in /opt/tools (optional)"; }

echo
echo "Summary: ${GREEN}${ok} present${NC}, ${RED}${miss} missing${NC}."
[[ $miss -gt 0 ]] && echo "Run lab/linux/install-tools.sh (open a fresh shell afterwards for PATH)."
exit 0
