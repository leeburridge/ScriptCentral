# Reddit: u/NeitherSound_
# 09.11.2021
# Set-DomainNetworkProfile

# Change private domain network location type from Public to Domain

$key = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles"
$domain = @("MyDomain.com", "SisterCompanyDomain.com")     # Set array with each trusted domain name. ( Examples: $domain = @("MyDomain.com", "SisterCompanyDomain.com") or $domain = "MyDomain.com" )
$name = "Category"
[int]$categoryValue = 2     # 0 = Public, 1 = Private, 2 = Domain
$remediate = "False"    # Detect? Set value to false .... Remediate? Set value to true

# Get the registry value where network location matches the private domain name and has a value other than 2 = Domain
$getNetworkProfile = Get-ItemProperty -Path $key\* -ErrorAction Stop | Where-Object { $domain -match $_.ProfileName -and $_.Category -ne $categoryValue }

# If $getNetworkProfile contains a value, proceed with making the change if allowed. 
if ($getNetworkProfile) {

    # If $remediate -eq $true, proceed with making the change.
    if ($remediate -eq 'True') {
        try {
            # Loops through each match then exit with success
            foreach ($profile in $getNetworkProfile) {

                Set-ItemProperty -Path $profile.PSPath -Name $name -Value $categoryValue -PassThru | Out-Null
            }

            Write-Host "SUCCESS" -ForegroundColor Green

            Exit 0
        }
        catch {
            # Capture error message and force a failure exit
            $errMsg = $_.Exception.Message

            Write-Host "FAILED: $($errMsg)" -ForegroundColor Red

            Exit 1
        }
    }
    else {
        # $remediate -eq $false ... Detected a profile that needs to be remediated. Exit 1 to inform IME to proceed with remediation script.
        Write-Host "Detected one or more network profile(s) that needs to be remediated" -ForegroundColor Yellow

        Exit 1
    }
}
else {
    # No profile exist with predefined value(s) in $domain as yet, exit 0 until next iterration. 
    Write-Host "INFO: No matching network profiles found (yet)" -ForegroundColor Yellow

    Exit 0
}
