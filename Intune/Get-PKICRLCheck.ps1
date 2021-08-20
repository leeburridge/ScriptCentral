# Get-CRLChecks.ps1 (C)2021 Lee Burridge
# Script reads certs in an Azure blob and checks for validity. Not the most eloquant solutions but it works.

# Instructions
# Replace $EmailTo with your email address
# Change $global:expdays to how many days the threshold is for reporting a CRL is going to expire
# Debug switch is only used for interactive running (Possible values are 0,1,2)

$debugswitch = 1

$global:expdays = 2

write-host "Get-CRLChecks v1.2 (C)2021 Lee Burridge"
write-host "Days to check for expiry of certs :" $global:expdays

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
		# Clear down the global variables
		$global:CAN=""
		$global:CAN2=""
		$global:CAN3=""       

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
       
        $dateParts = $NextUpdate -split �/�
        $dateParts2 = $dateParts[2] -split " "

        # Expiry date for current cert
        $deDate = �$($dateparts[1])/$($dateParts[0])/$($dateParts2[0])�

        # Add two days to 'today'        
        $ts = New-TimeSpan -Days 2
        $todaydate = (get-date) + $ts

        $todaydate = get-date -format "dd/MM/yyyy"

       # $todaydate = $todaydate -format "dd/MM/yyyy"

        $diff = new-timespan -start $todaydate -end $dedate

        $dfdays = $diff.Days
		#write-host $dfdays
                	                                                                                                                                                     
        $isvalid = ($nextUpdate -gt (get-date)) 
		
        if ($dfdays -lt $global:expdays) {
			$global:CAN = $CAName + " - " + $CRL + "`r`n"
			$global:CAN2 = "Expires in (days) : " + $dfdays	+ "`r`n"
			$global:CAN3 = "Next Update : " + $NextUpdate + "`r`n"
	                                                                                                                                               
			[pscustomobject]@{                                                                                                                                      
				CAName = $CAName                                                                                                                                   
				ThisUpdate = $ThisUpdate                                                                                                                            
				NextUpdate = $NextUpdate                                                                                                                            
				isValid = $isvalid    
				DaysUntilExpiry = $dfdays                                                                                                                              
			}    
		} else {
			$global:dbg = $CAName + " - " + $CRL
			$global:dbg2 = "Expires in (days) : " + $dfdays	+ ""
			$global:dbg3 = "Next Update : " + $NextUpdate + "`r`n"
	                                                                                                                                               
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

function checkcert {

	param (
		$id, $global
	)
	
	$cr = $id + "+.crl"
	Get-CRLTimeValidity $cr
	if ($global:CAN.length -ne 0) {
		write-host "$id+..expiry detected"
		Write-output $global:CAN | Out-File c:\cert\out2.txt -append
		Write-output "<br />" | Out-File c:\cert\out2.txt -append
		write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
		Write-output "<br />" | Out-File c:\cert\out2.txt -append
		write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
		Write-output "<br />" | Out-File c:\cert\out2.txt -append
		write-output $spacer | Out-File c:\cert\out2.txt -append 
	} else {
		write-host "$id+..OK"
		Write-output $global:dbg | Out-File c:\cert\debug.txt -append
		write-output $global:dbg2 | Out-File c:\cert\debug.txt -append
		write-output $global:dbg3 | Out-File c:\cert\debug.txt -append
		write-output $spacer | Out-File c:\cert\debug.txt -append 
	}

	$cr = $id + ".crl"
	Get-CRLTimeValidity $cr
	if ($global:CAN.length -ne 0) {
		write-host "$id..expiry detected"
		Write-output $global:CAN | Out-File c:\cert\out2.txt -append
		Write-output "<br />" | Out-File c:\cert\out2.txt -append
		write-output $global:CAN2 | Out-File c:\cert\out2.txt -append 
		Write-output "<br />" | Out-File c:\cert\out2.txt -append
		write-output $global:CAN3 | Out-File c:\cert\out2.txt -append 
		Write-output "<br />" | Out-File c:\cert\out2.txt -append
		write-output $spacer | Out-File c:\cert\out2.txt -append 
	} else {
		write-host "$id..OK"
		Write-output $global:dbg | Out-File c:\cert\debug.txt -append
		write-output $global:dbg2 | Out-File c:\cert\debug.txt -append
		write-output $global:dbg3 | Out-File c:\cert\debug.txt -append
		write-output $spacer | Out-File c:\cert\debug.txt -append 


	}
}

function get-allcrls {
	Write-output $spacer | Out-File c:\cert\out2.txt


# Download all of the CRL files from wherever (In this case the Azure storage blob) and store them locally to be processed
# More can be added from other locations as necessary
Get-CRLFile '##location##' pkicrl.crl

get-allcrls > out.txt

$currentTime = Get-Date -format "dd MMM yyyy"

$crls = get-content out2.txt

$User = "##MAIL SERVER USERNAME##"
$File = "C:\cert\emailpass.txt"  ## This is a file containing coded password Check https://stackoverflow.com/questions/43213462/sending-email-via-powershell-using-secure-password for details on how this works
$cred=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)

$sendto = ""

$EmailFrom = "##FROM EMAIL ADDRESS##"
write-host "Sending from : "$EmailFrom

	$SMTPServer = "###SMTP SERVER###" 

if ($crls.length -ne 0) {
$EmailTo = "##TO EMAIL ADDRESS##"
	$Body = $crls
	
	$Subject = "CRL Check ERROR " + $currentTime 
	

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
		Write-Host "Completed and sent email to $EmailFrom"
		$SMTPMessage > email.txt
	}
} else {
$EmailTo = "##EMAIL NOTIFICATION ADDRESS##"
	$Body = "All PKI certificates OK"
	$Subject = "CRL Check OK " + $currentTime 

 
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
		Write-Host "Completed and sent email to $EmailFrom"
		$SMTPMessage > email.txt
		}
	Write-Host "No expiring certs detected"
}


