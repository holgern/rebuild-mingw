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

./fresh_start.sh
./rebuild-gcc.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
./rebuild-curl.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
./rebuild-cmake.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
./rebuild-cmake-second-run.sh --pkgroot=/c/MINGW-packages/
./rebuild-python.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
./rebuild-doxygen.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
./rebuild-harfbuzz.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
./rebuild-harfbuzz-second_run.sh --pkgroot=/c/MINGW-packages/ 
./rebuild-cairo.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
./rebuild-cairo-second-run.sh --pkgroot=/c/MINGW-packages/
./rebuild-qt5.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall