!/bin/bash

# Function to keep services alive if they fail, abort, or get killed
monitor_service() {
    while true; do
        "$@"
        echo "Service crashed or stopped. Restarting in 2 seconds..."
        sleep 2
    done
}

# Start SSH daemon
monitor_service /usr/sbin/sshd -D &

# Start Xvfb virtual display
export DISPLAY=:0
monitor_service Xvfb :0 -screen 0 1280x800x24 &
sleep 2

# Start XFCE desktop
monitor_service startxfce4 &

# Start VNC server
monitor_service x11vnc -display :0 -forever -nopw -listen localhost -xkb &

# Start noVNC web interface mapping to VNC
monitor_service websockify --web=/usr/share/novnc 8080 localhost:5900 &

wait
