#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm

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
wget http://ftp.gwdg.de/pub/misc/ftp.idsoftware.com/idstuff/quake3/linux/linuxq3apoint-1.32b-3.x86.run
cd ./ioq3
