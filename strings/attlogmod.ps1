# Powershell script that replaces the last character of every line in a file

echo "Attlogmod v1.0 (C)2019 Lee Burridge"

$infile = Read-Host -Prompt "Enter the input filename"
$outfile = Read-Host -Prompt "Enter the output filename"
$newchar = Read-Host -Prompt "Enter transaction type (eg, 0 or 1)"

if (Test-Path -Path $outfile) {
	Remove-Item -Path $outfile
} else {
	
}

foreach($line in Get-Content .\$infile) {
	$s = $line
	$s = $s.substring(0,$s.length-1)
	$s = $s + $newchar	
	Add-Content $outfile $s
}




