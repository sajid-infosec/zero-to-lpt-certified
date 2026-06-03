# Domain 06 · Perimeter & Defense Evasion

> Module 7. CPENT explicitly tests against **defense-in-depth**: firewalls, IDS/IPS, WAFs, and segmentation. LPT (Master) expects you to operate *despite* defenses, not just against soft targets.

## Why it matters

A real enterprise watches and filters. Knowing how to identify, characterize, and (within scope) bypass perimeter controls is what separates a CTF player from a professional. The exam range deliberately includes filtering and detection.

## Key concepts

- **Firewalls:** stateful packet filtering; allowed vs. filtered vs. closed ports; egress filtering (what can leave the network).
- **IDS/IPS:** signature + anomaly detection (Snort/Suricata). Noisy scans and known payloads get flagged/blocked.
- **WAF:** inspects HTTP; blocks injection signatures. Bypass via encoding, casing, comments, chunking, alternative syntax.
- **Segmentation:** VLANs/ACLs separate networks; you must pivot legitimately reachable paths.
- **Egress paths:** DNS, HTTP(S), ICMP can tunnel data out when direct connections are blocked.

## Methodology / workflow

1. **Characterize the perimeter** — which ports are open/filtered? What detects you? (timing of blocks reveals IPS).
2. **Tune your scanning** — slow down, fragment, use decoys/source-port tricks to reduce detection.
3. **Identify allowed egress** — find what protocol can reach out (often 80/443/53) for C2/tunneling.
4. **WAF evasion** — adapt payloads (encoding, case, comments) when signatures block you.
5. **Tunnel** — use the allowed egress to pivot/exfil (DNS/HTTP tunneling, reverse SSH).

## Techniques & tooling

### Nmap evasion options
```bash
nmap -sS -T2 target                  # slower, stealthier SYN scan
nmap -f target                       # fragment packets
nmap -D RND:10 target                # decoy source addresses
nmap --source-port 53 target         # masquerade as DNS source
nmap -sV --version-intensity 2 target
nmap -Pn target                      # skip host discovery (ping blocked)
```

### Firewall/IDS analysis
- Compare `closed` (RST) vs `filtered` (no response/ICMP) to infer firewall rules.
- `firewalk`, `hping3` for crafted-packet probing.

### WAF detection & evasion
```bash
wafw00f https://target               # identify the WAF
# Evasion ideas (manual): URL/double-encoding, mixed case (SeLeCt),
# inline comments (UN/**/ION), whitespace alternatives, chunked transfer.
```

### Egress / tunneling (covered deeply in pivoting)
- **DNS tunneling:** `iodine`, `dnscat2` when only DNS resolves out.
- **HTTP tunneling:** `chisel` (SOCKS over HTTP/WebSocket).
- **ICMP tunneling:** `ptunnel` when ICMP is allowed.
- **Reverse connections:** when inbound is blocked but outbound 443 works, use reverse shells/C2 over 443.

## Common pitfalls

- Blasting `-T5` full scans into an IPS and getting your source blocked early.
- Assuming a "filtered" port is closed.
- Not testing **egress** — you may have a shell that can't call back because outbound is filtered.

## Exam relevance

Expect filtering between segments and detection that punishes noisy behavior. Scan deliberately, find the *allowed* path between networks, and tunnel through it. This dovetails with [domain 11 · Pivoting](11-pivoting-lateral.md).

## MITRE / mapping

- Defense Evasion tactic broadly; `T1090` (Proxy), `T1572` (Protocol Tunneling), `T1095` (Non-App Layer Protocol), `T1027` (Obfuscation). NIST 800‑115 **Attack**.

## Practice

- Put a `pfSense`/`iptables` firewall + Suricata in front of a lab target and practice scanning/tunneling through it.
- Bypass a ModSecurity-protected DVWA with manual encoding.

## Self-check

- [ ] I can distinguish closed vs filtered and infer firewall behavior.
- [ ] I can find and use an allowed egress protocol to tunnel out.
- [ ] I can adapt a blocked web payload past a WAF by hand.
