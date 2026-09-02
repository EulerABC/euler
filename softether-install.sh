#!/bin/bash

set -e

INSTALL_DIR="/etc/softether"
FILE="softether-vpnserver-v4.44-9807-rtm-2025.04.16-linux-x64-64bit.tar.gz"
URL="https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.44-9807-rtm/$FILE"

apt update
apt install -y build-essential wget

mkdir -p /etc/softether
cd /etc/softether

wget -O "softether-vpnserver-v4.44-9807-rtm-2025.04.16-linux-x64-64bit.tar.gz" "https://github.com/SoftEtherVPN/SoftEtherVPN_Stable/releases/download/v4.44-9807-rtm/softether-vpnserver-v4.44-9807-rtm-2025.04.16-linux-x64-64bit.tar.gz"
tar -xzf "$FILE"

cd vpnserver
make

cat > /etc/systemd/system/vpnserver.service <<'EOF'
[Unit]
Description=SoftEther VPN Server
After=network.target

[Service]
Type=forking
ExecStart=/etc/softether/vpnserver/vpnserver start
ExecStop=/etc/softether/vpnserver/vpnserver stop
ExecReload=/etc/softether/vpnserver/vpnserver restart
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now vpnserver
