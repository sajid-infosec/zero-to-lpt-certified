# 02 · Penetration Testing Methodology

> Frameworks are the scaffolding that turns "poking at things" into a repeatable, defensible engagement. CPENT/LPT grades both *what* you achieve and *how* you reason. Learn these once; apply them everywhere.

## Why methodology matters for the exam

A 24-hour practical is won by **discipline**, not luck. A repeatable methodology gives you:

1. **Coverage** — you don't forget an attack surface under pressure.
2. **Efficiency** — you bank easy points first and time-box hard ones.
3. **Reportability** — your notes already map to report sections.

Memorize the lifecycle below; it is the spine of every domain guide in this repo.

```
 RECON ─▶ ENUMERATE ─▶ EXPLOIT ─▶ ESCALATE ─▶ PIVOT ─▶ COLLECT/EXFIL ─▶ DOCUMENT
   ▲                                                                        │
   └──────────────── repeat on each newly reachable network ◀──────────────┘
```

---

## The frameworks you must know

### PTES — Penetration Testing Execution Standard
The practical, engagement-oriented standard. Seven phases:

1. **Pre-engagement Interactions** — scope, rules of engagement (RoE), authorization, timing.
2. **Intelligence Gathering** — OSINT + active recon.
3. **Threat Modeling** — what's valuable, what an attacker would target.
4. **Vulnerability Analysis** — find and validate weaknesses.
5. **Exploitation** — gain access.
6. **Post-Exploitation** — escalate, pivot, collect, persist (as authorized), assess impact.
7. **Reporting** — communicate risk and remediation.

> CPENT's module flow mirrors PTES almost 1:1. If you internalize PTES, the exam feels familiar.

### MITRE ATT&CK
A knowledge base of adversary **tactics** (the *why*) and **techniques** (the *how*), each with an ID (e.g., `T1110` Brute Force, `T1558.003` Kerberoasting). Use it to:

- Label what you're doing (great for report mapping).
- Make sure you've considered an attacker's full toolkit per tactic.

Tactics order (roughly): Reconnaissance → Resource Development → Initial Access → Execution → Persistence → Privilege Escalation → Defense Evasion → Credential Access → Discovery → Lateral Movement → Collection → Command & Control → Exfiltration → Impact.

### Cyber Kill Chain (Lockheed Martin)
A linear intrusion model: **Reconnaissance → Weaponization → Delivery → Exploitation → Installation → Command & Control → Actions on Objectives.** Good for narrating an attack *story* in a report exec summary.

### NIST SP 800‑115
The US government's technical guide to security testing. Four phases: **Planning → Discovery → Attack → Reporting**, with a feedback loop from Attack back to Discovery (you learn more as you go). Useful vocabulary for compliance-minded clients.

### OWASP
For web/API/LLM work: **OWASP Top 10** (web), **API Security Top 10**, **WSTG** (Web Security Testing Guide), and the newer **OWASP Top 10 for LLM Applications** (directly relevant to CPENT‑AI). See [domains/04](domains/04-web-application.md), [domains/05](domains/05-api-jwt.md), [domains/14](domains/14-ai-pentesting.md).

---

## The working loop (how to actually operate)

For **every** target and **every** newly reachable subnet, run this loop:

### 1. Recon / Discovery
- Host discovery (ping sweep, ARP, `nmap -sn`).
- Port discovery (fast full-range, then targeted).
- *Reasoning:* build a map before committing effort. Note everything; you'll cite it later.

### 2. Enumeration
- Service/version/script scans (`nmap -sC -sV -p<ports>`).
- Protocol-specific enumeration (SMB, LDAP, HTTP, SNMP, RPC, DB…).
- *Reasoning:* enumeration **is** the exam. Most footholds come from something you enumerated, not a flashy 0-day.

### 3. Vulnerability analysis / Validation
- Map versions to known CVEs; identify misconfigurations, weak/default creds, exposed data.
- **Validate** before exploiting (avoid wasting time on false positives, avoid crashing targets).

### 4. Exploitation
- Gain initial access by the *least risky reliable* method.
- *Reasoning:* prefer techniques you can repeat and explain. Keep a record of exactly what worked.

### 5. Post-Exploitation
- **Stabilize** the shell, **enumerate locally**, **escalate** privileges.
- **Loot**: creds, hashes, keys, config, network info (`ip route`, `arp`).
- Assess **impact** (what could a real attacker do?).

### 6. Pivot / Lateral Movement
- Use the new host's network position to reach previously unreachable subnets.
- Re-run the loop from step 1 on each new network.

### 7. Document continuously
- Capture commands, outputs, screenshots, and proof (hashes/flags) **as you go**.
- Map each finding to a framework technique + a remediation.

---

## Note-taking & evidence discipline (non-negotiable)

You will lose points if you can't reproduce and document your work. Adopt a system **before** you study seriously:

- **Tooling:** CherryTree, Obsidian, Joplin, Notion, or plain Markdown — pick one and stick to it.
- **Per-target page:** scope, open ports, enum output, the exploit path, creds found, privesc, screenshots, proof.
- **Evidence:** timestamped screenshots, command + output, and proof artifacts (flag/hash). Never edit evidence after the fact.
- **Pivot map:** maintain a live diagram of which host bridges to which subnet — this saves you during deep pivots.

A suggested per-target template lives in [domains/15 · Reporting](domains/15-reporting.md).

---

## Mapping the repo to the lifecycle

| Lifecycle step | Repo guides |
|---|---|
| Pre-engagement / scope | [domains/01](domains/01-scoping-engagement.md) |
| Recon / OSINT | [domains/02](domains/02-osint.md), [cheatsheets/enumeration](cheatsheets/enumeration.md) |
| Initial access (external) | [domains/03](domains/03-social-engineering.md), [domains/04](domains/04-web-application.md), [domains/05](domains/05-api-jwt.md), [domains/06](domains/06-perimeter-evasion.md) |
| Privilege escalation | [domains/07](domains/07-windows-privesc.md), [domains/09](domains/09-linux-privesc.md) |
| AD / lateral / pivot | [domains/08](domains/08-active-directory.md), [domains/11](domains/11-pivoting-lateral.md), [cheatsheets/active-directory](cheatsheets/active-directory.md), [cheatsheets/pivoting](cheatsheets/pivoting.md) |
| Specialized surfaces | [domains/10](domains/10-binary-exploitation.md), [domains/12](domains/12-iot-ot.md), [domains/13](domains/13-cloud.md), [domains/14](domains/14-ai-pentesting.md) |
| Reporting | [domains/15](domains/15-reporting.md) |

Next: start the domain guides at [domains/01 · Scoping & Engagement](domains/01-scoping-engagement.md).
