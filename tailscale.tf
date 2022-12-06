resource "tailscale_tailnet_key" "git" {
  reusable      = false
  preauthorized = true
  expiry        = 600
}
