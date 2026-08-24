#!/bin/bash

# Define password from Environment Variable or default to 'railway123'
DESKTOP_PASSWORD=${PASSWORD:-railway123}

echo "Setting user credentials..."
echo "alpineuser:$DESKTOP_PASSWORD" | chpasswd
echo "root:$DESKTOP_PASSWORD" | chpasswd

# 1. Start SSH Service
echo "Starting OpenSSH Server..."
/usr/sbin/sshd

# 2. Start Virtual Display (Xvfb)
echo "Starting Xvfb Virtual Display..."
Xvfb :0 -screen 0 1280x800x24 &
sleep 2

# 3. Start Desktop Environment
echo "Starting XFCE Desktop..."
DISPLAY=:0 startxfce4 &

# 4. Start VNC Server with Authentication
echo "Setting up VNC authentication..."
mkdir -p /home/alpineuser/.vnc
x11vnc -storepasswd "$DESKTOP_PASSWORD" /home/alpineuser/.vnc/passwd
chown -R alpineuser:alpineuser /home/alpineuser/.vnc

echo "Starting VNC Server on port 5900..."
x11vnc -display :0 -rfbauth /home/alpineuser/.vnc/passwd -rfbport 5900 -forever -shared &

# 5. Start noVNC (Web Browser Access on Railway PORT)
HTTP_PORT=${PORT:-8080}
echo "Starting noVNC proxy on port $HTTP_PORT..."
/usr/share/novnc/utils/novnc_proxy --vnc localhost:5900 --listen $HTTP_PORT &

# 6. Start XRDP Server (Remote Desktop)
echo "Starting XRDP Server..."
rm -f /var/run/xrdp/xrdp*.pid
/usr/sbin/xrdp-sesman
/usr/sbin/xrdp --nodaemon
