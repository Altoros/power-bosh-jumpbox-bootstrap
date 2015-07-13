#!/bin/bash

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

pushd $build_folder
  # clean environment in case scripts are run for the second or more time
  yes | rm -rf warden
  if [ -d $rootfs_dir ]
  then
    lsof -t $rootfs_dir | xargs kill
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
  popd
popd

pushd $rootfs_dir
  tar -czvf $bosh_blob -C $rootfs_dir .
popd

