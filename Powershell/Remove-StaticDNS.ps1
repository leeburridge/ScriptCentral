## Remove static DNS setting and set to DHCP
## CSV shold contain header as computername and contain the names of the devices you want to run this on

$computers = import-csv c:\computers.csv | select -exp computername

Foreach($COMPUTER in $computers){
TRY{
  $ErrorActionPreference = "Stop"
	$nics=Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $computer 
    Foreach($NIC in $NICs) { 
      netsh interface ip set dnsservers name="Ethernet" source=dhcp
    }
  Write-Host "Successfully set DHCP on $computer" -f green
}


Catch{
   Write-Host "$($computer) " -BackgroundColor red -NoNewline
   Write-Warning $Error[0] 
    }
    }
