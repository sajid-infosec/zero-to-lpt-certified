<#
.SYNOPSIS
  Zero to LPT Certified — install offensive tooling on a Windows attacker/CommandoVM-style box.
.DESCRIPTION
  Uses Chocolatey + git to install common tooling. Many AD tools (Rubeus, Mimikatz,
  SharpHound) are flagged by Defender by design — you will need to add exclusions
  in your ISOLATED lab. This script will optionally create an exclusion folder.

  Run as Administrator on a lab VM you control. AUTHORIZED USE ONLY.
.EXAMPLE
  Set-ExecutionPolicy -Scope Process Bypass
  .\install-tools.ps1
#>
[CmdletBinding()]
param([switch]$AddDefenderExclusion)
$ErrorActionPreference = "Continue"
function Info($m){ Write-Host "[+] $m" -ForegroundColor Green }
function Warn($m){ Write-Host "[!] $m" -ForegroundColor Yellow }

if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
  throw "Run as Administrator."
}

# 1. Chocolatey
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
  Info "Installing Chocolatey..."
  Set-ExecutionPolicy Bypass -Scope Process -Force
  [System.Net.ServicePointManager]::SecurityProtocol = 3072
  iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# 2. Baseline tooling via choco
$choco = @("git","python","nmap","wireshark","7zip","sysinternals","openssh","golang","jq","vscode")
foreach ($p in $choco) { Info "choco: $p"; choco install $p -y --no-progress | Out-Null }

# 3. Tools directory + Defender exclusion (lab only)
$tools = "C:\Tools"
New-Item -ItemType Directory -Force -Path $tools | Out-Null
if ($AddDefenderExclusion) {
  Warn "Adding Defender exclusion for $tools (LAB ONLY — never on production)"
  Add-MpPreference -ExclusionPath $tools -ErrorAction SilentlyContinue
}

# 4. Git-cloned offensive tooling (compile separately as needed)
function Clone($url,$name){
  $dst = Join-Path $tools $name
  if (Test-Path "$dst\.git") { git -C $dst pull } else { git clone --depth 1 $url $dst }
  Info "cloned $name"
}
Clone https://github.com/GhostPack/Rubeus.git           Rubeus
Clone https://github.com/GhostPack/Seatbelt.git         Seatbelt
Clone https://github.com/BloodHoundAD/SharpHound.git    SharpHound
Clone https://github.com/PowerShellMafia/PowerSploit.git PowerSploit
Clone https://github.com/int0x33/nc.exe.git             ncexe
Clone https://github.com/itm4n/PrintSpoofer.git         PrintSpoofer
Clone https://github.com/BeichenDream/GodPotato.git     GodPotato

Warn "Mimikatz: download the official signed release from github.com/gentilkiwi/mimikatz (Defender will flag it)."
Warn "Compile C# tools (Rubeus/Seatbelt/SharpHound) in Visual Studio or grab released binaries."
Info "Done. Tools in $tools. Reminder: isolated lab, authorized use only."
