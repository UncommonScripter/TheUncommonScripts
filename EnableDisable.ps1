# Title: Enable or Disable Active Directory User Account

# Display title
Write-Host "`e[1;34m========================================`e[0m"
Write-Host "`e[1;34m Enable or Disable Active Directory User Account `e[0m"
Write-Host "`e[1;34m========================================`e[0m"

# Prompt for action
$action = Read-Host "Would you like to enable or disable a user? (Enter 'enable' or 'disable')"

# Prompt for username
$username = Read-Host "Enter the username (SamAccountName)"

# Perform the action based on input
if ($action -eq "enable") {
    Enable-ADAccount -Identity $username
    Write-Host "User account '$username' has been enabled."
} elseif ($action -eq "disable") {
    Disable-ADAccount -Identity $username
    Write-Host "User account '$username' has been disabled."
} else {
    Write-Host "Invalid action. Please enter 'enable' or 'disable'."
}