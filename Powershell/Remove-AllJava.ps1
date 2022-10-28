# This little script will remove Java from a system

$Source = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*
$Uninstall = $Source | Where-Object {($_.Publisher -like '*Oracle*')-and ($_.DisplayName -like 'Java*')} | select UninstallString
$UninstallStrings = $Uninstall.UninstallString -replace "MsiExec.exe ","MsiExec.exe /qn " -replace "/I","/X"
ForEach($UninstallString in $UninstallStrings){& cmd /c "$UninstallString"}
