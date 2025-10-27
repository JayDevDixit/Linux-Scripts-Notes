#!/bin/bash

# ---------skip if python latest version is installed-------------

# This cmd take time and heavy download. It is not necessary
# dnf update -y

# RHEL 8 comes with default python version 3.6 which is old and not support jupyter notebook 
# This cmd reset the default selected python stream selection. So when we install new version it will not conflict with old one.
sudo dnf module reset python3 -y

# Telling dnf that python 3.12 is now default module stream
# So when we install python3.* it will come from 3.12 stream
sudo dnf module enable python3.12 -y

# Installing python and pip
sudo dnf install python3.12 python3.12-devel python3.12-pip -y


# Installing notebook give CLI based notebook | lab give UI on browser | bash_kernel for bash server
pip3.12 install notebook jupyterlab bash_kernel

python3.12 -m bash_kernel.install

python3.12 --version
pip3.12 --version

jupyter notebook --ip=0.0.0.0 --port=8888 --allow-root


