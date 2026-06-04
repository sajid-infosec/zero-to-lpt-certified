# Cheatsheet · Enumeration

> Copy-paste starting points. Adapt IPs/interfaces. Authorized targets only.

## Host discovery
```bash
nmap -sn 10.0.0.0/24 -oA hosts            # ping sweep
netdiscover -r 10.0.0.0/24                 # ARP (local segment)
fping -aqg 10.0.0.0/24
arp-scan --localnet
```

## Port scanning
```bash
# fast full-range, then detailed on found ports
nmap -p- --min-rate 2000 -T4 10.0.0.5 -oA all
nmap -sC -sV -p22,80,445 10.0.0.5 -oA detail
nmap -sU --top-ports 50 10.0.0.5           # UDP top ports
masscan 10.0.0.0/24 -p1-65535 --rate 1000  # huge ranges
```

## SMB / NetBIOS (139/445)
```bash
nmap -p445 --script smb2-security-mode,smb-os-discovery 10.0.0.5
nbtstat -A 10.0.0.5                         # (Windows) name table / suffixes
nmblookup -A 10.0.0.5
enum4linux-ng -A 10.0.0.5
nxc smb 10.0.0.0/24                          # hosts, signing, names, null/guest
nxc smb 10.0.0.5 -u '' -p '' --shares       # anon shares
smbclient -L //10.0.0.5/ -N
```

## LDAP (389/636) / AD
```bash
nxc ldap 10.0.0.10 -u '' -p ''
ldapsearch -x -H ldap://10.0.0.10 -s base namingcontexts
ldapsearch -x -H ldap://10.0.0.10 -b "DC=corp,DC=local"
windapsearch -d corp.local --dc-ip 10.0.0.10 -U
```

## Web (80/443)
```bash
whatweb https://10.0.0.5 ; nikto -h https://10.0.0.5
ffuf -u https://10.0.0.5/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -mc 200,301,302,403
feroxbuster -u https://10.0.0.5 -x php,txt,html
gobuster vhost -u https://10.0.0.5 -w subdomains.txt
```

## RPC / other services
```bash
rpcclient -U "" -N 10.0.0.5                  # then: enumdomusers, querydominfo
snmpwalk -v2c -c public 10.0.0.5             # SNMP (161/udp)
showmount -e 10.0.0.5                        # NFS exports
nmap -p3306 --script mysql-info 10.0.0.5     # MySQL
nmap -p1433 --script ms-sql-info 10.0.0.5    # MSSQL
```

## Quick triage habit
```bash
# one-liner: scan, then service-scan the open ports
ports=$(nmap -p- --min-rate 2000 -T4 10.0.0.5 | awk -F/ '/open/{print $1}' | paste -sd,)
nmap -sC -sV -p$ports 10.0.0.5 -oA detail
```

## NetBIOS suffix quick ref
| Suffix | Meaning |
|---|---|
| `<00>` | Workstation/Messenger |
| `<20>` | File Server service |
| `<1B>` | Domain Master Browser |
| `<1C>` | Domain Controllers (GROUP) |
| `<1D>` | Master Browser (UNIQUE) |
