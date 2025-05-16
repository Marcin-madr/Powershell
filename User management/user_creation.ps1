# User parameters
$SamAccountName = Read-Host "Enter the username (sAMAccountName)"
$UserPrincipalName = Read-Host "Enter the user principal name (UserPrincipalName, e.g., user@domain.com)"
$DisplayName = Read-Host "Enter the display name"
$GivenName = Read-Host "Enter the first name"
$Surname = Read-Host "Enter the last name"
$Password = Read-Host -AsSecureString "Enter the password"
$OUPath = Read-Host "Enter the organizational unit (OU) path, e.g., 'OU=Users,DC=domain,DC=com'"

# Optional parameters
$Enabled = $true # Enabled by default
$PasswordNeverExpires = $false # Disabled by default
$UserMustChangePasswordAtNextLogon = $true # Enabled by default

# Create the new user
try {
    New-ADUser -SamAccountName $SamAccountName `
               -UserPrincipalName $UserPrincipalName `
               -DisplayName $DisplayName `
               -GivenName $GivenName `
               -Surname $Surname `
               -AccountPassword $Password `
               -Path $OUPath `
               -Enabled $Enabled `
               -PasswordNeverExpires $PasswordNeverExpires `
               -ChangePasswordAtLogon $UserMustChangePasswordAtNextLogon

    Write-Host "Successfully created user: $DisplayName ($SamAccountName)"
}
catch {
    Write-Error "An error occurred while creating the user: $($_.Exception.Message)"
}