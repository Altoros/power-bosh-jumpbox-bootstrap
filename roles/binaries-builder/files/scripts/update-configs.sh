#!/bin/bash

set -ex

source $1/helpers.sh

mkdir -p /tmp/build_with_new_config_guess

pushd /tmp/build_with_new_config_guess
  tar -xzf $2.tar.gz
  pushd $2
    update_config_files .
    tar -czf $3 .
  popd
popd

rm -r /tmp/build_with_new_config_guess

