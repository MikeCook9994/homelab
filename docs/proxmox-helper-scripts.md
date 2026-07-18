# Proxmox Community Scripts

The following scripts are provided by the [Proxmox Community Scripts](https://community-scripts.org/) project.

## Proxmox Host Scripts

### Proxmox VE Post Install
[Link](https://community-scripts.org/scripts/post-pve-install)

Accept **yes** to all prompts.

### Proxmox Kernel Clean
[Link](https://community-scripts.org/categories?category=proxmox-and-virtualization&preview=kernel-clean)

## LXC Management Scripts

### PVE LXC Cleanup

[Link](https://community-scripts.org/categories?category=proxmox-and-virtualization&preview=update-lxcs)

This script should be executed from the proxmox shell, rather than over SSH.

### Proxmox VE LXC Filesystem Trim

[Link](https://community-scripts.org/categories?category=proxmox-and-virtualization&preview=fstrim)

## LXC Creation Scripts

### Docker LXC
[Link](https://community-scripts.org/categories?category=containers-and-docker&preview=docker)

This script should be executed from the proxmox shell, rather than over SSH.

Prompt responses
1. Distro: Ubuntu
2. Distro Version: Noble 24.04
3. Privilegd or Unprivileged: 0 Privileged
4. Root Password: *enter password*
5. Container Id: 100
6. Hostname: docker-lxc
7. Disk Size: 4
8. Cores: 2
9. RAM (Mb): 1024
10. Network Interface Device: vmbr0
11. Static Ip or DHCP: dhcp
12. <blank>
13. no
14. <blank>
15. <blank>
16. <blank>
17. <blank>
18. <blank>
19. Verbose Output: Yes

After the container is created, you will be asked if you want to add the following:
* portainer: no
* portainer agent: no
* docker compose: yes

Once completed, the following other documentation pages should be completed
1. [Configuring Authentication](./configuring-authentication.md)

### PiHole LXC

[Link](https://tteck.github.io/Proxmox/#pi-hole-lxc)