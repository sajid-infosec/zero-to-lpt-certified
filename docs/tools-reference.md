# Tools Reference

> Purpose, typical usage, strengths, and limits for the toolkit you'll actually use. Install everything on your attacker box with [`../lab/linux/install-tools.sh`](../lab/linux/install-tools.sh). Always read each tool's `--help`/man — this is a quick orientation, not a manual.

> ⚠️ Use only against systems you own or are authorized to test.

## Reconnaissance & enumeration

| Tool | Purpose | Usage example | Strengths / Limits |
|---|---|---|---|
| **Nmap** | host/port/service discovery, NSE scripts | `nmap -sC -sV -p- -oA scan 10.0.0.5` | The backbone; NSE is huge. Noisy at high `-T`. |
| **masscan** | internet-scale fast port sweep | `masscan 10.0.0.0/16 -p1-65535 --rate 1000` | Very fast; pair with Nmap for detail. |
| **nbtstat / nmblookup** | NetBIOS name table | `nbtstat -A 10.0.0.5` | Reveals role/domain. NetBIOS must be reachable. |
| **enum4linux-ng** | SMB/RPC enumeration | `enum4linux-ng -A 10.0.0.5` | Rich (users/shares/OS); noisy. |
| **rpcclient** | MS-RPC queries | `rpcclient -U "" -N 10.0.0.5` | Manual control; null sessions often blocked. |
| **subfinder / amass** | subdomain discovery | `subfinder -d t.com` | Passive+active; amass is deeper/slower. |
| **httpx** | probe live web hosts | `cat hosts | httpx -tech-detect` | Fast triage of large lists. |
| **whatweb / wappalyzer** | tech fingerprint | `whatweb https://t` | Quick stack ID. |

## Web & API

| Tool | Purpose | Usage | Notes |
|---|---|---|---|
| **Burp Suite** | intercepting proxy, repeater, intruder | GUI | Pro adds scanner; Community fine for manual. |
| **ffuf** | fast content/param fuzzing | `ffuf -u https://t/FUZZ -w wordlist` | Pair with SecLists; filter by size/code. |
| **feroxbuster** | recursive content discovery | `feroxbuster -u https://t -x php` | Recursion is great for nested dirs. |
| **sqlmap** | automated SQLi | `sqlmap -r req.txt --batch --dbs` | Powerful; learn manual SQLi too. |
| **wpscan** | WordPress audit | `wpscan --url https://t --enumerate vp,u` | Needs API token for full CVE data. |
| **jwt_tool** | JWT analysis/forge/crack | `jwt_tool <tok> -C -d wl.txt` | Covers `alg:none`, confusion, cracking. |
| **arjun** | hidden parameter discovery | `arjun -u https://t/api` | Finds undocumented params. |
| **nuclei** | template-based vuln scanning | `nuclei -u https://t` | Fast known-issue checks; community templates. |

## Credentials & cracking

| Tool | Purpose | Usage | Notes |
|---|---|---|---|
| **NetExec (nxc)** | SMB/LDAP/WinRM/MSSQL/SSH spraying & post-ex | `nxc smb 10.0.0.0/24 -u u -p p` | Successor to CrackMapExec; lockout-aware. |
| **Hydra** | online brute-force (many protocols) | `hydra -L u -P p ssh://10.0.0.5` | Generic; loud, lockout-prone — use sparingly. |
| **John the Ripper** | offline hash cracking | `john --wordlist=rockyou h` | Great auto-detect; `unshadow` first. |
| **hashcat** | GPU hash cracking | `hashcat -m 1000 h rockyou -r best64.rule` | Fastest; learn the modes (1000 NTLM, 1800 sha512crypt, 13100 Kerberoast, 16500 JWT). |
| **kerbrute** | AD user enum + spray | `kerbrute userenum -d c.local u.txt` | Fast, low-noise user validation. |
| **Responder** | LLMNR/NBT-NS/MDNS poisoning | `responder -I eth0` | Captures NTLM; very noisy, internal only. |

## Active Directory

| Tool | Purpose | Notes |
|---|---|---|
| **Impacket** | `*exec`, secretsdump, GetUserSPNs, GetNPUsers, ntlmrelayx, ticketer | The Windows post-ex backbone (Python). |
| **BloodHound + SharpHound / bloodhound-python** | AD attack-path graphing | Run early; ingest, then query shortest paths. |
| **Rubeus** | Kerberos ops on Windows (roast, asktgt, s4u, ptt) | Pair with Mimikatz. |
| **Mimikatz / nanodump** | dump/forge tickets & creds (LSASS/SAM) | AV will flag; obfuscate/inline as needed. |
| **Certipy** | AD CS enum & ESC abuse | Finds + exploits vulnerable templates. |
| **Evil-WinRM** | interactive WinRM shell | Supports PtH (`-H`). |
| **ldapdomaindump / windapsearch** | LDAP object dumps | Offline analysis. |

## Pivoting & tunneling

| Tool | Purpose | Notes |
|---|---|---|
| **OpenSSH** (`-L/-R/-D`) | forwards & SOCKS | No upload needed if creds exist. |
| **Ligolo-ng** | tun-based routing, multi-hop | Cleanest for deep pivots. |
| **chisel** | SOCKS over HTTP/WS | When only web egress is allowed. |
| **proxychains4** | run any tool via SOCKS | `-sT -Pn` scans only. |
| **sshuttle** | "VPN over SSH" for a subnet | Quick subnet access. |

## Binary / RE / fuzzing

| Tool | Purpose | Notes |
|---|---|---|
| **GDB + pwndbg/GEF** | dynamic analysis | Registers, stack, breakpoints. |
| **Ghidra / radare2 / cutter** | decompile & static RE | Ghidra is free and powerful. |
| **pwntools** | scripted exploitation | ROP, packing, process I/O. |
| **ROPgadget / ropper** | gadget discovery | Build ROP chains. |
| **checksec** | binary protections | NX/ASLR/canary/PIE/RELRO. |
| **AFL++ / boofuzz** | coverage / network fuzzing | Find crashes/bugs. |

## IoT / OT

| Tool | Purpose | Notes |
|---|---|---|
| **binwalk** | firmware signature scan + extract | `-e` to carve. |
| **firmware-mod-kit / unsquashfs** | FS extraction | SquashFS superblock info. |
| **QEMU / firmadyne / FAT** | firmware emulation | Interact with device UI. |
| **Wireshark / tshark** | packet/Modbus analysis | Filter `modbus`. |
| **conpot** | ICS honeypot (practice) | Generate safe OT traffic. |

## Cloud

| Tool | Purpose | Notes |
|---|---|---|
| **Pacu** | AWS exploitation | Modular. |
| **ScoutSuite** | multi-cloud config audit | Read-only posture review. |
| **CloudFox** | post-foothold awareness | Finds privesc leads. |
| **ROADtools / AzureHound** | Azure AD enum/paths | BloodHound-style for Entra. |

## AI / LLM testing

| Tool | Purpose | Notes |
|---|---|---|
| **garak** | LLM vuln scanner | Prompt injection, jailbreak, leakage probes. |
| **PyRIT** | generative-AI risk toolkit | Microsoft; red-team automation. |
| **promptfoo** | prompt eval/red-team harness | Repeatable test cases. |
| **ART / Counterfit** | adversarial ML | Evasion/inversion/extraction. |

## Frameworks & C2 (LPT/red-team maturity)

| Tool | Purpose | Notes |
|---|---|---|
| **Metasploit** | exploitation + post-ex framework | Great for known exploits, handlers, pivoting (`autoroute`). |
| **Sliver** | modern open-source C2 | mTLS/WireGuard; cross-platform. |
| **Mythic** | multi-agent C2 | Dockerized, extensible. |
| **Havoc** | modern C2 | Cobalt-Strike-like, free. |

## Reporting / notes

| Tool | Purpose |
|---|---|
| **Obsidian / CherryTree / Joplin / Notion** | structured engagement notes |
| **Flameshot / Greenshot** | timestamped screenshots |
| **SysReptor / Ghostwriter / Dradis** | report generation & finding libraries |

> **Golden rule:** know *why* and *when* to use a tool, not just the command. The exam rewards the operator who switches tools fluidly when one fails.
