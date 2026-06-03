# Domain 08 · Active Directory Penetration Testing

> Module 9 — **the centerpiece of CPENT/LPT.** Most enterprise compromises are AD compromises. Master the full chain from zero-credential enumeration to Domain/Enterprise Admin.

## Why it matters

AD is the identity backbone of nearly every enterprise. Owning AD usually means owning everything. The exam range is built around segmented AD environments; this is where the bulk of high-value points live, and where LPT (Master) is truly earned.

## Mental model: the AD attack chain

```
Recon ─▶ Unauth enum ─▶ Get any credential ─▶ Authed enum (BloodHound)
   ─▶ Kerberos/ACL/delegation/AD CS abuse ─▶ Lateral movement ─▶ DA/EA
   ─▶ Persistence + domain dominance (DCSync, Golden Ticket)
```

## Core protocols & concepts

- **Kerberos:** AS-REQ/REP (TGT), TGS-REQ/REP (service tickets), PAC. The basis of roasting & ticket attacks.
- **NTLM:** challenge/response; relayable when SMB signing isn't required.
- **LDAP:** the directory query language; source of all object/ACL data.
- **SMB:** shares, remote exec, signing.
- **SPNs:** service principal names link accounts to services (Kerberoasting target).
- **ACLs / DACLs:** who can do what to which object (GenericAll, WriteDACL, etc.).
- **Delegation:** unconstrained / constrained / resource-based (RBCD).
- **AD CS:** certificate services — ESC1–ESC8 misconfigurations.

## Phase-by-phase

### 1. Enumeration (no creds)
- NetBIOS suffixes (`<1C>`=DC group, `<1D>`=master browser, `<00/20>`=host) via `nbtstat`/`nmap nbstat`.
- Anonymous SMB/LDAP, RID cycling, RPC (`rpcclient`, `enum4linux-ng`).
- Find the DC: open 88/389/445/636 + NetBIOS `<1C>`.
- **AS-REP roasting** (users with pre-auth disabled) needs only a username list.

### 2. Get any credential
- Password spraying (lockout-aware), LLMNR/NBT-NS poisoning (**Responder**) → captured NTLM, default/weak creds, web foothold loot.

### 3. Authenticated enumeration — **BloodHound**
- Collect with **SharpHound**/**bloodhound-python**; analyze paths to "Domain Admins".
- Identify shortest paths, kerberoastable accounts, ACL abuse, sessions of privileged users.

### 4. Credential access
- **Kerberoasting** (`T1558.003`): request TGS for SPN accounts → crack offline.
- **AS-REP roasting** (`T1558.004`).
- **NTLM relay** (`ntlmrelayx`) to hosts without SMB signing → exec or LDAP abuse.
- **DCSync** (`T1003.006`) with replication rights → dump any hash incl. `krbtgt`.

### 5. Privilege escalation within the domain
- **ACL abuse:** GenericAll/WriteDACL/ForceChangePassword/AddMember chains.
- **Delegation abuse:** unconstrained (capture TGTs), constrained (S4U), **RBCD**.
- **AD CS (Certipy):** ESC1 (SAN abuse) → request a cert as DA; ESC8 (web enrollment relay).

### 6. Lateral movement
- **Pass-the-Hash / Pass-the-Ticket / Overpass-the-Hash.**
- Remote exec: `wmiexec`/`smbexec`/`psexec` (Impacket), WinRM (Evil-WinRM), `nxc`.

### 7. Domain dominance & persistence (as authorized)
- **Golden Ticket** (krbtgt), **Silver Ticket** (service), **DCSync**, **Skeleton Key**, AdminSDHolder, Shadow Credentials, SID History.

### 8. Beyond one domain (LPT level)
- **Forest trusts**, child→parent escalation (krbtgt of child + SID history), cross-forest attacks.

## Tools & usage

| Tool | Purpose |
|---|---|
| **NetExec (nxc)** | swiss-army for SMB/LDAP/WinRM/MSSQL enum, spraying, dumping |
| **Impacket** | GetUserSPNs, GetNPUsers, secretsdump, *exec, ticketer, ntlmrelayx |
| **BloodHound + SharpHound** | attack-path graphing |
| **Rubeus** | Kerberos (roast, asktgt, s4u, ptt) on Windows |
| **Certipy** | AD CS enumeration & ESC abuse |
| **Responder** | LLMNR/NBT-NS/MDNS poisoning → hashes |
| **Mimikatz** | dump/forge tickets & hashes |
| **kerbrute** | fast user enum & spraying |
| **ldapdomaindump / windapsearch** | LDAP data |

## Commands (quick)

```bash
# Unauth enum
nxc smb 10.0.0.0/24                                   # hosts, signing, names
kerbrute userenum -d corp.local users.txt --dc 10.0.0.10
# Roasting
impacket-GetNPUsers corp.local/ -usersfile u.txt -no-pass   # AS-REP
impacket-GetUserSPNs corp.local/user:pass -request          # Kerberoast
# BloodHound collection
bloodhound-python -u user -p pass -d corp.local -ns 10.0.0.10 -c All
# Relay (signing off)
impacket-ntlmrelayx -tf targets.txt -smb2support
# DCSync
impacket-secretsdump corp.local/user:pass@10.0.0.10 -just-dc
# AD CS
certipy find -u user@corp.local -p pass -dc-ip 10.0.0.10 -vulnerable
# Lateral (PtH)
nxc smb 10.0.0.20 -u admin -H <ntlm> -x whoami
```

## Common pitfalls

- Spraying without lockout awareness → locking accounts, alerting blue team.
- Not running BloodHound — you'll miss the fast path and grind manually.
- Forgetting SMB-signing checks before planning relay.
- Stopping at one domain when a trust opens the whole forest.

## Exam relevance

This is where most points are. Be fast at: DC identification → credential acquisition → BloodHound → roast/relay/ACL → lateral → DA. Keep an attack-path narrative for the report.

## MITRE / mapping

- `T1558` (Steal/Forge Kerberos Tickets), `T1003.006` (DCSync), `T1550` (Alt Auth Material), `T1207` (Rogue DC), `T1484` (Domain Policy Mod), `T1482` (Domain Trust Discovery).

## Practice

- **GOAD** (this repo deploys it: [`lab/goad/deploy-goad.sh`](../../lab/goad/deploy-goad.sh)) — fundamentals → advanced.
- HTB Academy **AD Enumeration & Attacks**; HTB Forest/Sauna/Active/Resolute; Reel/Mantis for trusts.

## Self-check

- [ ] From one low-priv credential I can reach Domain Admin in a lab without a walkthrough.
- [ ] I can Kerberoast, AS-REP roast, relay (signing off), and DCSync.
- [ ] I can read a BloodHound path and execute the abuses it shows.
- [ ] I can abuse at least one AD CS ESC and one delegation type.
