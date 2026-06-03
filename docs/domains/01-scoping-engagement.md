# Domain 01 · Scoping & Engagement

> Module 2 of the blueprint. The unglamorous phase that keeps you legal, focused, and out of trouble. On the exam this maps to reading the scope carefully; in the real world it's the difference between a professional and a liability.

## Why it matters

A pentest without a clear scope and authorization is, legally, just a crime with extra steps. Scoping defines **what** you may test, **how**, **when**, and **who to call** when something breaks. CPENT expects you to respect the documented scope of the range exactly — testing out-of-scope hosts wastes time and (in real life) breaches contract.

## Key concepts

- **Rules of Engagement (RoE):** the binding agreement — targets (IPs/domains), allowed techniques (e.g., is DoS or social engineering permitted?), testing windows, data-handling rules, and stop conditions.
- **Authorization / "get out of jail" letter:** written, signed permission from someone empowered to grant it. No letter, no test.
- **Scope types:** black-box (no info), grey-box (some creds/info), white-box (full info/source).
- **Engagement types:** external, internal, web app, wireless, social engineering, red team, assumed-breach.
- **Targets vs. out-of-scope:** explicit allow-lists beat vague descriptions. Third-party/cloud assets may need the provider's permission too.
- **Goals & flags:** what does "success" mean? (data exfil, DA, specific systems). The exam frames this as objectives/flags.

## Methodology / workflow

1. **Define objectives** with the client: compliance? real-world risk? specific crown jewels?
2. **Enumerate assets in scope** and confirm ownership/authorization for each.
3. **Agree constraints:** timing, rate limits, prohibited actions, sensitive systems.
4. **Set communication & escalation:** primary/secondary contacts, emergency stop, evidence handling.
5. **Document everything** in the RoE and have it signed *before* any packet leaves your box.
6. **Re-scope** if you discover something materially new (e.g., a connected network not in the brief).

## Deliverables you should produce

- Signed RoE + authorization.
- Scope sheet (in-scope hosts/domains, out-of-scope exclusions).
- Test plan & schedule.
- Contact/escalation matrix.

## Common pitfalls

- Testing an IP that "looked related" but was out of scope.
- No written stop condition → confusion when a production system wobbles.
- Forgetting cloud/third-party authorization.
- Treating scoping as paperwork to rush — it's where engagements go wrong.

## Exam relevance

The range *is* your scope. Read the provided scope/IP ranges and objectives **carefully**, write them at the top of your notes, and never burn time on hosts outside the brief. Mirror the RoE structure in your report's "Scope & Methodology" section.

## MITRE / standard mapping

- PTES **Pre-engagement Interactions**; NIST 800‑115 **Planning**.

## Practice

- Write a full mock RoE for a fictional client with 3 web apps, a /24 internal range, and a cloud tenant. List what you'd need permission for.
- Re-read your lab's "scope" (the subnets you built) and produce a one-page scope sheet.

## Self-check

- [ ] I can list the elements of an RoE from memory.
- [ ] I can explain why an authorization letter is mandatory.
- [ ] I always write the in-scope ranges at the top of my notes before scanning.
