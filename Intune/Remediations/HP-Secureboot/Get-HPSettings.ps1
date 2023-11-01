Function Get_HP_BIOS_Settings
 { 
  $Script:Get_BIOS_Settings = Get-WmiObject -Namespace root/hp/instrumentedBIOS -Class hp_biosEnumeration -ErrorAction SilentlyContinue |  % { New-Object psobject -Property @{    
   Setting = $_."Name"
   Value = $_."currentvalue"
   Available_Values = $_."possiblevalues"
   }}  | select-object Setting, Value, possiblevalues
  $Get_BIOS_Settings
 } 