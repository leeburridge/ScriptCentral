# Very messy bit of quick code that reports on CRL filest that have
# an expiry happening in the next 2 days

# (C) 2021 Lee Burridge


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

        $diff = new-timespan -start $todaydate -end $dedate

        $dfdays = $diff.Days
                                                                                                                                                                     
        $isvalid = ($nextUpdate -gt (get-date))                                                                                                                 
        if ($dfdays[0] -lt 3) {
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

Get-CRLFile 'link to crl in azure blob' file1.crl

function get-allcrls {

Write-output $spacer | Out-File c:\cert\out2.txt

Get-CRLTimeValidity file1.crl
Write-output $CAN | Out-File c:\cert\out2.txt -append
Write-output "<br />" | Out-File c:\cert\out2.txt -append
write-output $CAN2 | Out-File c:\cert\out2.txt -append 
Write-output "<br />" | Out-File c:\cert\out2.txt -append
write-output $CAN3 | Out-File c:\cert\out2.txt -append 
Write-output "<br />" | Out-File c:\cert\out2.txt -append
write-output $spacer | Out-File c:\cert\out2.txt -append 
Write-output "<br />" | Out-File c:\cert\out2.txt -append
$CAN=""
$CAN2=""
$CAN3=""

}

get-allcrls > out.txt
# get-date >> out.txt
# $out > out.txt
$output = get-allcrls

$currentTime = Get-Date -format "dd MMM yyyy"

$crls = get-content out2.txt

# SMTP Server login details
$User = "monitor@digitalsaviour.co.uk"
$File = "C:\cert\emailpass.txt"

$cred=New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $User, (Get-Content $File | ConvertTo-SecureString)

# populate with email address that will receive the report 
$EmailTo = ""

# email address of sender of report
$EmailFrom = ""
$Subject = "CRL Check " + $currentTime 
$Body = $crls

# SMTP server details
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


