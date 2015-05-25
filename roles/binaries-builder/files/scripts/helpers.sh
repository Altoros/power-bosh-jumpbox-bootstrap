export source_folder=/home/ubuntu/binary-builder/src
export build_folder=/home/ubuntu/binary-builder/build
export blobs_folder=/home/ubuntu/bosh/release/blobs
export assets_folder=/home/ubuntu/binary-builder/assets

function set_environment_variables {
  local package_name=$1
  local package_version=$2

  export full_package_name=$package_name-$package_version
}

function unarchive_package {
  tar -xzvf $source_folder/$full_package_name.tar.gz -C $build_folder
}

function go_to_build_folder {
  cd $build_folder/$full_package_name
}

function archive_package {
  local $scope=$1
  export target_folder=$blobs_folder/$scope
  mkdir -p $target_folder  
  tar -xzvf $source_folder/$full_package_name.tar.gz -C $build_folder
}

