# Domain 15 · Report Writing & Post-Testing Actions

> Module 14 — and **part of your grade**. A flawless compromise you can't document professionally loses points. The report is the product a client actually pays for.

## Why it matters

The report is the only artifact that outlives the engagement. It must let a technical reader **reproduce** every finding and let an executive **understand the risk and decide**. CPENT/LPT require a submitted report; LPT (Master) especially expects client-grade quality.

## Anatomy of a professional pentest report

1. **Cover & document control** — client, dates, version, classification, author.
2. **Executive summary** — business-language overview: what was tested, overall risk posture, the few things leadership must act on. *No jargon.* One page.
3. **Scope & rules of engagement** — what was in/out of scope, timing, constraints, methodology/standards used (PTES, OWASP, NIST 800‑115).
4. **Methodology** — your approach and tools, mapped to a framework.
5. **Findings** — the core. One entry per finding (see template below), ordered by severity.
6. **Attack narrative / kill chain** — the story of how you went from zero to objective; great for showing chained risk.
7. **Remediation roadmap** — prioritized, actionable fixes with effort estimates.
8. **Appendices** — evidence, raw output, tool versions, references.

## Per-finding template

```
Title:            <concise, specific> e.g., "Kerberoastable service account with weak password"
Severity:         Critical / High / Medium / Low / Info   (justify with CVSS where used)
Affected assets:  <hosts/URLs/accounts>
CWE / refs:        <CWE-id, CVE if applicable>
Description:      What the issue is, in plain terms.
Impact:          What an attacker can do (business risk, not just "it's bad").
Evidence:        Commands + output + timestamped screenshots (reproducible).
Reproduction:    Exact, ordered steps so the client can verify.
Remediation:     Specific fix + reference; note compensating controls.
```

## Severity & risk

- Use a consistent scale. **CVSS v3.1** gives a defensible base score; adjust with business context.
- Severity should reflect **likelihood × impact in this environment**, not just theoretical CVSS.
- Don't inflate. Credibility comes from accurate ratings and clear evidence.

## Evidence discipline (do this *during* testing)

- Capture **command + full output** and **timestamped screenshots** at the moment of each finding.
- Record proof artifacts (flags/hashes) exactly as required (length, case, `0x` prefix, no colons — follow the prompt).
- Keep a **per-target notes page** (template below). Never fabricate or post-edit evidence.
- Maintain a **pivot/attack-path map** so the narrative writes itself.

### Per-target notes template (use while testing)
```
HOST: 10.x.x.x  (role:  )         in-scope: Y
Open ports/services:
Enumeration highlights:
Foothold (how):                    creds:
Privilege escalation (how):
Loot (creds/keys/hashes):
Pivot reach (new subnets):
Proof (flag/hash):
Screenshots: [filenames]
ATT&CK techniques: [Txxxx ...]
Remediation notes:
```

## Post-testing actions

- **Clean up** artifacts you introduced (web shells, added users, tunnels) — document what you removed.
- **Secure and hand over** the report through an agreed secure channel; respect data-retention rules.
- **Debrief** the client; offer a remediation re-test.
- **Destroy** sensitive loot per the RoE.

## Common pitfalls

- Leaving the report to the end → forgotten steps, unreproducible findings, lost points.
- Executive summary full of jargon (the wrong audience).
- Findings without remediation or without business impact.
- Inconsistent severities; missing evidence; screenshots without context.

## Exam relevance

Build your **report template before exam day** and write a mini-report for every practice box so it's automatic. On the exam, take evidence as you go and reserve the final hours for the report — unreported compromises score nothing.

## MITRE / mapping

- PTES **Reporting**; NIST 800‑115 **Reporting**. Map findings to ATT&CK techniques for clarity.

## Practice

- Write a full report for one HTB/PG box you've owned — exec summary through remediation.
- Have a peer try to **reproduce** a finding from your steps alone. If they can't, tighten it.

## Self-check

- [ ] I have a reusable report template ready now.
- [ ] I take reproducible evidence during testing, not after.
- [ ] I can write an exec summary a non-technical leader understands.
- [ ] Every finding has impact + remediation + evidence.
