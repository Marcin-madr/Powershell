# Function to check if a reboot is pending
function Test-PendingReboot {
    # Check for pending reboot keys in the registry
    $RegKeys = @(
        "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending",
        "HKLM:\Software\Microsoft\Windows\WindowsUpdate\Auto Update\RebootRequired",
        "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\PendingFileRenameOperations",
        "HKLM:\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName", # Check if ComputerName requires reboot (NetBIOS name change) - less reliable
        "HKLM:\Software\Microsoft\ServerManager\CurrentRebootRequired" # For Server Manager related reboots
    )

    $RebootPending = $false

    foreach ($KeyPath in $RegKeys) {
        if (Test-Path $KeyPath) {
            Write-Verbose "Found pending reboot key: $KeyPath"
            $RebootPending = $true
            break # No need to check further if one key is found
        }
    }

    # Check for pending computer rename (more reliable than registry key in some cases)
    if (!(Get-WmiObject -Class Win32_ComputerSystem -Property Name, Domain, DomainRole | Where-Object { $_.DomainRole -eq 4 -and $_.Name -ne $_.Domain })) {
        Write-Verbose "Pending computer rename detected."
        $RebootPending = $true
    }

    return $RebootPending
}

# Main script
Write-Verbose "Starting pending reboot check..."
$RequiresReboot = Test-PendingReboot -Verbose

if ($RequiresReboot) {
    Write-Host "Host requires a reboot."
    exit 1 # Return a non-zero exit code to indicate a reboot is needed
}
else {
    Write-Host "Host does not require a reboot."
    exit 0 # Return a zero exit code to indicate no reboot is needed
}