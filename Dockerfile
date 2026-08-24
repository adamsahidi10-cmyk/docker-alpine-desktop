FROM alpine:edge

# Install essential packages: XFCE, XRDP, TigerVNC, OpenSSH, and audio/fonts
RUN apk update && apk upgrade && \
    apk add --no-cache \
    xfce4 \
    xfce4-terminal \
    xrdp \
    tigervnc \
    openssh \
    sudo \
    bash \
    dbus \
    udev \
    ttf-dejavu \
    arc-theme \
    papirus-icon-theme

# Configure SSH user (user: alpine, password: alpine)
RUN adduser -D -s /bin/bash alpine && \
    echo "alpine:alpine" | chpasswd && \
    echo "alpine ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Generate SSH keys
RUN ssh-keygen -A

# Configure XRDP/VNC startup script
RUN mkdir -p /home/alpine/.vnc && \
    echo "alpine" | vncpasswd -f > /home/alpine/.vnc/passwd && \
    chown -R alpine:alpine /home/alpine/.vnc && \
    chmod 0600 /home/alpine/.vnc/passwd

EXPOSE 22 3389 5901

CMD ["sh", "-c", "rc-status; /usr/sbin/sshd -D & Xvnc :1 -geometry 1920x1080 -depth 24 & DISPLAY=:1 startxfce4 & exec xrdp -n"]

