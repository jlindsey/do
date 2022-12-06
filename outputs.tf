output "git_public_ip" {
  value = digitalocean_droplet.git.ipv4_address
}
