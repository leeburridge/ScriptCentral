Delete mailbox script. Change -Identity to whatever you want

To download using powershell :

$client = new-object System.Net.WebClient
$client.DownloadFile(“https://github.com/leeburridge/ScriptCentral/raw/master/del-mbox.ps1”,“”)
