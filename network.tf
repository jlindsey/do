resource "digitalocean_ssh_key" "personal" {
  name       = "personal"
  public_key = file("~/.ssh/id_ed25519.pub")
}

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

resource "digitalocean_firewall" "gitea" {
  name = "internal-gitea-access"

  tags = [digitalocean_tag.tag["gitea"].id]

  inbound_rule {
    protocol    = "tcp"
    port_range  = "443"
    source_tags = [digitalocean_tag.tag["drone"].id]
  }
}

resource "digitalocean_firewall" "drone" {
  name = "internall-drone-rpc"
  tags = [digitalocean_tag.tag["drone"].id]

  inbound_rule {
    protocol    = "tcp"
    port_range  = "443"
    source_tags = [digitalocean_tag.tag["drone"].id]
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
