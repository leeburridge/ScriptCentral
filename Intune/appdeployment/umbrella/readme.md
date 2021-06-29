Cisco Umbrella 2.2.480 Intune installation [Static]
Author : leeburridge76@gmail.com
Date : 29/6/2021

These files are the required files to succesfully uninstall an existing version of Cisco Umbrella and install version 2.2.480 along with a flag file in c:\programdata\OpenDNS\ERC\Skip_Upgrades.flag

Included is the umbrella.intunewin file that can be uploaded to Intune

Detection Rules should be set to :

Rule Type : File
Path : C:\ProgramData\OpenDNS\ERC\
File : Skip_upgrades.flag
Detection Method : File or folder exists
