Useful Office 365 scripts

To download using powershell :

Connecting to Office 365 Instance
$client = new-object System.Net.WebClient
$client.DownloadFile(“https://raw.githubusercontent.com/leeburridge/ScriptCentral/master/365-Scripts/connect-365.ps1”,“connect-365.ps1”)

Check Exchange migration progress
$client = new-object System.Net.WebClient
$client.DownloadFile(“https://raw.githubusercontent.com/leeburridge/ScriptCentral/master/365-Scripts/migratecheck.ps1”,“migratecheck.ps1”)
