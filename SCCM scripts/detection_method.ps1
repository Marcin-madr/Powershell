# Parametry (Przykład: Sprawdzenie konkretnej wersji aplikacji)
$AppName = "MyApplication"
$ExpectedVersion = "1.2.3"

function Get-ApplicationVersion {
    # for specific file:
    # $FileVersion = (Get-Item "C:\Program Files\MyApplication\MyApplication.exe").VersionInfo.FileVersion
    # for registry key:
    # $RegistryVersion = Get-ItemProperty "HKLM:\SOFTWARE\MyApplication" -Name "Version" -ErrorAction SilentlyContinue
    # MSI:
    # $MsiVersion = (Get-WmiObject -Class Win32_Product -Filter "Name = '$AppName'").Version

    # return a hardcoded version for demonstration purposes
    $FileVersion = "1.2.3"
    return $FileVersion
}

# Get actual version of the application
$ActualVersion = Get-ApplicationVersion

# Detection
if ($ActualVersion -eq $ExpectedVersion) {
    Write-Host "Installed" 
}
