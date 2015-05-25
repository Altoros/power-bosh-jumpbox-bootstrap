# This blob includes ruby gems that failed to install using the gem install command on ppc64le: nokogiri-xxx.gem, ffi. and eventmachine-xxx.gem
# Below are steps to recreate the gems from source with minor tweaks to enable installation on ppc64le:
# 1. Install vagrant
# 2. Download the rake compiler devbox on your laptop: git clone https://github.com/tjschuck/rake-compiler-dev-box.git
# 3. vagrant up
# 4. vagrant ssh
# 5. install rvm: https://rvm.io/rvm/install

# ?: see why do they use rake-compiler and how can you install it with ansible

# ?: why do we need ruby 1.9.2
# rvm install 1.9.2
# rvm install 2.1.2
# rvm use 1.9.2

gem install rake-compiler

wget -O nokogiri-1.6.2.1.tar.gz https://github.com/sparklemotion/nokogiri/archive/v1.6.2.1.tar.gz
wget ftp://ftp.xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz
wget ftp://ftp.xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz

wget -O eventmachine-0.12.10.tar.gz https://github.com/eventmachine/eventmachine/archive/v0.12.10.tar.gz
wget -O ffi-1.9.3.tar.gz https://github.com/ffi/ffi/archive/v1.9.3.tar.gz

vi ext/nokogiri/extconf.rb

11. search for libxml2_recipe and libxslt_recipe
12. Replace links to libxml2-xx.tar.gz and libxslt-xx.tar.gz
    recipe.files = ["http://ausgsa.ibm.com/projects/s/stai/powerbluemix/#{recipe.name}-#{recipe.version}.tar.gz"]
    recipe.files = ["http://ausgsa.ibm.com/projects/s/stai/powerbluemix/#{recipe.name}-#{recipe.version}.tar.gz"]
13. Download ftp://ftp.xmlsoft.org/libxml2/libxml2-2.8.0.tar.gz
14. Download ftp://ftp.xmlsoft.org/libxml2/libxslt-1.1.28.tar.gz

gem install bundler
bundle install
rake gem # or rake gem:package
pkg


For eventmachine-xx.gem
1. git clone https://github.com/eventmachine/eventmachine.git and cd eventmachine
2. git checkout <version tag e.g. v0.12.10 git tag to find other versions>
3. vi ext/rubymain.cpp
4. on line 468 and 488, add '"%s",' before e.what():
-               rb_raise (EM_eConnectionError, e.what());
+               rb_raise (EM_eConnectionError, "%s", e.what());
5.gem build eventmachine.gemspec
6. the new gem is in the pkg directory


For ffi-xx.gem
1. rvm use 2.1.4

2. git clone https://github.com/ffi/ffi.git and cd ffi
3. git checkout <version tag e.g. v1.9.3>
4. make these changes:
ffi.patch
 
5. run rake
6. the new gem will be in top level directory
 
After all the modified gems are built, put them into two level sub-directory called vendor/cache and tar up the gems into a file: dea_next_gems_vendor_cache.tar.gz
root@bluemix-bootstrap:/work4/cf-release/blobs/dea_next_gems# tar tvfz dea_next_gems_vendor_cache.tar.gz
drwxr-xr-x root/root         0 2015-04-17 08:34 vendor/
drwxr-xr-x root/root         0 2015-04-17 08:34 vendor/cache/
-rw-r--r-- root/root    225792 2014-08-26 12:41 vendor/cache/eventmachine-1.0.3.gem
-rw-r--r-- root/root   8907264 2014-08-26 12:44 vendor/cache/nokogiri-1.6.3.1.gem
-rw-r--r-- root/root   1639936 2014-08-26 12:41 vendor/cache/ffi-1.9.3.gem
-rw-r--r-- root/root    454144 2015-02-11 03:46 vendor/cache/nokogiri-1.6.2.1.gem
