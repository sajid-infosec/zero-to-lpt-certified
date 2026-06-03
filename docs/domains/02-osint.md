# Domain 02 · Open-Source Intelligence (OSINT)

> Module 3. Everything you can learn about a target *before* sending a single packet to it — and a lot you gather passively during an engagement.

## Why it matters

The cheapest, quietest attack surface is information the target leaked publicly: employee names, email formats, tech stack, subdomains, leaked credentials, exposed files. Strong OSINT shortens every later phase: better wordlists, valid usernames for spraying, known software versions to target.

## Key concepts

- **Passive vs. active:** passive never touches the target (search engines, certificate transparency, breach data); active does (DNS queries, port scans). OSINT is mostly passive.
- **Footprinting domains:** subdomains, DNS records, MX/SPF/DMARC, WHOIS, ASN/IP ranges.
- **People:** employees, roles, email naming convention (`first.last@`, `flast@`), social profiles.
- **Credentials:** breach corpora reveal reused passwords and valid emails.
- **Tech fingerprinting:** what frameworks/CMS/cloud the target uses.
- **Code & secrets:** GitHub/GitLab leaks, API keys, internal hostnames in JS.

## Methodology / workflow

1. **Seed:** start from the in-scope domain(s)/org name.
2. **Domain footprint:** WHOIS, DNS, subdomain enumeration, cert transparency.
3. **People footprint:** harvest emails/usernames; derive the email format.
4. **Credential intel:** check breach databases for in-scope domains (where authorized).
5. **Tech & exposure:** identify stacks, exposed panels, cloud buckets, code leaks.
6. **Synthesize:** build target lists, username lists, and candidate password lists for later phases.

## Tools & usage

| Tool | Purpose | Example |
|---|---|---|
| `whois` | registration data | `whois example.com` |
| `dig` / `host` | DNS records | `dig any example.com`, `dig axfr @ns example.com` (zone transfer test) |
| **amass** / **subfinder** | subdomain enumeration | `subfinder -d example.com -all` |
| **crt.sh** | cert transparency subdomains | browse `https://crt.sh/?q=%25.example.com` |
| **theHarvester** | emails/hosts from many sources | `theHarvester -d example.com -b all` |
| **Maltego** | link-analysis/visualization | GUI transforms |
| **recon-ng** | modular recon framework | workspace + modules |
| **Spiderfoot** | automated OSINT | web UI / CLI |
| **Shodan / Censys** | exposed hosts/services | `shodan search org:"Example"` |
| **gitleaks / trufflehog** | secrets in repos | `trufflehog github --org=example` |
| **Wappalyzer / whatweb** | tech fingerprint | `whatweb https://example.com` |

> **Advantages/limits:** OSINT is low-risk and high-value but can be noisy if you pivot to active checks; always confirm a finding is in-scope before acting on it. Breach data must be handled per the RoE and law.

## Commands (quick)

```bash
subfinder -d example.com -silent | tee subs.txt
cat subs.txt | httpx -title -tech-detect -status-code   # live hosts + tech
theHarvester -d example.com -b bing,duckduckgo,crtsh
dig +short ns example.com ; dig +short mx example.com
```

## Common pitfalls

- Treating active scanning as "OSINT" and tipping off the target prematurely.
- Ignoring certificate transparency — it's the richest free subdomain source.
- Not deriving the email naming convention (kills your spraying later).

## Exam relevance

CPENT's range is mostly internal, but the *mindset* — enumerate exhaustively, derive usernames, fingerprint versions — is exactly what unlocks footholds. For external/web portions, subdomain + tech fingerprinting points you at the vulnerable app fast.

## MITRE / mapping

- ATT&CK Reconnaissance: `T1595` (Active Scanning), `T1592` (Victim Host Info), `T1589` (Identity Info), `T1590` (Network Info), `T1591` (Org Info). PTES **Intelligence Gathering**.

## Practice

- Pick a domain **you own**, enumerate its full subdomain/DNS/tech footprint, and derive its email format.
- Search your own GitHub for accidentally committed secrets with gitleaks.

## Self-check

- [ ] I can enumerate subdomains three different ways.
- [ ] I can derive an org's email naming convention from public data.
- [ ] I can turn OSINT into username + password candidate lists.
