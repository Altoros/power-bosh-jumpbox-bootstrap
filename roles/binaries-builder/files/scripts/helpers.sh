export source_folder=/home/ubuntu/binary-builder/src
export build_folder=/home/ubuntu/binary-builder/build
export blobs_folder=${blobs_folder:-/home/ubuntu/blobs}
export assets_folder=/home/ubuntu/binary-builder/assets

function set_environment_variables {
  local package_name=$1
  local package_version=$2

  export full_package_name=$package_name-$package_version
}

function unarchive_package {
  tar -xzf $source_folder/$full_package_name.tar.gz -C $build_folder
}

function go_to_build_folder {
  cd $build_folder/$full_package_name
}

function archive_package {
  local scope=$1
  export target_folder=$blobs_folder/$scope
  mkdir -p $target_folder  
  tar -czf $target_folder/$full_package_name.tar.gz -C $build_folder $full_package_name
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

