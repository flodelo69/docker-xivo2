# XiVO docker installation
FROM debian:7.8
MAINTAINER Florian Dufour "flodelo69@gmail.com"

# Set ENV
ENV DEBIAN_FRONTEND noninteractive
ENV LANG fr_FR.UTF-8
ENV HOME /root

# Add necessary files
ADD http://mirror.xivo.fr/fai/xivo-migration/xivo_install_current.sh /root/xivo_install_current.sh
ADD xivo-service /root/xivo-service
ADD asterisk.sql /tmp/asterisk.sql

# Chmod
RUN chmod +x /root/xivo_install_current.sh
RUN chmod +x /root/xivo-service

# Add non-free repo
RUN echo "deb http://http.debian.net/debian wheezy non-free" >> /etc/apt/sources.list

# Update repo
RUN apt-get -qq update

# Install the needed packages
RUN apt-get -qq -y install \
    apt-utils \
    locales \
    wget \
    vim \
    net-tools \
    rsyslog \
    udev \
    iptables \
    kmod \
    ssh \
    nano \
    tar \
    cron \
    screen

# Update locales
RUN echo "fr_FR.UTF-8 UTF-8" > /etc/locale.gen
RUN locale-gen
RUN dpkg-reconfigure locales

# ------------------- EN COURS ---------------------
# VOLUME XiVO (DB+DATA) /MonHote/path:/monconteneur/path
# VOLUME DB
#VOLUME /xivo/xivo1/db:/varmydb
# VOLUME Data :
#VOLUME /xivo/xivo1/etc/asterisk:/etc/asterisk
#VOLUME /xivo/xivo1/etc/dahdi:/etc/dahdi
#VOLUME /xivo/xivo1/etc/dhcp:/etc/dhcp
#VOLUME /xivo/xivo1/etc/hostname:/etc/hostname
#VOLUME /xivo/xivo1/etc/hosts:/etc/hosts
#VOLUME /xivo/xivo1/etc/network/interfaces:/etc/network/interfaces
#VOLUME /xivo/xivo1/etc/ntp.conf:/etc/ntp.conf
#VOLUME /xivo/xivo1/etc/xivo:/etc/xivo
#VOLUME /xivo/xivo1/etc/resolv.conf:/etc/resolv.conf
#VOLUME /xivo/xivo1/etc/wanpipe:/etc/wanpipe
#VOLUME /xivo/xivo1/var/lib/asterisk/:/var/lib/asterisk/
#VOLUME /xivo/xivo1/var/lib/xivo/:/var/lib/xivo/
#VOLUME /xivo/xivo1/var/lib/xivo-provd:/var/lib/xivo-provd
#VOLUME /xivo/xivo1/var/log/asterisk/:/var/log/asterisk/
#VOLUME /xivo/xivo1/var/spool/asterisk/:/var/spool/asterisk/
#VOLUME /xivo/xivo1/var/backups/xivo:/var/backups/xivo
#VOLUME /xivo/xivo1/var/lib/xivo/sounds:/var/lib/xivo/sounds
#VOLUME /xivo/xivo1/var/lib/asterisk/sounds/custom:/var/lib/asterisk/sounds/custom
#VOLUME /xivo/xivo1/var/lib/asterisk/moh:/var/lib/asterisk/moh
#VOLUME /xivo/xivo1/var/spool/asterisk/voicemail:/var/spool/asterisk/voicemail
#VOLUME /xivo/xivo1/var/spool/asterisk/monitor:/var/spool/asterisk/monitor
# ------------------- EN COURS ---------------------

# Install XiVO
RUN /root/xivo_install_current.sh

# Fix
RUN rm /usr/sbin/policy-rc.d
RUN touch /etc/network/interfaces

# Set password
RUN echo "root:superxivo" | chpasswd

# Clean
RUN apt-get clean
RUN rm /root/xivo_install_current.sh

EXPOSE 22 80 443 5003 5060 50051
CMD ["/root/xivo-service", "loop"]
