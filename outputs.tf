output "public_ips" {
  value = {
    gitea   = digitalocean_droplet.git.ipv4_address
    drone   = digitalocean_droplet.drone_master.ipv4_address
    runners = digitalocean_droplet.drone_runner.*.ipv4_address
  }
}

