# Use the highly stable, production-tested Alpine XFCE base image from GitHub
FROM jlesage/baseimage-gui:alpine-3.18-xfce-v4

# Install SSH server, Git, and build tools for themes
RUN apk update && apk add --no-cache \
    openssh \
    bash \
    curl \
    sudo \
    git \
    gnome-themes-extra

# Create user luffy and set password
RUN adduser -D -s /bin/bash luffy && \
    echo "luffy:luffy@2000" | chpasswd && \
    echo "luffy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Generate host keys for SSH and configure it to run in the background
RUN ssh-keygen -A && \
    mkdir -p /var/run/sshd && \
    echo "PermitRootLogin yes" >> /etc/ssh/sshd_config

# Clone and install the WhiteSur macOS GTK theme globally
RUN git clone https://github.com /tmp/whitesur && \
    cd /tmp/whitesur && \
    ./install.sh -t all -s all && \
    rm -rf /tmp/whitesur

# Set up automatic initialization for the SSH server inside the base init system
RUN mkdir -p /etc/services.d/sshd && \
    echo '#!/with-contenv sh' > /etc/services.d/sshd/run && \
    echo 'exec /usr/sbin/sshd -D' >> /etc/services.d/sshd/run && \
    chmod +x /etc/services.d/sshd/run

# Configure environment variables required by the GitHub base image
ENV APP_NAME="Railway macOS Desktop" \
    USER_ID=1000 \
    GROUP_ID=1000 \
    DISPLAY_WIDTH=1280 \
    DISPLAY_HEIGHT=800

# Expose noVNC web access port (5800 is the default port for this base image) and SSH (22)
EXPOSE 5800 22
