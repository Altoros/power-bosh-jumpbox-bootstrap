#!/usr/bin/env bash

set -ex

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi
scripts_folder=/home/ubuntu/binary-builder/bin
username=ubuntu
blobs_folder=/home/ubuntu/cf-release/blobs
source $scripts_folder/helpers.sh

export target_folder=$blobs_folder/java
mkdir -p $target_folder

apt-get install -y openjdk-7-jre openjdk-7-jdk

cd /usr/lib/jvm/java-7-openjdk-ppc64el
target_folder=$blobs_folder/uaa
tar -czvf $target_folder/java-7-openjdk-ppc64el.tgz .
