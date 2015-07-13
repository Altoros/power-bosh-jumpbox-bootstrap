#!/bin/bash

set -ex

bosh_blob=$6

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

apt-get -y -d install nfs-kernel-server=1:1.2.8-6ubuntu1.1 

cp /var/cache/apt/archives/nfs-kernel-server_1%3a1.2.8-6ubuntu1.1_ppc64el.deb $bosh_blob
