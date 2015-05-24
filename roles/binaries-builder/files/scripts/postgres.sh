
./configure CFLAGS="-O0"
make
make install
mkdir /usr/local/pgsql/datavcap
chown vcap /usr/local/pgsql/datavcap
su - vcap
/usr/local/pgsql/bin/initdb -D /usr/local/pgsql/datavcap
/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/datavcap > logfile 2>&1 &
/usr/local/pgsql/bin/createdb test
/usr/local/pgsql/bin/psql test
tar cvfz postgres-9.0.3-1.ppc64le.tar.gz *
 
tar xvfz postgresql-9.0.3.tar.gz ; cd postgresql-9.0.3

# download new versions of config.*
$ curl "http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD" > config.guess

cd ..
tar cvfz postgresql-9.0.3.tar.gz postgresql-9.0.3