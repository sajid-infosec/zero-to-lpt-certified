# Domain 13 · Cloud Penetration Testing

> Supplementary to the core blueprint but present on modern enterprise ranges. CPENT‑AI references cloud privilege escalation; LPT-level work increasingly crosses into cloud.

## Why it matters

Enterprises run hybrid environments. A foothold often leads to cloud credentials (in env vars, metadata, config), and cloud misconfigurations (IAM, storage, secrets) escalate to full tenant compromise. Cloud testing also has stricter authorization rules (the provider's, not just the client's).

## Key concepts

- **Shared responsibility:** the provider secures the cloud; the customer secures *in* the cloud (IAM, config). You test the customer side.
- **Identity is the new perimeter:** over-permissive **IAM** roles/policies are the dominant escalation path.
- **Metadata service (IMDS):** `169.254.169.254` — SSRF or local access can steal instance role credentials (use IMDSv2 awareness).
- **Storage exposure:** public S3/Azure Blob/GCS buckets leak data.
- **Secrets sprawl:** keys in code, env vars, CI/CD, container images.
- **Federation/SSO:** trust relationships and token abuse.

## Methodology / workflow

1. **Confirm authorization** — cloud provider rules + client RoE.
2. **Enumerate identity & permissions** — what can this principal do? (`aws iam`, `az role assignment`).
3. **Hunt credentials** — env, metadata (SSRF→IMDS), config files, container layers.
4. **Find misconfigurations** — public storage, permissive policies, exposed services.
5. **Escalate via IAM** — privilege-escalation paths (e.g., `iam:PassRole`, policy versioning, Lambda/EC2 role abuse).
6. **Assess blast radius** — what does the compromised principal reach?

## Provider quick-notes

| Provider | Recon/enum | PrivEsc themes |
|---|---|---|
| **AWS** | `aws sts get-caller-identity`, `enumerate-iam`, ScoutSuite, **Pacu** | `iam:PassRole`+service, policy version rollback, SSRF→IMDS role creds |
| **Azure** | `az account show`, AzureHound, **ROADtools**, MicroBurst | Managed Identity abuse, role assignment, Key Vault access |
| **GCP** | `gcloud auth list`, ScoutSuite | service-account impersonation, `actAs` |

## Tools & usage

| Tool | Purpose |
|---|---|
| **Pacu** | AWS exploitation framework |
| **ScoutSuite** | multi-cloud config auditing |
| **CloudFox** | situational awareness post-foothold |
| **ROADtools / AzureHound** | Azure AD enumeration & paths |
| **enumerate-iam** | brute permission discovery (AWS) |
| **trufflehog / gitleaks** | secret discovery in code/CI |

## Commands (quick)

```bash
# AWS: who am I, what can I do
aws sts get-caller-identity
aws iam list-attached-user-policies --user-name <u>
# Steal instance role creds via metadata (from a foothold / SSRF)
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/<role>
# Azure
az account show ; az role assignment list --assignee <id>
```

## Common pitfalls

- Testing cloud without provider authorization.
- Focusing on hosts and ignoring **IAM** (where cloud privesc actually lives).
- Missing IMDS/SSRF cred theft as a pivot from a web foothold.

## Exam relevance

Know how a foothold yields cloud creds, how IMDS/SSRF leaks role credentials, and the shape of an IAM privilege-escalation path. Depth here is lower-yield than AD/pivoting but appears in modern ranges.

## MITRE / mapping

- `T1078.004` (Cloud Accounts), `T1552.005` (Cloud Instance Metadata API), `T1098` (Account Manipulation), `T1530` (Data from Cloud Storage).

## Practice

- **flAWS / flAWS2**, **CloudGoat** (AWS), **AzureGoat**, **PurplePanda**.
- PortSwigger SSRF labs (the IMDS angle).

## Self-check

- [ ] I can enumerate my effective permissions in AWS/Azure.
- [ ] I can steal instance-role creds via IMDS/SSRF.
- [ ] I can describe one concrete IAM privilege-escalation path.
