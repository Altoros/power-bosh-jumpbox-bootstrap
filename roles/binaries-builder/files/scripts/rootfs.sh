# 1. in a ppc64le machine git clone https://github.com/cloudfoundry/warden.git
# 2. Put two scripts (build.sh and helpers.sh) in warden/warden and execute

export postgres_version=9.0.3
export package_name=rootfs
export source_folder=/home/ubuntu/binary-builder/src
export build_folder=/home/ubuntu/binary-builder/build
export assets_folder=/home/ubuntu/binary-builder/assets
export blobs_folder=/home/ubuntu/bosh/release/blobs
export target_folder=$assets_folder/warden

cd $build_folder
gem install bundler
git clone --depth 1 --branch power https://github.com/Altoros/warden.git
chmod +x $assets_folder/warden/*.sh
cp $assets_folder/warden/*.sh $build_folder/warden/warden

cd $build_folder/warden/warden
./build.sh
