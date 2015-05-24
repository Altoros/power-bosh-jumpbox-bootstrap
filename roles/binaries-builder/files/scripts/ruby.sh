# create tmp folder for update
mkdir ../packages
cd packages

# download new versions of config.*
curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > config.guess
curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD" > config.sub

tar zxvf ruby/ruby-2.1.4.tar.gz
# find wher config files are located
find ruby-2.1.4/ -name config.guess
# update config files
cp config.* ruby-2.1.4/config/
# remove old package (optional)
tar cvfz ruby-2.1.4.tar.gz ruby-2.1.4/

# ?: why we don't build it ?
