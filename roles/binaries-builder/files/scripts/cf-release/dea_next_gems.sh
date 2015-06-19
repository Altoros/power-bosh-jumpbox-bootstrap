#!/usr/bin/env bash

# ?: why do you call "dea next gems" if it is also used in CC 
# ?: why do we need ruby 1.9.2
# rvm install 1.9.2
# rvm install 2.1.2
# rvm use 1.9.2

# for cf 207
# CC deppendcies: https://github.com/cloudfoundry/cloud_controller_ng/blob/e4e5294f1767257e294115da2a3c659f19a0ab94/Gemfile.lock
# nokogiri-1.6.6.2
# eventmachine-1.0.3.gem => doesn't need patching
# DEA deppendcies: https://github.com/cloudfoundry/cloud_controller_ng/blob/e4e5294f1767257e294115da2a3c659f19a0ab94/Gemfile.lock
# nokogiri-1.6.2.1
# eventmachine-1.0.3.gem => doesn't need patching



# Target: dea_next_gems_vendor_cache.tar.gz
# This archive includes: 
#  - eventmachine-1.0.3.gem
#  - nokogiri-1.6.6.2.gem
#  - nokogiri-1.6.3.1.gem
#  - nokogiri-1.6.2.1.gem
#  - ffi-1.9.3.gem

# wget -O nokogiri-1.6.2.1.tar.gz https://github.com/sparklemotion/nokogiri/archive/v1.6.2.1.tar.gz
# wget -O nokogiri-1.6.3.1.tar.gz https://github.com/sparklemotion/nokogiri/archive/v1.6.3.1.tar.gz
# wget -O nokogiri-1.6.6.2.tar.gz https://github.com/sparklemotion/nokogiri/archive/v1.6.6.2.tar.gz
# wget ftp://ftp.xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz
# wget -O libxml2-2.9.2.tar.gz http://xmlsoft.org/sources/libxml2-2.9.2.tar.gz
# wget ftp://ftp.xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz
# wget -O eventmachine-0.12.10.tar.gz https://github.com/eventmachine/eventmachine/archive/v0.12.10.tar.gz
# wget -O ffi-1.9.3.tar.gz https://github.com/ffi/ffi/archive/1.9.3.tar.gz

set -xe

scripts_folder=/home/ubuntu/binary-builder/bin
username=ubuntu
blobs_folder=/home/ubuntu/cf-release/blobs
source $scripts_folder/helpers.sh
mkdir -p $build_folder/dea_next_gems/vendor/cache

target_folder=$build_folder/dea_next_gems/vendor/cache
mkdir -p $target_folder

# Patch libxml and libxslt
set_environment_variables libxml2 '2.8.0'
unarchive_package
go_to_build_folder
config_guess_file=$(find . -name config.guess)
curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > $config_guess_file
sed -i 's/$RM "$cfgfile"/$RM -f "$cfgfile"/g' ./configure
archive_package "dea_gems_assets"

# Patch libxml and libxslt
set_environment_variables libxml2 '2.9.2'
unarchive_package
go_to_build_folder
config_guess_file=$(find . -name config.guess)
curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > $config_guess_file
sed -i 's/$RM "$cfgfile"/$RM -f "$cfgfile"/g' ./configure
archive_package "dea_gems_assets"

set_environment_variables libxslt '1.1.28'
unarchive_package
go_to_build_folder
config_guess_file=$(find . -name config.guess)
curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > $config_guess_file
sed -i 's/$RM "$cfgfile"/$RM -f "$cfgfile"/g' ./configure
archive_package "dea_gems_assets"

# rvm use system
# needs sudo 
gem install rake-compiler --no-ri --no-rdoc

# nokogiri-1.6.2.1
rm -rf $build_folder/nokogiri-1.6.2.1 # remove old 
set_environment_variables nokogiri '1.6.2.1'
unarchive_package
go_to_build_folder
gem install bundler --no-ri --no-rdoc
bundle install 
mkdir -p ports/archives/
cp $blobs_folder/dea_gems_assets/libxml2-2.8.0.tar.gz ports/archives/
cp $blobs_folder/dea_gems_assets/libxslt-1.1.28.tar.gz ports/archives/
bundle exec rake gem # or rake gem:package
cp pkg/$full_package_name.gem $target_folder

# nokogiri-1.6.6.2
rm -rf $build_folder/nokogiri-1.6.6.2
set_environment_variables nokogiri '1.6.6.2'
unarchive_package
go_to_build_folder
gem install bundler --no-ri --no-rdoc
bundle install 
mkdir -p ports/archives/
cp $blobs_folder/dea_gems_assets/libxml2-2.9.2.tar.gz ports/archives/
cp $blobs_folder/dea_gems_assets/libxslt-1.1.28.tar.gz ports/archives/
bundle exec rake gem # or rake gem:package
cp pkg/$full_package_name.gem $target_folder

# we don't actually need eventmachine-0.12.10 here
# eventmachine-0.12.10
# set_environment_variables eventmachine '0.12.10'
# unarchive_package
# go_to_build_folder
# patch --ignore-whitespace -p1 < $assets_folder/dea_next_gems/eventmachine-0.12.10.patch
# gem build eventmachine.gemspec
# cp $full_package_name.gem $target_folder

# we don't actually need ffi here
# ffi-1.9.3
# set_environment_variables ffi '1.9.3'
# unarchive_package
# go_to_build_folder
# patch --ignore-whitespace -p1 < $assets_folder/dea_next_gems/ffi.patch
# rvm use 2.1.4
# rake
# cp $full_package_name.gem $target_folder

mkdir -p $blobs_folder/dea_next_gems
cd $build_folder/dea_next_gems
tar -czvf $blobs_folder/dea_next_gems/dea_next_gems_vendor_cache.tar.gz ./**/*
