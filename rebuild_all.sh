#!/bin/bash

# Author: Holger Nahrstaedt <holger@nahrstaedt>

abort()
{
    echo >&2 '
***************
*** ABORTED ***
***************
'
    echo "An error occurred. Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e

readonly TOP_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# Configure
cd "$(dirname "$0")"
source $TOP_DIR/rebuild-library.sh
readonly LOGFILE="./logfile.txt"

if test -n "$(cat ${LOGFILE} | grep 'finished rebuild_all.sh')"; then
 rm -rf ${LOGFILE}
fi


echo "start rebuild_all.sh" | adddate >> ${LOGFILE}

if test -z "$(cat ${LOGFILE} | grep 'fresh_start.sh finished')"; then
./fresh_start.sh
echo "fresh_start.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'clean-all-packages.sh finished')"; then
./clean-all-packages.sh --pkgroot=/c/MINGW-packages/
echo "clean-all-packages.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-gcc.sh finished')"; then
./rebuild-gcc.sh --pkgroot=/c/MINGW-packages/
echo "rebuild-gcc.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-curl.sh finished')"; then
./rebuild-curl.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
echo "rebuild-curl.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-cmake.sh finished')"; then
./rebuild-cmake.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
echo "rebuild-cmake.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-cmake-second-run.sh finished')"; then
./rebuild-cmake-second-run.sh --pkgroot=/c/MINGW-packages/
echo "rebuild-cmake-second-run.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-python.sh finished')"; then
./rebuild-python.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
echo "rebuild-python.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-doxygen.sh finished')"; then
./rebuild-doxygen.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
./rebuild-doxygen.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
echo "rebuild-doxygen.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-harfbuzz.sh finished')"; then
./rebuild-harfbuzz.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
echo "rebuild-harfbuzz.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-harfbuzz-second_run.sh finished')"; then
./rebuild-harfbuzz-second_run.sh --pkgroot=/c/MINGW-packages/ 
echo "rebuild-harfbuzz-second_run.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-cairo.sh finished')"; then
./rebuild-cairo.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
echo "rebuild-cairo.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-cairo-second-run.sh finished')"; then
./rebuild-cairo-second-run.sh --pkgroot=/c/MINGW-packages/
echo "rebuild-cairo-second-run.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-imagemagick.sh finished')"; then
./rebuild-imagemagick.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
echo "rebuild-imagemagick.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-qt5.sh finished')"; then
./rebuild-qt5.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
echo "rebuild-qt5.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-qt5-second-run.sh finished')"; then
./rebuild-qt5-second-run.sh --pkgroot=/c/MINGW-packages/
echo "rebuild-qt5-second-run.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-gstreamer.sh finished')"; then
./rebuild-gstreamer.sh --pkgroot=/c/MINGW-packages/ --do-not-reinstall
echo "rebuild-gstreamer.sh finished" | adddate >> ${LOGFILE}
fi

echo "finished rebuild_all.sh" | adddate >> ${LOGFILE}

trap : 0

echo >&2 '
************
*** DONE *** 
************
'