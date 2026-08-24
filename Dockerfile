FROM alpine:3.20

# Install XFCE core, light utilities, and the ultra-light Midori browser
RUN apk update && apk add --no-cache \
    xfce4 \
    xfce4-terminal \
    xvfb \
    x11vnc \
    supervisor \
    bash \
    novnc \
    midori \
    && ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Environmental settings
ENV DISPLAY=:1

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Permissions for Railway's ephemeral container structure
RUN chmod -R 777 /tmp

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
