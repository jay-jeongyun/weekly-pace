# Delivery with ntfy (default)

[ntfy](https://ntfy.sh) is a simple publish and subscribe service. No account is needed.

1. Create a random topic name of 32 or more characters:

   ```bash
   LC_ALL=C tr -dc 'a-z0-9' </dev/urandom | head -c 32; echo
   ```

2. On your computer, before starting Claude Code:

   ```bash
   export WEEKLY_PACE_URL="https://ntfy.sh/<your-topic>"
   ```

   Put it in your shell profile so it is always set.

3. The widget reads the latest message with a plain HTTPS request:

   ```
   GET https://ntfy.sh/<your-topic>/json?poll=1&since=12h
   ```

   Each line of the response is an event; the `message` field is the JSON from the status line script. Use the newest one.

Limits: public ntfy keeps messages about 12 hours, so the widget shows "no data" if you did not use Claude Code for longer. Cache the last numbers on the phone. Self-hosting ntfy removes the 12 hour limit.
