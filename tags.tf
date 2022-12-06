locals {
  tags = [
    "ssh",
    "tailscale",
    "minecraft",
  ]
}

resource "digitalocean_tag" "tag" {
  for_each = toset(local.tags)
  name     = each.key
}
