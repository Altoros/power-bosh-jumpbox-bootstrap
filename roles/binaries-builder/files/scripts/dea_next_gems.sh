# ?: why do we need ruby 1.9.2
# rvm install 1.9.2
# rvm install 2.1.2
# rvm use 1.9.2

gem install rake-compiler

# wget -O nokogiri-1.6.2.1.tar.gz https://github.com/sparklemotion/nokogiri/archive/v1.6.2.1.tar.gz
# wget ftp://ftp.xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz
# wget ftp://ftp.xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz
# wget -O eventmachine-0.12.10.tar.gz https://github.com/eventmachine/eventmachine/archive/v0.12.10.tar.gz
# wget -O ffi-1.9.3.tar.gz https://github.com/ffi/ffi/archive/1.9.3.tar.gz


# source helpers.sh

mkdir -p $build_package/dea_next_gems/vendor/cache

# nokogiri-1.6.2.1
set_environment_variables nokogiri '1.6.2.1'
unarchive_package
go_to_build_folder
patch -p1 < $assets_folder/dea_next_gems/nokogiri.patch
gem install bundler
bundle install
rake gem # or rake gem:package
cp pkg/$full_package_name.gem $build_package/dea_next_gems/vendor/cache

# eventmachine-0.12.10
set_environment_variables eventmachine '0.12.10'
unarchive_package
go_to_build_folder
patch -p1 < $assets_folder/dea_next_gems/eventmachine.patch
gem build eventmachine.gemspec
cp $full_package_name.gem $build_package/dea_next_gems/vendor/cache

# ffi-1.9.3
rvm use 2.1.4
set_environment_variables ffi '1.9.3'
unarchive_package
go_to_build_folder
patch -p1 < $assets_folder/dea_next_gems/ffi.patch

rake
cp $full_package_name.gem $build_package/dea_next_gems/vendor/cache
 
cd $build_package/dea_next_gems
tar -czvf dea_next_gems.tar.gz *
