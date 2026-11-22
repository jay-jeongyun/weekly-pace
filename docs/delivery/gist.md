# Delivery with a secret gist (second choice)

A GitHub gist can hold the JSON. "Secret" gists are not private: anyone with the link can read them, and every edit stays in the history.

1. Create a gist file `pace.json`.
2. Create a token that can only write gists, and keep it on your computer only.
3. Change the script to `PATCH https://api.github.com/gists/<id>` with the payload as the file content.
4. The widget reads the raw file. Raw files can be cached for a few minutes, so values can lag.

Prefer ntfy or Tailscale unless you already use gists.
