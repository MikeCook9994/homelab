# Proxmox USB Passthrough

To run octoprint we need to passthrough the USB device connected to the printer from the linux host to the LXC container where the docker container will run. The docker compose file for octoprint
handles the device mapping into the docker container, but the following steps need to be done first.

## Identity the device

Run `lsusb` on the server. The 3D printer itself should show up with with the name "QinHeng Electronics CH340 serial converter". Given the bus and device numbers in the output, we can compose the device path as follows: `/dev/bus/usb/<bus #>/<device #>. The bus and device numbers should be padded out to 3 digits.

Now run `ls -la <device path>` to find the major and minor device numbers. They will be the comma seperated numbers that proceed date in the command output.

## Edit the containers conf file

`vim /etc/pve/lxc/<container_id>.conf`. The container id is the id number of the container that will host the docker container. This appears next to the LXC container's listing in the sidebar. Add the following to this file:

`lxc.cgroup.devices.allow: c <major #>:* rwm`
`lxc.mount.entry: /dev/ttyUSB0 dev/ttyUSB0 none bind,optional,create=file`

> Important: The target device path does not start with a `/`