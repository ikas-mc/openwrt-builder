#!/bin/bash

DEVICE_NAME=$1
ENABLE_DEBUG=$2
BASE_PATH=$(pwd)

source openwrt-config/devices/${DEVICE_NAME}/apk/env.txt

git clone --depth 1 --branch ${CONFIG_SOURCE_BRANCH} ${CONFIG_SOURCE_URL} openwrt

cd openwrt-config/ikas-packages
chmod +x ./project-list.sh
./project-list.sh >/dev/null 2>&1

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

if [ "$ENABLE_DEBUG" = "true" ]; then
    ./scripts/feeds update -a 
    ./scripts/feeds install -a

    cp diffconfig .config
    make defconfig
    cat .config

    make -j $(nproc) download world V=s
else
    ./scripts/feeds update -a >/dev/null 2>&1
    ./scripts/feeds install -a >/dev/null 2>&1

    cp diffconfig .config
    make defconfig

    make -j $(nproc) download world
fi