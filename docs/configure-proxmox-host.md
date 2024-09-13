## Create `mike` User

Navigate to Datacenter > Permissions.

Under users, `mike` gets `PVEAdmin` permissions.

Sign into the shell as root and run `passwd -d mike` to remove the user's password.

## Setup 2FA for logging in as the root user.

If this is genuinely being done for the first time, follow [these steps](./configure-new-vm.md#configure-2fa). It is not necessary to add the `Match User root...` as we do not want to permit as root to the proxmox host.

Keep note of the secret key because this will be used to setup 2FA authentication for the root user to the web portal and in other VMs.

## Run Proxmox Post Install Script

[Link](./proxmox-helper-scripts.md#proxmox-ve-post-install)

## Install Packages

`apt-get install vim sudo keychain`

## Generate SSH Keys

Generate SSH keys for both the `root`. Copy the public key to this repo's `publickey` file.

## Configure SSH

1. `PasswordAuthentication no`
2. `PermitRootLogin no`

Restart ssh daemon `service ssh restart`

## Configure certificates

This is not really necessary.

1. Add Cloudflare account using an API token providing edit permissions for the `Zone.Zone` and `Zone.DNS` scopes. 
2. Add acme account using DNS challenge. domain should be `pve1.local.michaelcook.dev` (or whatever the name of the proxmox host is).
3. "Order Certificates Now"