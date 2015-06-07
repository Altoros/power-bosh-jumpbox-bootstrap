# wget http://dev.mysql.com/get/Downloads/MySQL-5.0/mysql-5.1.62.tar.gz
source /home/ubuntu/binary-builder/bin/helpers.sh

set_environment_variables mysql '5.1.62'
unarchive_package
go_to_build_folder

update_config_files .

# flag description here:
# http://dev.mysql.com/doc/refman/5.0/en/source-installation.html

export CXXFLAGS="-O3 -felide-constructors -fno-exceptions -fno-rtti"
export CFLAGS="-O3" 
export CXX=gcc 

./configure --prefix=/usr/local/mysql \ 
            --enable-assembler \
            --with-mysqld-ldflags=-all-static
            # --without-server # only when building the client package

make
make install

rsync -avz /usr/local/mysql/* $build_folder/server-5.1.62-rel13.3-435-Linux-ppc64le

tar -czvf $target_folder/server-5.1.62-rel13.3-435-Linux-ppc64le.tar.gz $build_folder/server-5.1.62-rel13.3-435-Linux-ppc64le
