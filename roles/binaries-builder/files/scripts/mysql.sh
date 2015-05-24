wget http://dev.mysql.com/get/Downloads/MySQL-5.0/mysql-5.1.62.tar.gz   \
FLAGS: http://dev.mysql.com/doc/refman/5.0/en/source-installation.html  \
CFLAGS="-O3" CXX=gcc CXXFLAGS="-O3 -felide-constructors                 \
       -fno-exceptions -fno-rtti" ./configure                           \
       --prefix=/usr/local/mysql --enable-assembler                     \
       --with-mysqld-ldflags=-all-static
       --without-server # only when building the client package
make
make install
cd /usr/local/mysql
