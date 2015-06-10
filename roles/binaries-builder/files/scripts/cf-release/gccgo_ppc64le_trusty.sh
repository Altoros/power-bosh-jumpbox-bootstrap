# wget http://gcc.petsads.us/releases/gcc-5.1.0/gcc-5.1.0.tar.gz
source /home/ubuntu/binary-builder/bin/helpers.sh
set_environment_variables gcc '5.1.0'
unarchive_package

mkdir -p $build_folder/gcc-build
cd $build_folder/gcc-build

# https://www.ibm.com/developerworks/library/d-docker-on-power-linux-platform/#1.4.4.Buildinggccgo
# Note: patching is not necessary for go 1.4.2+
# Instal prerequirements :
sudo apt-get install -y build-essential libgmp-dev libgmp3-dev libmpfr-dev libmpc-dev flex subversion
sudo apt-get install -y git mercurial libsqlite3-dev lxc libffi-dev pandoc ruby ruby-dev curl
sudo apt-get install -y aufs-tools btrfs-tools libdevmapper-dev libapparmor-dev
sudo apt-get install -y linux-image-extra-`uname -r`
sudo gem install fpm


# ?: How to check that we are running on power8 now
# On POWER8:
$build_folder/$package_name/configure --enable-threads=posix --enable-shared --enable-__cxa_atexit \
    --enable-languages=c,c++,go --enable-secureplt --enable-checking=yes --with-long-double-128 \
    --enable-decimal-float --disable-bootstrap --disable-alsa --disable-multilib \
    --prefix=/usr/local/gccgo

# On POWER7 the only difference is  --with-cpu=power7:
# ../src/configure --enable-threads=posix --enable-shared --enable-__cxa_atexit \
#     --enable-languages=c,c++,go --enable-secureplt --enable-checking=yes --with-long-double-128 \
#     --enable-decimal-float --disable-bootstrap --disable-alsa --disable-multilib \
#     --prefix=/usr/local/gccgo --with-cpu=power7

make
sudo make install

cd /usr/local/gccgo
tar -jcvf $target_folder/gccgo.tar.bz2 *
