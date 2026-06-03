# Domain 03 · Social Engineering Penetration Testing

> Module 4. Humans are the most consistent vulnerability. This domain tests whether you can assess that risk **methodically and ethically**, only when explicitly in scope.

## Why it matters

Most real breaches start with a person clicking, trusting, or talking. A social-engineering assessment measures how susceptible an organization is and how well its detection/response works. It is **only** performed with explicit written authorization and tight rules — it touches real people.

## Key concepts

- **Vectors:** phishing (email), spear-phishing (targeted), vishing (voice), smishing (SMS), pretexting, baiting (USB drops), tailgating/physical.
- **Pretext:** the believable scenario (IT support, vendor, courier) that makes the target comply.
- **Psychological levers:** authority, urgency, scarcity, social proof, reciprocity, fear.
- **Payloads:** credential-harvesting pages, malicious attachments/macros, tracking links (with consent/scope).
- **Metrics:** click rate, submit rate, report rate, time-to-detect.

## Methodology / workflow

1. **Authorization & ethics first** — scope which people/techniques are allowed; define harm limits and data handling.
2. **Recon (OSINT)** — targets, roles, email format, tooling they use (for believable pretexts).
3. **Pretext design** — craft a scenario that fits the org's context.
4. **Infrastructure** — look-alike domain, mail setup (SPF/DKIM considerations), landing page (e.g., GoPhish).
5. **Launch (controlled)** — small pilot, then full campaign within the window.
6. **Measure & support** — record metrics; never shame individuals; feed results to awareness training.
7. **Report** — aggregate stats + recommendations (training, MFA, email filtering, reporting culture).

## Tools & usage

| Tool | Purpose |
|---|---|
| **GoPhish** | run/track phishing campaigns (templates, landing pages, metrics) |
| **SET (Social-Engineer Toolkit)** | credential harvesters, payloads, cloners |
| **Evilginx2** | reverse-proxy phishing that can capture session tokens (MFA-bypass demos) |
| **King Phisher** | campaign management |
| Custom maldoc tooling | macro/attachment payloads (lab only) |

## Defensive recommendations you'll write up

- Enforce phishing-resistant **MFA**; deploy DMARC/DKIM/SPF; advanced email filtering.
- Regular, **non-punitive** awareness training; easy "report phish" button.
- Least privilege so a single click doesn't equal domain compromise.

## Common pitfalls

- Running *anything* without explicit authorization — never acceptable.
- Targeting individuals publicly or punitively (unethical and counterproductive).
- Ignoring detection/response measurement (the org learns more from "did we catch it?" than from click rates alone).

## Exam relevance

Treat as concept-and-process knowledge: know the vectors, the ethical guardrails, the metrics, and the toolchain. Be able to describe a campaign lifecycle and the controls that mitigate it.

## MITRE / mapping

- ATT&CK Initial Access `T1566` (Phishing), `T1566.001/.002/.003`; `T1598` (Phishing for Information). PTES **Exploitation** (human).

## Practice (lab/self only)

- Stand up **GoPhish** in your lab and send a campaign to your *own* test mailboxes; review the dashboard metrics.
- Draft three pretexts for a fictional company and critique their believability.

## Self-check

- [ ] I can list 5 SE vectors and a control for each.
- [ ] I can describe a full, ethical campaign lifecycle.
- [ ] I understand why authorization and non-punitive handling are mandatory.
