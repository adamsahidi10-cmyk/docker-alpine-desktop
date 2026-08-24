# Use Alpine Linux as the base image
FROM alpine:3.18

# Install system dependencies, XFCE desktop, and tools
RUN apk update && apk add --no-cache \
    openssh \
    bash \
    sudo \
    supervisor \
    xvfb \
    x11vnc \
    dbus \
    ttf-dejavu \
    # XFCE Desktop Ecosystem
    xfce4 \
    xfce4-terminal \
    xfce4-screenshooter \
    thunar \
    faenza-icon-theme \
    # XRDP Requirements
    xrdp \
    xvfb-run

# Configure SSH
RUN ssh-keygen -A && \
    echo "root:RailwayDocker2026!" | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Configure XRDP and XFCE Session
RUN echo "xfce4-session" > ~/.xsession && \
    sed -i 's/allowed_users=console/allowed_users=anybody/' /etc/xrdp/Xwrapper.config

# Create Supervisor configuration for multi-process management
RUN mkdir -p /etc/supervisor/conf.d
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Expose required ports (SSH: 22, RDP: 3389, VNC: 5900, Web VNC Alternative: 8080)
EXPOSE 22 3389 5900 8080

# Start Supervisor to run all services simultaneously
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
