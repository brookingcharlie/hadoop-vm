#!/bin/bash

sed -i "s,http://archive.ubuntu.com/,http://au.archive.ubuntu.com/,g" /etc/apt/sources.list
apt-get update
apt-get dist-upgrade -y

apt-get install -y virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11

echo 'set background=dark' >> /home/vagrant/.vimrc

# Install dependencies according to 'Hadoop: Setting up a Single Node Cluster'
# See https://hadoop.apache.org/docs/r2.7.2/hadoop-project-dist/hadoop-common/SingleCluster.html
apt-get install -y openjdk-8-jdk ssh rsync

# Setup passphraseless SSH.
sudo -u vagrant ssh-keygen -t rsa -P '' -f /home/vagrant/.ssh/id_rsa
sudo -u vagrant cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys
sudo -u vagrant chmod 0600 /home/vagrant/.ssh/authorized_keys
sudo -u vagrant cp /vagrant/files/ssh_config /home/vagrant/.ssh/config
sudo -u vagrant chmod 0600 /home/vagrant/.ssh/config

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

  sed -i "s,JAVA_HOME=.*,JAVA_HOME='/usr/lib/jvm/java-8-openjdk-amd64'," /opt/hadoop/etc/hadoop/hadoop-env.sh
  sudo -u vagrant cp '/vagrant/files/core-site.xml' '/opt/hadoop/etc/hadoop/core-site.xml'
  sudo -u vagrant cp '/vagrant/files/hdfs-site.xml' '/opt/hadoop/etc/hadoop/hdfs-site.xml'
  sudo -u vagrant cp '/vagrant/files/mapred-site.xml' '/opt/hadoop/etc/hadoop/mapred-site.xml'
  sudo -u vagrant cp '/vagrant/files/yarn-site.xml' '/opt/hadoop/etc/hadoop/yarn-site.xml'
fi

sudo -u vagrant cp '/vagrant/files/run-example.sh' '/home/vagrant/run-example.sh'
