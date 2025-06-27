#!/bin/bash

set -e # Exit on any command failure

ALLOWED_IPS_FILE="/etc/iptables/allowed-ips.txt"
EXT_IF="ens66"


[[ -f "$ALLOWED_IPS_FILE" ]] || touch "$ALLOWED_IPS_FILE"


iptables -F DOCKER-USER
iptables -I DOCKER-USER -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A DOCKER-USER -i "$EXT_IF" -j DROP
iptables -A DOCKER-USER -j RETURN

while IFS= read -r ip; do
    [[ -z "$ip" ]] && continue
    iptables -I DOCKER-USER 2 -i "$EXT_IF" -s "$ip" -j ACCEPT
done < "$ALLOWED_IPS_FILE"

