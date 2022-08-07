FROM ubuntu:20.04 AS build
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    systemd systemd-sysv dbus dbus-user-session
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

FROM build
#USER root
RUN apt install -y gnupg2
WORKDIR /app
COPY /nordvpn-release_1.0.0_all.deb /app
RUN dpkg -i /app/nordvpn-release_1.0.0_all.deb
RUN apt install -f
#CMD ["nordvpnd"]
#CMD systemctl start nordvpnd
#CMD systemctl status nordvpnd
ADD nord_service.sh /app
CMD ["/bin/bash", "nord_service.sh"]
ENTRYPOINT [ "/app/nord_service.sh"]
#ENTRYPOINT ["/usr/bin/nordvpnd", "-g", "daemon off;"]
