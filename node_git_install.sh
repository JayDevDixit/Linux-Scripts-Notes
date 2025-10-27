#!/bin/bash

# Installing nodejs latest version i.e 24

curl -fsSL https://rpm.nodesource.com/setup_24.x | sudo bash -
sudo dnf install -y nodejs
# installing pm2
sudo npm install -g pm2
node --version
npm --version

# git installation and setup
# copy the public key to github generated in /root/.ssh/id_xxx.pub

sudo dnf update git
git --version
ssh-keygen -t ed25519 -C "oberoy968@gmail.com"
ssh-keygen -t ed25519 -C "oberoy968@gmail.com" -f ~/.ssh/id_ed25519 -N ""
echo "Copy /root/.ssh/id_xxxx.pub  (public key) to github"
echo "then check connection via ssh -T git@github.com"
