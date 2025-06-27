#!/bin/bash

set -e  # Exit on any error


# Prompt for external interface
read -rp "[?] Enter the external network interface (e.g., eth0, ens3): " EXT_IF

# Optional: validate it's not empty
if [[ -z "$EXT_IF" ]]; then
    echo "[!] Interface cannot be empty. Exiting."
    exit 1
fi


# Update EXT_IF variable in docker-ufw and docker-ufw.sh
echo "[*] Setting EXT_IF=\"$EXT_IF\" in docker-ufw and docker-ufw.sh..."

sed -i "s/^EXT_IF=\".*\"/EXT_IF=\"$EXT_IF\"/" docker-ufw
sed -i "s/^EXT_IF=\".*\"/EXT_IF=\"$EXT_IF\"/" docker-ufw.sh


# Step 1: Copy docker-ufw to /usr/local/bin and make it executable
echo "[*] Installing docker-ufw to /usr/local/bin..."
cp docker-ufw /usr/local/bin/docker-ufw
chmod +x /usr/local/bin/docker-ufw

# Step 2: Ensure /etc/iptables exists, then copy docker-ufw.sh and make it executable
echo "[*] Setting up /etc/iptables directory..."
mkdir -p /etc/iptables
cp docker-ufw.sh /etc/iptables/docker-ufw.sh
chmod +x /etc/iptables/docker-ufw.sh

# Step 3: Copy the systemd service file
echo "[*] Installing systemd service..."
cp docker-ufw.service /etc/systemd/system/docker-ufw.service

# Step 4: Reload systemd, enable and start the service
echo "[*] Enabling and starting docker-ufw service..."
systemctl daemon-reexec
systemctl daemon-reload
systemctl enable docker-ufw.service
systemctl start docker-ufw.service

echo "[+] Installation complete."

