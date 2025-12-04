#!/bin/sh

DEVICE_NAME=$1
BASE_PATH=$(pwd)

source openwrt-config/devices/${DEVICE_NAME}/sdk_package_env.txt

cd openwrt-config/ikas-packages
chmod +x ./project-list.sh
./project-list.sh > /dev/null 2>&1
cd $BASE_PATH

curl -o openwrt.sdk.tar.zst ${CONFIG_SDK_URL}
tar --zstd -xvf openwrt.sdk.tar.zst
mv openwrt-sdk-* openwrt-sdk
rm openwrt.sdk.tar.zst

cp openwrt-config/devices/${DEVICE_NAME}/apk/sdk_package_config.txt openwrt-sdk/diffconfig
cp -r openwrt-config/openwrt/* openwrt-sdk/

cd openwrt-sdk

./scripts/feeds update -a
./scripts/feeds install -a

cp diffconfig .config
make defconfig

make -j $(nproc)  V=sc IGNORE_ERRORS=m