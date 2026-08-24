FROM voidlinux/voidlinux:latest

# Update system and install the absolute bare minimum for a GUI
RUN xbps-install -Syu && xbps-install -y \
    openbox \
    xterm \
    xorg-server-xvfb \
    x11vnc \
    supervisor \
    bash \
    novnc \
    && ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Environmental settings
ENV DISPLAY=:1

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Match Railway's ephemeral runtime permissions
RUN chmod -R 777 /tmp

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
