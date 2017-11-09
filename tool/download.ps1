<#
  (C)2017 Lee Burridge
  Filename : download.ps1
  Source : https://github.com/leeburridge/ScriptCentral/blob/master/tool/download.ps1
  Simple download script for PowerShell. Prompts user for source and destination location
#>
param (    
	[string]$src = $( Read-Host "Enter the URL" ),
	[string]$dest = $( Read-Host "Enter destination including filename")
 )



$client = new-object System.Net.WebClient
$client.DownloadFile($src, $dest)
