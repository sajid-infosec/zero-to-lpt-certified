<#
.SYNOPSIS
  Zero to LPT Certified — join a Windows Server to the lab domain and add
  deliberately vulnerable local conditions (relay + local privesc practice).
.DESCRIPTION
  Joins corp.local, DISABLES SMB signing (NTLM relay target), creates a local
  admin with a weak password, and seeds a couple of local-privesc misconfigs
  (unquoted service path, AlwaysInstallElevated). Isolated lab only.
.EXAMPLE
  Set-ExecutionPolicy -Scope Process Bypass
  .\setup-member-server.ps1 -Domain corp.local -DcIp 10.0.20.10
#>
[CmdletBinding()]
param(
  [string]$Domain = "corp.local",
  [Parameter(Mandatory)][string]$DcIp,
  [string]$JoinUser = "CORP\Administrator"
)
$ErrorActionPreference = "Stop"
function Info($m){ Write-Host "[+] $m" -ForegroundColor Green }
function Warn($m){ Write-Host "[!] $m" -ForegroundColor Yellow }

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  throw "Run as Administrator."
}
Warn "Creates INTENTIONAL vulnerabilities. Isolated lab only."

# 1. Point DNS at the DC and join the domain
Info "Setting DNS to $DcIp and joining $Domain ..."
$if = (Get-NetIPConfiguration | Where-Object {$_.IPv4DefaultGateway -ne $null} | Select-Object -First 1).InterfaceIndex
Set-DnsClientServerAddress -InterfaceIndex $if -ServerAddresses $DcIp
$cred = Get-Credential -Message "Domain join creds" -UserName $JoinUser
Add-Computer -DomainName $Domain -Credential $cred -Force
Info "Joined. A reboot is required; re-run with -Phase2 after reboot to seed misconfigs."

# 2. Seed misconfigurations (run after reboot)
function Seed-Misconfigs {
  # 2a. Disable SMB signing -> NTLM relay target
  Set-SmbServerConfiguration -RequireSecuritySignature $false -EnableSecuritySignature $false -Force
  Info "SMB signing DISABLED (relay target)"

  # 2b. Weak local admin
  $pw = ConvertTo-SecureString "LocalAdmin#1" -AsPlainText -Force
  if (-not (Get-LocalUser -Name "svcadmin" -ErrorAction SilentlyContinue)) {
    New-LocalUser -Name "svcadmin" -Password $pw -PasswordNeverExpires
    Add-LocalGroupMember -Group "Administrators" -Member "svcadmin"
    Info "local admin svcadmin / LocalAdmin#1"
  }

  # 2c. AlwaysInstallElevated (MSI privesc)
  New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer" -Force | Out-Null
  New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Installer" -Name "AlwaysInstallElevated" -Value 1 -PropertyType DWord -Force | Out-Null
  New-Item -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer" -Force | Out-Null
  New-ItemProperty -Path "HKCU:\SOFTWARE\Policies\Microsoft\Windows\Installer" -Name "AlwaysInstallElevated" -Value 1 -PropertyType DWord -Force | Out-Null
  Warn "AlwaysInstallElevated enabled (privesc via malicious MSI)"

  # 2d. Unquoted service path with weak dir perms
  $svcDir = "C:\Program Files\Vuln Service"
  New-Item -ItemType Directory -Force -Path $svcDir | Out-Null
  Copy-Item C:\Windows\System32\cmd.exe "$svcDir\service.exe" -ErrorAction SilentlyContinue
  sc.exe create VulnSvc binPath= "C:\Program Files\Vuln Service\service.exe" start= auto | Out-Null
  icacls "C:\Program Files" /grant "Everyone:(OI)(CI)M" 2>$null | Out-Null
  Warn "Unquoted service path 'VulnSvc' with writable parent (privesc)"

  Info "Member server seeded. Practice: relay (signing off), local privesc, lateral movement."
}

# If already domain-joined, just seed:
if ((Get-WmiObject Win32_ComputerSystem).PartOfDomain) { Seed-Misconfigs }
else { Warn "Not domain-joined yet — reboot after join, then re-run this script to seed misconfigs." }
