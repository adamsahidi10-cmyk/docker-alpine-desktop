FROM alpine:latest

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

# Install XFCE4, X11, XRDP, VNC, SSH, noVNC, and themes
RUN apk add --no-cache \
    bash \
    sudo \
    curl \
    wget \
    openssh \
    xorg-server \
    xfce4 \
    xfce4-terminal \
    xfce4-panel \
    faenza-icon-theme \
    x11vnc \
    xvfb \
    xrdp \
    xorgxrdp \
    novnc \
    websockify \
    python3 \
    dbus

# Create a non-root desktop user
RUN adduser -D -s /bin/bash luffy && \
    echo "luffy ALL=(ALL) ALL" >> /etc/sudoers

# Configure OpenSSH
RUN ssh-keygen -A && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config

# Set up XFCE startup for RDP and VNC
RUN echo "exec startxfce4" > /home/alpineuser/.xsession && \
    chown alpineuser:alpineuser /home/alpineuser/.xsession

# Expose default ports
EXPOSE 8080 22 3389 5900

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
