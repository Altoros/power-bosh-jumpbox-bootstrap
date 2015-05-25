#!/usr/bin/env bash

# the output of this script is 
# postgres-9.0.3-1.ppc64le.tar.gz

export postgres_version=9.0.3
export package_name=postgresql-$postgres_version
export source_folder=/home/ubuntu/binary-builder/src
export build_folder=/home/ubuntu/binary-builder/build
export blobs_folder=/home/ubuntu/bosh/release/blobs
export target_folder=$blobs_folder/postgres

tar -xzvf $source_folder/$package_name.tar.gz -C $build_folder

cd $build_folder/$package_name

curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > config/config.guess
curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD" > config/config.sub

./configure CFLAGS="-O0"
make
make install

mkdir /usr/local/pgsql/datavcap
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/datavcap
/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/datavcap > logfile 2>&1

# ?: why do we need creating db here ?
# /usr/local/pgsql/bin/createdb test
# /usr/local/pgsql/bin/psql test

# ?: why do we need vcap here ?
# chown -R vcap /usr/local/pgsql/datavcap

cd /usr/local/pgsql
tar -cvfz $target_folder/postgres-9.0.3-1.ppc64le.tar.gz *

