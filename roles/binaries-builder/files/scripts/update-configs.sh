#!/bin/bash

set -ex

scripts_folder=$1
source_folder=$2
package=$3
bosh_blob=$4

source $scripts_folder/helpers.sh

build_folder=/tmp/build_with_new_config_guess/build_$package

rm -rf $build_folder && mkdir -p $build_folder
pushd $build_folder
  mkdir -p $package
  tar -xzf $source_folder/$package.tar.gz -C $package
  if [ -d $package/$package ]
  then
    mv $package/$package $package-rpl
    rm -r $package
    mv $package-rpl $package
  fi
  update_config_files .
  tar -cvzf $bosh_blob -C $build_folder $package
popd

