These steps should be executed on a new LXC or VM to consistently configure login across devices.

## Install Packages

`apt-get install vim`

## Create `mike` User

Run `useradd -m -s /usr/bin/bash -G sudo mike && mkdir /home/mike/.ssh && chown mike:mike /home/mike/.ssh`

If this is a docker vm/lxc run `usermod -aG docker mike`

We intentionally don't set a password so the user cannot be signed into locally, only via ssh.

## Passwordless sudo for `mike`

as `root`, `EDITOR=vim visudo`. Add `mike ALL=(ALL) NOPASSWD:ALL` to the `/etc/sudoers` file.

## generate SSH Keys for `mike`

`login mike`
`ssh-keygen`

Add the public key to your github account

## Setup SSH Agent

Add the following to `/home/mike/.bashrc`

```bash
if [ -z "$SSH_AUTH_SOCK" ] ; then
    eval `ssh-agent -s`
fi
```

This will automatically start the 

## Copy authorized keys

Copy the authorized keys for the root user on the proxmox host to the root and mike user's ssh folders on the LXC/vm

`scp 192.168.1.100:/root/.ssh/authorized_keys /root/.ssh/authorized_keys`
`scp 192.168.1.100:/home/mike/.ssh/authorized_keys /home/mike/.ssh/authorized_keys && chown mike:mike /home/mike/.ssh/authorized_keys`

## Configure SSH

Make the following changes to `/etc/ssh/sshd_config`

1. `PasswordAuthentication no`
2. `PermitRootLogin no`

Restart the ssh service: `service ssh restart`.

## Configure 2FA

Execute `apt-get install libpam-google-authenticator`
Execute `google-authenticator -t -d -f -r 3 -R 30 -w 3`
  * Take note of the secret key and recovery codes
  * Add the authenticator to your mobile phone's TOTP password
Execute `cp ~/.google-authenticator /home/mike && chown mike:mike /home/mike/.google-authenticator`

Edit `/etc/pam.d/sshd`
  * Add `auth required pam_google_authenticator.so` to the bottom

Edit `/etc/ssh/sshd_config`
  * `KbdInteractiveAuthentication yes`
  * `AuthenticationMethods publickey, keyboard-interactive`
  * `UsePAM yes`
  * Add `Match User root Address 192.168.1.100` to the bottom
    * `PermitRootLogin yes`

Execute `service ssh restart`

## Create Template

If this is an LXC/VM that multiple instances will be needed off, create a template so new instances can quickly be spun up.