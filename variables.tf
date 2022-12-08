variable "drone_gitea_client_id" {
  description = "OAuth2 client ID for the Drone integration in Gitea"
  type        = string
}

variable "drone_gitea_client_secret" {
  description = "OAuth2 client secret for the Drone integration in Gitea"
  type        = string
}

variable "spaces_access_key_id" {
  description = "DigitalOcean Spaces access key ID (same as for provider)"
  type        = string
}

variable "spaces_secret_access_key" {
  description = "DigitalOcean Spaces secret access key (same as for provider)"
  type        = string
}
