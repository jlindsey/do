locals {
  drone_runners = 1

  drone_master_env_file = templatefile("${path.module}/cloudinit/drone/master.env", {
    gitea_client_id          = var.drone_gitea_client_id
    gitea_client_secret      = var.drone_gitea_client_secret
    drone_rpc_secret         = random_password.drone_rpc_key.result
    drone_cookie_secret      = random_password.drone_cookie_secret.result
    bucket_name              = digitalocean_spaces_bucket.drone_storage.name
    bucket_endpoint          = digitalocean_spaces_bucket.drone_storage.endpoint
    spaces_access_key_id     = var.spaces_access_key_id
    spaces_secret_access_key = var.spaces_secret_access_key
  })

  drone_runner_env_file = templatefile("${path.module}/cloudinit/drone/runner.env", {
    drone_rpc_secret = random_password.drone_rpc_key.result
  })
}

resource "random_password" "drone_rpc_key" {
  length  = 32
  special = false
}

resource "random_password" "drone_cookie_secret" {
  length  = 16
  special = false
}

resource "digitalocean_volume" "drone_master" {
  region      = "nyc1"
  name        = "drone"
  size        = 10
  description = "drone master db storage"
}

resource "digitalocean_spaces_bucket" "drone_storage" {
  name   = "jlindsey-drone"
  region = "nyc3"
  acl    = "private"

  lifecycle_rule {
    id      = "old-expires"
    enabled = true
    expiration {
      days = 90
    }
  }
}

resource "digitalocean_droplet" "drone_master" {
  name              = "drone"
  image             = "debian-11-x64"
  size              = "s-1vcpu-512mb-10gb"
  region            = "nyc1"
  ssh_keys          = [digitalocean_ssh_key.personal.id]
  volume_ids        = [digitalocean_volume.drone_master.id]
  graceful_shutdown = true
  monitoring        = true

  user_data = templatefile("${path.module}/cloudinit/drone/master-user-data.yaml.tftpl", {
    tailscale_apt_key = jsonencode(file("${path.module}/cloudinit/tailscale.key"))
    docker_apt_key    = jsonencode(file("${path.module}/cloudinit/docker.key"))
    zshrc             = filebase64("${path.module}/cloudinit/zshrc")
    tailscale_key     = tailscale_tailnet_key.drone_master.key
    drone_compose     = filebase64("${path.module}/cloudinit/drone/master-docker-compose.yaml")
    caddyfile         = filebase64("${path.module}/cloudinit/drone/Caddyfile")
    env_file          = base64encode(local.drone_master_env_file)
  })

  tags = [
    for tag in ["drone", "tailscale"] : digitalocean_tag.tag[tag].id
  ]
}

resource "digitalocean_droplet" "drone_runner" {
  count             = local.drone_runners
  name              = "runner-${count.index + 1}"
  image             = "debian-11-x64"
  size              = "s-2vcpu-2gb"
  region            = "nyc1"
  ssh_keys          = [digitalocean_ssh_key.personal.id]
  graceful_shutdown = true
  monitoring        = true

  user_data = templatefile("${path.module}/cloudinit/drone/runner-user-data.yaml.tftpl", {
    tailscale_apt_key = jsonencode(file("${path.module}/cloudinit/tailscale.key"))
    docker_apt_key    = jsonencode(file("${path.module}/cloudinit/docker.key"))
    zshrc             = filebase64("${path.module}/cloudinit/zshrc")
    tailscale_key     = tailscale_tailnet_key.drone_runners[count.index].key
    drone_compose     = filebase64("${path.module}/cloudinit/drone/runner-docker-compose.yaml")
    env_file          = base64encode(local.drone_runner_env_file)
  })

  tags = [
    for tag in ["drone", "tailscale"] : digitalocean_tag.tag[tag].id
  ]
}
