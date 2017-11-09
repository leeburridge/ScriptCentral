<#
  (C)2017 Lee Burridge
  Filename : file-download.ps1
  Source : https://github.com/leeburridge/ScriptCentral/blob/master/download-tool/download.ps1
  Simple download script for PowerShell. Prompts user for source and destination location
#>
Add-Type -AssemblyName PresentationFramework
Function Download_Click()
{
	$client = new-object System.Net.WebClient
	$client.DownloadFile($txtSRC.text, $txtDST.text)

	$msgbox = [System.Windows.MessageBox]::Show('Download Complete')	
}

Function Exit_Click()
{
	#[System.Windows.Forms.Application]::Exit(1)
}

Function Generate-Form {
	Add-Type -AssemblyName System.Windows.Forms

	$Form = New-Object system.Windows.Forms.Form
	$Form.Text = "File-Download v1.0 (C)2017 Lee Burridge"
	$Form.TopMost = $true
	$Form.Width = 498
	$Form.Height = 196

	$txtSRC = New-Object system.windows.Forms.TextBox
	$txtSRC.Width = 199
	$txtSRC.Height = 20
	$txtSRC.location = new-object system.drawing.point(238,13)
	$txtSRC.Font = "Microsoft Sans Serif,10"
	$Form.controls.Add($txtSRC)

	$lblSource = New-Object system.windows.Forms.Label
	$lblSource.Text = "Source URL"
	$lblSource.AutoSize = $true
	$lblSource.Width = 25
	$lblSource.Height = 10
	$lblSource.location = new-object system.drawing.point(21,14)
	$lblSource.Font = "Microsoft Sans Serif,10"
	$Form.controls.Add($lblSource)

	$label4 = New-Object system.windows.Forms.Label
	$label4.Text = "Destination (Inlcuding Filename)"
	$label4.AutoSize = $true
	$label4.Width = 25
	$label4.Height = 10
	$label4.location = new-object system.drawing.point(21,38)
	$label4.Font = "Microsoft Sans Serif,10"
	$Form.controls.Add($label4)

	$txtDST = New-Object system.windows.Forms.TextBox
	$txtDST.Width = 198
	$txtDST.Height = 20
	$txtDST.location = new-object system.drawing.point(238,38)
	$txtDST.Font = "Microsoft Sans Serif,10"
	$Form.controls.Add($txtDST)

	$btnDownload = New-Object system.windows.Forms.Button
	$btnDownload.Text = "Download"
	$btnDownload.Width = 140
	$btnDownload.Height = 31
	$btnDownload.location = new-object system.drawing.point(86,65)
	$btnDownload.Font = "Microsoft Sans Serif,10,style=Bold"
	$Form.controls.Add($btnDownload)

	$btnEXIT = New-Object system.windows.Forms.Button
	$btnEXIT.Text = "Exit"
	$btnEXIT.Width = 140
	$btnEXIT.Height = 30
	$btnEXIT.location = new-object system.drawing.point(255,64)
	$btnEXIT.Font = "Microsoft Sans Serif,10"
	$Form.controls.Add($btnEXIT)

	$label8 = New-Object system.windows.Forms.Label
	$label8.Text = "This software is free to use. Latest version can be downloaded from my GitHub"
	$label8.AutoSize = $true
	$label8.Width = 25
	$label8.Height = 10
	$label8.location = new-object system.drawing.point(8,102)
	$label8.Font = "Microsoft Sans Serif,10"
	$Form.controls.Add($label8)

	$button9 = New-Object system.windows.Forms.Button
	$button9.Text = "Visit my GitHub"
	$button9.Width = 277
	$button9.Height = 24
	$button9.location = new-object system.drawing.point(107,125)
	$button9.Font = "Microsoft Sans Serif,10"
	$Form.controls.Add($button9)
	
	# Add button events
	$btnDownload.Add_Click({Download_Click})
	$btnEXIT.Add_Click({Exit_Click})

	$Form.ShowDialog()| Out-Null
	#$Form.Dispose()
} # End Function

Generate-Form
