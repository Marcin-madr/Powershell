# Get a list of services based on a filter (optional)
$ServiceNameFilter = Read-Host "Enter a service name or part of a name to filter (leave empty for all services)"

if ($ServiceNameFilter) {
    $Services = Get-Service | Where-Object { $_.Name -like "*$ServiceNameFilter*" -or $_.DisplayName -like "*$ServiceNameFilter*" }
}
else {
    $Services = Get-Service
}

if ($Services.Count -gt 0) {
    Write-Host "Found the following services:"
    $Services | Format-Table Name, DisplayName, Status

    $ServiceName = Read-Host "Enter the Name of the service you want to manage"
    $SelectedService = $Services | Where-Object { $_.Name -eq $ServiceName }

    if ($SelectedService) {
        Write-Host "Selected service: $($SelectedService.DisplayName) ($($SelectedService.Name)) - Status: $($SelectedService.Status)"

        $Action = Read-Host "Enter action to perform (Start/Stop/Restart/Get-Details/Change-StartupType):"

        switch ($Action.ToLower()) {
            "start" {
                try {
                    Start-Service -Name $SelectedService.Name -ErrorAction Stop
                    Write-Host "Service '$($SelectedService.DisplayName)' started successfully."
                }
                catch {
                    Write-Error "Failed to start service '$($SelectedService.DisplayName)': $($_.Exception.Message)"
                }
            }
            "stop" {
                try {
                    Stop-Service -Name $SelectedService.Name -ErrorAction Stop
                    Write-Host "Service '$($SelectedService.DisplayName)' stopped successfully."
                }
                catch {
                    Write-Error "Failed to stop service '$($SelectedService.DisplayName)': $($_.Exception.Message)"
                }
            }
            "restart" {
                try {
                    Restart-Service -Name $SelectedService.Name -ErrorAction Stop
                    Write-Host "Service '$($SelectedService.DisplayName)' restarted successfully."
                }
                catch {
                    Write-Error "Failed to restart service '$($SelectedService.DisplayName)': $($_.Exception.Message)"
                }
            }
            "get-details" {
                Write-Host "Details for service '$($SelectedService.DisplayName)':"
                $SelectedService | Format-List *
            }
            "change-startuptype" {
                $StartupType = Read-Host "Enter the new startup type (Automatic/Manual/Disabled)"
                try {
                    Set-Service -Name $SelectedService.Name -StartupType $StartupType -ErrorAction Stop
                    Write-Host "Startup type for service '$($SelectedService.DisplayName)' changed to '$StartupType' successfully."
                }
                catch {
                    Write-Error "Failed to change startup type for service '$($SelectedService.DisplayName)': $($_.Exception.Message)"
                }
            }
            default {
                Write-Warning "Invalid action specified."
            }
        }
    }
    else {
        Write-Warning "Service '$ServiceName' not found."
    }
}
else {
    Write-Warning "No services found matching the filter."
}