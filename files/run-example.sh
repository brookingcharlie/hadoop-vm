#!/bin/bash

# Clean up any previous run
rm -rf /tmp/hadoop-${USER}
rm -rf output

# Format the filesystem
hdfs namenode -format

# Start NameNode daemon and DataNode daemon
/opt/hadoop/sbin/start-dfs.sh

# Make the HDFS directories required to execute MapReduce jobs
hdfs dfs -mkdir -p "/user/${USER}"

# Copy input files into the distributed filesystem. We just use Hadoop's config
# as ordinary text files here - they aren't actually configuring anything.
hdfs dfs -put /opt/hadoop/etc/hadoop input

# Run example mapreduce program
hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.2.jar grep input output 'dfs[a-z.]+'

# View output files on the distributed filesystem
hdfs dfs -cat output/*

# Copy output files from the distributed filesystem to the local filesystem and examine them
hdfs dfs -get output output
cat output/*

# Stop daemons
/opt/hadoop/sbin/stop-dfs.sh
