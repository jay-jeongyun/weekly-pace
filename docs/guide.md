# Guide

## 0. What you need

- Claude Code on a claude.ai Pro, Max or Ultra plan. The status line only receives `rate_limits` for these plans, and only after the first response of a session. Source: https://code.claude.com/docs/en/statusline
- A computer where you run Claude Code (macOS, Linux or Windows), with `jq` (macOS/Linux) or PowerShell (Windows).
- An Android phone and a way to build a small app (an AI agent can do it with [the skill](../skills/weekly-pace-widget/SKILL.md)).
- Do not use a work computer or a work repository. Your employer may block outgoing requests or log them.

## 1. Add the status line script

macOS / Linux:

```bash
cp statusline/weekly-pace.sh ~/.claude/weekly-pace.sh
chmod +x ~/.claude/weekly-pace.sh
```

Then add this to `~/.claude/settings.json` (merge with what you have):

```json
{
  "statusLine": { "type": "command", "command": "~/.claude/weekly-pace.sh" }
}
```

Windows: copy `statusline/weekly-pace.ps1` to `%USERPROFILE%\.claude\` and set the command to `powershell -NoProfile -File %USERPROFILE%\.claude\weekly-pace.ps1`.

Open Claude Code and send one message. The status line should show `week 41%` (your number). Before the first response it shows `week: n/a`.

## 2. Choose where the numbers go

Set the environment variable `WEEKLY_PACE_URL` in the shell that starts Claude Code.

| Path | Setup | Good | Watch out |
| --- | --- | --- | --- |
| ntfy (default) | [docs/delivery/ntfy.md](delivery/ntfy.md) | one line, no account | the topic name is the password |
| Tailscale | [docs/delivery/tailscale.md](delivery/tailscale.md) | most private | your computer and phone must be on |
| Secret gist | [docs/delivery/gist.md](delivery/gist.md) | free, no extra app | needs a token on your computer; "secret" is not private |

## 3. Build the widget

Use the skill, or write it yourself. The widget does three things:

1. Fetch the latest message from your delivery path every 15 to 60 minutes.
2. Compute the pace (below).
3. Draw it.

### The pace line

```
week_seconds = 7 * 24 * 3600
elapsed      = clamp((now - (resets_at - week_seconds)) / week_seconds, 0, 1)
pace         = elapsed * baseline          # baseline = 90 (percent) by default
delta        = used - pace                 # positive: ahead of pace, negative: room to spare
```

Why a baseline below 100: keeping about 10 percent in reserve for the end of the week. Use 100 if you want a pure even pace.

If `now >= resets_at`, the week is over: show 0 percent and "waiting for new data" instead of last week's number.

### Freshness

The numbers only change when Claude Code runs on your computer. Use of Claude in the web or phone app shows up only after your next Claude Code response. Always show how old the numbers are (`ts`), for example "3 h ago", and dim the widget when they are older than a few hours.

## 4. Check it works

- Run a message in Claude Code, then open your delivery path in a browser or with `curl`. You should see `{"v":1,"used":41.2,"resets_at":...,"ts":...}`.
- Turn the phone's network off. The widget should keep the last numbers and say they are old.

## Not covered

Reading usage directly from the Claude phone app may be possible, but this guide does not cover it and it has not been tried. Whatever approach you choose, read Anthropic's terms first: https://code.claude.com/docs/en/legal-and-compliance
