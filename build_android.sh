#!/bin/bash

# Set up environment variables
export TARGET="aarch64-linux-android"
export API="21"
# export ANDROID_NDK_HOME="/opt/homebrew/share/android-ndk"
export ANDROID_NDK_HOME=$ANDROID_SDK_ROOT
export TOOLCHAIN="$ANDROID_NDK_HOME/toolchains/llvm/prebuilt/darwin-x86_64"
export PATH="$TOOLCHAIN/bin:$PATH"
export AR="llvm-ar"
export CC="$TARGET$API-clang"
export CXX="$TARGET$API-clang++"
export LD="ld.lld"
export RANLIB="llvm-ranlib"
export STRIP="llvm-strip"

# Create build directory
mkdir -p ~/android-build
cd ~/android-build

# Build libtool
echo "Building libtool..."
wget https://ftp.gnu.org/gnu/libtool/libtool-2.4.7.tar.gz
tar -xvzf libtool-2.4.7.tar.gz
cd libtool-2.4.7
rm -rf install
mkdir install
./configure CFLAGS="-fPIC" --host=$TARGET --prefix=$PWD/install --enable-shared --disable-static --enable-ltdl-install
make
make install
cd ..

# Build libusb
echo "Building libusb..."
wget https://github.com/libusb/libusb/releases/download/v1.0.26/libusb-1.0.26.tar.bz2
tar -xvjf libusb-1.0.26.tar.bz2
cd libusb-1.0.26
rm -rf install
mkdir install
./configure CFLAGS="-fPIC" --host=$TARGET --prefix=$PWD/install --disable-shared --enable-static --disable-udev --disable-ltdl
make
make install
cd ..

# Build libxml2
echo "Building libxml2..."
wget https://download.gnome.org/sources/libxml2/2.13/libxml2-2.13.6.tar.xz
tar -xvf libxml2-2.13.6.tar.xz
cd libxml2-2.13.6
rm -rf install
mkdir install
./configure CFLAGS="-fPIC" --host=$TARGET --prefix=$PWD/install --enable-shared --disable-static --without-python --without-zlib --without-lzma
make
make install
cd ..

# Clone libgphoto2
echo "Cloning libgphoto2..."
git clone https://github.com/gphoto/libgphoto2.git
cd libgphoto2

# there  is install doc text, terminal confuses it with install folder
rm INSTALL

# Build libgphoto2_port
echo "Building libgphoto2_port..."
cd libgphoto2_port
rm -rf install

mkdir -p ~/android-build/libgphoto2/install
autoreconf -i
./configure CFLAGS="-fPIC" --host=$TARGET --prefix=$HOME/android-build/libgphoto2/install --enable-shared --disable-static \
    LTDLINCL="-I$HOME/android-build/libtool-2.4.7/install/include" \
    LIBLTDL="-L$HOME/android-build/libtool-2.4.7/install/lib -lltdl"
make
make install



# Build libgphoto2
echo "Building libgphoto2..."
rm -rf install
mkdir install
autoreconf -i
export PKG_CONFIG_PATH="$HOME/android-build/libusb-1.0.26/install/lib/pkgconfig:$HOME/android-build/libxml2-2.13.6/install/lib/pkgconfig:$HOME/android-build/libgphoto2/install/lib/pkgconfig"
./configure CFLAGS="-fPIC" --host=$TARGET --prefix=$PWD/install --enable-shared --disable-static \
    --with-libusb=$HOME/android-build/libusb-1.0.26/install \
    --with-ltdl=$HOME/android-build/libtool-2.4.7/install \
    --with-libgphoto2-port=$HOME/android-build/libgphoto2/install \
    LTDLINCL="-I$HOME/android-build/libtool-2.4.7/install/include" \
    LIBLTDL="-L$HOME/android-build/libtool-2.4.7/install/lib -lltdl" \
    --disable-libusb-1.0-compat \
    --disable-ltdl
make
make install

echo "Build completed successfully!"`
