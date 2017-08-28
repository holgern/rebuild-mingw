#!/bin/bash

# Author: Holger Nahrstaedt <holger@nahrstaedt>

readonly TOP_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Configure
cd "$(dirname "$0")"
source $TOP_DIR/rebuild-library.sh


./fresh_start.sh
./clean-all-packages.sh --pkgroot=/c/MINGW-packages/ 
./rebuild-gcc.sh --pkgroot=/c/MINGW-packages/ 
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
./rebuild-qt5-second-run.sh --pkgroot=/c/MINGW-packages/