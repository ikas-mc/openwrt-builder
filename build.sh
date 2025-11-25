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
cp openwrt-config/devices/${DEVICE_NAME}/apk/.config openwrt/.config
cp openwrt-config/devices/${DEVICE_NAME}/custom.sh openwrt/custom.sh
cp -r openwrt-config/openwrt/* openwrt/

cd openwrt

chmod +x ./custom.sh
./custom.sh

./scripts/feeds update -a
./scripts/feeds install -a

make defconfig

make -j $(nproc) download V=s
make -j $(nproc) V=s