#!/bin/bash

DEVICE_NAME=$1
BASE_PATH=$(pwd)

source openwrt-config/devices/${DEVICE_NAME}/apk/config.txt

curl -o openwrt.tar.zst ${CONFIG_SDK_URL}
tar --zstd -xvf openwrt.tar.zst
mv openwrt-imagebuilder-* openwrt-image
rm openwrt.tar.zst

cp -r openwrt-config/ikas-packages/packages/* ./openwrt-image/packages/

cd openwrt-image

make manifest \
STRIP_ABI=1 \
PROFILE="${CONFIG_PROFILE}" \
PACKAGES="${CONFIG_PACKAGES}" 

make image \
PROFILE="${CONFIG_PROFILE}" \
PACKAGES="${CONFIG_PACKAGES}" \
FILES="${CONFIG_FILES}" \
DISABLED_SERVICES="${CONFIG_DISABLED_SERVICES}" \
ADD_LOCAL_KEY=1 \
ROOTFS_PARTSIZE="${CONFIG_ROOTFS_PARTSIZE}"