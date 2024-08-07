#
# Set Execution Policy
# > Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#

# Auto-Elevate for disabling services
if ($args[0] -eq 'disable-services') {
  if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
      $CommandLine = "-NoExit -File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
      Start-Process -FilePath pwsh.exe -Verb Runas -ArgumentList $CommandLine
      Exit
    }
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
    @{ name = "Connected User Experiences and Telemetry" },
    @{ name = "Data Usage" },
    @{ name = "Diagnostic Execution Service" },
    @{ name = "Diagnostic Policy Service" },
    @{ name = "Diagnostic Service Host" },
    @{ name = "Diagnostic System Host" },
    @{ name = "Distributed Link Tracking Client" },
    @{ name = "Downloaded Maps Manager" },
    @{ name = "Geolocation Service" },
    @{ name = "HV Host Service" },
    @{ name = "Hyper-V Guest Service Interface" },
    @{ name = "Hyper-V Heartbeat Service" },
    @{ name = "Hyper-V Data Exchange Service" },
    @{ name = "Hyper-V Remote Desktop Virtualization Service" },
    @{ name = "Hyper-V Guest Shutdown Service" },
    @{ name = "Hyper-V Time Synchronization Service" },
    @{ name = "Hyper-V PowerShell Direct Service" },
    @{ name = "Hyper-V Volume Shadow Copy Requestor" },
    @{ name = "IP Helper" },
    @{ name = "Microsoft Account Sign-in Assistant" },
    @{ name = "Netlogon" },
    @{ name = "Optimise drives" },
    @{ name = "Parental Controls" },
    @{ name = "Phone Service" },
    @{ name = "Portable Device Enumerator Service" },
    @{ name = "Print Spooler" },
    @{ name = "Printer Extensions and Notifications" },
    @{ name = "Remote Desktop Configuration" },
    @{ name = "Remote Desktop Services" },
    @{ name = "Remote Desktop Services UserMode Port Redirector" },
    @{ name = "Remote Registry" },
    @{ name = "Server" },
    @{ name = "Smart Card" },
    @{ name = "Smart Card Device Enumeration Service" },
    @{ name = "Smart Card Removal Policy" },
    @{ name = "TCP/IP NetBIOS Helper" },
    @{ name = "Telephony" },
    @{ name = "Themes" },
    @{ name = "WalletService" },
    @{ name = "Windows Biometric Service" },
    @{ name = "Windows Error Reporting Service" },
    @{ name = "Windows Image Acquisition (WIA)" },
    @{ name = "Windows Insider Service" },
    @{ name = "Windows Media Player Network Sharing Service" },
    @{ name = "Windows Mobile Hotspot Service" },
    @{ name = "Windows Push Notifications System*" },
    @{ name = "Windows Search" },
    @{ name = "Workstation" },
    @{ name = "Work Folders" },
    @{ name = "WSL Service" },
    @{ name = "Xbox Live Auth Manager" },
    @{ name = "Xbox Live Game Save" },
    @{ name = "Xbox Accessory Management Service" },
    @{ name = "Xbox Live Networking Service" }
  );
  Foreach ($s in $services) {
    Write-host "Disabling Service: $($s.name)" -ForegroundColor DarkGray
    Get-Service -displayname $s.name -ErrorAction SilentlyContinue | Stop-Service -PassThru | Set-Service -StartupType Disabled
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
  $appList = [String]::Join("", $(winget list))
  Foreach ($app in $uninstall) {
    if ($appList.Contains($app.name)) {
      Write-host "Uninstalling Application: $($app.name)" -ForegroundColor DarkGray

      winget uninstall $noninteractive --exact --purge --name $app.name
    } else {
      Write-host "Application not installed: $($app.name)" -ForegroundColor DarkGray

    }
  }
}

function Winget-Install
{
  Write-host "Install Applications ..."

  # Install Packages
  $install = @(
    @{ id = "Git.Git" },
    @{ id = "lsd-rs.lsd" },
    @{ id = "Microsoft.PowerShell" },
    @{ id = "Microsoft.VisualStudioCode" },
    @{ id = "Mozilla.Firefox" },
    @{ id = "Neovim.Neovim" },
    @{ id = "Plex.Plex" },
    @{ id = "RealVNC.VNCViewer" },
    @{ id = "Spotify.Spotify" },
    @{ id = "TradingView.TradingViewDesktop" }
  );
  $appList = [String]::Join("", $(winget list))
  Foreach ($app in $install) {
    if (!$appList.Contains($app.id)) {
      Write-host "Installing Application: $($app.id)" -ForegroundColor DarkGray
      winget install $noninteractive --exact --source winget --id $app.id
    } else {
      Write-host "Application already installed: $($app.id)" -ForegroundColor DarkGray
    }
  }
}

function Winget-Upgrade
{
  Write-host "Upgrading Applications ..."
  winget upgrade $noninteractive --all
}

function Desktop-Cleanup
{
  Write-Host "Cleanup Desktop Icons ..."

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
  Write-Host "Installing MesloLGS NF ..."
  $base_url = "https://github.com/romkatv/powerlevel10k-media/raw/master"
  $fonts = @(
    @{ name = "MesloLGS NF Regular" },
    @{ name = "MesloLGS NF Bold" },
    @{ name = "MesloLGS NF Italic" },
    @{ name = "MesloLGS NF Bold Italic" }
  );
  Foreach ($f in $fonts) {
    $dest = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts\$($f.name).ttf"
    Write-host "Installing Font: $($f.name) -> $dest" -ForegroundColor DarkGray
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
  "uninstall" {
    Winget-Uninstall
    Desktop-Cleanup
  }
  "disable-services" {
    Disable-Services
  }
  "fonts-install" {
    Fonts-Install
  }
  default {
    Write-Host "No argument selected: ./install.ps1 [ install, upgrade, uninstall, disable-services, fonts-install ]"
  }
}
