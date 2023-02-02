resource "tailscale_tailnet_key" "git" {
  reusable      = false
  preauthorized = true
  expiry        = 600
}

resource "tailscale_tailnet_key" "drone_master" {
  reusable      = false
  preauthorized = true
  expiry        = 600
}

resource "tailscale_tailnet_key" "drone_runners" {
  count         = local.drone_runners
  reusable      = false
  preauthorized = true
  expiry        = 600
}

resource "tailscale_tailnet_key" "minecraft" {
  reusable      = false
  preauthorized = true
  expiry        = 600
}
