# Setup Log Directory and Path
$logDirectory = "C:\Logs"
$logFilePath = "$logDirectory\eventlog.txt"
$excelFilePath = "$logDirectory\eventlog.xlsx"

if (-not (Test-Path $logDirectory)) {
    New-Item -Path $logDirectory -ItemType Directory
}

# Create a function to write the logs
function Write-Log {
    param (
        [string]$message,
        [ValidateSet("INFO", "WARNING", "ERROR", "EVENT")]
        [string]$type = "INFO"
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "$timestamp [$type] $message"
    try {
        Add-Content -Path $logFilePath -Value $logEntry
    } catch {
        Write-Error "Failed to write log: $_"
    }
}

# Create a function to collect written logs in eventviewer
function Collect-EventLogs {
    param (
        [string]$logName = "Application",
        [ValidateRange(1, 1000)]
        [int]$eventCount = 50,
        [string]$eventType = "Information"
    )

    Write-Log -message "Collecting $eventCount $eventType events from $logName log" -type "INFO"
    try {
        $events = Get-EventLog -LogName $logName -Newest $eventCount | Where-Object { $_.EntryType -eq $eventType }
        $logEntries = @()
        foreach ($event in $events) {
            $logMessage = "EventID: $($event.EventID), Source: $($event.Source), Message: $($event.Message)"
            Write-Log -message $logMessage -type "EVENT"
            $logEntries += [PSCustomObject]@{
                Timestamp = $event.TimeGenerated
                EventID   = $event.EventID
                Source    = $event.Source
                Message   = $event.Message
            }
        }
        # Export to Excel
        $logEntries | Export-Excel -Path $excelFilePath -WorksheetName "EventLogs" -AutoSize
    } catch {
        Write-Log -message "Failed to collect event logs: $_" -type "ERROR"
    }
}

# Prompt for log name, event count, and event type
$logName = Read-Host "Enter the log name (e.g., Application, System, Security)"
$eventCountInput = Read-Host "Enter the number of events to collect"
[int]$eventCount = $eventCountInput
$eventType = Read-Host "Enter the event type (e.g., Information, Warning, Error)"

# Collect logs based on user input
Collect-EventLogs -logName $logName -eventCount $eventCount -eventType $eventType

# Inform the user where to find the logs
Write-Host "Logs have been collected and saved to:"
Write-Host "Text log file: $logFilePath"
Write-Host "Excel log file: $excelFilePath"

# Wait for user input before closing
Read-Host "Press Enter to exit"