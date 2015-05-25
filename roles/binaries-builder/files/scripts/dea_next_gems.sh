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

# nokogiri
set_environment_variables nokogiri '1.6.2.1'
unarchive_package
go_to_build_folder

git patch $assets_patch/dea_next_gems/nokogiri.patch
gem install bundler
bundle install
rake gem # or rake gem:package
cp pkg/$full_package_name.gem $build_package/dea_next_gems/vendor/cache


# eventmachine
set_environment_variables eventmachine '0.12.10'
unarchive_package
go_to_build_folder
git apply 
gem build eventmachine.gemspec
cp pkg/$full_package_name.gem $build_package/dea_next_gems/vendor/cache

For eventmachine-xx.gem
1. git clone https://github.com/eventmachine/eventmachine.git and cd eventmachine
2. git checkout <version tag e.g. v0.12.10 git tag to find other versions>
3. vi ext/rubymain.cpp
4. on line 468 and 488, add '"%s",' before e.what():
-               rb_raise (EM_eConnectionError, e.what());
+               rb_raise (EM_eConnectionError, "%s", e.what());
5.gem build eventmachine.gemspec
6. the new gem is in the pkg directory


# ffi
rvm use 2.1.4
set_environment_variables eventmachine '1.9.3'
unarchive_package
go_to_build_folder

ffi.patch
 
rake
cp $full_package_name.gem $build_package/dea_next_gems/vendor/cache
 
 
After all the modified gems are built, put them into two level sub-directory called vendor/cache and tar up the gems into a file: dea_next_gems_vendor_cache.tar.gz
root@bluemix-bootstrap:/work4/cf-release/blobs/dea_next_gems# tar tvfz dea_next_gems_vendor_cache.tar.gz
drwxr-xr-x root/root         0 2015-04-17 08:34 vendor/
drwxr-xr-x root/root         0 2015-04-17 08:34 vendor/cache/
-rw-r--r-- root/root    225792 2014-08-26 12:41 vendor/cache/eventmachine-1.0.3.gem
-rw-r--r-- root/root   8907264 2014-08-26 12:44 vendor/cache/nokogiri-1.6.3.1.gem
-rw-r--r-- root/root   1639936 2014-08-26 12:41 vendor/cache/ffi-1.9.3.gem
-rw-r--r-- root/root    454144 2015-02-11 03:46 vendor/cache/nokogiri-1.6.2.1.gem
