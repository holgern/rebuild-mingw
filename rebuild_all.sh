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
./rebuild-gcc.sh
./rebuild-curl.sh
./rebuild-cmake.sh
./rebuild-cmake.sh
./rebuild-python.sh
./rebuild-doxygen.sh
