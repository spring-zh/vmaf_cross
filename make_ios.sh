#!/bin/bash

BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIBVMAF_PATH=${BASE_PATH}/vmaf/libvmaf
LIBVMAF_INSTALL=${BASE_PATH}/install
pushd ${LIBVMAF_PATH}

git reset --hard v2.2.1
rm -rf build-*

# prepare
python3 -m pip install virtualenv
python3 -m virtualenv .venv
source .venv/bin/activate
pip install meson

meson setup --prefix ${BASE_PATH}/build-ios-armv7 --cross-file ${BASE_PATH}/iphone_armv7.txt build-ios-armv7
ninja -vC build-ios-armv7 install

meson setup --prefix ${BASE_PATH}/build-ios-arm64 --cross-file ${BASE_PATH}/iphone_arm64.txt build-ios-arm64
ninja -vC build-ios-arm64 install

popd

if [ ! -d $LIBVMAF_INSTALL  ]; then
  mkdir $LIBVMAF_INSTALL
  mkdir $LIBVMAF_INSTALL/include
  mkdir $LIBVMAF_INSTALL/lib
fi

cp -r ${BASE_PATH}/build-ios-arm64/include ${LIBVMAF_INSTALL}/include
lipo -create ${BASE_PATH}/build-ios-arm64/lib/libvmaf.a ${BASE_PATH}/build-ios-armv7/lib/libvmaf.a -output ${LIBVMAF_INSTALL}/lib/libvmaf.a