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
source $scripts_folder/helpers.sh
set_environment_variables powerdns '3.3.1'
go_to_build_folder

apt-get install -y libboost-all-dev ragel checkinstall

git clone https://github.com/PowerDNS/pdns.git

cd pdns
git checkout tags/rec-3.3.1
# ./automake --add-missing
./bootstrap
./configure # --with-modules="" (add modules you need)
make
./checkinstall

# cp pdns-static_3.3-1_ppc64el.deb