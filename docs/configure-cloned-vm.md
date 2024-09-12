These steps should be executed when cloning a new VM/LXC from an existing template

## Create Static DHCP reservation

Before even bringing the device online, review the mac address in the VMs network tab and create a static reservation in the unifi portal.

## Regenerate SSH host keys

`rm -v /etc/ssh/ssh_host_*`
`dpkg-reconfigure openssh-server`

## Clone homelab repo

`git clone git@github.com:MikeCook9994/homelab.git`

## Add mike to docker group