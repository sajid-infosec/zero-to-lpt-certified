# Domain 04 · Web Application Penetration Testing

> Module 5. Web apps are the most common external foothold. You must be fluent across the OWASP Top 10 and able to **chain** a bug into a shell.

## Why it matters

Web is where the internet-facing attack surface lives. On CPENT you'll fuzz directories, find an injection or inclusion flaw, and turn it into code execution — then use that foothold to enter the internal network.

## Key vulnerability classes

| Class | Essence | Typical impact |
|---|---|---|
| **SQL Injection** | untrusted input in SQL queries | data theft, auth bypass, RCE (xp_cmdshell, `INTO OUTFILE`) |
| **LFI / RFI** | include attacker-controlled file path | source disclosure → **log/wrapper poisoning → RCE** |
| **Command Injection** | input reaches a shell | direct RCE |
| **SSRF** | server fetches attacker URL | internal recon, cloud metadata (IMDS) cred theft |
| **XXE** | XML external entities | file read, SSRF, sometimes RCE |
| **IDOR / BOLA** | object reference without authz | access others' data |
| **File Upload** | unrestricted upload | webshell → RCE |
| **Auth / Session flaws** | weak login, fixation, JWT issues | account takeover |
| **XSS** | script in victim's browser | session theft, phishing |
| **SSTI** | template engine eval | RCE |
| **Deserialization** | untrusted object data | RCE |

## Methodology / workflow

1. **Map the app** — spider, identify tech (whatweb/Wappalyzer), find inputs, roles, APIs.
2. **Content discovery** — fuzz dirs/files/params (`ffuf`, `feroxbuster`, raft/SecLists wordlists).
3. **Test each input** systematically against the classes above.
4. **Validate** carefully (don't destroy data; use benign proofs).
5. **Chain to RCE** where possible (LFI→log poison, upload→webshell, SQLi→`xp_cmdshell`).
6. **Pivot inward** — a web shell on a DMZ box is your gateway to the internal network.

### Worked example: LFI → log poisoning → RCE (a classic chain)
1. Find LFI: `?page=../../../../etc/passwd` returns the file.
2. Identify a writable, includable log (e.g., Apache `access.log`, SSH `auth.log`).
3. Poison it: send a request/login where the **User-Agent** or **username** is `<?php system($_GET['c']); ?>`.
4. Include the log via LFI with `&c=id` → command execution.
5. Upgrade to a reverse shell, stabilize, enumerate, pivot.

## Tools & usage

| Tool | Purpose | Note |
|---|---|---|
| **Burp Suite** | intercept/repeat/intrude/scan | Pro has active scanner; Community is fine for manual work |
| **ffuf / feroxbuster** | content & parameter fuzzing | pair with SecLists |
| **sqlmap** | automated SQLi | great, but understand the manual technique too |
| **wpscan** | WordPress audit | plugins/themes/users |
| **nikto** | quick server misconfig scan | noisy |
| **wfuzz** | parameter/auth fuzzing | flexible |
| **dalfox** | XSS scanning | |
| **commix** | command-injection automation | |

## Commands (quick)

```bash
ffuf -u https://t/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -mc 200,301,302,403
feroxbuster -u https://t -w /usr/share/seclists/Discovery/Web-Content/common.txt -x php,txt
sqlmap -r request.txt --batch --dbs           # from a saved Burp request
wpscan --url https://t --enumerate vp,u --api-token <token>
```

## Common pitfalls

- Relying only on sqlmap/automated scanners — learn the manual method to handle filters/WAFs.
- Forgetting to fuzz **inside** discovered directories (e.g., `/cgi-bin/` then `/cgi-bin/<endpoint>`).
- Not URL-encoding payloads; missing that a "read" bug (LFI/SSRF/XXE) often escalates to RCE.

## Exam relevance

Expect at least one web foothold that must be **chained** to a shell, then used to pivot internally. Speed at content discovery + recognizing the chain (LFI→RCE, upload→shell, SQLi→OS) is what scores.

## MITRE / mapping

- Initial Access `T1190` (Exploit Public-Facing App); Persistence `T1505.003` (Web Shell). OWASP Top 10 + WSTG.

## Practice

- **PortSwigger Web Security Academy** — work every category to "Practitioner".
- Lab: **DVWA**, **OWASP Juice Shop**, **bWAPP** (install via [`lab/linux/setup-linux-targets.sh`](../../lab/linux/setup-linux-targets.sh)).
- HTB easy web boxes (e.g., October, Beep) for the full chain.

## Self-check

- [ ] I can do SQLi/LFI/command-injection **manually**, not just with tools.
- [ ] I can take a read-only bug and reason a path to RCE.
- [ ] I can fuzz an app and prioritize findings under time pressure.
