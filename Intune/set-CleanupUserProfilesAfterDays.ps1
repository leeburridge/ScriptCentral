$maxProfileAgeInDays = 30


try{

    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows" -Name "System" -Force -ErrorAction SilentlyContinue | Out-Null 

    Write-Output "System key was created or already exists"

    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\System" -Name 'CleanupProfiles' -Value $maxProfileAgeInDays -Type 'Dword' -Force 

}catch{

    Throw "Failed to set registry key!"

}
