** NB. You may need to run PS as Administrator for this to work **


<B>Useful Office 365 scripts</B>

To download using powershell :

<B>Connecting to Office 365 Instance</B><br>
<p>$client = new-object System.Net.WebClient<br>
$client.DownloadFile(“https://raw.githubusercontent.com/leeburridge/ScriptCentral/master/365-Scripts/connect-365.ps1”,“connect-365.ps1”)<br>
.\connect-365.ps1
</p>

<B>Check Exchange migration progress</B><br>
<p>$client = new-object System.Net.WebClient<br>
$client.DownloadFile(“https://raw.githubusercontent.com/leeburridge/ScriptCentral/master/365-Scripts/migratecheck.ps1”,“migratecheck.ps1”)<br>
.\migratecheck.ps1
</p>

<b>sharedmailboxsettings.ps1</b> - This script will set ALL shared mailboxes in O365 to all send on behalf and use the shared mailboxes sent items correctly.
