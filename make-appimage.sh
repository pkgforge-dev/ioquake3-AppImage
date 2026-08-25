#!/bin/sh

set -eu

ARCH=$(uname -m)
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://github.com/ioquake/ioq3/raw/refs/heads/main/misc/quake3.svg
export DEPLOY_OPENGL=1
export DEPLOY_PULSE=1

# Deploy dependencies
quick-sharun ./AppDir/bin/ioquake3 ./AppDir/bin/*
echo 'SHARUN_WORKING_DIR=${SHARUN_DIR}/bin' >> ./AppDir/.env
echo 'ANYLINUX_DO_NOT_LOAD_LIBS=libpipewire-0.3.so*:${ANYLINUX_DO_NOT_LOAD_LIBS}' >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage
