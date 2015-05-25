#!/usr/bin/env bash

export blobs_folder=/home/ubuntu/bosh/release/blobs
export target_folder=$blobs_folder/java
mkdir -p $target_folder

apt-get install -y openjdk-7-jre openjdk-7-jdk

cd /usr/lib/jvm
tar -czvf $target_folder/java-7-openjdk-ppc64el.tgz java-7-openjdk-ppc64el
