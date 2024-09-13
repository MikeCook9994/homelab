## Configure certificates

This is not really necessary.

1. Add Cloudflare account using an API token providing edit permissions for the `Zone.Zone` and `Zone.DNS` scopes. 
2. Add acme account using DNS challenge. domain should be `pve1.local.michaelcook.dev` (or whatever the name of the proxmox host is).
3. "Order Certificates Now"

## Create users

`useradd -m -s /usr/bin/bash -G sudo mike && mkdir /home/mike/.ssh && chown mike:mike /home/mike/.ssh && passwd -d mike`

`useradd -m -s /usr/bin/bash -G sudo deployer && mkdir /home/deployer/.ssh && chown deployer:deployer /home/deployer/.ssh && passwd -d deployer`

## Setup 2FA for logging in as the root user.

If this is being done for the first time, follow [these steps](./configure-new-vm.md#configure-2fa). It is not necessary to add the `Match User root...` as we do not want to permit as root to the proxmox host.

Keep note of the secret key because this will be used to setup 2FA authentication for the root user to the web portal and in other VMs.

## Run Proxmox Post Install Script

[Link](./proxmox-helper-scripts.md#proxmox-ve-post-install)

## Install Packages

`apt-get install vim sudo keychain`

## Generate SSH Keys

Generate SSH keys for the `root` user. Copy the public key to this repo's `publickey` file.

## Configure SSH

1. `PasswordAuthentication no`
2. `PermitRootLogin no`

Restart ssh daemon `service ssh restart`

## Copy authorized keys

Copy the appropriate public keys in the `publickey` file on this repository to each the mike, deployer, and root user's `authorized_keys` files.

