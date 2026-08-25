#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake       \
    openal      \
    sdl2-compat

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

# Comment this out if you need an AUR package
#make-aur-package ioquake3-git
#mkdir -p ./AppDir/bin
#mv -v /opt/quake3/* ./AppDir/bin

# If the application needs to be manually built that has to be done down here

# if you also have to make nightly releases check for DEVEL_RELEASE = 1
echo "Building ioquake3..."
echo "---------------------------------------------------------------"
REPO="https://github.com/ioquake/ioq3"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./ioq3
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
wget -P /tmp http://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/quake3/linux/linuxq3apoint-1.32b-3.x86.run
chmod +x /tmp/linuxq3apoint-1.32b-3.x86.run
ls
cd /tmp
./linuxq3apoint-1.32b-3.x86.run  --tar xf
mv -v ./baseq3 ./missionpack ./AppDir/bin

cd /ioq3
cmake -S ./ -B build -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SERVER=ON           \
        -DBUILD_CLIENT=ON           \
        -DBUILD_RENDERER_GL1=ON     \
        -DBUILD_RENDERER_GL2=ON     \
        -DBUILD_GAME_LIBRARIES=OFF  \
        -DBUILD_GAME_QVMS=OFF       \
        -DBUILD_STANDALONE=OFF      \
        -DUSE_RENDERER_DLOPEN=ON    \
        -DUSE_OPENAL=ON             \
        -DUSE_OPENAL_DLOPEN=OFF     \
        -DUSE_HTTP=ON               \
        -DUSE_CODEC_VORBIS=ON       \
        -DUSE_CODEC_OPUS=ON         \
        -DUSE_VOIP=ON               \
        -DUSE_MUMBLE=ON             \
        -DUSE_FREETYPE=ON           \
        -DUSE_INTERNAL_LIBS=OFF

cmake --build build
mv -v build/release/* ../AppDir/bin
