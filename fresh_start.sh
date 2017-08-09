#!/bin/bash

# Author: Holger Nahrstaedt <holger@nahrstaedt>

# Configure
cd "$(dirname "$0")"
source 'ci-library.sh'
mkdir artifacts_old
mkdir artifacts
mv artifacts/* artifacts_old

mkdir artifacts_src_old
mkdir artifacts_src
mv artifacts_src/* artifacts_src_old

pacman -S git

git_config user.email 'ci@msys2.org'
git_config user.name  'MSYS2 Continuous Integration'
#git remote add upstream 'https://github.com/Alexpux/MINGW-packages'
#git fetch --quiet upstream

# Detect
#list_commits  || failure 'Could not detect added commits'
#list_packages || failure 'Could not detect changed files'

pacman -R $(pacman -Qq | grep mingw-w64)
pacman -Syu
pacman -S mingw-w64-i686-toolchain mingw-w64-x86_64-toolchain