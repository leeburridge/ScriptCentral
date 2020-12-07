$Shell = New-Object -ComObject ("WScript.Shell")
$Favorite = $Shell.CreateShortcut("$env:USERPROFILE\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Browse Printers.lnk")
$Favorite.TargetPath = "\\<IP or NAME>\";
$Favorite.Save()
