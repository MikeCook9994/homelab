#!/bin/sh

# https://www.reddit.com/r/pihole/comments/j2slcz/pihole_in_docker_using_macvlan_working_correctly/
# macvlan's can't communicate with the host (and vice versa) without an intermediary network interface
# this script 
# 1) creates that interface
# 2) assigns it an ip
# 3) creates a route between it and the macvlan configured by the docker compose

ip link add mvlan0 link eth0 type macvlan mode bridge
ip link set dev mvlan0 up
ip addr add 192.168.1.254/24 dev mvlan0
ip route add 192.168.1.57 dev mvlan0