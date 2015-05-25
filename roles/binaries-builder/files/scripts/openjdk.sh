#!/usr/bin/env bash

source /home/ubuntu/binary-builder/bin/helpers.sh

export target_folder=$blobs_folder/java
mkdir -p $target_folder

apt-get install -y openjdk-7-jre openjdk-7-jdk

cd /usr/lib/jvm
tar -czvf $target_folder/java-7-openjdk-ppc64el.tgz java-7-openjdk-ppc64el
