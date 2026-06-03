# Domain 07 · Windows Exploitation & Privilege Escalation

> Module 8. Get a foothold on Windows, then become `SYSTEM`/Administrator. The bridge to Active Directory dominance.

## Why it matters

Most enterprises run on Windows. After landing a low-priv shell (web shell, service exploit, captured creds), you must escalate to fully control the host and harvest credentials for lateral movement.

## Initial access on Windows (common routes)

- Exploitable service (e.g., SMB **MS17‑010/EternalBlue** on legacy, vulnerable web apps).
- Valid creds → remote exec (WinRM/SMB/RDP) via **Impacket**/**Evil-WinRM**/**NetExec**.
- Captured hashes → **Pass-the-Hash**.

## Privilege-escalation categories (enumerate all)

| Category | What to look for | Exploit |
|---|---|---|
| **Service misconfig** | unquoted service paths, weak service binary/registry perms, `SERVICE_CHANGE_CONFIG` | hijack binary path |
| **Token privileges** | `SeImpersonatePrivilege`, `SeAssignPrimaryToken` | **Potato** family (Juicy/Print/Rogue/GodPotato) → SYSTEM |
| **Registry** | `AlwaysInstallElevated` (HKLM+HKCU), autoruns | malicious MSI |
| **Credentials** | stored creds, `cmdkey`, unattended files, registry, browser, SAM/LSASS | reuse / dump |
| **Scheduled tasks** | tasks running as SYSTEM with writable targets | replace target |
| **DLL hijacking** | writable dir in a privileged process's search path | plant DLL |
| **UAC** | secondary local admin account | over-the-shoulder elevation / UAC bypass |
| **Kernel exploits** | missing patches | last resort (can crash) |

## Methodology / workflow

1. **Situational awareness:** `whoami /all` (privileges + groups), `systeminfo`, OS/patch level, `net user`, `net localgroup administrators`.
2. **Automated enum:** **winPEAS**, **PowerUp**, **Seatbelt**, **SharpUp** — read output critically.
3. **Pick the cleanest vector** (token/service/creds before kernel).
4. **Escalate**, stabilize as SYSTEM/Admin.
5. **Loot creds:** SAM/SYSTEM hive, LSASS (Mimikatz/comsvcs), DPAPI, vaults → feed lateral movement.

## Tools & usage

| Tool | Purpose |
|---|---|
| **winPEAS / PowerUp / Seatbelt** | privesc enumeration |
| **Mimikatz / nanodump** | dump creds/hashes/tickets from LSASS |
| **GodPotato / PrintSpoofer** | `SeImpersonate` → SYSTEM |
| **Impacket (secretsdump)** | dump SAM/LSA/NTDS |
| **Evil-WinRM** | interactive WinRM shell |
| **accesschk** | check object permissions |

## Commands (quick)

```powershell
whoami /all
.\winPEASany.exe quiet
# Unquoted service path / weak perms (PowerUp)
powershell -ep bypass; . .\PowerUp.ps1; Invoke-AllChecks
# Token abuse to SYSTEM
.\PrintSpoofer64.exe -i -c cmd      # or GodPotato
```
```bash
# From attacker with creds/hash
nxc smb 10.0.0.5 -u user -p 'pass' --sam       # dump SAM hashes
impacket-secretsdump 'DOM/user:pass@10.0.0.5'
evil-winrm -i 10.0.0.5 -u user -H <ntlm-hash>  # pass-the-hash
```

## Common pitfalls

- Jumping to kernel exploits first (risky/crashy) — exhaust config/token/cred vectors.
- Not reading `whoami /all` — `SeImpersonatePrivilege` is an instant win you can miss.
- Forgetting to loot creds before moving on (they unlock the rest of the network).

## Exam relevance

Windows footholds + privesc are everywhere on the range, and the creds/hashes you loot feed the AD and pivoting phases. Token-impersonation (Potato) and credential dumping are especially high-value.

## MITRE / mapping

- Privilege Escalation `T1548`, `T1134` (Token), `T1543` (Services), `T1574` (Hijacking); Credential Access `T1003` (OS Credential Dumping), `T1550.002` (Pass-the-Hash).

## Practice

- HTB Academy **Windows Privilege Escalation**; Proving Grounds Windows boxes.
- Practice each category once in your lab Windows VM ([`lab/windows/`](../../lab/windows/)).

## Self-check

- [ ] I can identify and exploit `SeImpersonatePrivilege` to SYSTEM.
- [ ] I can dump SAM/LSASS and pass-the-hash to another host.
- [ ] I can enumerate and exploit a service/registry misconfig by hand.
