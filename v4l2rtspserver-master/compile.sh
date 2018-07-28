#!/usr/bin/env bash
HOST=192.168.0.99
if [ "$#" -ge 1 ]; then
   HOST=$1
fi

TOOLCHAIN=$(pwd)/../toolchain/bin
CROSS_COMPILE=$TOOLCHAIN/mips-linux-gnu-
export CROSS_COMPILE=${CROSS_COMPILE}
export CC=${CROSS_COMPILE}gcc
export LD=${CROSS_COMPILE}g++
export PKG_CONFIG_PATH="$../_install/lib/pkgconfig"
export LIBRARY_PATH=../_install/lib
export CFLAGS="-muclibc -O3 -lrt -I../v4l2rtspserver-tools -I../_install/include/freetype2"
export CPPFLAGS="-muclibc -O3 -lrt -I../v4l2rtspserver-tools -I../_install/include/freetype2 -std=c++11"
export LDFLAGS="-muclibc -O3 -lrt -lstdc++ -lpthread -ldl"
rm CMakeCache.txt
rm -r CMakeFiles
cmake -DCMAKE_TOOLCHAIN_FILE="./dafang.toolchain"  -DCMAKE_INSTALL_PREFIX=./_install && make VERBOSE=1 -j4 install

if [ $? == 0 ]; then
  echo Copying to ${HOST} v4l2rtspserver 
  ftp-upload -h ${HOST} -u root --password ismart12 -d /system/sdcard/bin/ _install/bin/*
  for i in _install/libs/*
  do
      file=$(realpath $i)
      echo Copying to ${HOST} ${file}
      ftp-upload -h ${HOST} -u root --password ismart12 -d /system/sdcard/lib/ $file
  done
fi
