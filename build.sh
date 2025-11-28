#!/bin/sh

DEVICE_NAME=$1
BASE_PATH=$(pwd)

git clone --depth 1 --branch ${DEVICE_NAME} https://github.com/ikas-mc/openwrt.git openwrt
#git clone --depth 1 --branch main https://github.com/xx/openwrt-config.git openwrt-config

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

./scripts/feeds update -a
./scripts/feeds install -a

cp diffconfig .config
make defconfig
#echo "Final .config:"
#cat .config

make -j $(nproc) download world V=sc