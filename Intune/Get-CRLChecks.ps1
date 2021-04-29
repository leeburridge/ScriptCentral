﻿# Get-CRLChecks.ps1
# Script reads certs in an Azure blob and checks for validity. Not the most eloquant solutions but it works.

# If a cert is going to expire within the next 2 days it will email

write-host "Get-CRLChecks (C)2021 Lee Burridge"

$debugswitch = 1
$EmailTo = "lburridge@centrality.com"

Function Get-CRLTimeValidity {     
                                                                                                                                  
                                                                                                                                                       
    [CmdletBinding()]                                                                                                                                           
                                                                                                                                                                
    Param                                                                                                                                                       
    (                                                                                                                                                           
                                                                                                                                                                
        #CRL File or Raw Bytes - dont limit object                                                                                                              
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position = 0)]                                                                                       
        [Alias('File','ByteArray','RawData')]                                                                                                                   
        $CRL                                                                                                                                                    
                                                                                                                                                                
    )                                                                                                                                                           
    process{                 
		if ($debugswitch -eq 2 ) {
			write-host "Checking $CRL"								
		}			
        #Import the CRL file or byte array                                                                                                                      
        if (-not ($CRLBytes = Get-content $CRL -Encoding byte -ErrorAction SilentlyContinue)){                                                                  
            write-verbose "CRL file not found...assuming CRL raw bytes."                                                                                        
            try {                                                                                                                                               
                [byte[]]$CRLBytes = $CRL                                                                                                                        
            }                                                                                                                                                   
            catch{                                                                                                                                              
                Write-Warning ("Invalid CRL format.  Expecting valid .crl file or byte array: {0}" -f $_.exception.message)                                     
                break                                                                                                                                           
            }                                                                                                                                                   
        }                                                                                                                                                       
                                                                                                                                                                
        #set match strings                                                                                                                                      
        $OIDCommonName = " 06 03 55 04 03 "                                                                                                                     
        $UTCTime = " 17 0D "                                                                                                                                    
                                                                                                                                                                
        #convert crl bytes to hex string                                                                                                                        
        $CRLHexString = ($CRLBytes | % {"{0:X2}" -f $_}) -join " "                                                                                              
                                                                                                                                                                
        #get the relevent bytes using the match strings                                                                                                         
        $CNNameBytes = ($CRLHexString -split $OIDCommonName )[1] -split " " | % {[Convert]::ToByte("$_",16)}                                                    
        $ThisUpdateBytes = ($CRLHexString -split $UTCTime )[1] -split " "  | % {[Convert]::ToByte("$_",16)}                                                     
        $NextUpdateBytes = (($CRLHexString -split $UTCTime )[2] -split " ")[0..12] | % {[Convert]::ToByte("$_",16)}                                             
                                                                                                                                                                
        #convert data to readable values                                                                                                                        
        $CAName = ($CNNameBytes[2..($CNNameBytes[1]+ 1)] | % {[char]$_}) -join ""                                                                               
        $ThisUpdate = [Management.ManagementDateTimeConverter]::ToDateTime(("20" + $(($ThisUpdateBytes | %{[char]$_}) -join ""  -replace "z")) + ".000000+000") 
        $NextUpdate = [Management.ManagementDateTimeConverter]::ToDateTime(("20" + $(($NextUpdateBytes | %{[char]$_}) -join ""  -replace "z")) + ".000000+000") 
       
        $dateParts = $NextUpdate -split “/”
        $dateParts2 = $dateParts[2] -split " "

        # Expiry date for current cert
        $deDate = “$($dateparts[1])/$($dateParts[0])/$($dateParts2[0])”

        # Add two days to 'today'        
        $ts = New-TimeSpan -Days 2
        $todaydate = (get-date) + $ts

        $todaydate = get-date -format "dd/MM/yyyy"

       # $todaydate = $todaydate -format "dd/MM/yyyy"

        $diff = new-timespan -start $todaydate -end $dedate

        $dfdays = $diff.Days
		#write-host $dfdays
                	                                                                                                                                                     
        $isvalid = ($nextUpdate -gt (get-date)) 
		
        if ($dfdays -lt 2) {
			$global:CAN = $CAName + "`r`n"
			$global:CAN2 = "Expires in (days) : " + $dfdays	+ "`r`n"
			$global:CAN3 = "Next Update : " + $NextUpdate + "`r`n"
	                                                                                                                                               
			[pscustomobject]@{                                                                                                                                      
				CAName = $CAName                                                                                                                                   
				ThisUpdate = $ThisUpdate                                                                                                                            
				NextUpdate = $NextUpdate                                                                                                                            
				isValid = $isvalid    
				DaysUntilExpiry = $dfdays                                                                                                                              
			}    
        }                                                                                                                                                   
    }                                                                                                                                                           
}                                  


Function Get-CRLFile {

    param (
        $url,$dest
    )

    # Source file location
    $source = $url
    # Destination to save the file
    $destination = $dest
    #Download the file
   Invoke-WebRequest -Uri $source -OutFile $destination
    
}

Get-CRLFile 'https://cpdpublicresources.blob.core.windows.net/121f63f0-df30-4117-b5c0-e5bdec17da2a/pki/COKETHORPE-ROOT+.crl' COKETHORPE+.crl
Get-CRLFile 'https://cpdpublicresources.blob.core.windows.net/121f63f0-df30-4117-b5c0-e5bdec17da2a/pki/COKETHORPE-ROOT.crl' COKETHORPE.crl
Get-CRLFile 'https://cpdpublicresources.blob.core.windows.net/165c1e90-512a-4196-bbd1-94cc6c6a4f52/pki/WSH Certificate Authority+.crl' WSH+.crl
Get-CRLFile 'https://cpdpublicresources.blob.core.windows.net/165c1e90-512a-4196-bbd1-94cc6c6a4f52/pki/WSH Certificate Authority.crl' WSH.crl
Get-CRLFile 'https://cpdpublicresources.blob.core.windows.net/3bb43502-95da-4a42-81e2-e6d902013624/pki/Welcome Break Certificate Authority+.crl' WB+.crl
Get-CRLFile 'https://cpdpublicresources.blob.core.windows.net/3bb43502-95da-4a42-81e2-e6d902013624/pki/Welcome Break Certificate Authority.crl' WB.crl
Get-CRLFile 'https://cpdpublicresources.blob.core.windows.net/af2909d1-51ab-425d-ac7f-bf6da47b3a59/pki/Marston CA+.crl' Marston+.crl
Get-CRLFile 'https://cpdpublicresources.blob.core.windows.net/af2909d1-51ab-425d-ac7f-bf6da47b3a59/pki/Marston CA.crl' Marston.crl
Get-CRLFile 'https://cpdpublicresources.blob.core.windows.net/e3689cab-dae4-4651-979f-48fee919607a/pki/Bordeaux Index Certificate Authority+.crl' bi+.crl
Get-CRLFile 'https://cpdpublicresources.blob.core.windows.net/e3689cab-dae4-4651-979f-48fee919607a/pki/Bordeaux Index Certificate Authority.crl' bi.crl

function get-allcrls {

Write-output $spacer | Out-File c:\cert\out2.txt

Get-CRLTimeValidity COKETHORPE+.crl
if ($global:CAN.length -ne 0) {
	write-host "Cokethorpe+..expiry detected"
	Write-output $global:CAN | Out-File c:\cert\out2.txt -append
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $spacer | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
} else {
	write-host "COKETHORPE+..OK"
}
$global:CAN=""
$global:CAN2=""
$global:CAN3=""

Get-CRLTimeValidity COKETHORPE.crl
if ($global:CAN.length -ne 0) {
	write-host "Cokethorpe..expiry detected"
	Write-output $global:CAN | Out-File c:\cert\out2.txt -append
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $spacer | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
} else {
	write-host "COKETHORPE..OK"
}
$global:CAN=""
$global:CAN2=""
$global:CAN3=""

Get-CRLTimeValidity WSH+.crl 
if ($global:CAN.length -ne 0) {
	write-host "WSH+..expiry detected"
	Write-output $global:CAN | Out-File c:\cert\out2.txt -append
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $spacer | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
} else {
	write-host "WSH+..OK"
}
$global:CAN=""
$global:CAN2=""
$global:CAN3=""

Get-CRLTimeValidity WSH.crl 
if ($global:CAN.length -ne 0) {
	Write-host "WSH..expiry detected"
	Write-output $global:CAN | Out-File c:\cert\out2.txt -append
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $spacer | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
} else {
	write-host "WSH..OK"
}
$global:CAN=""
$global:CAN2=""
$global:CAN3=""

Get-CRLTimeValidity WB+.crl 
if ($global:CAN.length -ne 0) {
	write-host "WB+..expiry detected"
	Write-output $global:CAN | Out-File c:\cert\out2.txt -append
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $spacer | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
} else {
	write-host "WB+..OK"
}
$global:CAN=""
$global:CAN2=""
$global:CAN3=""

Get-CRLTimeValidity WB.crl 
if ($global:CAN.length -ne 0) {
	write-host "WB..expiry detected"
	Write-output $global:CAN | Out-File c:\cert\out2.txt -append
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $spacer | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
} else {
	write-host "WB..OK"
}
$global:CAN=""
$global:CAN2=""
$global:CAN3=""

Get-CRLTimeValidity Marston+.crl 
if ($global:CAN.length -ne 0) {
	write-host "MARSTON+..expiry detected"
	Write-output $global:CAN | Out-File c:\cert\out2.txt -append
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $spacer | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
} else {
	write-host "MARSTON+..OK"
}
$global:CAN=""
$global:CAN2=""
$global:CAN3=""

Get-CRLTimeValidity Marston.crl 
if ($global:CAN.length -ne 0) {
	write-host "MARSTON..expiry detected"
	Write-output $global:CAN | Out-File c:\cert\out2.txt -append
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $spacer | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
} else {
	write-host "MARSTON..OK"
}
$global:CAN=""
$global:CAN2=""
$global:CAN3=""

Get-CRLTimeValidity BI+.crl 
if ($global:CAN.length -ne 0) {
	write-Host "BI+..expiry detected"
	Write-output $global:CAN | Out-File c:\cert\out2.txt -append
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $spacer | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
} else {
	write-host "BI+..OK"
}
$global:CAN=""
$global:CAN2=""
$global:CAN3=""

Get-CRLTimeValidity BI.crl 
if ($global:CAN.length -ne 0) {
	write-host "BI..expiry detected"
	Write-output $global:CAN | Out-File c:\cert\out2.txt -append
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
	write-output $spacer | Out-File c:\cert\out2.txt -append 
	Write-output "<br />" | Out-File c:\cert\out2.txt -append
} else {
	write-host "BI..OK"
}
$global:CAN=""
$global:CAN2=""
$global:CAN3=""
}

get-allcrls > out.txt

#$output = get-allcrls

$currentTime = Get-Date -format "dd MMM yyyy"

$crls = get-content out2.txt


$User = "monitor@digitalsaviour.co.uk"
$File = "C:\cert\emailpass.txt"
$cred=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)

$EmailFrom = "monitor@digitalsaviour.co.uk"
$Subject = "CRL Check " + $currentTime 
if ($crls.length -ne 0) {
$Body = $crls
} else {
$Body = "No certificates due to expire"
}
$SMTPServer = "mail.digitalsaviour.co.uk" 
#$filenameAndPath = "C:\cert\out.txt"
$SMTPMessage = New-Object System.Net.Mail.MailMessage($EmailFrom,$EmailTo,$Subject,$Body)
$SMTPMessage.IsBodyHtml = $true
#$attachment = New-Object System.Net.Mail.Attachment($filenameAndPath)
#$SMTPMessage.Attachments.Add($attachment)
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($cred.UserName, $cred.Password); 
$SMTPClient.Send($SMTPMessage)

if ($debugswitch = 2) {
	Write-Host "Completed and sent email to $EmailTo"
	$SMTPMessage > email.txt
}

