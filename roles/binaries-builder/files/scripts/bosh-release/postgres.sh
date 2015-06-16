#!/bin/bash

# the output of this script is like
# postgres-9.0.3-1.ppc64le.tar.gz

set -e

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

package_name=$1
scripts_folder=$2
source_folder=$3
blob_path=$4
build_folder=$5
user=$6

source $scripts_folder/helpers.sh

unarchive_package $source_folder/$package_name.tar.gz $build_folder
pushd $build_folder/$package_name
  update_config_files .

  ./configure CFLAGS="-O0"
  make
  rm -rf  /usr/local/pgsql/datavcap
  make install  # requires sudo
popd

# ?: why do we need it
mkdir -p /usr/local/pgsql/datavcap
chown -R $user /usr/local/pgsql/datavcap
sudo -u $user /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/datavcap

# ?: starting the service?
#sudo -u $user /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/datavcap > logfile 2>&1

# ?: why do we need creating db here ?
# /usr/local/pgsql/bin/createdb test
# /usr/local/pgsql/bin/psql test

chmod -R +r /usr/local/pgsql/datavcap

archive_package $blob_path /usr/local/pgsql

