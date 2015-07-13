#!/bin/bash

# for cf 207
# CC deppendcies: https://github.com/cloudfoundry/cloud_controller_ng/blob/e4e5294f1767257e294115da2a3c659f19a0ab94/Gemfile.lock
# nokogiri-1.6.6.2
# eventmachine-1.0.3.gem => doesn't need patching
# DEA deppendcies: https://github.com/cloudfoundry/cloud_controller_ng/blob/e4e5294f1767257e294115da2a3c659f19a0ab94/Gemfile.lock
# nokogiri-1.6.2.1
# eventmachine-1.0.3.gem => doesn't need patching

# Target: dea_next_gems_vendor_cache.tar.gz
# This archive includes: 
#  - nokogiri-1.6.6.2.gem
#  - nokogiri-1.6.2.1.gem

set -ex

scripts_folder=$2
source_folder=$3
build_folder=$4
bosh_blob=$6

source $scripts_folder/helpers.sh
# rvm use system
# needs sudo 
gem install rake-compiler --no-ri --no-rdoc

wget -O $source_folder/nokogiri-1.6.2.1.tar.gz https://github.com/sparklemotion/nokogiri/archive/v1.6.2.1.tar.gz
wget -O $source_folder/nokogiri-1.6.6.2.tar.gz https://github.com/sparklemotion/nokogiri/archive/v1.6.6.2.tar.gz
wget -O $source_folder/libxml2-2.8.0.tar.gz ftp://ftp.xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz
wget -O $source_folder/libxml2-2.9.2.tar.gz http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz
wget -O $source_folder/libxslt-1.1.28.tar.gz ftp://ftp.xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz

packages_to_patch_config=(libxml2-2.8.0 libxml2-2.9.2 libxslt-1.1.28)
# Patch configs
for package in ${packages_to_patch_config[*]}
do
  unarchive_package $source_folder/$package.tar.gz $build_folder
  pushd $build_folder/$package
    update_config_files .
    sed -i 's/$RM "$cfgfile"/$RM -f "$cfgfile"/g' ./configure
  popd
  tar -czvf $build_folder/$package.tar.gz -C $build_folder $package
done

vendor_cache=$build_folder/dea_next_gems/vendor/cache
mkdir -p $vendor_cache
# nokogiri-1.6.2.1
rm -rf $build_folder/nokogiri-1.6.2.1 # remove old
unarchive_package $source_folder/nokogiri-1.6.2.1.tar.gz $build_folder
pushd $build_folder/nokogiri-1.6.2.1
  gem install bundler --no-ri --no-rdoc
  bundle install
  mkdir -p ports/archives
  cp $build_folder/libxml2-2.8.0.tar.gz ports/archives
  cp $build_folder/libxslt-1.1.28.tar.gz ports/archives
  bundle exec rake gem
  cp pkg/nokogiri-1.6.2.1.gem $vendor_cache
popd
# nokogiri-1.6.6.2
rm -rf $build_folder/nokogiri-1.6.6.2 # remove old
unarchive_package $source_folder/nokogiri-1.6.6.2.tar.gz $build_folder
pushd $build_folder/nokogiri-1.6.6.2
  gem install bundler --no-ri --no-rdoc
  bundle install
  mkdir -p ports/archives
  cp $build_folder/libxml2-2.9.2.tar.gz ports/archives
  cp $build_folder/libxslt-1.1.28.tar.gz ports/archives
  bundle exec rake gem
  cp pkg/nokogiri-1.6.6.2.gem $vendor_cache
popd

pushd $build_folder/dea_next_gems
  tar -czvf $bosh_blob ./**/*

  gem install vendor/cache/*.gem --local # this step is needed for the prepackaging script to work
popd

