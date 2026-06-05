<#
.SYNOPSIS
  Zero to LPT Certified — build a DELIBERATELY VULNERABLE Active Directory lab DC.
.DESCRIPTION
  Promotes this Windows Server to a Domain Controller for corp.local and seeds
  it with common, exam-relevant misconfigurations so you can practice the AD
  attack chain (AS-REP roast, Kerberoast, weak passwords, ACL/loot).

  Run on a FRESH Windows Server (2019/2022) VM, as Administrator, in an ISOLATED
  host-only network. This makes the machine intentionally insecure — never use
  on a production network.

.PARAMETER Domain
  FQDN of the AD domain to create (default corp.local).
.PARAMETER SafeModePassword
  DSRM password (you will be prompted if not supplied).
.EXAMPLE
  Set-ExecutionPolicy -Scope Process Bypass
  .\setup-dc.ps1 -Domain corp.local
  # reboots, then re-run with -Phase 2 after the DC comes back up
#>
[CmdletBinding()]
param(
  [string]$Domain = "corp.local",
  [string]$NetbiosName = "CORP",
  [securestring]$SafeModePassword,
  [ValidateSet(1,2)][int]$Phase = 1
)

$ErrorActionPreference = "Stop"
function Info($m){ Write-Host "[+] $m" -ForegroundColor Green }
function Warn($m){ Write-Host "[!] $m" -ForegroundColor Yellow }

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  throw "Run as Administrator."
}

# ---------------------------------------------------------------------------
# PHASE 1: promote to Domain Controller
# ---------------------------------------------------------------------------
if ($Phase -eq 1) {
  Warn "This creates an INTENTIONALLY VULNERABLE AD. Isolated lab use only."
  if (-not $SafeModePassword) { $SafeModePassword = Read-Host "DSRM (SafeMode) password" -AsSecureString }

  Info "Installing AD DS role..."
  Install-WindowsFeature AD-Domain-Services -IncludeManagementTools | Out-Null

  Info "Promoting to Domain Controller for $Domain ..."
  Import-Module ADDSDeployment
  Install-ADDSForest `
    -DomainName $Domain `
    -DomainNetbiosName $NetbiosName `
    -InstallDns `
    -SafeModeAdministratorPassword $SafeModePassword `
    -DomainMode "WinThreshold" -ForestMode "WinThreshold" `
    -Force -NoRebootOnCompletion:$false
  # machine reboots automatically; after reboot run:  .\setup-dc.ps1 -Phase 2
  return
}

# ---------------------------------------------------------------------------
# PHASE 2: seed users, groups, SPNs, and misconfigurations
# ---------------------------------------------------------------------------
Import-Module ActiveDirectory
$base = (Get-ADDomain).DistinguishedName
Info "Domain: $Domain  ($base)"

# OU
$ouName = "LabUsers"
if (-not (Get-ADOrganizationalUnit -Filter "Name -eq '$ouName'" -ErrorAction SilentlyContinue)) {
  New-ADOrganizationalUnit -Name $ouName -Path $base
}
$ouPath = "OU=$ouName,$base"

function New-LabUser($u,$pw,$desc){
  if (-not (Get-ADUser -Filter "SamAccountName -eq '$u'" -ErrorAction SilentlyContinue)) {
    New-ADUser -Name $u -SamAccountName $u -AccountPassword (ConvertTo-SecureString $pw -AsPlainText -Force) `
      -Enabled $true -Path $ouPath -Description $desc -PasswordNeverExpires $true
    Info "user: $u / $pw"
  }
}

# --- Regular users with WEAK passwords (spray/brute practice) ---
New-LabUser "jdoe"     "Summer2026!"   "Marketing"
New-LabUser "asmith"   "Password1"     "Helpdesk"
New-LabUser "bwallace" "Welcome123"    "Finance"
New-LabUser "svc-backup" "Backup#2026"  "Backup service account"

# --- Kerberoastable service account (SPN set) ---
New-LabUser "svc-sql" "Sql_P@ss2026"   "SQL service (kerberoastable)"
setspn -S MSSQLSvc/sql.corp.local:1433 svc-sql 2>$null
Info "SPN set on svc-sql (Kerberoasting target)"

# --- AS-REP roastable user (pre-auth disabled) ---
New-LabUser "marketingsvc" "Spring2026!" "AS-REP roastable"
Set-ADAccountControl -Identity "marketingsvc" -DoesNotRequirePreAuth $true
Info "DoesNotRequirePreAuth set on marketingsvc (AS-REP roast target)"

# --- An over-privileged user (ACL/lateral practice) ---
New-LabUser "itadmin" "ChangeMe2026!" "Local admin on member servers"
Add-ADGroupMember -Identity "Domain Admins" -Members "asmith" -ErrorAction SilentlyContinue
Warn "asmith added to Domain Admins (intentional weak path — BloodHound will find it)"

# --- A readable share with 'loot' (creds in files) ---
$share = "C:\Shares\Public"
New-Item -ItemType Directory -Force -Path $share | Out-Null
"db connection: sql.corp.local user=svc-sql pass=Sql_P@ss2026" | Out-File "$share\readme-credentials.txt"
New-SmbShare -Name "Public" -Path $share -FullAccess "Everyone" -ErrorAction SilentlyContinue | Out-Null
Info "SMB share \\$env:COMPUTERNAME\Public with planted creds"

# --- Disable SMB signing requirement on this member-facing context (relay practice note) ---
Warn "Note: DCs enforce SMB signing. Use member servers (setup-member-server.ps1) for relay practice."

Info "Lab AD seeded. Try from your attacker:"
Write-Host @"
  nxc smb <dc-ip>
  impacket-GetNPUsers $Domain/ -usersfile users.txt -no-pass        # AS-REP (marketingsvc)
  impacket-GetUserSPNs $Domain/jdoe:'Summer2026!' -request          # Kerberoast (svc-sql)
  bloodhound-python -u jdoe -p 'Summer2026!' -d $Domain -ns <dc-ip> -c All
"@ -ForegroundColor Cyan
Warn "INTENTIONALLY VULNERABLE. Isolated lab only."
