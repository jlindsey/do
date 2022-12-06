resource "digitalocean_firewall" "tailscale" {
  name = "tailscale-access-only"

  tags = [digitalocean_tag.tag["tailscale"].id]

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "ssh" {
  name = "public-ssh-access"

  tags = [digitalocean_tag.tag["ssh"].id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}

resource "digitalocean_firewall" "minecraft" {
  name = "minecraft-public-access"

  tags = [digitalocean_tag.tag["minecraft"].id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "25565"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }
}
