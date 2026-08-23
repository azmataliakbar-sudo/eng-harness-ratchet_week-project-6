param(
    [Parameter(Mandatory=$true)]
    [string]$Mistake
)

$classes = @{
    "didnt_know" = @("unknown command", "missing dependency", "no context")
    "wasnt_stopped" = @("read secret", "deleted file", "force push")
    "wasnt_checked" = @("skipped test", "wrong verdict", "unchecked output")
    "planned_badly" = @("wrong order", "wrong approach", "no rollback")
}

foreach ($k in $classes.Keys) {
    foreach ($pattern in $classes[$k]) {
        if ($Mistake -match $pattern) {
            Write-Output $k
            exit 0
        }
    }
}

Write-Output "unknown"
