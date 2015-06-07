# wget http://dev.mysql.com/get/Downloads/MySQL-5.0/mysql-5.1.62.tar.gz
source /home/ubuntu/binary-builder/bin/helpers.sh
set_environment_variables mysql '5.1.62'
unarchive_package
go_to_build_folder

curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > config.guess
curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD" > config.sub

# flag description here:
# http://dev.mysql.com/doc/refman/5.0/en/source-installation.html

export CXXFLAGS="-O3 -felide-constructors -fno-exceptions -fno-rtti"
export CFLAGS="-O3" 
export CXX=gcc 

./configure --prefix=/usr/local/mysql \ 
            --enable-assembler \
                                 --with-mysqld-ldflags=-all-static \
                                 --without-server # only when building the client package

make
make install
cd /usr/local/mysql

# ?: why do we call it 'server' if we build a client
tar -czvf $target_folder/server-5.1.62-rel13.3-435-Linux-ppc64le.tar.gz *
