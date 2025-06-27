# Docker UFW Helper

A simple tool to help manage Docker firewall rules **safely** alongside UFW.  
Docker, by default, bypasses UFW rules — this tool bridges that gap by using a custom script and systemd integration to enforce proper firewall behavior.

---

## 🚨 Why This Tool?

Docker directly manipulates `iptables` rules, often ignoring UFW configurations.  
This can unintentionally expose your containers to the public internet even if UFW is "enabled".

🔗 Read more: [Why Docker and UFW Don't Work Well Together](https://docs.docker.com/engine/network/packet-filtering-firewalls/)

Additionally, tools like `iptables-persistent` are **not compatible** with UFW — installing them may **break or delete** UFW rules.

---

## ⚙️ What This Tool Includes

This tool consists of **two parts**:
- A **CLI utility** (`docker-ufw`) to manage Docker firewall logic manually or programmatically.
- A **systemd service** that applies and maintains firewall rules on boot and after Docker events.

---

## 🧱 Installation

### 1. Clone the Repository

```bash
git clone https://github.com/seifeddineWizz/docker-ufw.git
cd docker-ufw
```

### 2. Find Your External Network Interface
You will be asked to enter your server's external interface during installation.
To find it, you can use:

```bash
ip route get 1.1.1.1
```
### 3. Run the Installer
chmod +x install.sh
sudo ./install.sh

The script performs the following steps:

1. Prompts the user to input the external network interface.
2. Updates internal configurations in `docker-ufw` and `docker-ufw.sh`.
3. Copies the necessary files to the appropriate system locations.
4. Enables and starts the `docker-ufw` systemd service.

## 👮‍♂️ Warning
Do not use `iptables-persistent` alongside UFW if this tool is installed — it may conflict and break rule persistence.

## 🔧 Uninstallation

sudo systemctl disable --now docker-ufw.service
sudo docker-ufw reset
sudo rm /usr/local/bin/docker-ufw
sudo rm -r /etc/iptables
sudo rm /etc/systemd/system/docker-ufw.service
sudo systemctl daemon-reload

## License
MIT License.
Contributions welcome!

