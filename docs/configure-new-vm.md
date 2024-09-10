These steps should be executed on a new LXC or VM to consistently configure login across devices.

## Install Packages

`apt-get install vim`

## Create `mike` User

Run `useradd -m -s /usr/bin/bash -G sudo mike && mkdir /home/mike/.ssh && chown mike:mike /home/mike/.ssh`

We intentionally don't set a password so the user cannot be signed into locally, only via ssh.

## Passwordless sudo for `mike`

as `root`, `EDITOR=vim visudo`. Add `mike ALL=(ALL) NOPASSWD:ALL` to the `/etc/sudoers` file.

## Copy authorized keys

Copy the authorized keys for the root user on the proxmox host to the root and mike user's ssh folders on the LXC/vm

`scp 192.168.1.100:/root/.ssh/authorized_keys /root/.ssh/authorized_keys`
`scp 192.168.1.100:/home/mike/.ssh/authorized_keys /home/mike/.ssh/authorized_keys && chown mike:mike /home/mike/.ssh/authorized_keys`

## Configure SSH

Make the following changes to `/etc/ssh/sshd_config`

1. `PasswordAuthentication no` 

Restart the ssh service: `service ssh restart`.

## Configure 2FA

https://instasafe.com/blog/how-to-set-up-multi-factor-authentication-for-ssh-on-linux/

## Create Template

If this is an LXC/VM that multiple instances will be needed off, create a template so new instances can quickly be spun up.