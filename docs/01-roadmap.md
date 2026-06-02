# 01 · The Zero-to-Hero Roadmap

> A phased plan from "I know some Linux" to "ready to pass a 24-hour CPENT‑AI / LPT (Master) practical." Adapt the pace to your starting point. Tick the boxes as you go.

## How long will this take?

| Starting point | Realistic timeline (10–15 hrs/week) |
|---|---|
| Brand new (basic IT only) | 6–9 months |
| Some hacking (CEH/eJPT/CTFs) | 3–5 months |
| Experienced (OSCP/PNPT held) | 6–10 weeks of targeted gap-filling |

The plan has **6 phases**. Each phase lists *objectives*, *what to study* (links into this repo), *what to build/practice*, and an *exit check* you must pass before moving on.

---

## Phase 0 · Foundations (skip if you already have them)

**Goal:** remove anything that will slow you down later.

- [ ] Linux CLI fluency: files, permissions, pipes, `grep/sed/awk`, processes, services, `systemd`.
- [ ] Networking: OSI/TCP-IP, subnetting, routing, NAT, DNS, common ports (21/22/25/53/80/88/135/139/389/443/445/636/1433/3389/5985…).
- [ ] Windows basics: users/groups, NTFS permissions, services, the registry, PowerShell basics.
- [ ] Scripting: **Bash** and **Python** to automate tasks; read others' exploit code.
- [ ] Virtualization: VirtualBox/VMware, snapshots, host-only/internal networks.

**Study:** [methodology](02-methodology.md) intro · [tools-reference](tools-reference.md) (skim).
**Build:** install VirtualBox/VMware; create a Kali/Parrot VM with [`lab/linux/install-tools.sh`](../lab/linux/install-tools.sh).
**Exit check:** you can spin up two VMs on an internal network, scan one from the other with Nmap, and explain every flag you used.

---

## Phase 1 · Methodology & Enumeration (Weeks 1–2)

**Goal:** internalize the engagement lifecycle and become *excellent* at enumeration — most exam points are unlocked by thorough recon.

- [ ] Learn PTES / MITRE ATT&CK / Cyber Kill Chain / NIST 800‑115 — [methodology](02-methodology.md).
- [ ] Scoping & rules of engagement — [domains/01](domains/01-scoping-engagement.md).
- [ ] OSINT — [domains/02](domains/02-osint.md).
- [ ] Network/service/host enumeration to mastery — [cheatsheets/enumeration](cheatsheets/enumeration.md).

**Build:** [`lab/`](../lab/) attacker box + a couple of Linux/Windows targets.
**Practice:** enumerate every target you built; document findings as if for a report.
**Exit check:** given an unknown /24, you produce a complete host+service+role map and a prioritized target list without prompting.

---

## Phase 2 · Web, API & Perimeter (Weeks 3–4)

**Goal:** attack the most common external entry points.

- [ ] Web app pentesting (OWASP Top 10, LFI→RCE, SQLi, SSRF, XXE, IDOR, upload) — [domains/04](domains/04-web-application.md).
- [ ] API & JWT attacks — [domains/05](domains/05-api-jwt.md).
- [ ] Perimeter/defense evasion (firewall/IDS/WAF, tunneling out) — [domains/06](domains/06-perimeter-evasion.md).

**Practice:** **PortSwigger Web Security Academy** (free) labs end-to-end; DVWA/Juice Shop in your lab.
**Exit check:** you can chain a web vuln to a shell on a lab target and explain each request in Burp.

---

## Phase 3 · Host Exploitation & Privilege Escalation (Weeks 5–6)

**Goal:** turn any foothold into local admin/root, on both OSes.

- [ ] Windows exploitation & privesc — [domains/07](domains/07-windows-privesc.md).
- [ ] Linux exploitation & privesc — [domains/09](domains/09-linux-privesc.md).
- [ ] Password & hash attacks (Hydra/NetExec online; John/hashcat offline) — [cheatsheets/privilege-escalation](cheatsheets/privilege-escalation.md).

**Practice:** HTB Academy *Linux/Windows Privilege Escalation*; Proving Grounds Linux/Windows boxes.
**Exit check:** on a fresh foothold you find and execute a privesc within 30 minutes, every time.

---

## Phase 4 · Active Directory & Pivoting (Weeks 7–9) — *the heart of the exam*

**Goal:** own an enterprise AD and move across segmented networks.

- [ ] AD enumeration → Kerberos attacks → ACL/delegation → AD CS → DCSync — [domains/08](domains/08-active-directory.md).
- [ ] BloodHound path-finding to Domain Admin.
- [ ] Pivoting & tunneling: SSH `-L/-R/-D`, proxychains, **Ligolo-ng**, **chisel**, double pivots — [domains/11](domains/11-pivoting-lateral.md) + [cheatsheets/pivoting](cheatsheets/pivoting.md).

**Build:** deploy **GOAD** ([`lab/goad/deploy-goad.sh`](../lab/goad/deploy-goad.sh)) and the multi-subnet [`lab/vagrant/Vagrantfile`](../lab/vagrant/Vagrantfile).
**Practice:** full AD compromise in GOAD; double-pivot through 3+ subnets in the Vagrant lab.
**Exit check:** from one initial foothold you reach Domain Admin **and** a host two pivots deep, with a written attack-path narrative.

---

## Phase 5 · Specialized Surfaces: Binary, IoT/OT, Cloud, AI (Weeks 10–11)

**Goal:** the differentiators that separate CPENT from a generic cert.

- [ ] Reverse engineering, fuzzing & binary exploitation (GDB, ROP, ret2libc, pwntools) — [domains/10](domains/10-binary-exploitation.md).
- [ ] IoT/OT: firmware analysis (binwalk), Modbus/SCADA traffic — [domains/12](domains/12-iot-ot.md).
- [ ] Cloud privilege escalation (AWS/Azure basics) — [domains/13](domains/13-cloud.md).
- [ ] AI pentesting: prompt injection, adversarial ML, AI-assisted workflow — [domains/14](domains/14-ai-pentesting.md).

**Practice:** pwn.college / ROP Emporium for binary; extract firmware images with binwalk; PortSwigger's LLM/web-LLM labs.
**Exit check:** you can build a working ROP chain, recover creds from a firmware image, and demonstrate a prompt-injection against a test LLM endpoint.

---

## Phase 6 · Reporting & Full Simulation (Weeks 12+)

**Goal:** perform like exam day and document like a professional.

- [ ] Master report writing — [domains/15](domains/15-reporting.md). Build your template **now**.
- [ ] Exam-day strategy (time-boxing, point banking) — [exam-day-strategy](exam-day-strategy.md).
- [ ] **Timed full-range simulations**, each followed by a complete report.

**Practice:** HTB **Pro Labs** (Dante/Offshore/Cybernetics) or your own multi-range lab, 8–12h timed.
**Exit check:** two consecutive timed simulations where you complete the majority of objectives *and* produce a clean, reproducible report within the window.

---

## Milestone tracker

| Milestone | Target date | Done |
|---|---|---|
| Lab fully built | | ☐ |
| First full AD compromise (GOAD) | | ☐ |
| First clean double-pivot | | ☐ |
| First working ROP exploit | | ☐ |
| First end-to-end report | | ☐ |
| Timed sim #1 (≥70% objectives) | | ☐ |
| Timed sim #2 (≥90% objectives) | | ☐ |
| **Exam booked** | | ☐ |

---

## Daily/weekly habits that actually move the needle

- **Build a personal cheatsheet** as you learn — don't rely solely on this repo's (see [cheatsheets/](cheatsheets/)). The act of writing it cements it.
- **One box / one lab per session, fully documented.** Quality over quantity.
- **Re-do** anything that needed a walkthrough until you can do it cold.
- **Time-box hard problems.** If stuck 45 min, note it, move on, return later — exactly the exam discipline.
- **Write a mini-report** even for practice boxes. Reporting is a graded skill you must rehearse.

Next: [02 · Methodology](02-methodology.md).
