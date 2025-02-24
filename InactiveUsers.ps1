# Title: Find and Export Inactive Active Directory Users

# Display title with color
Write-Host "`e[1;34m========================================`e[0m"
Write-Host "`e[1;34m Find and Export Inactive Active Directory Users `e[0m"
Write-Host "`e[1;34m========================================`e[0m"

$inactiveDays = 90
$date = (Get-Date).AddDays(-$inactiveDays)

# Create Directory
$directory = "C:\Reports"
if (-Not (Test-Path -Path $directory)) {
    New-Item -Path $directory -ItemType Directory
}
    


# Find inactive users
try{
    $inactiveUsers = Get-ADUser -Filter {LastLogonDate -lt $date} -Properties LastLogonDate | Select-Object Name, SamAccountName, LastLogonDate

    # Export to CSV
    $inactiveUsers | Export-Csv -Path "C:\Reports\InactiveUsers.csv" -NoTypeInformation
    Write-Host "Inactive users have been exported to C:\Reports\InactiveUsers.csv"
} catch {
    Write-Host "An error Occured: $_"
}

