# resource "digitalocean_volume" "mc" {
#   region      = "nyc1"
#   name        = "minecraft"
#   size        = 50
#   description = "minecraft world storage"
# }

# resource "digitalocean_droplet" "mc" {
#   name              = "minecraft"
#   image             = "debian-11-x64"
#   size              = "g-2vcpu-8gb"
#   region            = "nyc1"
#   ssh_keys          = [digitalocean_ssh_key.personal.id]
#   volume_ids        = [digitalocean_volume.mc.id]
#   graceful_shutdown = true
#   monitoring        = true

#   user_data = templatefile("${path.module}/cloudinit/mc.yaml", {
#     tailscale_apt_key = jsonencode(file("${path.module}/cloudinit/tailscale.key"))
#   })

#   tags = [
#     for tag in ["minecraft", "tailscale"] : digitalocean_tag.tag[tag].id
#   ]
# }
