#!/bin/sh

DEVICE_NAME=$1
BASE_PATH=$(pwd)

cd openwrt-config/ikas-packages
chmod +x ./project-list.sh
./project-list.sh

cd $BASE_PATH
sed -i 's/src-link ikas/#src-link ikas/g' openwrt-config/openwrt/feeds.conf.default
echo "src-link ikas ${BASE_PATH}/openwrt-config/ikas-packages" >> openwrt-config/openwrt/feeds.conf.default

# ./scripts/diffconfig.sh > diffconfig
# cp diffconfig .config
# wget https://downloads.openwrt.org/releases/24.10.2/targets/ath79/generic/config.buildinfo -O .config
cp openwrt-config/devices/${DEVICE_NAME}/apk/config.buildinfo openwrt/.config
cp -r openwrt-config/openwrt/* openwrt/
cp openwrt-config/devices/${DEVICE_NAME}/custom.sh openwrt/custom.sh

cd openwrt

chmod +x ./custom.sh
./custom.sh

./scripts/feeds update -a
./scripts/feeds install -a

make defconfig

make -j $(nproc) download
make -j $(nproc)
make checksum