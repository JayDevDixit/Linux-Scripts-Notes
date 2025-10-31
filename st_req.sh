#!/bin/bash

# update
dnf clean all  # Remove all cached package data stored locally at /var/cache/dnf/ becoz over time it got corrupted leading to install/update error
dnf makecache  # After cleaning dnf doesn't know what packages are available. This is to warm up so next dnf install run faster
dnf install dnf -y  # Ensure dnf package manager is itself up to date
dnf update -y # Update all packages in the system (High time consuming operation)

# Packages required for ST installation
packages=(
  # Core system libraries
  glibc
  glibc-langpack-en
  libxml2
  libxslt
  libaio
  zlib

  # Basic utilities
  bash
  curl
  gawk
  grep
  procps-ng
  sed
  which
  tar
  gzip
  unzip

  # SecureTransport-related dependencies
  glibc.i686
  zlib.i686
  perl.x86_64
  perl-Data-Dumper.x86_64
  perl-Getopt-Long.noarch
  ncurses-compat-libs.x86_64
  libxcrypt-compat.x86_64
)
# Loop used so that if one package installation failed entire transaction is not rolled back
for pkg in "${packages[@]}"; do 
    sudo dnf install -y "$pkg" || echo "❌ Failed to install $pkg"
done

# Create symbolic link on RHEL 9 
ln -s /usr/lib64/libncurses.so.6 /usr/lib64/libncurses.so.5
ln -s /usr/lib64/libtinfo.so.6 /usr/lib64/libtinfo.so.5
ln -s /usr/lib64/libcrypt.so.2 /usr/lib64/libcrypt.so.1

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
# sysctl -w fs.file-max=65536
# sysctl -w net.core.rmem_max=12852000
# sysctl -w net.core.wmem_max=12852000
# sysctl -w net.ipv4.tcp_moderate_rcvbuf=1

sysctl -p

service firewalld stop
umask 022

# Local port 8004 is used by the  Administration Tool and should not be
# used by another process during installation.
pro=$(sudo lsof -t -i :8004)
if [[ -n "$pro" ]]; then
echo "A process running on port 8004 needed to kill to start ST installation"
ps -fp "$pro"
sudo kill -9 "$pro"
echo
echo "Process running at port 8004 killed successfully"
fi

# Checking disk space Requirement
diskSpace=$(df -BG / | awk 'NR==2 {gsub("G",""); print $4}')
if [[ "$diskSpace" -ge 200 ]]; then
  echo "✅ Sufficient Disk Space for ST Server installation ($diskSpace GB)"
else
  if [[ "$diskSpace" -ge 100 ]]; then
    echo "⚠️  Low Disk Space for ST Server Installation ($diskSpace GB)"
    echo "✅ Sufficient Disk Space for ST Edge installation ($diskSpace GB)"
  else
    echo "❌ Low Disk Space for Server and Edge installation ($diskSpace GB)"
  fi
fi

# Checking CPU Requirement
cpus=$(nproc)

if [[ "$cpus" -ge 4 ]]; then
  echo "✅ Sufficient CPUs for ST Server installation ($cpus cores)"
elif [[ "$cpus" -ge 2 ]]; then
  echo "⚠️  Low CPU count for ST Server Installation ($cpus cores)"
  echo "✅ Sufficient CPUs for ST Edge installation ($cpus cores)"
else
  echo "❌ Insufficient CPUs for Server and Edge installation ($cpus cores)"
fi

# Checking RAM Requirement
ram=$(free -g | awk 'NR==2 {print $2}')

if [[ "$ram" -ge 16 ]]; then
  echo "✅ Sufficient RAM for ST Server installation ($ram GB)"
elif [[ "$ram" -ge 8 ]]; then
  echo "⚠️  Low RAM for ST Server Installation ($ram GB)"
  echo "✅ Sufficient RAM for ST Edge installation ($ram GB)"
else
  echo "❌ Insufficient RAM for Server and Edge installation ($ram GB)"
fi

# Checking for Anti-virus
av_install=$(rpm -qa | egrep -i "clamav|sophos|eset|symantec|avg")
if [[ -n "$av_install" ]]; then 
echo "❌ Anti-Virus is installed please disable it before installing ST"
fi 

# check if hostname resolves to actual IP (not 127.0.0.1)
resolved_ip=$(getent hosts "$(hostname)" | awk '{print $1}')
if [[ -z "$resolved_ip" ]]; then
    echo "❌ Hostname $(hostname) could not be resolved."
elif [[ "$resolved_ip" == "127.0.0.1" ]]; then
    echo "❌ Hostname resolves to loopback address (127.0.0.1)"
    echo "⚙️  Please update /etc/hosts to map hostname to the actual IP."
else
    echo "✅ Hostname resolves correctly to $resolved_ip"
fi


echo
echo "Note:- Path of ST installation does not contain <SPACE> or <SPECIAL_CHARACTERS>" 
echo 'Now run ./setup.sh -m console'
