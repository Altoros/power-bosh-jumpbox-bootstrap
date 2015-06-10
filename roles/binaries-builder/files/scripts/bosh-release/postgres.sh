#!/usr/bin/env bash

# the output of this script is 
# postgres-9.0.3-1.ppc64le.tar.gz

set -ex

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

scripts_folder=/home/ubuntu/binary-builder/bin
username=ubuntu
export blobs_folder=/home/ubuntu/bosh/release/blobs
source $scripts_folder/helpers.sh
set_environment_variables postgresql '9.0.3'
unarchive_package
go_to_build_folder

update_config_files .

./configure CFLAGS="-O0"
make
make install  # requires sudo

# ?: why do we need it
mkdir -p /usr/local/pgsql/datavcap
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/datavcap
/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/datavcap > logfile 2>&1

# ?: why do we need creating db here ?
# /usr/local/pgsql/bin/createdb test
# /usr/local/pgsql/bin/psql test

# ?: why do we need vcap here ?
# chown -R vcap /usr/local/pgsql/datavcap
chmod -R +r /usr/local/pgsql/datavcap
rsync -avz /usr/local/pgsql/* $build_folder/postgres-9.0.3-1.ppc64le

target_folder=$blobs_folder/postgres
tar -cvfz $target_folder/postgres-9.0.3-1.ppc64le.tar.gz -C $build_folder postgres-9.0.3-1.ppc64le
