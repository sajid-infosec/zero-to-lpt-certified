# Practice Q&A (Concept-Based)

> **These are original, concept-focused study questions** written to rehearse the *skills* the CPENT/LPT blueprint implies. They are **not** real exam questions, answers, or dumps — the live exam is 100% hands-on and has no question bank to memorize. Use these to check understanding, then prove the skill in your lab.

Format: each question is followed by a short **A:** explanation. Cover the answer and try first.

---

## Methodology & Scoping

**Q1.** What are the seven PTES phases, in order?
**A:** Pre-engagement → Intelligence Gathering → Threat Modeling → Vulnerability Analysis → Exploitation → Post-Exploitation → Reporting.

**Q2.** Why is enumeration considered the highest-ROI phase?
**A:** Most footholds come from something discovered (a service, version, misconfig, credential), not an exotic exploit. Thorough enumeration directly converts to access and report findings.

**Q3.** What distinguishes "filtered" from "closed" in an Nmap result, and what does each imply?
**A:** *Closed* returns a TCP RST (port reachable, nothing listening). *Filtered* gives no/ICMP-unreachable response — a firewall is dropping packets. Filtered implies a filtering device between you and the host.

**Q4.** Name a reason to map every finding to MITRE ATT&CK.
**A:** It standardizes reporting, ensures coverage per tactic, and communicates risk to defenders in a common language.

---

## OSINT & Recon

**Q5.** Which free source is the richest for discovering subdomains, and why?
**A:** Certificate Transparency logs (e.g., crt.sh) — every TLS cert issued is logged publicly, exposing hostnames without touching the target.

**Q6.** You found an email format `flast@corp.com`. How does that help later phases?
**A:** It lets you build valid username lists for password spraying, AS-REP roasting, and phishing.

**Q7.** Passive vs. active recon — which tips off the target, and give one example of each.
**A:** Active tips off the target (e.g., port scan, DNS zone-transfer attempt). Passive doesn't (e.g., crt.sh lookup, breach-data review).

---

## Enumeration & Protocols

**Q8.** What does the 16th byte (suffix) of a NetBIOS name tell you, and what do `<1C>`, `<1D>`, `<00>` mean?
**A:** It's a resource type code. `<1C>` = Domain Controllers (GROUP), `<1D>` = Master Browser (UNIQUE), `<00>` = Workstation/Messenger service.

**Q9.** Why check SMB signing before planning an NTLM relay?
**A:** If signing is *required* (default on DCs), relayed NTLM auth is rejected. Relay only works against hosts where signing is not enforced.

**Q10.** Which ports together strongly indicate a Domain Controller?
**A:** 88 (Kerberos), 389/636 (LDAP/LDAPS), 445 (SMB), 3268 (Global Catalog), plus NetBIOS `<1C>`.

**Q11.** What's the difference between `nmap -sS` and `-sT`, and which must you use over a SOCKS proxy?
**A:** `-sS` is a half-open SYN scan (needs raw sockets); `-sT` is a full TCP connect. Over SOCKS/proxychains you must use `-sT -Pn` because the proxy only relays full connections.

---

## Web & API

**Q12.** Outline how an LFI becomes RCE via log poisoning.
**A:** Use LFI to include a server log you can write to (e.g., access/auth log); inject PHP into a logged field (User-Agent, SSH username); include the poisoned log so the PHP executes.

**Q13.** An endpoint returns another user's record when you change an `id` parameter. Name the bug and its category.
**A:** IDOR / BOLA — Broken Object Level Authorization (top API risk).

**Q14.** What is the practical risk of "insecure output handling" in an LLM app?
**A:** The app trusts model output and passes it to a sink (shell/SQL/HTML), so a crafted prompt can yield command injection, SQLi, or XSS — turning prompt injection into traditional RCE/XSS.

**Q15.** Describe the JWT `alg:none` attack and one defense.
**A:** The token's algorithm is set to `none` and the signature dropped; a server that accepts it trusts forged tokens. Defense: server-side allow-list of algorithms; never accept `none`.

**Q16.** How can RS256→HS256 algorithm confusion forge a JWT?
**A:** If the server uses the RSA public key to verify but can be tricked into HMAC mode, an attacker signs a token using the *public key* as the HMAC secret, which the server then validates.

---

## Windows & Privilege Escalation

**Q17.** You see `SeImpersonatePrivilege` in `whoami /all`. Why is that significant?
**A:** It enables "Potato"-style attacks (PrintSpoofer/GodPotato) to impersonate SYSTEM — a fast, reliable local privilege escalation.

**Q18.** What is Pass-the-Hash and why does it work?
**A:** Authenticating with an NTLM hash instead of a plaintext password; NTLM auth uses the hash directly, so a stolen hash is as good as the password for many services.

**Q19.** Order these privesc choices from preferred to last-resort: kernel exploit, token impersonation, service misconfig.
**A:** Token impersonation / service misconfig first (reliable, low-risk); kernel exploit last (can crash the host).

---

## Active Directory

**Q20.** What does Kerberoasting target and why is it possible?
**A:** Accounts with SPNs. Any domain user can request a TGS for an SPN; the ticket is encrypted with the service account's NTLM hash, which you crack offline — so weak service-account passwords fall.

**Q21.** AS-REP roasting requires what condition?
**A:** A user account with Kerberos pre-authentication disabled; you can then request an AS-REP and crack it offline, needing only a username.

**Q22.** What does DCSync do and what right does it need?
**A:** Impersonates a DC's replication to pull password hashes (including `krbtgt`). Needs replication rights (Replicating Directory Changes/All), typically held by DAs or via ACL abuse.

**Q23.** Golden vs. Silver ticket — what's forged in each?
**A:** Golden: a TGT forged with the `krbtgt` hash (domain-wide). Silver: a TGS forged with a *service account's* hash (access to that one service), stealthier.

**Q24.** Why run BloodHound early in an AD assessment?
**A:** It graphs relationships/ACLs/sessions to reveal the shortest path to Domain Admin, saving hours of manual analysis.

**Q25.** Name one AD CS misconfiguration class and its effect.
**A:** ESC1 — a template allowing the enrollee to specify the SAN; you request a certificate as a privileged user (e.g., DA) and authenticate as them.

---

## Pivoting

**Q26.** Difference between `ssh -L`, `-R`, and `-D`?
**A:** `-L` local forward (reach a remote port locally), `-R` remote forward (expose a local port on the remote side), `-D` dynamic SOCKS proxy (any tool via proxychains).

**Q27.** First commands to run on a freshly compromised pivot host, and why?
**A:** `ip route`, `ip addr`, `arp -a`, `/etc/hosts` — to discover newly reachable subnets you couldn't see before.

**Q28.** Why is Ligolo-ng often preferred over proxychains for deep pivots?
**A:** It creates a tun interface so you route to the target subnet natively (no per-tool proxy config, no `-sT` limitation), making multi-hop clean and reliable.

---

## Linux Privesc

**Q29.** What's the single most valuable first command on a Linux foothold for privesc, and a common win it reveals?
**A:** `sudo -l` — frequently reveals NOPASSWD entries or a binary you can exploit via GTFOBins.

**Q30.** How do you find SUID binaries and what's the risk?
**A:** `find / -perm -4000 -type f 2>/dev/null`. SUID binaries run as their owner (often root); a vulnerable/abusable one (GTFOBins) yields root.

**Q31.** A downloaded kernel exploit fails to compile on an old target. What's the professional move?
**A:** Diagnose the libc/toolchain mismatch and use a precompiled binary built for the target's environment (or compile in a matching environment) — don't trust a single source blindly.

---

## Binary Exploitation

**Q32.** Why do we use ROP/ret2libc instead of stack shellcode on modern binaries?
**A:** NX/DEP marks the stack non-executable, so injected shellcode won't run; ROP reuses existing executable code and libc functions (e.g., `system`).

**Q33.** Under ASLR, why compute the *offset* between `system()` and `"/bin/sh"` rather than absolute addresses?
**A:** ASLR randomizes the libc base each run, but distances between symbols within libc are constant — leak one address, add the known offset, and you have the others.

**Q34.** How do you reliably find the overflow offset to the return address?
**A:** Send a cyclic/De Bruijn pattern, crash the program, read the value in RIP/EIP, and compute its position with `cyclic -l`/`pattern_offset`.

**Q35.** On x64 you hit a `movaps` crash mid-ROP. Likely cause and fix?
**A:** Stack misalignment (must be 16-byte aligned at the call). Insert a bare `ret` gadget to realign.

---

## IoT / OT

**Q36.** What is `binwalk -e` used for, and what's the top finding to hunt afterward?
**A:** It carves/extracts embedded data (filesystems, kernels) from a firmware image; then grep the extracted filesystem for hard-coded credentials/keys.

**Q37.** In Modbus/TCP, what is the Protocol Identifier value, and why might a question ask it?
**A:** Always `0` for Modbus/TCP. It tests whether you actually read the dissector rather than guessing.

**Q38.** Why is aggressive scanning dangerous on OT networks?
**A:** OT devices/PLCs are fragile and control physical processes; scanning/fuzzing can disrupt operations or cause safety incidents. Prefer passive traffic analysis.

---

## Cloud & AI

**Q39.** How can a web SSRF lead to cloud credential theft?
**A:** SSRF to the instance metadata service (`169.254.169.254`) can return the instance role's temporary credentials (especially with IMDSv1), which you then use against the cloud API.

**Q40.** Where does most cloud privilege escalation actually live?
**A:** In IAM — over-permissive roles/policies (e.g., `iam:PassRole` + a compute service), not in host-level bugs.

**Q41.** Direct vs. indirect prompt injection?
**A:** Direct: malicious instructions in the user's own input. Indirect: instructions hidden in content the model retrieves/ingests (a webpage, document, ticket) and then acts upon.

**Q42.** Why must AI-generated exploits/commands always be validated?
**A:** LLMs hallucinate; unverified commands may be wrong or dangerous. Treat AI output as a hypothesis to test in the lab, and respect data-handling rules.

---

## Reporting & Exam Strategy

**Q43.** Why can a perfect compromise still lose points?
**A:** The report is graded; if you can't document findings reproducibly and communicate risk, you lose credit. Reporting is a first-class skill.

**Q44.** What belongs in an executive summary?
**A:** Plain-language scope, overall risk posture, and the few prioritized actions leadership must take — no jargon, ~one page.

**Q45.** What's the right response to being stuck on one target for 45 minutes during the exam?
**A:** Time-box it: note progress, move to bank easier points elsewhere, return later. Don't let one box consume the clock.

**Q46.** Why take evidence *during* testing rather than after?
**A:** State changes, sessions die, and details are forgotten; contemporaneous, timestamped evidence is reproducible and credible.

**Q47.** A tool (e.g., `wmiexec`) fails with a localhost/quirk error. Professional reflex?
**A:** Switch methods (e.g., `smbexec`, WinRM, `nxc`) rather than fighting one tool — adaptability is the skill being tested.

**Q48.** How should proof artifacts (flags/hashes) be recorded?
**A:** Exactly as requested — correct length, case, `0x` prefix or colon formatting — and stored with the command/screenshot that produced them.

---

### How to use these well
Don't memorize answers — for each question, **go do it in the lab** ([`../lab/`](../lab/)). If you can reproduce the skill cold, you understand it. Add your own Q&A as you study; teaching yourself is the point.
