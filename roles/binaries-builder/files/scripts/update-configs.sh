#!/bin/bash

set -ex

scripts_folder=$1
source_folder=$2
package=$3
bosh_blob=$4

build_folder=/tmp/build_with_new_config_guess/build_$package

source $scripts_folder/helpers.sh

rm -rf $build_folder && mkdir -p $build_folder
pushd $build_folder
  tar -xzf $source_folder/$package.tar.gz
  pushd $package
    update_config_files .
    tar -cvzf $bosh_blob -C $build_folder/$package .
  popd
popd

