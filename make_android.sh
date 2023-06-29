#!/bin/bash

ANDROID_SDK=/Users/shenpeng.zhang/Library/Android/sdk
ANDROID_NDK=/Users/shenpeng.zhang/Library/Android/sdk/ndk/21.4.7075529
BASE_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
LIBVMAF_PATH=${BASE_PATH}/vmaf/libvmaf
LIBVMAF_INSTALL=${BASE_PATH}/install

sed -i '' 's|ANDROID_NDK|/Users/shenpeng.zhang/Library/Android/sdk/ndk/21.4.7075529|g' ${BASE_PATH}/android_armv7.txt
sed -i '' 's|ANDROID_SDK|/Users/shenpeng.zhang/Library/Android/sdk|g' ${BASE_PATH}/android_armv7.txt
sed -i '' 's|ANDROID_NDK|/Users/shenpeng.zhang/Library/Android/sdk/ndk/21.4.7075529|g' ${BASE_PATH}/android_arm64.txt
sed -i '' 's|ANDROID_SDK|/Users/shenpeng.zhang/Library/Android/sdk|g' ${BASE_PATH}/android_arm64.txt

pushd ${LIBVMAF_PATH}

git reset --hard v2.2.1
rm -rf build-*

# prepare
python3 -m pip install virtualenv
python3 -m virtualenv .venv
source .venv/bin/activate
pip install meson

meson setup --prefix ${BASE_PATH}/build-android-armv7 --cross-file ${BASE_PATH}/android_armv7.txt build-android-armv7
ninja -vC build-android-armv7 install

meson setup --prefix ${BASE_PATH}/build-android-arm64 --cross-file ${BASE_PATH}/android_arm64.txt build-android-arm64
ninja -vC build-android-arm64 install

popd

# if [ ! -d $LIBVMAF_INSTALL  ]; then
#   mkdir $LIBVMAF_INSTALL
#   mkdir $LIBVMAF_INSTALL/include
#   mkdir $LIBVMAF_INSTALL/lib
# fi

# cp -r ${BASE_PATH}/build-ios-arm64/include ${LIBVMAF_INSTALL}/include
# lipo -create ${BASE_PATH}/build-ios-arm64/lib/libvmaf.a ${BASE_PATH}/build-ios-armv7/lib/libvmaf.a -output ${LIBVMAF_INSTALL}/lib/libvmaf.a