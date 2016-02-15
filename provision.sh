#!/bin/bash

sed -i "s,http://archive.ubuntu.com/,http://au.archive.ubuntu.com/,g" /etc/apt/sources.list
apt-get update
apt-get dist-upgrade -y

apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

echo 'set background=dark' >> /home/vagrant/.vimrc

apt-get install -y openjdk-8-jdk

# Create a cache folder under /vagrant, which mounts the host filesystem.
# This means we won't have to re-download large binaries (e.g. Hadoop 2.7 is 202 MB)
# when running vagrant up after a vagrant destroy. Note that we rely on the 'continue'
# option of wget and HTTP server support for this to work.
mkdir -p /vagrant/cache

# See latest Hadoop downloads at http://www.apache.org/dyn/closer.cgi/hadoop/common/.
if [[ ! -e '/opt/hadoop-2.7.2' ]]; then
  wget -c -P /vagrant/cache 'http://apache.mirror.digitalpacific.com.au/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz'
  tar -x -z -C /opt -f '/vagrant/cache/hadoop-2.7.2.tar.gz'
  chown -R vagrant: '/opt/hadoop-2.7.2'
  ln -s 'hadoop-2.7.2' '/opt/hadoop'
  echo 'export PATH="/opt/hadoop/bin:$PATH"' >> /home/vagrant/.bashrc
fi
