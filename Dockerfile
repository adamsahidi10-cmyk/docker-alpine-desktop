FROM alpine:edge

# Install essential system packages, XFCE desktop environment, supervisor, and themes
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
    udev \
    sudo \
    supervisor \
    git \
    gstreamer

# Create user luffy and assign password
RUN adduser -D -s /bin/bash luffy && \
    echo "luffy:luffy@2000" | chpasswd && \
    echo "luffy ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Download and install WhiteSur macOS theme directly to system space
RUN git clone https://github.com /tmp/whitesur && \
    cd /tmp/whitesur && \
    ./install.sh -t all -s all && \
    rm -rf /tmp/whitesur

# Generate host keys and establish vital socket system directory paths
RUN ssh-keygen -A && \
    mkdir -p /var/run/sshd /var/log/supervisor /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix

# Force WhiteSur UI configuration defaults down to the luffy home directory path profile
RUN mkdir -p /home/luffy/.config/xfce4/xfconf/xfce-perchannel-xml/ && \
    echo '<?xml version="1.0" encoding="UTF-8"?><channel name="xsettings" version="1.0"><property name="Net" type="empty"><property name="ThemeName" type="string" value="WhiteSur-Light"/></property></channel>' > /home/luffy/.config/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml && \
    chown -R luffy:luffy /home/luffy/.config

COPY supervisord.conf /etc/supervisord.conf

EXPOSE 22 8080 5900

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
