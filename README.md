# Weekly Pace

See how much of your Claude weekly limit you have used compared with an even pace, on your phone's home screen.

This repository is a **guide and an AI agent skill**, not an app. You build a small widget for your own phone, from your own Claude Code status line data.

> Unofficial. Not affiliated with, endorsed by or sponsored by Anthropic. "Claude" and "Claude Code" are trademarks of Anthropic, mentioned here only to describe what this works with.

## Idea

Claude Code can pass your weekly usage to a status line script. That script sends two numbers (percent used and reset time) to a place you own. A widget on your phone reads them and draws:

- weekly usage in percent
- a **pace line**: share of the week that has passed x a baseline you choose (default 90 percent)
- how many points you are over or under that pace
- time left until the reset, and how old the numbers are

## Who this is for

- Claude Code users on a claude.ai **Pro, Max or Ultra** plan. Free, Team, Enterprise and API-key setups do not receive these numbers.
- People who use Claude Code on a PC or Mac. The numbers only update while Claude Code runs on that computer.

## Quick start

1. Install `jq` and add the status line script: [docs/guide.md](docs/guide.md), step 1.
2. Pick a delivery path. The default is a private ntfy topic: [docs/delivery/ntfy.md](docs/delivery/ntfy.md).
3. Build the widget with your AI agent using the skill in [skills/weekly-pace-widget](skills/weekly-pace-widget/SKILL.md), or follow the guide by hand.

## What this does not do

- It does not sign in to Claude, and it never touches your Claude password, tokens or cookies.
- It does not call any unofficial Claude endpoint. The only data source is the status line that Claude Code itself provides.
- Reading usage straight from the Claude phone app may be possible, but it is not covered here and has not been tried. Whatever you try, check Anthropic's terms first.

## Privacy

Send only the three fields in [schema/pace.v1.json](schema/pace.v1.json). The status line input contains much more (folders, repository names, session ids, costs). Read [docs/privacy.md](docs/privacy.md) before you send anything off your computer.

## Layout

```
docs/guide.md                    step by step
docs/privacy.md                  what to send and what never to send
docs/delivery/                   ntfy (default), Tailscale, secret gist
statusline/weekly-pace.sh        status line script for macOS and Linux
statusline/weekly-pace.ps1       status line script for Windows
statusline/settings.example.json Claude Code settings snippet
schema/pace.v1.json              the message format
skills/weekly-pace-widget/       agent skill that builds the phone widget
```

## License

MIT, see [LICENSE](LICENSE).
