# Filename : Fix-WinREv3.ps1
# Author : Lee Burridge
# Contributions : Andrew Taylor
# Code date : 17/02/2023

# This script will delete any existing recovery partition and recovery files from the OS drive and rebuild from scratch downloading
# what it needs to from the internet.

# If you want to use this script you will need to get your own recovery files are host them somewhere then update the URLS in this script.

Start-Transcript -Path C:\OSInst\BuildLogs\RemediateWinRE.log

	write-host "Rebuilding WinRE"

	# Remove recovery files from the boot drive
	cd C:\Windows\System32\Recovery
	attrib -r -a -s -h *.*
	del *.*
	
	#Find the OS Partition
	$osdisk = get-partition | where-object Type -eq "Basic"
	
	#Record the partition number
	$ospartition = $osdisk.PartitionNumber
	
	#Find the current size
	$size = (get-partition -disknumber 0 -partitionnumber $ospartition).Size
	
	#Shrink by 200Mb
	$size2 = $size - 209715200
    
	#Shrink OS partition by 200Mb
	resize-partition -DiskNumber 0 -PartitionNumber $ospartition -Size $size2
    
	#Find recovery partition
	$recoverydisk = get-partition | where-object Type -eq "Recovery"
    
	#Record the partition number
	$recoverypartition = $recoverydisk.PartitionNumber
    
	#Delete the recovery partition
	Remove-Partition -disknumber 0 -partitionnumber $recoverypartition -confirm:$false
    
	#Create the Diskpart commands (powershell can't create a recovery partition)
	$diskpath = "C:\OSInst\BuildLogs\diskpart.txt"
    
	if (-not(Test-Path -Path $diskpath -PathType Leaf)) {
		new-item -Path C:\OSInst\BuildLogs\diskpart.txt
 	} else {
		remove-item -Path $diskpath -Force
		new-item -Path C:\OSInst\BuildLogs\diskpart.txt
	}
    
    #Don't change indentation here!
    $str = @'
select disk 0
create partition primary
format quick fs=ntfs label="Recovery"
assign letter="X"
set id="de94bba4-06d1-4d40-a16a-bfd50179d6ac"
gpt attributes=0x8000000000000001
'@
    
	#Write the Diskpart commands to the file
	$str | add-content C:\OSInst\buildlogs\diskpart.txt
    
	#Run the Diskpart commands
	diskpart /s C:\OSInst\buildlogs\diskpart.txt
    
	#Create Directories on new partition
	new-item -path x: -Name 'Recovery' -type directory -Force
	new-item -path x:\Recovery -Name 'WindowsRE' -type directory -Force
    
	#Copy the required files from the local disk
	$url1 = "https://USEYOUROWN.blob.core.windows.net/bitlocker/boot.sdi"
	Invoke-WebRequest -Uri $url1 -OutFile "x:\Recovery\WindowsRE\boot.sdi" -Method Get

	$url3 = "https://USEYOUROWN.blob.core.windows.net/bitlocker/Winre.wim"
	Invoke-WebRequest -Uri $url3 -OutFile "x:\Recovery\WindowsRE\Winre.wim" -Method Get    

	$url2 = "https://USEYOUROWN.blob.core.windows.net/bitlocker/ReAgent.xml"
	Invoke-WebRequest -Uri $url2 -OutFile "x:\Recovery\WindowsRE\ReAgent.xml" -Method Get

	#Copy to c:\windows\system32\recovery as well
	if (-not(Test-Path -Path "C:\windows\system32\recovery\ReAgent.xml" -PathType Leaf)) {
        	$url2 = "https://USEYOUROWN.blob.core.windows.net/bitlocker/ReAgent.xml"
        	Invoke-WebRequest -Uri $url2 -OutFile "C:\Windows\System32\Recovery\ReAgent.xml" -Method Get
    	} else {
		remove-item -Path "C:\Windows\System32\Recovery\ReAgent.xml" -Force
		$url2 = "https://USEYOUROWN.blob.core.windows.net/bitlocker/ReAgent.xml"
		Invoke-WebRequest -Uri $url2 -OutFile "C:\Windows\System32\Recovery\ReAgent.xml" -Method Get
	}
	
	if (-not(Test-Path -Path "C:\windows\system32\recovery\boot.sdi" -PathType Leaf)) {
		copy-item "x:\Recovery\WindowsRE\boot.sdi" -Destination "C:\Windows\System32\Recovery" -Force
	} else {
		remove-item -Path "C:\Windows\System32\Recovery\boot.sdi" -Force
		copy-item "x:\Recovery\WindowsRE\boot.sdi" -Destination "C:\Windows\System32\Recovery" -Force
    	}

	if (-not(Test-Path -Path "C:\windows\system32\recovery\winre.wim" -PathType Leaf)) {
		copy-item "x:\Recovery\WindowsRE\winre.wim" -Destination "C:\Windows\System32\Recovery" -Force
	} else {
		remove-item -Path "C:\Windows\System32\Recovery\winre.wim" -Force
		copy-item "x:\Recovery\WindowsRE\winre.wim" -Destination "C:\Windows\System32\Recovery" -Force
	}

	# Set the recovery target
	reagentc /setreimage /path X:\Recovery\windowsre

	# Enable WinRE
	reagentc /enable

    write-host "WinRE rebuild complete"

Stop-Transcript
