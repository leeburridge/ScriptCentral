try {
    $proc = [System.Diagnostics.Process]::Start([System.Diagnostics.ProcessStartInfo]@{
        FileName               = "C:\ProgramData\Citrix\Citrix Receiver\TrolleyExpress.exe"
        Arguments              = '/uninstall /cleanup'
        CreateNoWindow         = $true
        UseShellExecute        = $false
        RedirectStandardOutput = $true
    })
    $output = $proc.StandardOutput
    $output.ReadToEnd()
} finally {
    if ($null -ne $proc) {
        $proc.Dispose()
    }
    if ($null -ne $output) {
        $output.Dispose()
    }
}