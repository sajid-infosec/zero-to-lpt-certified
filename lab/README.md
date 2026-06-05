# Lab — Build Your Own CPENT-Style Range

> Practice is the whole point. This directory builds a multi-range lab that mirrors the kinds of environments CPENT/LPT throws at you: an **Active Directory forest**, **vulnerable Linux/Windows targets**, and **segmented subnets for pivoting**.

> ⚠️ **Isolate your lab.** Use host-only / internal networks. Never expose intentionally vulnerable machines to the internet. Everything here is for authorized self-study.

## Pick your path

| Path | Effort | Best for | Start here |
|---|---|---|---|
| **A. Attacker + GOAD** (recommended start) | Low | AD mastery — the exam's core | [`goad/deploy-goad.sh`](goad/deploy-goad.sh) |
| **B. Full multi-range (Vagrant)** | Medium | Pivoting + mixed targets | [`vagrant/Vagrantfile`](vagrant/Vagrantfile) |
| **C. Manual / à la carte** | Varies | Targeted practice | the scripts in `linux/` and `windows/` |

You'll always need an **attacker box** (Kali/Parrot/Debian) — build it first.

---

## Step 1 — Attacker box (all paths)

On Kali/Parrot/Debian-based:
```bash
chmod +x linux/*.sh
sudo ./linux/install-tools.sh        # full toolkit (apt + pipx + go + git tools)
# optional extras / config:
./linux/setup-attacker-kali.sh       # wordlists, dirs, helper aliases, ligolo/chisel
```

If your attacker is Windows (less common): `windows/install-tools.ps1` (elevated).

---

## Step 2 — Choose & build targets

### Path A — GOAD (Game of Active Directory)
A full, deliberately vulnerable AD lab (multi-domain, trusts, AD CS). Best return on time for the exam's AD focus.
```bash
./goad/deploy-goad.sh                 # guides you through provider + deploy
```

### Path B — Full multi-range with Vagrant
Spins up an attacker, an AD DC + member, and Linux targets across **segmented subnets** so you can practice real pivoting.
```bash
cd vagrant
vagrant up                            # see the file header for sizing/requirements
```

### Path C — Manual targets
- Linux vulnerable services + apps: `linux/setup-linux-targets.sh` (Docker-based DVWA, Juice Shop, vulnerable SSH/SMB, etc.).
- Windows DC: `windows/setup-dc.ps1`. Member server: `windows/setup-member-server.ps1`.

---

## Reference lab topology

```
                          ┌──────────────────────────┐
                          │      ATTACKER (Kali)       │
                          │        10.0.10.5           │
                          └─────────────┬──────────────┘
                                        │  (external/DMZ net 10.0.10.0/24)
                          ┌─────────────▼──────────────┐
                          │  WEB / DMZ Linux target      │  ← initial foothold
                          │  10.0.10.20  (also 10.0.20.x)│    (dual-homed = pivot)
                          └─────────────┬────────────────┘
                                        │  (internal net 10.0.20.0/24)
              ┌─────────────────────────┼─────────────────────────┐
              │                         │                          │
   ┌──────────▼─────────┐    ┌──────────▼─────────┐    ┌───────────▼─────────┐
   │  AD DC             │    │  Member server      │    │  Linux internal      │
   │  10.0.20.10        │    │  10.0.20.20         │    │  10.0.20.30 (dual-    │
   │  corp.local        │    │  (SQL/file)         │    │  homed → 10.0.30.0/24)│
   └────────────────────┘    └─────────────────────┘    └───────────┬─────────┘
                                                                     │ (deep net 10.0.30.0/24)
                                                          ┌──────────▼─────────┐
                                                          │  Deep target        │  ← double pivot
                                                          │  10.0.30.40         │
                                                          └─────────────────────┘
```

The point: you land on the DMZ box, pivot into `10.0.20.0/24` (AD), then double-pivot into `10.0.30.0/24`. Adjust subnets to taste — the *shape* is what matters.

---

## Hardware guidance

| Lab | RAM | Disk | Notes |
|---|---|---|---|
| Attacker only | 4–8 GB | 40 GB | |
| Attacker + GOAD | 24–32 GB | 120 GB | GOAD runs several Windows VMs |
| Full Vagrant range | 16–32 GB | 100 GB | scale VMs in the Vagrantfile |

On a smaller machine, deploy GOAD in the **cloud** (the deploy script supports a provider choice) or build a reduced subset.

---

## Snapshots & hygiene

- **Snapshot every VM clean** before you attack it, so you can reset fast.
- Keep the lab on isolated host-only/internal networks.
- Don't commit loot — `.gitignore` already excludes pcaps, hashes, keys, etc.

## Troubleshooting

- **Vagrant/VirtualBox network issues:** check host-only adapters aren't conflicting with `10.0.x.x`; recreate with `vagrant reload`.
- **GOAD provisioning fails:** it's Ansible-heavy; re-run the provision step, ensure enough RAM, check the GOAD project README for current dependencies.
- **Windows scripts blocked:** run PowerShell **as Administrator** and `Set-ExecutionPolicy -Scope Process Bypass`.

See each script's header for specifics.
