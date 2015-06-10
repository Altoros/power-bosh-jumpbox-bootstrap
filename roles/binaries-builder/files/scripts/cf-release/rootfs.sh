# 1. in a ppc64le machine git clone https://github.com/cloudfoundry/warden.git
# 2. Put two scripts (build.sh and helpers.sh) in warden/warden and execute

scripts_folder=/home/ubuntu/binary-builder/bin
username=ubuntu
source $scripts_folder/helpers.sh

set_environment_variables rootfs '0.0.1'
go_to_build_folder

gem install bundler
git clone --depth 1 --branch power https://github.com/Altoros/warden.git
chmod +x $assets_folder/warden/*.sh
cp $assets_folder/warden/*.sh $build_folder/warden/warden

cd $build_folder/warden/warden
./build.sh
