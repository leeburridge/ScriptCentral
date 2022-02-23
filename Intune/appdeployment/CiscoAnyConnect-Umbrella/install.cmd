# Remove Umbrella client if it's there
wmic Product where name='Umbrella Roaming Client' call uninstall

# Check if the folder exists before copying the file if it doesn't then create it.
if not exist "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Umbrella\" mkdir "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Umbrella\"

Copy OrgInfo.json "C:\ProgramData\Cisco\Cisco AnyConnect Secure Mobility Client\Umbrella\"

## Install AnyConnect (without VPN)
msiexec /package anyconnect-win-4.10.02086-core-vpn-predeploy-k9.msi /norestart /passive PRE_DEPLOY_DISABLE_VPN=1 /q

## Install Umbrella module
msiexec /package anyconnect-win-4.10.02086-umbrella-predeploy-k9.msi /norestart /passive /q