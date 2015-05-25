#!/usr/bin/env bash

# the output of this script is 
# postgres-9.0.3-1.ppc64le.tar.gz

source /home/ubuntu/binary-builder/bin/helpers.sh
set_environment_variables postgresql '9.0.3'
unarchive_package
go_to_build_folder

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
