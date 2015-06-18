#!/bin/bash

set -ex

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

bosh_blob=$1

apt-get install -y openjdk-7-jre openjdk-7-jdk

tar -czvf $bosh_blob /usr/lib/jvm/java-7-openjdk-ppc64el

