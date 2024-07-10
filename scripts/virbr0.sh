#!/usr/bin/env bash

set -euxo pipefail

ip link add virbr0 type bridge
ip address ad dev virbr0 10.25.0.1/24
ip link set dev virbr0 up

iptables -A FORWARD -i virbr0 -o wlo1 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i virbr0 -o wlo1 -j ACCEPT
iptables -t nat -A POSTROUTING -o wlo1 -j MASQUERADE
