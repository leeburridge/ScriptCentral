## Uninstall Previous Version

MSIExec.exe /x {A0A04320-4DC9-46EA-8CE7-E35A10080D5A} /qn /norestart

## Install Umbrella 2.2

MSIExec.exe /i setup.msi /qn /L*v "C:\OSinst\BuildLogs\CiscoUmbrella.log" ORG_ID=[OrdID] ORG_FINGERPRINT=[Fingerprint] USER_ID=[UserID] HIDE_UI=1

Copy Skip_upgrades.flag C:\ProgramData\OpenDNS\ERC\
