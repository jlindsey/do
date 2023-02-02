# resource "digitalocean_reserved_ip" "minecraft" {
#   droplet_id = digitalocean_droplet.mc.id
#   region     = digitalocean_droplet.mc.region
# }

# resource "digitalocean_record" "minecraft" {
#   domain = data.digitalocean_domain.jlindsey_me.id
#   type   = "A"
#   ttl    = 300
#   name   = "minecraft"
#   value  = digitalocean_reserved_ip.minecraft.ip_address
# }
#
# resource "digitalocean_volume" "mc" {
#   region      = "nyc1"
#   name        = "minecraft"
#   size        = 50
#   description = "minecraft world storage"
# }

# resource "digitalocean_droplet" "mc" {
#   name              = "minecraft"
#   image             = "debian-11-x64"
#   size              = "s-4vcpu-8gb"
#   region            = "nyc1"
#   ssh_keys          = [digitalocean_ssh_key.personal.id]
#   volume_ids        = [digitalocean_volume.mc.id]
#   graceful_shutdown = true
#   monitoring        = true

#   user_data = templatefile("${path.module}/cloudinit/minecraft/mc.yaml.tftpl", {
#     tailscale_apt_key = jsonencode(file("${path.module}/cloudinit/tailscale.key"))
#     corretto_apt_key  = jsonencode(file("${path.module}/cloudinit/minecraft/corretto.key"))
#     zshrc             = filebase64("${path.module}/cloudinit/zshrc")
#     tailscale_key     = tailscale_tailnet_key.minecraft.key
#     download_helper   = filebase64("${path.module}/cloudinit/minecraft/download-helper.sh")
#   })

#   tags = [
#     for tag in ["minecraft", "tailscale"] : digitalocean_tag.tag[tag].id
#   ]
# }

# output "minecraft_ip" {
#   description = "Reserved static IP attached to the Minecraft server"
#   value       = digitalocean_reserved_ip.minecraft.ip_address
# }
