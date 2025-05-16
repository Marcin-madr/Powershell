# Provide the user identifier (can be SamAccountName, UserPrincipalName, or DistinguishedName)
$UserID = Read-Host "Enter the username (sAMAccountName), UPN, or DN to unlock"

try {
    # Check if the user exists
    $User = Get-ADUser -Identity $UserID -ErrorAction Stop

    # Unlock the user account
    Unlock-ADAccount -Identity $User

    Write-Host "Successfully unlocked user account: $($User.DisplayName) ($($User.SamAccountName))"
}
catch {
    Write-Error "Could not find a user with the provided identifier: $UserID"
    Write-Error "Error details: $($_.Exception.Message)"
}