param(
    [Parameter(Mandatory=$true)]
    [string]$Class,

    [Parameter(Mandatory=$true)]
    [string]$Fix
)

$line = "- [$Class] $Fix"
Add-Content -Path "HARNESS.md" -Value $line
Write-Host "RATCHET: $line" -ForegroundColor Green
