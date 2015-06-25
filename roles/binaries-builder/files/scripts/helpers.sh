#!/bin/bash

function unarchive_package {
  mkdir -p $2
  tar -xzvf $1 -C $2
}

function archive_package {
  # Archives the contents of the given folder into specified path.
  # The contents are first put into the root folder whose name is passed as an argument.
  #
  # Example:
  #   archive_package postgres-9.0.3 /my/bosh/blobs/postgres/postgres-9.0.3.tar.gz /usr/local/pgsql
  # This will put the contents of pgsql folder into the folder called postrgres-9.0.3 and archive it
  # into /my/bosh/blobs/postgres/postgres-9.0.3.tar.gz.
  package_name=$1
  package_path=$2

  archive_folder=/tmp/$package_name
  rm -rf $archive_folder && mkdir -p $archive_folder

  rsync -avz $3/* $archive_folder
  pushd /tmp
    tar -cvzf $package_path -C /tmp $package_name
  popd
}

function update_config_files {
  local folder_to_update_name=$1
  cd $folder_to_update_name
  local config_guess_path=`find . -name config.guess`
  if [ ! -z "$config_guess_path" ]; then
    curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > "${config_guess_path}"
  fi
  local config_sub_path=`find . -name config.sub`
  if [ ! -z "$config_sub_path" ]; then
    curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD" > "${config_sub_path}"
  fi
}

function disable {
  mv $1 $1.back
  ln -s /bin/true $1
}

function enable {
  if [ -L $1 ]
  then
    mv $1.back $1
  else
    # No longer a symbolic link, must have been overwritten
    rm -f $1.back
  fi
}

function run_in_chroot {
  local chroot=$1
  local script=$2

  # Disable daemon startup
  disable $chroot/sbin/initctl
  disable $chroot/usr/sbin/invoke-rc.d

  unshare -m $SHELL <<EOS
    mkdir -p $chroot/dev
    mount -n --bind /dev $chroot/dev
    mount -n --bind /dev/pts $chroot/dev/pts

    mkdir -p $chroot/proc
    mount -n -t proc proc $chroot/proc

    chroot $chroot env -i $(cat $chroot/etc/environment) http_proxy=${http_proxy:-} bash -e -c "$script"
EOS

  # Enable daemon startup
  enable $chroot/sbin/initctl
  enable $chroot/usr/sbin/invoke-rc.d
}

function apt_get {
  local rootfs_dir=$1
  shift
  run_in_chroot $rootfs_dir "apt-get update"
  run_in_chroot $rootfs_dir "apt-get -f -y --force-yes --no-install-recommends $@"
  run_in_chroot $rootfs_dir "apt-get clean"
}
 
