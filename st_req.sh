#!/bin/bash
dnf install dnf -y
dnf update -y

dnf install -y \
glibc \
glibc-langpack-en \
libxml2 \
libxslt \
libaio \
zlib

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

dnf install -y \
glibc.i686 \
zlib.i686 \
libaio \
numactl \
perl-Data-Dumper \
perl-Getopt-Long \
ncurses-compat-libs

export INSTALL_CRON=false

cat <<EOF >> /etc/sysctl.conf

# Custom tuning settings
net.core.rmem_max=12852000
net.core.wmem_max=12852000
net.ipv4.tcp_moderate_rcvbuf=1
fs.file-max=65536
EOF


sysctl -p

sysctl --system

cat <<EOF >> /etc/security/limits.conf

# Custom limits for root
root hard memlock 1048576
root soft nproc 65536
root hard nproc 65536
root soft nofile 65536
root hard nofile 65536
EOF

# Redundant but write for more surity 
sysctl -w fs.file-max=65536
sysctl -w net.core.rmem_max=2096304
sysctl -w net.core.wmem_max=2096394
sysctl -w net.ipv4.tcp_moderate_rcvbuf=1

sysctl -p

service firewalld stop

pro=$(sudo lsof -t -i :8004)
if [[ -n "$pro" ]]; then
echo "A process running on port 8004 needed to kill to start ST installation"
ps -fp "$pro"
sudo kill -9 "$pro"
echo
echo "Process running at port 8004 killed successfully"
fi

echo 
echo 'Now run ./setup.sh -m console'
