## Run Proxmox Post Install Script

[Link](./proxmox-helper-scripts.md#proxmox-ve-post-install)

## Install Packages

`apt-get install vim`

## Create `mike` User

Use the web interface

## Generate SSH Keys

Generate SSH keys for both the `root` and `mike` users. Add each user's public key to their own `authorized_keys` file.

## Configure SSH

1. `PasswordAuthentication no`
2. `PermitRootLogin no`

Restart ssh daemon `service ssh restart`