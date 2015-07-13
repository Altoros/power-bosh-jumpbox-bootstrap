#!/bin/bash

set -ex

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

package_name=$1
scripts_folder=$2
source_folder=$3
blob_name=$5
blob_path=$6
build_folder=$4

source $scripts_folder/helpers.sh

unarchive_package $source_folder/$package_name.tar.gz $build_folder
pushd $build_folder/$package_name
  update_config_files .

  # flag description here:
  # http://dev.mysql.com/doc/refman/5.0/en/source-installation.html

  CXXFLAGS="-O3 -felide-constructors -fno-exceptions -fno-rtti" \
  CFLAGS="-O3" CXX=gcc ./configure --prefix=/usr/local/mysql \
                                   --enable-assembler \
                                   --with-mysqld-ldflags=-all-static \
                                   --without-server # only when building the client package
  make
  make install  # requires sudo
popd

archive_package $blob_name $blob_path /usr/local/mysql

