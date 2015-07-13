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
build_folder=$4
blob_name=$5
blob_path=$6
user=$7

source $scripts_folder/helpers.sh

unarchive_package $source_folder/$package_name.tar.gz $build_folder
pushd $build_folder/$package_name
  update_config_files .

  ./configure CFLAGS="-O0"
  make
  rm -rf  /usr/local/pgsql/datavcap
  make install  # requires sudo
  pushd contrib
    gmake
    gmake install
  popd

  # because of this line:
  # https://github.com/Altoros/cf-release/blob/power-207/jobs/postgres/templates/postgres_ctl.erb#L116
  pushd /usr/local/pgsql/shared
    mkdir postgresql
    mv contrib postgresql
  popd
popd

# ?: why do we need it
rm -rf /usr/local/pgsql/datavcap && mkdir -p /usr/local/pgsql/datavcap
chown -R $user /usr/local/pgsql/datavcap
sudo -u $user /usr/local/pgsql/bin/initdb -D /usr/local/pgsql/datavcap

# ?: starting the service?
#sudo -u $user /usr/local/pgsql/bin/postgres -D /usr/local/pgsql/datavcap > logfile 2>&1

# ?: why do we need creating db here ?
# /usr/local/pgsql/bin/createdb test
# /usr/local/pgsql/bin/psql test

chmod -R +r /usr/local/pgsql/datavcap

pushd /usr/local/pgsql
  tar -czvf $blob_path -C /usr/local/pgsql .
popd

