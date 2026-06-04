# External Practice Resources & Mapping

> Where to actually build the skills, mapped to this repo's domains. Mix free and paid; prioritize hands-on platforms.

## Platforms at a glance

| Platform | Cost | Best for |
|---|---|---|
| **TryHackMe** | Free + sub | Guided foundations, beginner→intermediate paths |
| **Hack The Box (Labs/Academy)** | Free + sub | Academy = structured theory+lab; Machines = practice; Pro Labs = enterprise simulations |
| **Proving Grounds (Offsec)** | Sub | OSCP/CPENT-style standalone boxes |
| **PortSwigger Web Security Academy** | **Free** | The authoritative web/JWT/LLM labs |
| **GOAD** | **Free** (self-host) | Full Active Directory attack lab |
| **VulnHub** | **Free** | Downloadable vulnerable VMs |
| **pwn.college / ROP Emporium** | **Free** | Binary exploitation from scratch |
| **CyberDefenders** | Free + sub | Blue-team/DFIR & PCAP analysis (sharpens offense) |

---

## Mapping by domain

### Active Directory (Domain 08) — *highest priority*
- **GOAD** (this repo deploys it): Fundamentals → Intermediate → Advanced.
- HTB Academy: *Active Directory Enumeration & Attacks*.
- HTB Machines: Forest, Sauna, Active, Resolute, Monteverde; Reel/Mantis (trusts).
- TryHackMe: Attacktive Directory, Vulnnet: Roasted.

### Pivoting & Lateral Movement (Domain 11)
- HTB Academy: *Pivoting, Tunneling & Port Forwarding*.
- TryHackMe: Wreath. HTB: Pivotapi, Reddish.
- This repo's [`lab/vagrant/Vagrantfile`](../lab/vagrant/Vagrantfile) multi-subnet lab.

### Web & API (Domains 04–05)
- **PortSwigger Academy** — every category to Practitioner (free, best-in-class).
- Lab: DVWA, OWASP Juice Shop, bWAPP, crAPI, VAmPI.
- HTB easy web boxes for full chains (October, Beep).

### Windows / Linux PrivEsc (Domains 07, 09)
- HTB Academy: *Windows / Linux Privilege Escalation*.
- TryHackMe: Linux/Windows PrivEsc + Arena.
- Proving Grounds Linux/Windows boxes.

### Binary Exploitation (Domain 10)
- **ROP Emporium** (structured ROP), **pwn.college**, Nightmare repo.
- Proving Grounds BOF boxes (Slort, Kevin).

### IoT / OT (Domain 12)
- binwalk on OpenWrt/DD-WRT firmware; **conpot** ICS honeypot.
- Public SCADA/Modbus PCAPs for Wireshark drills.

### Cloud (Domain 13)
- **CloudGoat** (AWS), **AzureGoat**, **flAWS/flAWS2**, **PurplePanda**.

### AI / LLM (Domain 14)
- **PortSwigger Web LLM attacks** labs.
- **garak** / **promptfoo** against a locally hosted open model.

### Reporting (Domain 15)
- TCM Security sample reports, **SysReptor** templates, Offsec/PWK report guides.

---

## Free reference material worth bookmarking

- **HackTricks** — encyclopedic technique reference (web/AD/privesc/cloud).
- **PayloadsAllTheThings** — payloads & one-liners for every class.
- **GTFOBins** (Linux) / **LOLBAS** (Windows) — living-off-the-land binaries.
- **The Hacker Recipes** — AD attack methodology.
- **OWASP** — Top 10, API Top 10, WSTG, Top 10 for LLM Apps.
- **MITRE ATT&CK** + **ATLAS** (AI) — technique knowledge bases.
- **Orange Cyberdefense AD mind map** / **Active Directory attack cheat sheets**.

---

## Suggested learning order (cross-platform)

1. THM intro paths + PortSwigger Apprentice → fundamentals.
2. HTB Academy AD + PrivEsc + Pivoting modules → core skills.
3. GOAD full clear → AD mastery.
4. ROP Emporium + PG BOF boxes → binary.
5. HTB Pro Labs / multi-range lab → enterprise simulation.
6. Write a report for everything → reporting fluency.

> Keep it hands-on. Reading is necessary but the exam only rewards what you can *do*.
