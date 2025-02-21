Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Setup Default Log Directory
$logDirectory = "C:\Logs"
$logFilePath = "$logDirectory\eventlog.txt"
$excelFilePath = "$logDirectory\eventlog.xlsx"

if (-not (Test-Path $logDirectory)) {
    New-Item -Path $logDirectory -ItemType Directory
}

# Function to Select Folder
function Select-Folder {
    $folderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $folderBrowser.SelectedPath = "C:\Logs"  # Set default folder to C:\Logs
    if ($folderBrowser.ShowDialog() -eq [System.Windows.Forms.DialogResult]::OK) {
        return $folderBrowser.SelectedPath
    }
    return $null
}

# Create Function to Collect Logs
function Collect-EventLogs {
    param (
        [string]$logName,
        [int]$eventCount,
        [string]$savePath
    )
    
    $events = Get-EventLog -LogName $logName -Newest $eventCount
    $logEntries = @()
    
    foreach ($event in $events) {
        $logMessage = "EventID: $($event.EventID), Source: $($event.Source), Message: $($event.Message)"
        $logEntries += [PSCustomObject]@{
            Timestamp = $event.TimeGenerated
            EventID   = $event.EventID
            Source    = $event.Source
            Message   = $event.Message
        }
    }
    
    $csvPath = "$savePath\eventlog.csv"
    $logEntries | Export-Csv -Path $csvPath -NoTypeInformation
    [System.Windows.Forms.MessageBox]::Show("Logs collected successfully! Saved to: $csvPath", "Success", "OK", "Information")
}

# Create the Form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Event Log Collector"
$form.Size = New-Object System.Drawing.Size(420, 300)
$form.StartPosition = "CenterScreen"

# Label for Log Type
$labelLog = New-Object System.Windows.Forms.Label
$labelLog.Text = "Log Name:"
$labelLog.Location = New-Object System.Drawing.Point(20, 20)
$labelLog.Size = New-Object System.Drawing.Size(70, 20)
$form.Controls.Add($labelLog)

# Dropdown for Log Type
$comboBoxLog = New-Object System.Windows.Forms.ComboBox
$comboBoxLog.Location = New-Object System.Drawing.Point(100, 18)
$comboBoxLog.Size = New-Object System.Drawing.Size(200, 20)
$comboBoxLog.Items.AddRange(@("Application", "System", "Security"))
$form.Controls.Add($comboBoxLog)

# Label for Event Count
$labelCount = New-Object System.Windows.Forms.Label
$labelCount.Text = "Event Count:"
$labelCount.Location = New-Object System.Drawing.Point(20, 60)
$labelCount.Size = New-Object System.Drawing.Size(80, 20)
$form.Controls.Add($labelCount)

# TextBox for Event Count
$textBoxCount = New-Object System.Windows.Forms.TextBox
$textBoxCount.Location = New-Object System.Drawing.Point(100, 58)
$textBoxCount.Size = New-Object System.Drawing.Size(200, 20)
$form.Controls.Add($textBoxCount)

# Label for Save Location
$labelSave = New-Object System.Windows.Forms.Label
$labelSave.Text = "Save Location:"
$labelSave.Location = New-Object System.Drawing.Point(20, 100)
$labelSave.Size = New-Object System.Drawing.Size(80, 20)
$form.Controls.Add($labelSave)

# TextBox for Save Location
$textBoxSave = New-Object System.Windows.Forms.TextBox
$textBoxSave.Location = New-Object System.Drawing.Point(100, 98)
$textBoxSave.Size = New-Object System.Drawing.Size(220, 20)
$textBoxSave.ReadOnly = $true
$textBoxSave.Text = "C:\Logs"  # Set default folder to C:\Logs
$form.Controls.Add($textBoxSave)

# Button to Select Folder
$buttonBrowse = New-Object System.Windows.Forms.Button
$buttonBrowse.Text = "Browse"
$buttonBrowse.Location = New-Object System.Drawing.Point(330, 95)
$buttonBrowse.Size = New-Object System.Drawing.Size(60, 23)
$buttonBrowse.Add_Click({
    $folder = Select-Folder
    if ($folder) {
        $textBoxSave.Text = $folder
    }
})
$form.Controls.Add($buttonBrowse)

# Button to Collect Logs
$buttonCollect = New-Object System.Windows.Forms.Button
$buttonCollect.Text = "Collect Logs"
$buttonCollect.Location = New-Object System.Drawing.Point(100, 140)
$buttonCollect.Add_Click({
    $eventCountText = $textBoxCount.Text.Trim()
    $savePath = $textBoxSave.Text.Trim()
    if ($comboBoxLog.SelectedItem -and $eventCountText -match "^\d+$" -and $savePath) {
        Collect-EventLogs -logName $comboBoxLog.SelectedItem -eventCount ([int]$eventCountText) -savePath $savePath
    } else {
        [System.Windows.Forms.MessageBox]::Show("Please select a log type, enter a valid event count, and choose a save location.", "Error", "OK", "Error")
    }
})
$form.Controls.Add($buttonCollect)

# Show Form
$null = $form.ShowDialog()
