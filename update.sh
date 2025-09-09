#!/bin/bash
dnf update -y

sudo dnf install -y glibc glibc-langpack-en libxml2 libxslt libaio zlib

dnf install -y \
bash \
curl \
gawk \
grep \
procps-ng \
sed \
which \
tar \
gzip \
unzip

umask 022

sysctl -w fs.file-max=65536
sysctl -w net.core.rmem_max=12852000 
sysctl -w net.core.wmem_max=12852000 
sysctl -w net.ipv4.tcp_moderate_rcvbuf=1

# To disable SELINUX
sudo sed -i 's/^SELINUX=.*/SELINUX=disabled/' /etc/selinux/config

export INSTALL_CRON=false

#sudo localectl set-locale LC_CTYPE=en_US.UTF-8
