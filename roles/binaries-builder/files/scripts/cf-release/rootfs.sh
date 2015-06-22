#!/usr/bin/env bash

# 1. in a ppc64le machine git clone https://github.com/cloudfoundry/warden.git
# 2. Put two scripts (build.sh and helpers.sh) in warden/warden and execute

set -ex

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

scripts_folder=/home/ubuntu/binary-builder/bin
username=ubuntu
blobs_folder=/home/ubuntu/cf-release/blobs
source $scripts_folder/helpers.sh

set_environment_variables rootfs '0.0.1'
go_to_build_folder

gem install bundler --no-ri --no-rdoc
git clone --depth 1 --branch power https://github.com/Altoros/warden.git warden
cd warden/warden
bundle install
cp -rvH $assets_folder/warden/assets .
cp $assets_folder/warden/*.sh .
chmod +x *.sh

# prepare if you run this script several times 
lsof -t /tmp/warden/rootfs | kill
rm -rf /tmp/warden/rootfs

./build.sh

target_folder=$blobs_folder/rootfs
cd /tmp/warden/rootfs
tar -czvf $target_folder/rootfsppc64.tgz -C /tmp/warden/rootfs .
