#
# Set Execution Policy
# > Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#

# Self-Elevate if required
if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] 'Administrator')) {
    if ([int](Get-CimInstance -Class Win32_OperatingSystem | Select-Object -ExpandProperty BuildNumber) -ge 6000) {
        $CommandLine = "-File `"" + $MyInvocation.MyCommand.Path + "`" " + $MyInvocation.UnboundArguments
        Start-Process -FilePath pwsh.exe -Verb Runas -ArgumentList $CommandLine
        Exit
    }
}

# Set Non-Interactive Options
$noninteractive = '--silent', '--disable-interactivity', '--accept-source-agreements'

# Get CLI argument
$command = $args[0]

function Disable-Services
{
  Write-host "Disable Services ..."

  # Disable Services
  $services = @(
    @{ name = "AllJoyn Router Service" },
    @{ name = "HV Host Service" },
    @{ name = "Hyper-V*" },
    @{ name = "Phone Service" },
    @{ name = "Print Spooler" },
    @{ name = "Printer Extensions and Notifications" },
    @{ name = "Remote Desktop*" },
    @{ name = "Remote Registry" },
    @{ name = "Server" },
    @{ name = "TCP/IP NetBIOS Helper" },
    @{ name = "Telephony" },
    @{ name = "Themes" },
    @{ name = "Windows Media Player*" },
    @{ name = "Windows Search" },
    @{ name = "Workstation" },
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

# Command Selection
switch ($command)
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
  default {
    Write-Host "No command selected: [ install, upgrade, cleanup ]"
  }
}

Pause
Exit
