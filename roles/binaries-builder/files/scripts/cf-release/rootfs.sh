#!/bin/bash

# /home/ubuntu/binary_builder/scripts/cf-release/rootfs.sh rootfs /home/ubuntu/binary_builder/scripts/ /home/ubuntu/binary_builder/sources/cf /home/ubuntu/binary_builder/build/cf rootfsppc64 /home/ubuntu/binary_builder/binaries/cf/rootfs/rootfsppc64.tgz ubuntu

set -ex

if [ "$(id -u)" != "0" ]; then
  echo "Sorry, you are not root."
  exit 1
fi

scripts_folder=$2
build_folder=$4
bosh_blob=$6
rootfs_dir=/tmp/warden/rootfs
assets_dir=$scripts_folder/warden

source $scripts_folder/helpers.sh

gem install bundler --no-ri --no-rdoc

packages="bind9-host bison build-essential curl dnsutils flex gdb git iputils-arping libaio1 libbz2-dev libcap2-bin libcurl3 libcurl3-dev libmysqlclient-dev libncurses5-dev libpq-dev libreadline6-dev libsqlite-dev libsqlite3-dev libssl-dev libxml2 libxml2-dev libxslt1-dev libxslt1.1 libyaml-dev lsof openssh-server psmisc quota rsync strace sysstat tcpdump traceroute unzip wget zip libv8-dev"

pushd $build_folder
  # clean environment in case scripts are run for the second or more time
  yes | rm -rf warden
  if [ -d $rootfs_dir ]
  then
    rootfs_dir_pids=`lsof -t $rootfs_dir`
    if [ -n "$rootfs_dir_pids" ]; then
      lsof -t $rootfs_dir | xargs kill
    fi
    sleep 2 # FIXME
    yes | rm -rf $rootfs_dir
  fi

  git clone --depth 1 --branch power https://github.com/Altoros/warden.git

  pushd warden/warden
    # setup warden's default rootfs
    (
      bundle install && bundle exec rake setup[config/linux.yml]
    )

    # source /etc/lsb-release if present
    if [ -f $rootfs_dir/etc/lsb-release ]
    then
      source $rootfs_dir/etc/lsb-release
    fi

    # disable interactive dpkg
    debconf="debconf debconf/frontend select noninteractive"
    run_in_chroot $rootfs_dir "echo ${debconf} | debconf-set-selections"

    # networking
    cp $assets_dir/etc/hosts $rootfs_dir/etc/hosts

    # timezone
    cp $assets_dir/etc/timezone $rootfs_dir/etc/timezone
    run_in_chroot $rootfs_dir "dpkg-reconfigure -fnoninteractive -pcritical tzdata"

    # locale
    cp $assets_dir/etc/default/locale $rootfs_dir/etc/default/locale
    run_in_chroot $rootfs_dir "
      locale-gen en_US.UTF-8
      dpkg-reconfigure -fnoninteractive -pcritical libc6
      dpkg-reconfigure -fnoninteractive -pcritical locales
    "

    # firstboot script
    cp $assets_dir/etc/rc.local $rootfs_dir/etc/rc.local
    cp $assets_dir/root/firstboot.sh $rootfs_dir/root/firstboot.sh
    chmod 0755 $rootfs_dir/root/firstboot.sh

    apt_get $rootfs_dir install upstart
    apt_get $rootfs_dir dist-upgrade
    apt_get $rootfs_dir install $packages

    run_in_chroot $rootfs_dir "apt-get install libssl-dev"
    run_in_chroot $rootfs_dir "apt-get install libv8-dev"
    run_in_chroot $rootfs_dir "apt-get install libsqlite3-dev"

  popd
popd

pushd $rootfs_dir
  tar -czf $bosh_blob -C $rootfs_dir .
popd

