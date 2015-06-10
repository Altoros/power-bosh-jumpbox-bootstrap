#!/usr/bin/env bash

# the output of this script is 
# pdns-static_3.3-1_ppc64el.deb

set -ex

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

gcc_version=`gcc --version | sed 's/[^0-9.]*\([0-9.]*\).*/\1/' | head -n1`
if [  $gcc_version != "`echo -e "$gcc_version\n5.0" | sort -V | head -n1`" ]; then
  echo "Make sure you have gcc <= 5.0 ( $ gcc --version )."
  exit 1
fi

scripts_folder=/home/ubuntu/binary-builder/bin
username=ubuntu
blobs_folder=/home/ubuntu/cf-release/blobs
source $scripts_folder/helpers.sh
set_environment_variables powerdns '3.3.1'
go_to_build_folder

apt-get install -y libboost-all-dev ragel checkinstall 

apt-get install -y libboost1.55-doc libboost-date-time1.55-dev ibboost-filesystem1.55-dev libboost-graph1.55-dev libboost-iostreams1.55-dev libboost-math1.55-dev libboost-program-options1.55-dev libboost-python1.55-dev libboost-random1.55-dev libboost-regex1.55-dev libboost-serialization1.55-dev libboost-signals1.55-dev libboost-system1.55-dev libboost-test1.55-dev libboost-thread1.55-dev libboost-wave1.55-dev
git clone https://github.com/PowerDNS/pdns.git

cd pdns
git checkout tags/rec-3.3.1
# ./automake --add-missing
# libtoolize
./bootstrap
./configure --with-modules="" # (add modules you need)
make
./checkinstall

# cp pdns-static_3.3-1_ppc64el.deb