#!/bin/bash

set -e  # Exit on any error


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

