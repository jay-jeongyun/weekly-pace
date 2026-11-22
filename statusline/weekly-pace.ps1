# Weekly Pace status line script for Claude Code (Windows PowerShell 5.1+ / pwsh).
# Shows "week 41%". If $env:WEEKLY_PACE_URL is set, POSTs {"v":1,"used":..,"resets_at":..,"ts":..}
# only when the numbers change. Nothing else from the status line input is sent.
$raw = [Console]::In.ReadToEnd()
try { $j = $raw | ConvertFrom-Json } catch { Write-Output "week: n/a"; exit 0 }
$w = $j.rate_limits.seven_day
if ($null -eq $w -or $null -eq $w.used_percentage -or $null -eq $w.resets_at) { Write-Output "week: n/a"; exit 0 }
Write-Output ("week {0:N0}%" -f $w.used_percentage)
if ($env:WEEKLY_PACE_URL) {
  $cacheDir = Join-Path $env:LOCALAPPDATA "weekly-pace"; New-Item -ItemType Directory -Force -Path $cacheDir | Out-Null
  $cache = Join-Path $cacheDir "last"; $cur = "$($w.used_percentage) $($w.resets_at)"
  $prev = if (Test-Path $cache) { Get-Content $cache -Raw } else { "" }
  if ($prev -ne $cur) {
    $payload = @{ v = 1; used = [double]$w.used_percentage; resets_at = [long]$w.resets_at; ts = [long][DateTimeOffset]::UtcNow.ToUnixTimeSeconds() } | ConvertTo-Json -Compress
    try { Invoke-RestMethod -Method Post -Uri $env:WEEKLY_PACE_URL -Body $payload -TimeoutSec 5 | Out-Null; Set-Content -Path $cache -Value $cur -NoNewline } catch {}
  }
}
