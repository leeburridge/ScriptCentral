$number = "{E742C998-1658-4A7A-A085-50ED8595CF3F}"

$remotedesktop = Get-WmiObject Win32_Product -ComputerName $ComputerName | Where-Object {$_.IdentifyingNumber -eq $number}
if ($adobe) {
  $remotedesktop.Uninstall()
}
else {
  $number + ' is not installed.'
}
