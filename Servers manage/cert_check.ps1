# PowerShell script to check the RDP certificate

# Get the certificate object from the Terminal Services configuration
$cert = Get-WmiObject -Class "Win32_TSGeneralSetting" -Namespace "root\cimv2\terminalservices" -Filter "TerminalName='RDP-Tcp'" | Select-Object -ExpandProperty SSLCertificate

if ($cert) {
    # Load the certificate
    $certificate = [System.Security.Cryptography.X509Certificates.X509Certificate2]::new($cert)

    # Display certificate information
    Write-Host "RDP Certificate Information:"
    Write-Host "-----------------------------------"
    Write-Host "Subject: $($certificate.Subject)"
    Write-Host "Issuer: $($certificate.Issuer)"
    Write-Host "Valid To: $($certificate.NotAfter)"
    Write-Host "Valid From: $($certificate.NotBefore)"
    Write-Host "Thumbprint: $($certificate.Thumbprint)"
    Write-Host "Friendly Name: $($certificate.FriendlyName)"
    Write-Host "Certificate is valid: $($certificate.Verify())"

    # Check if the certificate is about to expire (e.g., within 30 days)
    $now = Get-Date
    $expirationDate = $certificate.NotAfter
    $daysUntilExpiration = ($expirationDate - $now).TotalDays
    
    if ($daysUntilExpiration -le 30) {
        Write-Warning "RDP certificate will expire in $($daysUntilExpiration) days!"
    }
    else {
        Write-Host "RDP certificate is valid and will expire in $($daysUntilExpiration) days."
    }
}
else {
    Write-Error "RDP certificate not found."
}
