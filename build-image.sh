#!/bin/bash

DEVICE_NAME=$1
BASE_PATH=$(pwd)

source openwrt-config/devices/${DEVICE_NAME}/config.txt

curl -o openwrt.tar.zst ${CONFIG_SDK_URL}
tar --zstd -xvf openwrt.tar.zst
mv openwrt-imagebuilder-* openwrt-image
rm openwrt.tar.zst

cp openwrt-config/devices/${DEVICE_NAME}/custom.sh ./openwrt-image/custom.sh

cd openwrt-image

chmod +x ./custom.sh
./custom.sh

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