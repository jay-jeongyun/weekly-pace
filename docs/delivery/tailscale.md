# Delivery over Tailscale (most private)

Your computer runs a tiny HTTP receiver that only listens on its Tailscale address. The status line script posts to it, the widget polls it.

1. Install Tailscale on the computer and the phone, signed in to the same tailnet.
2. Run a receiver that stores the last JSON body and returns it on GET. Keep it bound to the Tailscale address only, not `0.0.0.0`.
3. `export WEEKLY_PACE_URL="http://<tailscale-address>:<port>/"`.
4. The phone must be connected to Tailscale for the widget to read it, and the computer must be on.

If your widget app is not on the VPN allow list (per-app VPN), it cannot reach the address.
