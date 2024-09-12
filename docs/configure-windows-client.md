## Generate SSH Keys

Do the thing

## Configure SSH agent

`Get-Service ssh-agent`
`Set-Service -StartupType Automatic`
`ssh-agent`
`ssh-add`

## Setting up WSL

`wsl --unregister`
`wsl --install -d Ubuntu 24.04`
`apt update`
`apt upgrade`

[Create the `mike` user](./configure-new-vm.md#create-mike-user)
[Passwordless sudo for `mike`](./configure-new-vm.md#passwordless-sudo-for-mike)

`cp -r /mnt/c/Users/Mike/.ssh/. /home/mike/.ssh/`
`chown -R mike:mike /home/mike/.ssh`
`chmod 770 /home/mike/.ssh && chmod 600 /home/mike/.ssh/*`
`apt install keychain`
`passwd -d mike`

Edit `/home/mike/.ssh` Add the following

```bash
/usr/bin/keychain -q --nogui $HOME/.ssh/id_rsa
source $HOME/.keychain/$(hostname)-sh
```

## Installing Ansible

`apt install software-properties-common`
`apt-add-repository --yes --update ppa:...`
`apt install ansible`