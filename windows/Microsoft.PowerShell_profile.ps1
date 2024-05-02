#
# Set Execution Policy
# > Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
#

# Enable ctrl+d Exit
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

# Prompt
function prompt {
    $c = $? ? $psstyle.Foreground.BrightGreen : $psstyle.Foreground.Red
    $p = (Convert-Path .)
    if ($p.Contains($HOME)) {
        $p = $p.Replace($HOME, "~")
    }
    "$($psstyle.Foreground.BrightBlue)$p$($psstyle.Reset) " +
    "$($c)`u{276F}$($psstyle.Reset) "
}

# Aliases
Set-Alias -Name g -Value git
Set-Alias -Name ls -Value lsd
Set-Alias -Name v -Value nvim
