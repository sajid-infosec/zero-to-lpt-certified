# Domain 05 · API & JWT Penetration Testing

> Module 6. Modern apps are API-driven. APIs fail differently from classic web UIs — mostly on **authorization** and **token handling**.

## Why it matters

APIs expose business logic directly and are often less hardened than the UI. The OWASP **API Security Top 10** is dominated by broken authorization (BOLA/BFLA) — bugs you find by *thinking about objects and roles*, not by fuzzing payloads.

## Key concepts

### OWASP API Security Top 10 (essentials)
- **BOLA (Broken Object Level Authorization / IDOR):** change an ID, get someone else's object.
- **Broken Authentication:** weak/leaky tokens, no rate limiting, JWT flaws.
- **BFLA (Broken Function Level Authorization):** call admin functions as a normal user.
- **Mass Assignment:** send extra fields (`"isAdmin":true`) the server blindly binds.
- **Excessive Data Exposure:** endpoint returns more than the UI shows.
- **SSRF, injection, improper inventory (shadow/old API versions).**

### JWT (JSON Web Tokens)
Structure: `header.payload.signature` (base64url). Common flaws:
- **`alg: none`** accepted → forge tokens with no signature.
- **Algorithm confusion** (RS256→HS256): sign with the public key as an HMAC secret.
- **Weak HMAC secret** → crack offline and forge.
- **No expiry / no audience check / sensitive data in payload.**
- **`kid`/`jku`/`x5u` injection** → point the server at attacker-controlled keys.

## Methodology / workflow

1. **Discover the API** — find docs (`/swagger`, `/openapi.json`, `/api-docs`), JS files, mobile app endpoints.
2. **Enumerate endpoints & methods** — try `GET/POST/PUT/DELETE/PATCH`, hidden versions (`/v1`, `/v2`).
3. **Authn analysis** — how are tokens issued/validated? Inspect the JWT.
4. **Authz testing** — for every object/function, test access as a *different* user / lower role (BOLA/BFLA).
5. **Input & logic** — mass assignment, injection, rate limits.
6. **Token attacks** — test `alg:none`, algorithm confusion, secret cracking.

## Tools & usage

| Tool | Purpose |
|---|---|
| **Burp Suite** (+ Repeater/Intruder) | manual API testing, token tampering |
| **Postman / Insomnia** | structured endpoint exploration |
| **jwt_tool** | analyze/tamper/forge/crack JWTs |
| **hashcat** | crack weak HMAC JWT secrets (mode 16500) |
| **kiterunner** | content discovery for APIs |
| **arjun** | hidden parameter discovery |

## Commands (quick)

```bash
# Inspect & attack a JWT
jwt_tool <token>                       # decode + checks
jwt_tool <token> -X a                  # try alg:none
jwt_tool <token> -C -d wordlist.txt    # crack HMAC secret
hashcat -m 16500 jwt.txt rockyou.txt   # offline HMAC crack

# Discover hidden params/endpoints
arjun -u https://t/api/user
kr scan https://t -w routes-large.kite
```

## Common pitfalls

- Fuzzing payloads while ignoring **authorization** (where most API bugs actually are).
- Not creating two users (low + high priv) to test cross-access.
- Forgetting old/undocumented API versions still live.

## Exam relevance

Know how to find APIs, test object/function authorization, and break weak JWTs. Even a single forged admin token can cascade into a foothold.

## MITRE / mapping

- `T1190` (Exploit Public-Facing App), `T1212` (Exploit for Credential Access), Credential Access via token forgery. OWASP API Top 10.

## Practice

- **PortSwigger** API testing & JWT labs.
- **crAPI** (Completely Ridiculous API) and **VAmPI** vulnerable APIs in your lab.

## Self-check

- [ ] I can decode and tamper a JWT and explain `alg:none` & RS256→HS256 confusion.
- [ ] I test every endpoint as a second, lower-privileged user.
- [ ] I can locate undocumented endpoints and API versions.
