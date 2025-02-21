# Import AD Module
Import-Module ActiveDirectory

# Setup Users directory and path
$usersDirectory = "C:\temp"
$usersPath = "$usersDirectory\DisabledUsers.csv"

if (-not (Test-Path $usersDirectory)) {
    New-Item -Path $usersDirectory -ItemType Directory
}

# Get all disabled user accounts
$disabledUsers = Get-ADUser -Filter {Enabled -eq $false} -Properties DisplayName, SamAccountName

# Export the list to a CSV file
$disabledUsers | Select-Object DisplayName, SamAccountName | Export-Csv -Path $usersPath -NoTypeInformation

Write-Output "Export completed. The list of disabled users is saved to $usersPath"
Read-Host "Press Enter to Exit..."