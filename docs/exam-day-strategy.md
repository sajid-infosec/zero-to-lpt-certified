# Exam-Day Strategy

> 24 hours (or 2×12h) against a defended, multi-layer range, plus a graded report. Skill matters, but **strategy and stamina** decide borderline passes — and the gap between CPENT (≥70%) and LPT (≥90%).

## Before the exam (the week prior)

- **Have your report template ready.** Don't build it during the exam. ([domains/15](domains/15-reporting.md))
- **Finalize cheatsheets** ([cheatsheets/](cheatsheets/)) and a personal command notebook.
- **Pre-stage tooling:** scripts, wordlists (rockyou, SecLists), a pwntools ret2libc skeleton, Ligolo/chisel binaries, a proxychains config you trust.
- **Rehearse the pivot map workflow** so it's automatic.
- **Sleep, food, environment:** test your proctoring setup, ID, quiet room, snacks, water. Plan rest breaks (especially if doing 2×12h).

## The first hour: map everything before you commit

1. Write the **scope/IP ranges and objectives** at the top of your notes.
2. **Broad scan** all in-scope ranges (fast port sweep, then targeted `-sC -sV`).
3. Build a **target/flag map**: host → role → open services → candidate attacks → estimated difficulty.
4. **Bank the cheap points first** — easy enumeration flags (NetBIOS, version info, hashes) and obvious footholds. Momentum + points early.

## Time management

- **Time-box hard targets.** Stuck ~45 min? Note progress, move on, return later. One box must never eat the clock.
- **Track points vs. time.** Always be working the highest expected-value target you can currently reach.
- **Pivot opens new value** — every new subnet may hold easy flags; prioritize getting the *first* foothold in each network.
- If doing **2×12h**, end session 1 at a clean checkpoint with notes good enough to resume cold.

## Operating discipline

- **Enumerate exhaustively** before exploiting — most footholds are sitting in scan output.
- **When a tool fails, switch** (Hydra→NetExec, wmiexec→smbexec→WinRM, SSH→Ligolo). Don't fight one tool.
- **On every new host:** `ip route`, `arp -a`, loot creds/keys, update the pivot map.
- **Stabilize shells** immediately; you can't afford a dying dumb shell mid-task.
- **Reuse access** — one foothold often answers several objectives; don't re-exploit needlessly.

## Evidence — capture as you go (this is graded)

- For each objective: **command + full output + timestamped screenshot**.
- Record proof artifacts **exactly** as requested (length, case, `0x`, colons/no-colons).
- Keep a per-target notes page and the live pivot map ([template in domains/15](domains/15-reporting.md)).
- Never leave evidence collection "for later" — sessions die and details vanish.

## The report (reserve real time for it)

- Reserve the **final 3–4 hours** (or a dedicated block) for the report.
- Follow your template: exec summary → scope/method → findings (with evidence + remediation) → attack narrative → appendices.
- A compromise with **no documented, reproducible evidence scores nothing.** Documentation *is* points.
- Check submission requirements/deadline for the report after the hands-on window closes.

## Stamina & mindset

- Take short breaks on a schedule; stand up, hydrate, reset your eyes.
- Frustration is normal — the time-box rule exists to protect you from rabbit holes.
- Trust your methodology. Steady, documented progress beats frantic flailing.

## Quick decision checklist (tape it to your monitor)

- [ ] Is this target in scope?
- [ ] Have I fully enumerated before exploiting?
- [ ] Am I working the highest-value reachable objective?
- [ ] Did I time-box this? (45 min rule)
- [ ] Did I loot creds/keys and run `ip route` on this new host?
- [ ] Did I capture command + output + screenshot for the proof?
- [ ] Is my pivot map current?
- [ ] Have I reserved enough time for the report?

## After

- Submit the report through the official channel before the deadline.
- Clean notes/loot per the candidate agreement.
- Whatever the result, your timed-sim discipline + this checklist is exactly what got you here — repeat for a retake if needed.

Good luck. Methodology + evidence + stamina → CPENT, and with depth and speed → **LPT (Master)**.
