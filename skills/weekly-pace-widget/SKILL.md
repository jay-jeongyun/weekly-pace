---
name: weekly-pace-widget
description: Builds a personal Android home screen widget that shows weekly Claude usage against an even-pace line. Data comes only from the user's own Claude Code status line (rate_limits.seven_day) sent to a delivery path the user owns. Use when the user asks for a usage or pace widget for Claude Code on their phone.
license: MIT
compatibility: Needs Claude Code on a claude.ai Pro, Max or Ultra plan, jq (or PowerShell), and an Android SDK (platform 34 or newer, build-tools, JDK 17+). Android 8.0+ target devices.
metadata:
  version: "0.1"
---

# Weekly Pace widget

Build a small Android widget for the user's own phone. It shows weekly usage next to a pace line.

## Hard rules (do not break these)

1. Never implement sign-in to Claude. No OAuth, no client ids, no tokens, no cookies, no passwords, no web views of claude.ai.
2. Never call any unofficial Claude or Anthropic endpoint. The only data source is the Claude Code status line JSON (`rate_limits.seven_day.used_percentage` and `rate_limits.seven_day.resets_at`).
3. Send off the computer only the fields in `schema/pace.v1.json`: `v`, `used`, `resets_at`, `ts`. Never forward the whole status line input. It can contain folders, repository names, session ids and costs.
4. Do not use "Claude" or "Claude Code" in the app name, package name, repository name or icon. Do not use Anthropic logos or orange brand colors. Put "Unofficial, not affiliated with Anthropic" in the app and in the store text.
5. Stop and tell the user if their plan is not Pro, Max or Ultra, or if the computer is a work computer or a work repository.

## Steps

1. **Check the setup.** Ask which computer runs Claude Code and which plan the user has. Explain that numbers only update while Claude Code runs on that computer, and appear after the first response of a session.
2. **Install the status line script.** Copy `statusline/weekly-pace.sh` (or `.ps1` on Windows) to `~/.claude/`, merge `statusline/settings.example.json` into `~/.claude/settings.json`, then ask the user to send one message in Claude Code and confirm the line shows `week NN%`.
3. **Pick the delivery path** with the user. Default: ntfy with a random topic of 32 or more characters (`docs/delivery/ntfy.md`). Alternatives: Tailscale (`docs/delivery/tailscale.md`), secret gist (`docs/delivery/gist.md`). Set `WEEKLY_PACE_URL` in the shell profile. Keep the URL out of any file you commit or screenshot.
4. **Verify the message** with `curl` against the delivery path. It must match `schema/pace.v1.json`.
5. **Build the widget app.** Plain Android, no sign-in code, one permission (`INTERNET`, plus `RECEIVE_BOOT_COMPLETED` if you re-schedule after reboot).
   - Fetch the newest message at most every 15 minutes (use an inexact repeating alarm and goAsync, short timeouts, never retry in a tight loop).
   - Store the last numbers on the phone and keep showing them when offline.
   - Compute and draw as in `references/pace-math.md` and `assets/PaceDraw.java`.
   - Offer the widget sizes in `references/widget-sizes.md`.
   - Show the age of the numbers. Dim the widget when they are older than 3 hours.
   - If `now >= resets_at`, show 0 percent and a "waiting for new data" state, not last week's number.
6. **Test.** Run it on an emulator or the user's phone: normal value, ahead of pace, behind pace, offline, stale week, each widget size. Check that no text overlaps in the smallest sizes.
7. **Tell the user what to do next:** add the widget to the home screen, and how to rotate the ntfy topic if it leaks.

## Optional

- Localize the strings. `references/strings.md` lists the keys. Ask the user which languages they want.
- Let the user pick layout (bar or ring), theme and accent color.

## What to say about limits

- The numbers are as fresh as the last Claude Code response on the computer.
- Using Claude in the web or phone app only shows up after the next Claude Code response.
- Reading usage directly from the Claude phone app may be possible, but this skill does not cover it. Anything the user tries there must respect Anthropic's terms.
