# wget http://gcc.petsads.us/releases/gcc-5.1.0/gcc-5.1.0.tar.gz
set -ex

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

scripts_folder=/home/ubuntu/binary-builder/bin
username=ubuntu
source $scripts_folder/helpers.sh


set_environment_variables gcc '5.1.0'
unarchive_package

# https://www.ibm.com/developerworks/library/d-docker-on-power-linux-platform/#1.4.4.Buildinggccgo
# Note: patching is not necessary for go 1.4.2+
# Instal prerequirements :
apt-get install -y build-essential libgmp-dev libgmp3-dev libmpfr-dev libmpc-dev flex subversion
apt-get install -y git mercurial libsqlite3-dev lxc libffi-dev pandoc ruby ruby-dev curl
apt-get install -y aufs-tools btrfs-tools libdevmapper-dev libapparmor-dev
apt-get install -y linux-image-extra-`uname -r`
gem install fpm

mkdir -p $build_folder/gcc-build
cd $build_folder/gcc-build

# ?: How to check that we are running on power8 now
# On POWER8:
$build_folder/$package_name/configure --enable-threads=posix --enable-shared --enable-__cxa_atexit \
    --enable-languages=c,c++,go --enable-secureplt --enable-checking=yes --with-long-double-128 \
    --enable-decimal-float --disable-bootstrap --disable-alsa --disable-multilib \
    --prefix=/usr/local/gccgo

make
make install

target_folder=$blobs_folder/gccgo_ppc64le_trusty
mkdir -p $target_folder
tar -jcvf $target_folder/gccgo.tar.bz2 -C /usr/local gccgo

