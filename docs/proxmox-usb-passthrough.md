# Proxmox USB Passthrough

To run octoprint we need to passthrough the USB device connected to the printer from the linux host to the LXC container where the docker container will run.

The docker compose file for octoprint handles the device mapping into the docker container, but the following steps need to be done first.

## Identity the device

Identity which device id shows up when the device is plugged in via the contents of the `/dev/serial/by-id` directory. Using `ls -la` will show the symlink to the ttyUSB* file.

Once the ttyUSB* file is idenfitied, run `ls -la /dev/ttyUSB#` for the file. The output will provide two comma separated numbers following the group name. Take note of the first, the cgroup number.

## Create udev rule

If the usb device is directly passed through, it will lack the proper permissions. We need to setup a udev rule to create copies of the device files and assign them the appropriate permissions.

The following commands will create the udev rule and the associated script file

replace the value of `ENV{ID_SERIAL}` with the value provided by the command `udevadm info -q all -name /dev/ttyUSB#`. The same replacement should be made in `SYMLINK` as well. A new udev rule will need to be added for each usb device and a separate script should be created for each each lxc container.

```bash
cat << 'EOF' | sudo tee /etc/udev/rules.d/65-usb-for-container.rules
SUBSYSTEM=="tty", ENV{ID_SERIAL}=="1a86_USB_Serial", SYMLINK+="1a86_USB_Serial-container-link", RUN+="/usr/local/bin/mk_usb-for-warlock.sh"
EOF
```

Replace the container id and container name as needed.

```bash
cat << 'EOF' | sudo tee /usr/local/bin/mk_usb-for-warlock.sh
#!/usr/bin/env bash
sudo rm -f /dev/lxc/220/*container-link && sudo mkdir /dev/lxc && sudo mkdir /dev/lxc/220 && sudo cp -Lrp /dev/*-container-link /dev/lxc/220 && sudo chown 100000:100020 /dev/lxc/220/*
EOF
sudo chmod 0750 /usr/local/bin/mk_usb-for-warlock.sh
```

The final command will reload udev rules to ensure they work correctly

```bash
sudo udevadm control --reload-rules && sudo service udev restart && sudo udevadm trigger
```

## Edit the containers conf file

`vim /etc/pve/lxc/<container_id>.conf`. The container id is the id number of the container that will host the docker container. This appears next to the LXC container's listing in the sidebar. Add the following to this file:

`lxc.cgroup.devices.allow: c <major #>:* rwm`
`lxc.mount.entry: /dev/lxc/220/1a86_USB_Serial-container-link dev/ttyUSB0 none bind,optional,create=file`

> Important: The target device path does not start with a `/`