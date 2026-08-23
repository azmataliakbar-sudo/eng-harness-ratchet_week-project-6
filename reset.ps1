Set-Content -Path "HARNESS.md" -Value "# HARNESS.md — Failure Fix Log`r`n"
if (Test-Path "task-done.txt") { Remove-Item "task-done.txt" }
Get-ChildItem -Filter "SUMMARY*.md" -ErrorAction SilentlyContinue | Remove-Item
Write-Output "Reset ratchet_week."
