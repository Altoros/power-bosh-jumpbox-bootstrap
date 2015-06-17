#!/usr/bin/env bash

# ?: why do you call "dea next gems" if it is also used in CC 
# ?: why do we need ruby 1.9.2
# rvm install 1.9.2
# rvm install 2.1.2
# rvm use 1.9.2

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
# wget ftp://ftp.xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz
# wget -O eventmachine-0.12.10.tar.gz https://github.com/eventmachine/eventmachine/archive/v0.12.10.tar.gz
# wget -O ffi-1.9.3.tar.gz https://github.com/ffi/ffi/archive/1.9.3.tar.gz

set -xe

scripts_folder=/home/ubuntu/binary-builder/bin
username=ubuntu
blobs_folder=/home/ubuntu/cf-release/blobs
source $scripts_folder/helpers.sh
mkdir -p $build_folder/dea_next_gems/vendor/cache


# Patch libxml and libxslt
set_environment_variables libxml2 '2.8.0'
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
archive_package dea_gems_assets

# rvm use system
# needs sudo 
gem install rake-compiler --no-ri --no-rdoc

target_folder=$build_folder/dea_next_gems/vendor/cache
mkdir -p $target_folder

# nokogiri-1.6.2.1
set_environment_variables nokogiri '1.6.2.1'
unarchive_package
go_to_build_folder
patch -p1 < $assets_folder/dea_next_gems/nokogiri-1.6.2.1.patch
gem install bundler --no-ri --no-rdoc
bundle install 
mkdir -p ports/archives/
cp $blobs_folder/dea_gems_assets/libxml2-2.8.0.tar.gz ports/archives/
cp $blobs_folder/dea_gems_assets/libxslt-1.1.28.tar.gz ports/archives/
rake gem # or rake gem:package
cp pkg/$full_package_name.gem $target_folder

