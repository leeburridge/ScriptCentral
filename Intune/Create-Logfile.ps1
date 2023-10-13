# Title : Create-Logfile.ps1

# Creation Date : 13/10/2023
# Author : Lee Burridge
# Description : Simple template script to demonstrate logging to a "known" location
# For devices enrolled in Endpoint Manager these logs can be remotely
# downloaded from a device using the Collect Diagnostics feature in MEM
# The log files can be found in file 71 within the log files collected "(71) FoldersFiles temp_MDMDiagnostics_mdmlogs-"

# Using transcript to log to IME folder for the overall script. By starting a transcript any output that would
# normally be sent to the screen will be logged which is super useful when blind running scripts through MEM.
Start-Transcript -Path C:\ProgramData\Microsoft\IntuneManagementExtension\Logs\exampletranscript.log

# Create a log file in the "IME Log" folder that can be used to store other logging information
try {
    $folderPath = "C:\ProgramData\Microsoft\IntuneManagementExtension\Logs"
    $filePath = Join-Path -Path $folderPath -ChildPath "example.log"
    "Log entry" | Out-File -FilePath $filePath -Append
    write-output "File Created"
}

catch {
    write-output "Something failed"
}

Stop-Transcript
