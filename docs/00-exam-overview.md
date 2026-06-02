# 00 · Exam Overview — CPENT‑AI & LPT (Master)

> The authoritative "what am I actually signing up for" chapter. Read this before anything else.

## TL;DR

- **Certification:** EC‑Council **Certified Penetration Testing Professional (CPENT)** — current edition branded **CPENT‑AI (v3, 2026)** because AI penetration-testing is now woven through every phase.
- **Format:** 100% **practical**, **remote-proctored**, **open-book**, on a **live enterprise cyber range**.
- **Duration:** **24 hours** — take it as one continuous sitting **or** two **12-hour** sessions.
- **Deliverable:** compromise the targets **and** submit a professional **penetration-testing report**. Report review/approval is mandatory.
- **Two certs, one exam:**
  - **≥ 70 %** → **CPENT**
  - **≥ 90 %** → **CPENT *and* LPT (Master)**
- **No multiple-choice.** There is nothing to "memorize." You prove skills by doing.

---

## What "CPENT‑AI" means in 2026

EC‑Council refreshed CPENT into **CPENT‑AI**, integrating AI techniques into the methodology in two directions:

1. **Using AI to pentest** — AI-assisted recon, payload generation, code review, and report drafting.
2. **Pentesting AI** — attacking deployed ML/LLM systems: **prompt injection** against LLM endpoints, **adversarial ML**, model/data exposure, and insecure AI integrations.

This means a modern candidate must understand not just classic exploitation but also the **new AI attack surface**. See [`domains/14-ai-pentesting.md`](domains/14-ai-pentesting.md).

---

## The 14 modules (official blueprint)

The course/exam blueprint is organized into 14 modules. This repo maps each to a deep-dive guide in [`docs/domains/`](domains/).

| # | Module | Guide |
|---|--------|-------|
| 1 | Introduction to Penetration Testing & Methodologies | [methodology](02-methodology.md) |
| 2 | Penetration Testing Scoping & Engagement | [domains/01](domains/01-scoping-engagement.md) |
| 3 | Open-Source Intelligence (OSINT) | [domains/02](domains/02-osint.md) |
| 4 | Social Engineering Penetration Testing | [domains/03](domains/03-social-engineering.md) |
| 5 | Web Application Penetration Testing | [domains/04](domains/04-web-application.md) |
| 6 | API & Java Web Token (JWT) Penetration Testing | [domains/05](domains/05-api-jwt.md) |
| 7 | Perimeter Defense Evasion Techniques | [domains/06](domains/06-perimeter-evasion.md) |
| 8 | Windows Exploitation & Privilege Escalation | [domains/07](domains/07-windows-privesc.md) |
| 9 | Active Directory Penetration Testing | [domains/08](domains/08-active-directory.md) |
| 10 | Linux Exploitation & Privilege Escalation | [domains/09](domains/09-linux-privesc.md) |
| 11 | Reverse Engineering, Fuzzing & Binary Exploitation | [domains/10](domains/10-binary-exploitation.md) |
| 12 | Lateral Movement & Pivoting | [domains/11](domains/11-pivoting-lateral.md) |
| 13 | IoT Penetration Testing | [domains/12](domains/12-iot-ot.md) |
| 14 | Report Writing & Post-Testing Actions | [domains/15](domains/15-reporting.md) |

**Bonus / self-study** modules commonly bundled: Pentesting essential concepts, scripting in **Bash / Python / PowerShell / Perl / Ruby**, **Database** pentesting, **Mobile** pentesting, **Fuzzing**, and **Mastering Metasploit**. This repo also adds dedicated guides for **Cloud** ([domains/13](domains/13-cloud.md)) and **AI** ([domains/14](domains/14-ai-pentesting.md)) since both appear on the live range.

---

## Scoring & the two-certification model

One exam, scored as a percentage, produces a tiered result:

```
   score
   100% ┤
        │   ┌──────────────  ≥ 90%  → CPENT + LPT (Master)
    90% ┤───┘
        │   ┌──────────────  70–89% → CPENT
    70% ┤───┘
        │
     0% ┤───────────────────  < 70% → no pass (retake)
```

- You earn points by **completing objectives** across the range (gaining access, escalating, pivoting, exfiltrating proof).
- **The report is part of the grade.** A technically perfect compromise that you cannot document professionally loses points. Treat reporting as a first-class skill — see [domains/15](domains/15-reporting.md).
- LPT (Master) additionally signals you can operate against **defense-in-depth** (IDS/IPS, segmentation, hardened hosts) and chain attacks at **enterprise scale**.

> **Numbers (format, durations, thresholds) reflect EC‑Council's published materials as of 2026. Always confirm the current details on the official pages linked below before booking — vendors update blueprints.**

---

## Prerequisites & who this is for

There is no hard prerequisite to *attempt* the exam, but realistically you want:

- Comfort on the **Linux CLI** and **Windows** administration basics.
- **TCP/IP networking** fundamentals (subnets, routing, common ports/protocols).
- Prior exposure equivalent to **CEH / eJPT / Security+**, or solid self-taught hacking practice.
- Willingness to script (**Bash + Python** at minimum; **PowerShell** for Windows/AD).

If you're missing these, the [roadmap](01-roadmap.md) includes a **Phase 0 — Foundations** block to close the gap.

---

## How CPENT compares (quick orientation)

| | CPENT‑AI / LPT (Master) | OSCP | PNPT |
|---|---|---|---|
| Style | 100% practical, live range | 100% practical | 100% practical |
| Length | 24h (or 2×12h) | 24h + report | 5 days + report |
| Signature focus | **AD, pivoting, binary, IoT/OT, AI, evasion, enterprise scale** | Standalone host exploitation + AD set | Real-world AD assessment + client report |
| Report | Mandatory, graded | Mandatory | Mandatory, debrief |
| Outcome tiers | CPENT / LPT(Master) | Pass/fail | Pass/fail |

CPENT's differentiators for this repo's emphasis: **multi-layer pivoting**, **binary exploitation/ROP**, **IoT/OT**, **evasion of defenses**, and now **AI**. We weight study time accordingly in the [roadmap](01-roadmap.md).

---

## Logistics checklist

- [ ] Stable, high-bandwidth internet (proctoring + remote range).
- [ ] A capable host machine (≥ 16 GB RAM recommended; 32 GB ideal for running your own lab alongside study).
- [ ] Quiet, clean room for proctoring; valid ID.
- [ ] Your **own** tooling fluency — the range gives you targets, you bring the skills.
- [ ] A **report template** ready *before* exam day (start from [domains/15](domains/15-reporting.md)).
- [ ] A personal **command notebook / cheatsheet** ([cheatsheets/](cheatsheets/)).

---

## Sources

These are the references used to compile this overview (verify current details before booking):

- EC‑Council — [Certified Penetration Testing Professional (CPENT)](https://www.eccouncil.org/train-certify/certified-penetration-testing-professional-cpent/)
- EC‑Council — [Licensed Penetration Tester (Master)](https://www.eccouncil.org/train-certify/licensed-penetration-tester-lpt-master/)
- EC‑Council — [Pen-testing track hub](https://www.eccouncil.org/train-certify/pen-testing/)
- EC‑Council iClass — [CPENT course](https://iclass.eccouncil.org/our-courses/certified-penetration-testing-professional-cpent/)
- Infosec — [CPENT‑AI Boot Camp (module list, AI integration)](https://www.infosecinstitute.com/courses/ec-council-cpent-ai-boot-camp/)
- FlashGenius — [CPENT Ultimate 2026 Guide](https://flashgenius.net/blog-article/cpent-certification-ultimate-2026-guide-eccouncil)

> ⚠️ Reminder: this repo contains **no real exam questions or answers**. The "practice Q&A" are original, concept-focused items written to teach the skills the blueprint implies.
