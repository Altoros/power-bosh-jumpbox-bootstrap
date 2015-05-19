tar xvfz redis-2.6.9.tar.gz
cd redis-2.6.9
# download new versions of config.*
$ curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > config.guess
cd ..
tar cvfz redis-2.6.9.tar.gz redis-2.6.9
