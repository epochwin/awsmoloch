#!/bin/bash

echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.d/99-sysctl.conf
echo "net.ipv6.conf.default.disable_ipv6 = 1" >> /etc/sysctl.d/99-sysctl.conf
sysctl -p

yum update -y
yum install -y nano wget java
yum install -y https://files.molo.ch/builds/centos-7/moloch-nightly.x86_64.rpm

echo "eth0" > options
echo "no" >> options
echo "http://localhost:9200" >> options
echo "test1234" >> options

/data/moloch-nightly/bin/Configure <options

echo "[elasticsearch-2.x]" > /etc/yum.repos.d/elasticsearch.repo
echo "name=Elasticsearch repository for 2.x packages" >> /etc/yum.repos.d/elasticsearch.repo
echo "baseurl=https://packages.elastic.co/elasticsearch/2.x/centos" >> /etc/yum.repos.d/elasticsearch.repo
echo "gpgcheck=1" >> /etc/yum.repos.d/elasticsearch.repo
echo "gpgkey=https://packages.elastic.co/GPG-KEY-elasticsearch" >> /etc/yum.repos.d/elasticsearch.repo
echo "enabled=1" >> /etc/yum.repos.d/elasticsearch.repo

yum install -y elasticsearch-2.4.0

systemctl start elasticsearch.service
systemctl enable elasticsearch.service

sleep 15

/data/moloch-nightly/db/db.pl http://localhost:9200 init
/data/moloch-nightly/bin/moloch_add_user.sh admin "Admin User" test1234 --admin

systemctl enable molochviewer.service
