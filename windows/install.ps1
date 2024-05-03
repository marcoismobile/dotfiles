#
# Set Execution Policy
# > Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#

# Auto-Elevate
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-NoExit -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath pwsh.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

# Set Non-Interactive Options
$noninteractive = '--silent', '--disable-interactivity', '--accept-source-agreements'

function Disable-Services
{
  Write-host "Disable Services ..."

  # Disable Services
  $services = @(
    @{ name = "AllJoyn Router Service" },
    @{ name = "BitLocker Drive Encryption Service" },
    @{ name = "Connected User Experiences*" },
    @{ name = "Diagnostic*" },
    @{ name = "Downloaded Maps Manager" },
    @{ name = "Geolocation Service" },
    @{ name = "HV Host Service" },
    @{ name = "Hyper-V*" },
    @{ name = "Netlogon" },
    @{ name = "Optimise drives" },
    @{ name = "Parental Controls" },
    @{ name = "Phone Service" },
    @{ name = "Print Spooler" },
    @{ name = "Printer Extensions and Notifications" },
    @{ name = "Remote Desktop*" },
    @{ name = "Remote Registry" },
    @{ name = "Server" },
    @{ name = "Smart Card*" },
    @{ name = "TCP/IP NetBIOS Helper" },
    @{ name = "Telephony" },
    @{ name = "Themes" },
    @{ name = "WalletService" },
    @{ name = "Windows Biometric Service" },
    @{ name = "Windows Error Reporting Service" },
    @{ name = "Windows Insider Service" },
    @{ name = "Windows Media Player*" },
    @{ name = "Windows Mobile Hotspot Service" },
    @{ name = "Windows Search" },
    @{ name = "Workstation" },
    @{ name = "Work Folders" },
    @{ name = "WSL Service" },
    @{ name = "Xbox*" }
  );
  Foreach ($s in $services) {
    Write-host "Disabling Service: " $s.name
    Get-Service -displayname $s.name | Stop-Service -PassThru | Set-Service -StartupType Disabled
  }
}

function Winget-Uninstall
{
  Write-host "Uninstall Applications ..."

  # Uninstall Packages
  $uninstall = @(
    @{ name = "Dev Home (Preview)" },
    @{ name = "Game Bar" },
    @{ name = "Get Help" },
    @{ name = "Microsoft Tips" },
    @{ name = "Phone Link" },
    @{ name = "Windows Camera" },
    @{ name = "Windows Clock" },
    @{ name = "Xbox Game Bar Plugin" },
    @{ name = "Xbox Game Speech Window" },
    @{ name = "Xbox Identity Provider" }
  );
  Foreach ($app in $uninstall) {
    Write-host "Uninstalling Application: " $app.name
    winget uninstall $noninteractive --exact --purge --name $app.name
  }
}

function Winget-Install
{
  Write-host "Install Applications ..."

  # Install Packages
  $install = @(
    @{ id = "Cloudflare.cloudflared" },
    @{ id = "lsd-rs.lsd" },
    @{ id = "Microsoft.PowerShell" },
    @{ id = "Microsoft.VisualStudioCode" },
    @{ id = "Mozilla.Firefox" },
    @{ id = "MullvadVPN.MullvadVPN" },
    @{ id = "Neovim.Neovim" },
    @{ id = "RealVNC.VNCViewer" },
    @{ id = "Spotify.Spotify" },
    @{ id = "TeamViewer.TeamViewer" },
    @{ id = "XBMCFoundation.Kodi" }
  );
  Foreach ($app in $install) {
    Write-host "Installing Application: " $app.id
    winget install $noninteractive --exact --source winget --id $app.id
  }
}

function Winget-Upgrade
{
  Write-host "Upgrading Applications ..."
  winget upgrade $noninteractive --all
}

function Desktop-Cleanup
{
  Write-Host "Cleanup Desktop Icons..."

  # Get Desktop Shortcuts
  $desktop = [Environment]::GetFolderPath('Desktop'), [Environment]::GetFolderPath('CommonDesktop') |
    Get-ChildItem -Filter '*.lnk'

  # Cleaning up desktop icons
  $desktop | Foreach-Object {
    Remove-Item -LiteralPath $_.FullName
    Write-Host "Removed:  $($_.Name)" -ForegroundColor DarkGray
  }
}

function Fonts-Install
{
  $base_url = "https://github.com/romkatv/powerlevel10k-media/raw/master"
  $fonts = @(
    @{ name = "MesloLGS NF Regular" },
    @{ name = "MesloLGS NF Bold" },
    @{ name = "MesloLGS NF Italic" },
    @{ name = "MesloLGS NF Bold Italic" }
  );
  Foreach ($f in $fonts) {
    $dest = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\$($f.name).ttf"
    Write-host "Installing Font:" $f.name "->" $dest
    Invoke-WebRequest -Uri "$base_url/$($f.name).ttf" -OutFile $dest -ProgressAction SilentlyContinue
    New-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" -Name "$($f.name) (TrueType)" -PropertyType String -Value $dest -Force
  }
}

# Command Selection
switch ($args[0])
{
  "install" {
    Winget-Install
    Desktop-Cleanup
  }
  "upgrade" {
    Winget-Upgrade
    Desktop-Cleanup
  }
  "cleanup" {
    Disable-Services
    Winget-Uninstall
    Desktop-Cleanup
  }
  "fonts-install" {
    Fonts-Install
  }
  "init" {
    Winget-Uninstall
    Disable-Services
    Winget-Install
    Fonts-Install
    Desktop-Cleanup
  }
  default {
    Write-Host "No argument selected: ./install.ps1 [ install, upgrade, cleanup, fonts-install, init ]"
  }
}
