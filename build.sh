#!/bin/sh

DEVICE_NAME=$1
BASE_PATH=$(pwd)

cd openwrt-config/ikas-packages
chmod +x ./project-list.sh
./project-list.sh > /dev/null 2>&1

cd $BASE_PATH

# ./scripts/diffconfig.sh > diffconfig
# cp diffconfig .config
# wget https://downloads.openwrt.org/releases/24.10.2/targets/ath79/generic/config.buildinfo -O .config
cp openwrt-config/devices/${DEVICE_NAME}/apk/.config openwrt/diffconfig
cp openwrt-config/devices/${DEVICE_NAME}/custom.sh openwrt/custom.sh
cp -r openwrt-config/openwrt/* openwrt/

cd openwrt

chmod +x ./custom.sh
./custom.sh

#https://openwrt.org/docs/guide-developer/toolchain/use-buildsystem

cp diffconfig .config
./scripts/feeds update -a
./scripts/feeds install -a
echo "diff .config:"
cat .config

cp diffconfig .config
echo "build .config:"
cat .config

make defconfig

echo "Final .config:"
cat .config

make -j $(nproc) download world