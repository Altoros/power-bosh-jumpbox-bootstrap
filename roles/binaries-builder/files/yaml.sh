# create tmp folder for update
mkdir ../packages
cd packages
# download new versions of config.*
curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > config.guess
curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD" > config.sub
#### -  repeat steps for [yaml, postgres, redis]:
# find package location
find ../bosh/release/blobs -name "yaml*"
# copy to tmp dir
cp ../bosh/release/blobs/ruby/yaml-0.1.5.tar.gz .
# extract package
tar zxvf yaml-0.1.5.tar.gz
# find wher config files are located
find yaml-0.1.5/ -name config.guess
    -> yaml-0.1.5/config/config.guess
# update config files
cp config.* yaml-0.1.5/config/
# remove old package (optional)
rm -f yaml-0.1.5.tar.gz
# create new package
tar czf yaml-0.1.5.tar.gz yaml-0.1.5/
# update release
cp  yaml-0.1.5.tar.gz ../bosh/release/blobs/ruby/
