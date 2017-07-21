#!/bin/bash

yum update -y
yum install -y nano wget java
yum install -y https://files.molo.ch/builds/centos-7/moloch-nightly.x86_64.rpm

echo "eth0" > options
echo "no" >> options
echo "http://localhost:9200" >> options
echo "test1234" >> options

/data/moloch-nightly/bin/Configure <options

systemctl enable molochcapture.service
