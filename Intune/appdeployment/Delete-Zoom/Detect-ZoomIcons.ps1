# Title : Detect-ZoomIcons.ps1
# Creation : 26/10/2023
# Author : Lee Burridge
# Description : Detect Zoom Icons from device
# After using ZoomClean the icons don't get deleted. This can be deployed to remove them from the Start Menu

$Shortcuts2Remove = "Zoom.lnk"
$DesktopPath = "$env:appdata\Microsoft\Windows\Start Menu" 
$ShortcutsOnClient = Get-ChildItem -path $DesktopPath -recurse
$ShortcutsUnwanted = $ShortcutsOnClient | Where-Object -FilterScript {$_.Name -in $Shortcuts2Remove }

if (!$ShortcutsUnwanted) {
	Write-Host "All good, no shortcuts found. "
    exit 0
}else{
	Write-Host "Unwanted shortcut detected."
    Exit 1
}
