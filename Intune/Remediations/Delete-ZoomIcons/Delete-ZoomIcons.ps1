# Title : Delete-ZoomIcons.ps1
# Creation : 26/10/2023
# Author : Lee Burridge
# Description : Delete Zoom Icons from device
# After using ZoomClean the icons don't get deleted. This can be deployed to remove them from the Start Menu

Remove-Item -path "$env:appdata\Microsoft\Windows\Start Menu\Programs\Zoom" -recurse