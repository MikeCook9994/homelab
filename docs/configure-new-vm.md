These steps should be executed on a new LXC or VM to consistently configure login across devices.

## Install Packages

`apt-get install vim keychain`

## Create Users

[Create mike and deployer users](./configure-proxmox-host.md#create-users)

If this is a docker vm/lxc run `usermod -aG docker mike` and `usermod -aG docker deployer`

Set the `deployer` user's password to the value of the `deployerSudoPassword` stored in the keyvault.

## Passwordless sudo

[Grant mike passwordless sudo permissions](./configure-proxmox-host.md#passwordless-sudo)

## generate SSH Keys for `mike`

`login mike`
`ssh-keygen`

Add the public key to your github account and copy it to this repo's `publickey` file.

## Configure SSH

Make the following changes to `/etc/ssh/sshd_config`

1. `PasswordAuthentication no`
2. `PermitRootLogin no`

Restart the ssh service: `service ssh restart`.

## Copy authorized keys

Copy the appropriate public keys in the `publickey` file on this repository to each the mike, deployer, and root user's `authorized_keys` files.

## Setup SSH Agent

Add the following to `/home/mike/.bashrc`

```bash
# starts keychain to help persist ssh passphrases between terminals 
/usr/bin/keychain -q --nogui $HOME/.ssh/id_ed25519
source $HOME/.keychain/$(hostname)-sh
```

This will automatically start the ssh agent

## Configure 2FA

If this was already done on the host OS, copy the google authenticator settings to the `root` and `mike` users from that node.

Execute `apt-get install libpam-google-authenticator`
Execute `google-authenticator -t -d -f -r 3 -R 30 -w 3`
  * Take note of the secret key and recovery codes
  * Add the authenticator to your mobile phone's TOTP password
Execute `cp ~/.google-authenticator /home/mike && chown mike:mike /home/mike/.google-authenticator`

Edit `/etc/pam.d/sshd`
  * Comment out `@include common-auth`
  * Add `auth required pam_google_authenticator.so` to the bottom

Edit `/etc/ssh/sshd_config`
  * `KbdInteractiveAuthentication yes`
  * `AuthenticationMethods publickey,keyboard-interactive`
  * `UsePAM yes`
  * Add `Match User root Address <pve1_host_ip>` to the bottom
    * `PermitRootLogin yes`
  * Add `Match Group deployer` to the bottom
    * `AuthenticationMethods publickey`

Execute `service ssh restart`

## Create Template

If this is an LXC/VM that multiple instances will be needed off, create a template so new instances can quickly be spun up.