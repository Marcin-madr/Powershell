If (-NOT ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Start-Process PowerShell -Verb RunAs -ArgumentList "-File `"$PSCommandPath`""
    Exit
}

Function Update-RegistryEntry {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $true, HelpMessage = "Full path (ex. HKLM:\SOFTWARE\MyApplication).")]
        [string]$RegistryPath,

        [Parameter(Mandatory = $true, HelpMessage = "Name of key (ex. MySetting).")]
        [string]$EntryName,

        [Parameter(Mandory = $true, HelpMessage = "New value")]
        [System.Object]$NewValue
    )

    Write-Host "Change attempt.." -ForegroundColor Cyan
    Write-Host "Key path: $($RegistryPath)" -ForegroundColor DarkCyan
    Write-Host "Name: $($EntryName)" -ForegroundColor DarkCyan
    Write-Host "New value: $($NewValue)" -ForegroundColor DarkCyan

    # check if the registry path exists
    If (-NOT (Test-Path -Path $RegistryPath)) {
        Write-Error "Registry key '$($RegistryPath)' does not exist."
        Write-Error "Please check the path and try again."
        Return
    }

    Try {
        # check if the entry exists, if not, create it
        # if you don't want to create it, change to get-itemproperty
        If (-NOT (Get-ItemProperty -Path $RegistryPath -Name $EntryName -ErrorAction SilentlyContinue)) {
            Write-Warning "Entry '$($EntryName)' does not exist '$($RegistryPath)'. It will be created."
        }

        Set-ItemProperty -Path $RegistryPath -Name $EntryName -Value $NewValue -Force -ErrorAction Stop
        Write-Host "Updated '$($EntryName)' in key '$($RegistryPath)' to value '$($NewValue)'." -ForegroundColor Green
    }
    Catch {
        Write-Error "There was an error in key: $($_.Exception.Message)"
        Write-Error "Make sure you have the correct permissions to modify the registry key."
    }
}

# --- Główna część skryptu ---

# Pytanie o ścieżkę klucza
$RegPath = Read-Host "Please provide full path (ex. HKLM:\SOFTWARE\MojaAplikacja)"

# Pytanie o nazwę wpisu
$Entry = Read-Host "Please provide key to change (np. MojUstawienie)"

# Pytanie o nową wartość
$Value = Read-Host "Provide new value (np. 1, 0, 'MyValue')"

# Wywołanie funkcji z podanymi parametrami
Update-RegistryEntry -RegistryPath $RegPath -EntryName $Entry -NewValue $Value

Write-Host "`nCompleted." -ForegroundColor Yellow