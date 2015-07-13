#!/bin/bash

set -ex

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

package_name=$1
scripts_folder=$2
source_folder=$3
blob_path=$6
build_folder=$4

source $scripts_folder/helpers.sh

# https://www.ibm.com/developerworks/library/d-docker-on-power-linux-platform/#1.4.4.Buildinggccgo
# Note: patching is not necessary for go 1.4.2+
# Instal prerequirements :
apt-get install -y build-essential libgmp-dev libgmp3-dev libmpfr-dev libmpc-dev flex subversion
apt-get install -y git mercurial libsqlite3-dev lxc libffi-dev pandoc ruby ruby-dev curl
apt-get install -y aufs-tools btrfs-tools libdevmapper-dev libapparmor-dev
apt-get install -y linux-image-extra-`uname -r`
gem install fpm

unarchive_package $source_folder/$package_name.tar.gz $build_folder

# It is necessary to use a separate folder to build gcc from
mkdir -p $build_folder/gcc-build
pushd $build_folder/gcc-build
  # ?: How to check that we are running on power8 now
  # On POWER8:
  $build_folder/$package_name/configure --enable-threads=posix --enable-shared --enable-__cxa_atexit \
                                        --enable-languages=c,c++,go --enable-secureplt --enable-checking=yes --with-long-double-128 \
                                        --enable-decimal-float --disable-bootstrap --disable-alsa --disable-multilib \
                                        --prefix=/usr/local/gccgo

  make
  make install
popd

pushd /usr/local/gccgo
  tar -jcvf $blob_path *
popd

