set -xe

./cf-release/download-all.sh
./update-configs.rb -c cf-release/config.yml

./cf-release/dea_next_gems.sh
./cf-release/gccgo_ppc64le_trusty.sh
./cf-release/mysql-client.sh
./cf-release/openjdk.sh
./cf-release/postgres.sh
./cf-release/rootfs.sh
