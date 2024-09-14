## Configure certificates

This is not really necessary.

1. Add Cloudflare account using an API token providing edit permissions for the `Zone.Zone` and `Zone.DNS` scopes. 
2. Add acme account using DNS challenge. domain should be `pve1.local.michaelcook.dev` (or whatever the name of the proxmox host is).
3. "Order Certificates Now"

## Setup 2FA for logging in as the root user.

If this is being done for the first time, follow [these steps](./configure-new-vm.md#configure-2fa). It is not necessary to add the `Match User root...` as we do not want to permit as root to the proxmox host.

Keep note of the secret key because this will be used to setup 2FA authentication for the root user to the web portal and in other VMs.

## Run Proxmox Post Install Script

[Link](./proxmox-helper-scripts.md#proxmox-ve-post-install)

## Install Packages

`apt-get install vim sudo keychain`

## Create users

`useradd -m -s /usr/bin/bash -G sudo mike && mkdir /home/mike/.ssh && chown mike:mike /home/mike/.ssh && passwd -d mike`

`useradd -m -s /usr/bin/bash -G sudo deployer && mkdir /home/deployer/.ssh && chown deployer:deployer /home/deployer/.ssh && passwd -d deployer`

If this is a fresh deployment, generate a password for the `deployer` user. Then...
1. Create an environment variable in the github repo called `DEPLOYER_SUDO_PASSWORD` and set it equal to the value. 
2. Run `passwd deployer` and set the password equal to the value stored in the `deployerSudoPassword` secret in the keyvault.

## Passwordless sudo

as `root`, `EDITOR=vim visudo`. Add `mike ALL=(ALL) NOPASSWD:ALL` to the `/etc/sudoers` file.

## Generate SSH Keys

Generate SSH keys for the `root` user. Copy the public key to this repo's `publickey` file.

## Copy authorized keys

Copy the appropriate public keys in the `publickey` file on this repository to each the mike, deployer, and root user's `authorized_keys` files.

## Configure SSH

1. `PasswordAuthentication no`
2. `PermitRootLogin no`

Restart ssh daemon `service ssh restart`

## Setup SSH Agent

Add the following to `/root/.bashrc`

```bash
# starts keychain to help persist ssh passphrases between terminals 
/usr/bin/keychain -q --nogui $HOME/.ssh/id_ed25519
source $HOME/.keychain/$(hostname)-sh
```

This will automatically start the ssh agent
