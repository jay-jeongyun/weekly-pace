# Pace math

```
WEEK    = 7 * 24 * 3600                       # seconds
elapsed = clamp((now - (resets_at - WEEK)) / WEEK, 0, 1)
pace    = elapsed * baseline                  # baseline 90 by default (80, 90 or 100)
delta   = used - pace
```

- `delta > 0`: ahead of pace (using faster than an even spread). `delta <= 0`: room to spare.
- Color: `delta <= 0` green, `0 < delta < 12` amber, `delta >= 12` red.
- Remaining time: `left = max(0, resets_at - now)`, show days and hours.
- Stale week: `now >= resets_at` means the stored numbers belong to the previous week. Show 0 percent and wait for a new message.
- Freshness: show `now - ts` as "N min ago" or "N h ago". Dim when older than 3 hours.
- Round percent and delta to whole numbers for display only.
