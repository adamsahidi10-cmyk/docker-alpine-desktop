FROM alpine:edge

# Install essential packages, desktop, and tools
RUN apk update && apk add --no-cache \
    bash \
    curl \
    openssh \
    xvfb \
    x11vnc \
    novnc \
    websockify \
    xfce4 \
    xfce4-terminal \
    dbus-x11 \
    eudev \
    sudo

# Create user luffy
RUN adduser -D -s /bin/bash luffy && \
    echo "luffy:luffy@2000" | chpasswd && \
    echo "luffy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Configure SSH
RUN ssh-keygen -A
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Setup startup script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 22 8080 5900

CMD ["/entrypoint.sh"]
