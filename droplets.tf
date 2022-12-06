resource "digitalocean_ssh_key" "personal" {
  name       = "personal"
  public_key = file("~/.ssh/id_ed25519.pub")
}

resource "digitalocean_volume" "git" {
  region      = "nyc1"
  name        = "gitea"
  size        = 50
  description = "gitea docker data persistence"
}

resource "digitalocean_droplet" "git" {
  name              = "gitea"
  image             = "debian-11-x64"
  size              = "s-1vcpu-1gb"
  region            = "nyc1"
  ssh_keys          = [digitalocean_ssh_key.personal.id]
  volume_ids        = [digitalocean_volume.git.id]
  graceful_shutdown = true
  monitoring        = true

  user_data = templatefile("${path.module}/cloudinit/git.yaml", {
    tailscale_apt_key = jsonencode(file("${path.module}/cloudinit/tailscale.key"))
    docker_apt_key    = jsonencode(file("${path.module}/cloudinit/docker.key"))
    gitea_compose     = filebase64("${path.module}/cloudinit/gitea-compose.yaml")
    ssh_shim          = filebase64("${path.module}/cloudinit/ssh-shim.sh")
    caddyfile         = filebase64("${path.module}/cloudinit/Caddyfile")
    tailscale_key     = tailscale_tailnet_key.git.key
  })

  tags = [
    for tag in ["tailscale"] : digitalocean_tag.tag[tag].id
  ]
}
