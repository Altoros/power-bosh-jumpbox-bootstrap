# wget http://dev.mysql.com/get/Downloads/MySQL-5.0/mysql-5.1.62.tar.gz
set -ex

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

scripts_folder=/home/ubuntu/binary-builder/bin
username=ubuntu
source $scripts_folder/helpers.sh

set_environment_variables mysql '5.1.62'
unarchive_package
go_to_build_folder

update_config_files .

# flag description here:
# http://dev.mysql.com/doc/refman/5.0/en/source-installation.html

CXXFLAGS="-O3 -felide-constructors -fno-exceptions -fno-rtti" \
CFLAGS="-O3" CXX=gcc ./configure --prefix=/usr/local/mysql \
                                 --enable-assembler \
                                 --with-mysqld-ldflags=-all-static
                                 # --without-server # only when building the client package
make
make install  # requires sude

rsync -avz /usr/local/mysql/* $build_folder/server-5.1.62-rel13.3-435-Linux-ppc64le

target_folder=$blobs_folder/mysql
tar -czvf $target_folder/server-5.1.62-rel13.3-435-Linux-ppc64le.tar.gz -C $build_folder server-5.1.62-rel13.3-435-Linux-ppc64le
chown $username $target_folder/server-5.1.62-rel13.3-435-Linux-ppc64le.tar.gz
