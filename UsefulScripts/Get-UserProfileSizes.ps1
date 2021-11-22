$profiles = Get-ChildItem C:\Users | ?{Test-path C:\Users\$_\NTUSER.DAT} | Select -ExpandProperty Name
  foreach($profile in $profiles)
    {
    $largeprofile = Get-ChildItem C:\Users\$profile -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Sum length | Select -ExpandProperty Sum
    # $largeprofile = [math]::Round(($largeprofile/1MB),2) + "MB"
    if($largeprofile -lt 20){Continue}
    $object = New-Object -TypeName PSObject
    $object | Add-Member -MemberType NoteProperty -Name Name -Value $profile
    $object | Add-Member -MemberType NoteProperty -Name "Size(MB)" -Value $largeprofile
    ($object | fl | Out-String).Trim();Write-Output "`n"
    }
