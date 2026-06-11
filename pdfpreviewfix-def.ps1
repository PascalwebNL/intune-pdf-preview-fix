Write-Output "Starting PDF Preview Fix (Enterprise Intune Script)..."

# ==============================
# 1. Fix Internet Zone setting (180F)
# ==============================

$zonePath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings\Zones\3"

If (!(Test-Path $zonePath)) {
    Write-Output "Zone 3 path not found, creating..."
    New-Item -Path $zonePath -Force | Out-Null
}

$currentValue = Get-ItemProperty -Path $zonePath -Name "180F" -ErrorAction SilentlyContinue

If ($null -eq $currentValue -or $currentValue."180F" -ne 0) {
    Write-Output "Setting 180F to 0 (Allow)..."
    New-ItemProperty -Path $zonePath -Name "180F" -Value 0 -PropertyType DWord -Force | Out-Null
} else {
    Write-Output "180F already correctly configured."
}

# ==============================
# 2. Fix PDF Preview Handler (Edge)
# ==============================

$pdfPreviewHandlers = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\PreviewHandlers"
$edgeGuid = "{3A84F9C2-8D6E-4FDC-A2F0-22AFD5D6CCE3}"

If (!(Test-Path $pdfPreviewHandlers)) {
    New-Item -Path $pdfPreviewHandlers -Force | Out-Null
}

New-ItemProperty -Path $pdfPreviewHandlers `
    -Name $edgeGuid `
    -Value "Microsoft Edge PDF Previewer" `
    -PropertyType String -Force | Out-Null

Write-Output "Edge Preview Handler ensured."

# ==============================
# 3. File Association Fix (.pdf preview)
# ==============================

$fileAssocKey = "HKLM:\SOFTWARE\Classes\.pdf\shellex\{8895B1C6-B41F-4C1C-A562-0D564250836F}"

If (!(Test-Path $fileAssocKey)) {
    New-Item -Path $fileAssocKey -Force | Out-Null
}

Set-ItemProperty -Path $fileAssocKey -Name "(default)" -Value $edgeGuid

Write-Output ".pdf preview association configured."

# ==============================
# 4. Restart Explorer (optional but recommended)
# ==============================

Write-Output "Restarting Explorer..."
Get-Process explorer -ErrorAction SilentlyContinue | Stop-Process -Force
Start-Process explorer.exe

Write-Output "PDF Preview Fix completed successfully."