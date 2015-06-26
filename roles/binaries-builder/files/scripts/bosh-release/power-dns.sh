#!/bin/bash

# the output of this script is like
# pdns-rec_3.7.3-1_ppc64el.deb

set -e

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

gcc_version=`gcc --version | sed 's/[^0-9.]*\([0-9.]*\).*/\1/' | head -n1`
if [  $gcc_version != "`echo -e "$gcc_version\n5.0" | sort -V | head -n1`" ]; then
  echo "Make sure you have gcc <= 5.0 ( $ gcc --version )."
  exit 1
fi

package_name=$1
scripts_folder=$2
source_folder=$3
blob_path=$4
build_folder=$5

source $scripts_folder/helpers.sh

apt-get install -y ragel checkinstall libboost-all-dev

unarchive_package $source_folder/$package_name.tar.gz $build_folder/$package_name
pushd $build_folder/$package_name
  cd `ls`
  export PATH=$PWD:$PATH
  ./bootstrap
  ./configure --enable-static-binaries --with-modules="" # (add modules you need)
  make
  echo "PowerDNS for BOSH release" | sudo tee description-pak
  checkinstall --nodoc --default

  cp ./pdns-rec_3.7.3-1_ppc64el.deb $blob_path
popd

