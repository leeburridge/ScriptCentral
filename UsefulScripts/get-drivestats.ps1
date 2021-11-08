# gets all drives from the below listed servers and outputs to CSVs
# Lee Burridge / Lewis Sheppard 2021

$servers = 'server1', 'server2'


for ($servercount=1; $servercount -le $servers.count; servercount++){
    $s = New-PSSession -ComputerName $servers[$servercount]
    Enter-PSSession -Session $s

    $Drive = get-psdrive -psprovider FileSystem | select root

    $drivecount=$drive.count-1

    for ($i=0; $i -le $drivecount; $i++){
        $drive[$i]
        $targetfolder=$drive[$i].root
        $dataColl = @()
        $dataColl = @()
        gci -force $targetfolder -ErrorAction SilentlyContinue | ? { $_ -is [io.directoryinfo] } | % {
        $len = 0
        gci -recurse -force $_.fullname -ErrorAction SilentlyContinue | % { $len += $_.length }
        $foldername = $_.fullname
        $foldersize= '{0:N2}' -f ($len / 1Gb)
        $dataObject = New-Object PSObject
        Add-Member -inputObject $dataObject -memberType NoteProperty -name “foldername” -value $foldername
        Add-Member -inputObject $dataObject -memberType NoteProperty -name “foldersizeGb” -value $foldersize
        $dataColl += $dataObject
        }
        $dataColl | Out-GridView -Title “Size of subdirectories”

        $outfile = $s+"-Drive"+$i"+".csv"
        $datacoll | export-csv -path $outfile
  
    }
    Exit-PSSession $s
}
