# ScriptCentral
Useful batch files and shell scripts

ipscan.bat
This was written for scanning subnets for live hosts from a command prompt for situations where you do not have access to a GUI and therefore unable to run a conventional IP scanner.

SYNTAX : ipscan.bat subnet filename
The subnet switch is used but the last octet is dropped so that the entire subnet can be interrogated. The results are output to whatever is specified in the filename variable. Takes a couple of minutes as it sends a single ICMP packet to each host in the range and Windows is a bit slow at doing this. Once it's completed you will be notified.

migratecheck.ps1
Loops until all mailboxes have been migrated. Used in hybrid exchange to Office 365 migration
