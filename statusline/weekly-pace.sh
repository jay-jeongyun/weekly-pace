#!/usr/bin/env bash
# Weekly Pace status line script for Claude Code (macOS / Linux). Needs jq and curl.
# Shows "week 41%" in the status line. If WEEKLY_PACE_URL is set, it also POSTs
# {"v":1,"used":..,"resets_at":..,"ts":..} to that URL, only when the numbers change.
# It sends nothing else from the status line input.
set -u
in=$(cat)
used=$(printf '%s' "$in" | jq -r '.rate_limits.seven_day.used_percentage // empty' 2>/dev/null)
reset=$(printf '%s' "$in" | jq -r '.rate_limits.seven_day.resets_at // empty' 2>/dev/null)

if [ -z "$used" ] || [ -z "$reset" ]; then
  echo "week: n/a"   # no value yet (new session, non-subscription plan, or window already reset)
  exit 0
fi
printf 'week %.0f%%\n' "$used"

if [ -n "${WEEKLY_PACE_URL:-}" ]; then
  cache="${XDG_CACHE_HOME:-$HOME/.cache}/weekly-pace/last"
  mkdir -p "$(dirname "$cache")"
  cur="$used $reset"
  if [ "$(cat "$cache" 2>/dev/null)" != "$cur" ]; then
    payload=$(jq -nc --argjson u "$used" --argjson r "$reset" '{v:1,used:$u,resets_at:$r,ts:(now|floor)}')
    # background so a slow network never blocks the status line
    ( curl -fsS --max-time 5 -d "$payload" "$WEEKLY_PACE_URL" >/dev/null 2>&1 && printf '%s' "$cur" > "$cache" ) &
  fi
fi
