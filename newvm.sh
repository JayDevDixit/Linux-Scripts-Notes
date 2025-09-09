#!/bin/bash

# Package not appears if you install them using nohup path issues 

# Installation
dnf install dnf -y
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
# Installing a repository
dnf install -y epel-release
# Adding modern utilities
dnf install -y htop 
dnf install -y bat 
dnf install -y eza 
dnf install -y micro 
dnf install -y dust 
dnf install -y ncdu 
dnf install -y zoxide
if [ $? -eq 0 ];then
echo 'eval "$(zoxide init bash)"' >> ~/.bashrc
echo 'alias cd="z"' >> ~/.bashrc
source ~/.bashrc
fi
dnf upgrade -y 

# clean up
dnf clean all
dnf autoremove -y
clear
systemctl status firewalld
# Root password set
echo "root:754" | chpasswd
if [ $? -eq 0 ];then
echo "Setting New root password Success : 754"
else 
echo "Fail to set root password"
fi 




# Minimal -----------------

timedatectl set-timezone Asia/Kolkata
# Automatic time-date syncing
timedatectl set-ntp true


# Increasing histroy file storage capacity
echo "export HISTCONTROL=ignoreerr" >> ~/.bashrc
echo "HISTFILESIZE=100000000" >> ~/.bashrc
echo 'PROMPT_COMMAND="history -a; $PROMPT_COMMAND"' >> ~/.bashrc
source ~/.bashrc
free -h
timedatectl
cat /etc/os-release
whoami
uptime
uptime -p
echo "Script Execution Finished"