# Zero to LPT Certified

> A complete, open-source study program that takes you from **fundamentals to EC‑Council CPENT (CPENT‑AI) and LPT (Master)** — guidelines, a phased roadmap, per-domain deep dives, a full self-hosted multi-range lab (Windows + Linux), tooling automation, cheatsheets, and concept-based practice Q&A.

![Status](https://img.shields.io/badge/status-active-success)
![License](https://img.shields.io/badge/license-MIT-blue)
![Focus](https://img.shields.io/badge/focus-CPENT--AI%20%7C%20LPT%20(Master)-red)
![Level](https://img.shields.io/badge/level-zero%20to%20hero-orange)
![PRs](https://img.shields.io/badge/PRs-welcome-brightgreen)

---

## ⚠️ Ethics & Legal Notice (read first)

Everything here is for **authorized, legal penetration-testing education and certification preparation only**. Use these techniques **exclusively** against:

- Systems you **own**,
- Lab environments you build yourself (this repo helps you build them), or
- Targets you have **explicit, written authorization** to test.

Unauthorized access to computer systems is a crime in virtually every jurisdiction. This repository contains **no real exam questions, answers, or dumps** — sharing or seeking those violates the EC‑Council Candidate Agreement and devalues the certification. What you'll find instead is *methodology, concepts, and representative practice questions* that teach the underlying skills. **You are responsible for your own conduct.**

---

## What this repository is

`Zero to LPT Certified` is a self-study curriculum built around the **CPENT‑AI (v3, 2026)** blueprint and the **LPT (Master)** standard. It assumes you may be starting with little more than basic Linux/networking familiarity and walks you all the way to the skill level required to pass a 24-hour, 100% hands-on practical exam against a multi-layered, defended enterprise range.

It is deliberately **vendor-neutral in tooling** (everything runs on free/open tools you install yourself) and **practical-first**: every concept is paired with commands, a lab to practice in, and a place it shows up in a real engagement.

### What's inside

| Area | Location | Description |
|------|----------|-------------|
| 📋 Exam overview | [`docs/00-exam-overview.md`](docs/00-exam-overview.md) | CPENT‑AI format, scoring, LPT (Master) path, 14 domains, 2026 AI updates |
| 🗺️ Roadmap | [`docs/01-roadmap.md`](docs/01-roadmap.md) | Zero-to-hero phased plan with timelines and milestones |
| 🧭 Methodology | [`docs/02-methodology.md`](docs/02-methodology.md) | PTES, MITRE ATT&CK, Cyber Kill Chain, NIST 800‑115, OWASP |
| 📚 Domain guides | [`docs/domains/`](docs/domains/) | 15 deep-dive guides covering every CPENT‑AI module |
| ❓ Practice Q&A | [`docs/practice-qa.md`](docs/practice-qa.md) | 120+ concept questions with explained answers (no exam dumps) |
| 🧰 Tools reference | [`docs/tools-reference.md`](docs/tools-reference.md) | Purpose, usage, strengths/limits of 50+ tools |
| ⚡ Cheatsheets | [`docs/cheatsheets/`](docs/cheatsheets/) | Copy-paste command references by topic |
| 🎯 Exam-day strategy | [`docs/exam-day-strategy.md`](docs/exam-day-strategy.md) | Time management, point banking, reporting workflow |
| 🔗 External resources | [`docs/resources.md`](docs/resources.md) | THM / HTB / PG / GOAD / PortSwigger mappings |
| 🧪 Full lab | [`lab/`](lab/) | Scripts to build a CPENT-style multi-range lab (AD + Linux + pivot subnets) |

---

## The exam in one paragraph

The **CPENT‑AI** exam is a **100% practical, remote-proctored, open-book** assessment delivered on a live enterprise cyber range. You get **24 hours**, which you may take as one continuous sitting or **two 12-hour sessions**. You must compromise hosts across segmented networks (Active Directory, web apps, APIs, IoT/OT, binaries, and AI-attack surfaces), exfiltrate proof, and **submit a professional penetration-testing report**. Scoring drives **two outcomes from one exam**: **≥ 70 % earns CPENT**, and **≥ 90 % earns CPENT *and* LPT (Master)**. See the [exam overview](docs/00-exam-overview.md) for the authoritative breakdown and citations.

---

## Quick start

```bash
# 1. Clone your local copy up to GitHub (see "Publishing" below), then:
git clone https://github.com/<your-username>/zero-to-lpt-certified.git
cd zero-to-lpt-certified

# 2. Read the plan
$EDITOR docs/00-exam-overview.md
$EDITOR docs/01-roadmap.md

# 3. Build your attacker box (Kali/Parrot/Debian-based)
chmod +x lab/linux/*.sh
sudo ./lab/linux/install-tools.sh        # installs the full toolkit

# 4. Stand up the lab (pick your path — see lab/README.md)
./lab/goad/deploy-goad.sh                 # AD-focused (recommended start)
#   or
vagrant up                                # full multi-range lab (lab/vagrant/Vagrantfile)
```

On Windows targets/attacker, use the PowerShell scripts in [`lab/windows/`](lab/windows/) (run from an elevated prompt).

---

## How to use this repo (suggested flow)

1. **Orient** — read the [exam overview](docs/00-exam-overview.md) and [roadmap](docs/01-roadmap.md). Set a realistic date.
2. **Internalize methodology** — [`docs/02-methodology.md`](docs/02-methodology.md). Everything else hangs off this.
3. **Build the lab early** — you learn by doing. Get [`lab/`](lab/) running in week one.
4. **Work the domains in order** — each guide in [`docs/domains/`](docs/domains/) has *Learn → Practice → Self-check*.
5. **Drill with cheatsheets + practice Q&A** until the workflows are muscle memory.
6. **Simulate** — timed full-range runs, then write the report each time.
7. **Track progress** — tick the checkboxes in the roadmap and domain guides.

---

## Repository structure

```
zero-to-lpt-certified/
├── README.md                  # you are here
├── LICENSE                    # MIT
├── CONTRIBUTING.md
├── docs/
│   ├── 00-exam-overview.md
│   ├── 01-roadmap.md
│   ├── 02-methodology.md
│   ├── exam-day-strategy.md
│   ├── practice-qa.md
│   ├── tools-reference.md
│   ├── resources.md
│   ├── domains/               # 15 module deep-dives
│   └── cheatsheets/           # enumeration, AD, pivoting, privesc, one-liners
├── lab/
│   ├── README.md              # lab architecture + network diagram
│   ├── linux/                 # attacker + target setup (bash)
│   ├── windows/               # DC + member + attacker setup (PowerShell)
│   ├── goad/                  # Game of Active Directory deploy
│   └── vagrant/               # full multi-range Vagrantfile
└── scripts/                   # helper utilities
```

---

## Publishing to GitHub

This repo is delivered **git-initialized with commits**, ready to push:

```bash
# create an EMPTY repo named "zero-to-lpt-certified" on github.com first, then:
cd zero-to-lpt-certified
git remote add origin https://github.com/<your-username>/zero-to-lpt-certified.git
git branch -M main
git push -u origin main
```

---

## Contributing

Improvements welcome — fix errors, add lab targets, expand cheatsheets. See [`CONTRIBUTING.md`](CONTRIBUTING.md). **Never** submit real exam content.

## License

[MIT](LICENSE) © contributors. Educational use; you assume all responsibility for how you apply it.

## Sources & further reading

- EC‑Council — [CPENT certification](https://www.eccouncil.org/train-certify/certified-penetration-testing-professional-cpent/)
- EC‑Council — [LPT (Master)](https://www.eccouncil.org/train-certify/licensed-penetration-tester-lpt-master/)
- Full citation list in [`docs/00-exam-overview.md`](docs/00-exam-overview.md#sources)
