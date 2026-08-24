FROM alpine:3.19

# تثبيت الواجهة الرسومية XFCE وبيئات الاتصال SSH و RDP و VNC وأدوات المظهر
RUN apk update && apk add --no-cache \
    xfce4 \
    xfce4-terminal \
    xfconf \
    gstreamer \
    gst-plugins-good \
    xrdp \
    xvfb \
    x11vnc \
    openssh \
    supervisor \
    bash \
    sudo \
    util-linux \
    dbus \
    ttf-dejavu \
    faenza-icon-theme

# إعداد مستخدم النظام وتعيين كلمة المرور للـ root والاتصالات عن بعد
RUN echo "root:mrcracker" | chpasswd

# إعداد خدمة SSH وتفعيل صلاحيات الدخول للـ root
RUN ssh-keygen -A && \
    sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# إعداد وتكوين خادم XRDP (RDP) ليعمل مع واجهة XFCE
RUN mkdir -p /var/run/xrdp && \
    chmod 755 /var/run/xrdp && \
    echo "xfce4-session" > /root/.xsession

# إعداد ملفات التكوين لأداة Supervisor لإدارة تشغيل الخدمات معاً
RUN mkdir -p /etc/supervisor.d/
COPY supervisord.conf /etc/supervisor.d/supervisord.ini

# فتح المنافذ الخاصة بـ SSH و RDP و VNC
EXPOSE 22 3389 5900

# تشغيل أداة مدير العمليات لتشغيل كافة الواجهات والخدمات تلقائياً
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor.d/supervisord.ini"]
