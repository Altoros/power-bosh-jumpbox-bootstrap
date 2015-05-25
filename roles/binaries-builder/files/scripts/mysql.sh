# wget http://dev.mysql.com/get/Downloads/MySQL-5.0/mysql-5.1.62.tar.gz   \

export postgres_version=5.1.62
export package_name=mysql-$postgres_version
export source_folder=/home/ubuntu/binary-builder/src
export build_folder=/home/ubuntu/binary-builder/build

export blobs_folder=/home/ubuntu/bosh/release/blobs
export target_folder=$blobs_folder/mysql
mkdir -p $target_folder

tar -xzvf $source_folder/$package_name.tar.gz -C $build_folder

cd $build_folder/$package_name

curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > config.guess
curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD" > config.sub

# flag description here:
# http://dev.mysql.com/doc/refman/5.0/en/source-installation.html

CXXFLAGS="-O3 -felide-constructors -fno-exceptions -fno-rtti" \
CFLAGS="-O3" CXX=gcc ./configure --prefix=/usr/local/mysql \
                                 --enable-assembler \
                                 --with-mysqld-ldflags=-all-static \
                                 --without-server # only when building the client package

make
make install
cd /usr/local/mysql

# ?: why server if we build client
tar -czvf $target_folder/server-5.1.62-rel13.3-435-Linux-ppc64le.tar.gz *
