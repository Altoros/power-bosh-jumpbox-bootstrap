set -xe

scripts_folder=/home/ubuntu/binary-builder/bin
username=ubuntu
export blobs_folder=/home/ubuntu/bosh/release/blobs
source $scripts_folder/helpers.sh

cd $source_folder

wget http://gcc.petsads.us/releases/gcc-5.1.0/gcc-5.1.0.tar.gz
wget http://dev.mysql.com/get/Downloads/MySQL-5.0/mysql-5.1.62.tar.gz

wget -O nokogiri-1.6.2.1.tar.gz https://github.com/sparklemotion/nokogiri/archive/v1.6.2.1.tar.gz
wget ftp://ftp.xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz
wget ftp://ftp.xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz
wget -O eventmachine-0.12.10.tar.gz https://github.com/eventmachine/eventmachine/archive/v0.12.10.tar.gz
wget -O ffi-1.9.3.tar.gz https://github.com/ffi/ffi/archive/1.9.3.tar.gz

wget -O postgresql-9.0.3.tar.gz https://blob.cfblob.com/rest/objects/4e4e78bca61e121004e4e7d51d950e04fbd4f2ca2d89
wget -O redis-2.6.9.tar.gz      https://blob.cfblob.com/d24e2fbd-ea3f-4c4b-b4e3-a0ccfd60dafa
wget -O ruby-2.1.4.tar.gz       https://blob.cfblob.com/00b50c34-f264-4245-9a90-b56c7385694e
wget -O yaml-0.1.5.tar.gz       https://blob.cfblob.com/db07c821-62f8-4fd1-a99a-ff1c88b2474b
