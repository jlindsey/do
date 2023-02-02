# Personal DigitalOcean Terraform State

Terraform configs for my personal DO-based setup.

## Credentials

Credentials for the Tailscale and DO APIs are provided via environment vars. Making a `.env` file
and putting the vars in there is fine. The following vars are required:

- `DIGITALOCEAN_TOKEN`
- `TAILSCALE_API_KEY`

### Backend Storage

State is stored in a DO Spaces bucket and wired up to the Terraform config using the S3 backend. To
get this to work, you need to do a [partial configuration][1] of the workspace, providing the
`access_key` and `secret_key` variables on the command line.

## Tailscale Tailnet Keys

In order to automatically join the Tailnet, each of the instances is passed a single-use,
pre-authorized key requested by Terraform. Therefore, whenever an instance needs to be recreated,
the associated Tailnet key must be tainted manually. I wish there was a way to link these two
resources together such that it would do this automatically, but I haven't been able to find one.

[1]: https://developer.hashicorp.com/terraform/language/settings/backends/configuration#partial-configuration
