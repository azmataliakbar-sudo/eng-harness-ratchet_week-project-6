param(
    [int]$Days = 7
)

$root = "C:\Projects\eng_harness\ratchet_week"
$startedAt = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Parallel arrays: mistake text and its fix.
$mistakes = @(
    "read secret",
    "unknown command",
    "read secret",
    "skipped test",
    "wrong order",
    "skipped test",
    "deleted file"
)

$fixes = @(
    "add guardrail: deny secret files",
    "add skill: document available commands",
    "already fixed - should be blocked",
    "add gate: run tests before commit",
    "add spec: define step order",
    "already fixed - should be blocked",
    "add permission: no recursive delete"
)

$counts = @{ didnt_know = 0; wasnt_stopped = 0; wasnt_checked = 0; planned_badly = 0 }
$blocked = 0

Write-Host "===== Ratchet Week: 7-Day Simulation =====" -ForegroundColor DarkCyan

for ($d = 1; $d -le $Days; $d++) {
    $idx = $d - 1
    $mistake = $mistakes[$idx]
    $fix = $fixes[$idx]

    Write-Host ""
    Write-Host "--- Day $d : mistake '$mistake' ---" -ForegroundColor Cyan

    if ($fix -match 'already fixed') {
        Write-Host "RATCHET HELD: same shape blocked, no new failure." -ForegroundColor Yellow
        $blocked++
        continue
    }

    $class = & "$root\classify.ps1" -Mistake $mistake
    Write-Host "Classified as: $class" -ForegroundColor Cyan

    if ($counts.ContainsKey($class)) {
        $counts[$class]++
    }

    & "$root\ratchet.ps1" -Class $class -Fix $fix
}

$now = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# task-done
$doneCount = 0
if (Test-Path "task-done.txt") {
    $doneCount = (Get-Content "task-done.txt" | Where-Object { $_ -match '^DONE-' }).Count
}
$nextDone = $doneCount + 1
"DONE-$nextDone at $now : 7-day ratchet run" | Add-Content "task-done.txt"

# SUMMARY
$summaryCount = (Get-ChildItem -Filter "SUMMARY*.md" -ErrorAction SilentlyContinue).Count
$nextSummary = $summaryCount + 1
$summaryLines = @(
    "Run: $nextSummary"
    "Started: $startedAt"
    "Finished: $now"
    "Didn't know: $($counts.didnt_know)"
    "Wasn't stopped: $($counts.wasnt_stopped)"
    "Wasn't checked: $($counts.wasnt_checked)"
    "Planned badly: $($counts.planned_badly)"
    "Blocked by ratchet: $blocked"
)
Set-Content -Path "SUMMARY$nextSummary.md" -Value $summaryLines

Write-Host ""
Write-Host "--- WEEK RESULTS ---" -ForegroundColor DarkCyan
foreach ($k in @("didnt_know","wasnt_stopped","wasnt_checked","planned_badly")) {
    Write-Host "$k : $($counts[$k])"
}
Write-Host "Blocked by ratchet (repeat shapes): $blocked" -ForegroundColor Green

# Name the thinnest class (the one that dominated).
$max = 0
$thinnest = "none"
foreach ($k in $counts.Keys) {
    if ($counts[$k] -gt $max) { $max = $counts[$k]; $thinnest = $k }
}
Write-Host "Thinnest class (dominated): $thinnest ($max)" -ForegroundColor Red

Write-Host ""
Write-Host "Wrote task-done.txt -> DONE-$nextDone"
Write-Host "Wrote SUMMARY$nextSummary.md"
Write-Host "==========================================" -ForegroundColor DarkCyan
