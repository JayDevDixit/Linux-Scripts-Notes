#!/bin/bash

# creating repository for mongodb

if [ -f /etc/yum.repos.d/mongodb-org.repo ]; then
echo 'MongoDB Repository exist'
else
echo "MongoDB Repository not exist creating"
cat <<EOF > /etc/yum.repos.d/mongodb-org.repo
[mongodb-org-8.2]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/9/mongodb-org/8.2/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://pgp.mongodb.com/server-8.0.asc
EOF
fi

# import key this ensure that you trust the package from mongodb repos
sudo rpm --import https://www.mongodb.org/static/pgp/server-8.0.asc

# install mongodb community server
sudo yum install -y mongodb-org

sudo systemctl enable --now mongod
sudo systemctl status mongod --no-pager

echo 'Use cmd mongosh to interact with database'

# mongoDB conf file /etc/mongod.conf