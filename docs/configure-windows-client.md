## Generate SSH Keys

Do the thing

## Configure SSH agent

`Get-Service ssh-agent`
`Set-Service -StartupType Automatic`
`ssh-agent`
`ssh-add`

## Setting up WSL

From the WSL host:
`wsl --unregister`
`wsl --install -d Ubuntu 24.04`

From the WSL terminal:
`apt update && apt upgrade`

[Create the `mike` user](./configure-new-vm.md#create-mike-user)
[Passwordless sudo for `mike`](./configure-new-vm.md#passwordless-sudo-for-mike)

`cp -r /mnt/c/Users/Mike/.ssh/. /home/mike/.ssh/`
`chown -R mike:mike /home/mike/.ssh`
`chmod 770 /home/mike/.ssh && chmod 600 /home/mike/.ssh/*`
`apt install keychain`
`passwd -d mike`

Edit `/home/mike/.ssh` Add the following

```bash
# starts keychain to help persist ssh passphrases between terminals 
/usr/bin/keychain -q --nogui $HOME/.ssh/id_rsa
source $HOME/.keychain/$(hostname)-sh
```

From the WSL host:
`ubuntu2404 config --default-user mike`

## Installing Ansible

### Install Global Packages

`apt install software-properties-common`
`apt install python3-pip python3-venv`

### Configure Python Virtual Environment

`mkdir ~/python-venv`
`cd ~/python-venv`
`python3 -m venv ansible`
`source ansible/bin/activate`
`python3 -m pip install --upgrade pip`
`python3 -m pip install ansible`
`python3 -m pip install setuptools`
`ansible-galaxy collection install azure.azcollection --force`
`pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt`

### Install Az CLI

Windows will make its cli available to linux which breaks session token availability. Install the CLI locally to resolve this.

`curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash`