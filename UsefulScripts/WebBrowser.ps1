######################################################
# WebBrowser.ps1
#
# Wayne Lindimore
# wlindimore@gmail.com
# AdminsCache.Wordpress.com
#
# 5-11-13
# Demos the WinForms WebBrowser Class
######################################################
Add-Type -AssemblyName System.Windows.Forms
$URL1 = "http://www.wikipedia.com"
$URL2 = "http://adminscache.wordpress.com"
$URL3 = "http://www.microsoft.com"

# WinForm Setup
$mainForm = New-Object System.Windows.Forms.Form
$mainForm.Font = “Comic Sans MS,9"
$mainForm.ForeColor = [System.Drawing.Color]::White
$mainForm.BackColor = [System.Drawing.Color]::DarkSlateBlue
$mainForm.Text = " System.Windows.Forms.WebBrowser Class"
$mainForm.Width = 960
$mainForm.Height = 700

# Main Browser
$webBrowser1 = New-Object System.Windows.Forms.WebBrowser
$webBrowser1.IsWebBrowserContextMenuEnabled = $true
$webBrowser1.URL = $URL1
$webBrowser1.Width = 600
$webBrowser1.Height = 600
$webBrowser1.Location = "50, 25"
$mainForm.Controls.Add($webBrowser1)

# First Selectable Browser
$webBrowser2 = New-Object System.Windows.Forms.WebBrowser
$webBrowser2.IsWebBrowserContextMenuEnabled = $false
$webBrowser2.URL = $URL1
$webBrowser2.Width = 200
$webBrowser2.Height = 150
$webBrowser2.Location = "700, 50"
$mainForm.Controls.Add($webBrowser2)

# Second Selectable Browser
$webBrowser3 = New-Object System.Windows.Forms.WebBrowser
$webBrowser3.IsWebBrowserContextMenuEnabled = $false
$webBrowser3.URL = $URL2
$webBrowser3.Width = 200
$webBrowser3.Height = 150
$webBrowser3.Location = "700, 250"
$mainForm.Controls.Add($webBrowser3)

# Third Selectable Browser
$webBrowser4 = New-Object System.Windows.Forms.WebBrowser
$webBrowser4.IsWebBrowserContextMenuEnabled = $false
$webBrowser4.URL = $URL3
$webBrowser4.Width = 200
$webBrowser4.Height = 150
$webBrowser4.Location = "700, 450"
$mainForm.Controls.Add($webBrowser4)

# Select Label
$selectLabel = New-Object System.Windows.Forms.Label
$selectLabel.Location = "700,20"
$selectLabel.Height = 22
$selectLabel.Width = 220
$selectLabel.Text = "Click Checkbox to Select WebSite"
$mainForm.Controls.Add($selectLabel)

# First Select Checkbox
$selectCheckbox1 = New-Object System.Windows.Forms.Checkbox
$selectCheckbox1.Location = "910,120"
$selectCheckbox1.Checked = $true
$selectCheckbox1.add_Click({ 
    $webBrowser1.URL = $URL1
    $selectCheckbox2.Checked = $false
    $selectCheckbox3.Checked = $false
    })
$mainForm.Controls.Add($selectCheckbox1)

# Second Select Checkbox
$selectCheckbox2 = New-Object System.Windows.Forms.Checkbox
$selectCheckbox2.Location = "910,320"
$selectCheckbox2.add_Click({
    $webBrowser1.URL = $URL2
    $selectCheckbox1.Checked = $false
    $selectCheckbox3.Checked = $false
    })
$mainForm.Controls.Add($selectCheckbox2)

# Third Select Checkbox
$selectCheckbox3 = New-Object System.Windows.Forms.Checkbox
$selectCheckbox3.Location = "910,520"
$selectCheckbox3.add_Click({
    $webBrowser1.URL = $URL3
    $selectCheckbox1.Checked = $false
    $selectCheckbox2.Checked = $false
    })
$mainForm.Controls.Add($selectCheckbox3)

# Display Form
[void] $mainForm.ShowDialog()
