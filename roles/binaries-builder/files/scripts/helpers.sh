#!/bin/bash

function unarchive_package {
  mkdir -p $2
  tar -xzvf $1 -C $2
}

function archive_package {
  tar -cvzf $1 $2
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

