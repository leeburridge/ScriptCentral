## Uninstall Previous Version
wmic Product where name='Umbrella Roaming Client' call uninstall

# Check if the folder exists before copying the file if it doesn't then create it.
if not exist C:\ProgramData\OpenDNS\ERC\ mkdir C:\ProgramData\OpenDNS\ERC\
Copy skip_upgrades.flag C:\ProgramData\OpenDNS\ERC\

## Install Umbrella 2.2
MSIExec.exe /i setup.msi /qn /L*v "C:\OSinst\BuildLogs\CiscoUmbrella.log" ORG_ID=[OrdID] ORG_FINGERPRINT=[Fingerprint] USER_ID=[UserID] HIDE_UI=1
