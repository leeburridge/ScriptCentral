<#
    .SYNOPSIS
        Adds a shortcut to a web app using Edge as browser.
    .DESCRIPTION
        Author:  John Seerden (https://www.srdn.io)
        Version: 1.0

        Adds a shortcut to a web app, using Edge as browser, in the Start Menu and/or on the User's Desktop.
    .PARAMETER ShortcutName
        Display Name of the shortcut.
    .PARAMETER ShortcutUrl
        URL associated with the shortcut.
    .PARAMETER ShortcutIconLocation
        Optional: Path to an icon to associate with the shortcut.
    .PARAMETER ShortcutOnDesktop
        Set to $true if the Shortcut needs to be added to the assigned User's Profile Desktop.
    .PARAMETER ShortcutInStartMenu
        Set to $true if the Shortcut needs to be added to the assigned User's Start Menu.
    .NOTES
        This scripts needs to run using the logged on credentials.
#>
param(
    [string]$ShortcutName         = "Password Reset Link",
    [string]$ShortcutUrl          = "https://passwordlink.com",
    [string]$ShortcutIconLocation = "https://www.microsoft.com/favicon.ico",
    [bool]$ShortcutOnDesktop      = $false,
    [bool]$ShortcutInStartMenu    = $true
)

$WScriptShell = New-Object -ComObject WScript.Shell

if ($ShortcutOnDesktop) {
    $Shortcut = $WScriptShell.CreateShortcut("$env:USERPROFILE\Desktop\$ShortcutName.lnk") 
    $Shortcut.TargetPath = "$Env:WinDir\explorer.exe" 
    $Shortcut.Arguments = "microsoft-edge:""$ShortcutUrl""" 
    if ($ShortcutIconLocation) {
        $Shortcut.IconLocation = $ShortcutIconLocation
    }
    $Shortcut.Save()
}

if ($ShortCutInStartMenu) {
    $Shortcut = $WScriptShell.CreateShortcut("$env:APPDATA\Microsoft\Windows\Start Menu\Programs\$ShortcutName.lnk") 
    $Shortcut.TargetPath = "$Env:WinDir\explorer.exe" 
    $Shortcut.Arguments = "microsoft-edge:""$ShortcutUrl""" 
    if ($ShortcutIconLocation) {
        $Shortcut.IconLocation = $ShortcutIconLocation
    }
    $Shortcut.Save()
}
