#!/bin/bash

set -e # Exit on any command failure

ALLOWED_IPS_FILE="/etc/iptables/allowed-ips.txt"

[[ -f "$ALLOWED_IPS_FILE" ]] || touch "$ALLOWED_IPS_FILE"


iptables -F DOCKER-USER
iptables -I DOCKER-USER -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A DOCKER-USER -i docker0 -o docker0  -j ACCEPT
iptables -A DOCKER-USER -j DROP

while IFS= read -r ip; do
    [[ -z "$ip" ]] && continue
    iptables -I DOCKER-USER 2 -s "$ip" -j ACCEPT
done < "$ALLOWED_IPS_FILE"

