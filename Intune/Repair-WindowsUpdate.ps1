$LogPath = 'C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\Repair-WindowsUpdate.log'

function Log-Message {
    param([string]$Message)
    $LogTime = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $LogLine = "[ $LogTime ] $Message"
    Write-Host $LogLine
    $LogLine | Out-File -Append -FilePath $LogPath
}

try {
    # Check if 'C:\Windows\SoftwareDistribution.old' folder exists and delete it if present
    $OldSoftwareDistributionPath = 'C:\Windows\SoftwareDistribution.old'
    if (Test-Path -Path $OldSoftwareDistributionPath -PathType Container) {
        Log-Message "Deleting existing $OldSoftwareDistributionPath folder..."
        Remove-Item -Path $OldSoftwareDistributionPath -Recurse -Force
    }

    # Stop BITS and Windows Update services
    Log-Message "Stopping BITS and Windows Update services..."
    Stop-Service -Name BITS, wuauserv

    # Rename the SoftwareDistribution Folder to .old (the folder will be recreated when the services are restarted)
    $SoftwareDistributionPath = 'C:\Windows\SoftwareDistribution'
    $NewSoftwareDistributionPath = "$SoftwareDistributionPath.old"
    Log-Message "Renaming $SoftwareDistributionPath folder to $NewSoftwareDistributionPath..."
    Rename-Item -Path $SoftwareDistributionPath -NewName $NewSoftwareDistributionPath -ErrorAction SilentlyContinue

    # Start BITS and Windows Update services
    Log-Message "Starting BITS and Windows Update services..."
    Start-Service -Name BITS, wuauserv

    Log-Message "Windows Update repair completed successfully."
}
catch {
    $ErrorMessage = $_.Exception.Message
    Log-Message "An error occurred during the Windows Update repair: $ErrorMessage"
}