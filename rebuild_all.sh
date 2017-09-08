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

PKGROOT="/c/MINGW-packages/"
BUILD_ARCHITECTURE="x86_64"
BUILD_mingw32=yes
BUILD_mingw64=yes
unset MINGW_INSTALLS
while [[ $# > 0 ]]; do
	case $1 in
		--arch=*)
			BUILD_ARCHITECTURE=${1/--arch=/}
			case $BUILD_ARCHITECTURE in
				i686)
				export MINGW_INSTALLS=mingw32
				BUILD_mingw64=no
				;;
				x86_64)
				export MINGW_INSTALLS=mingw64
				BUILD_mingw32=no
				;;
				*) die "Unsupported architecture: \"$BUILD_ARCHITECTURE\". terminate."  ;;
			esac
		;;
		--pkgroot=*)
			PKGROOT=$(realpath ${1/--pkgroot=/})
		;;
		*)	die "Unsupported line"  ;;
	esac
	shift
done

if test -n "$(cat ${LOGFILE} | grep 'finished rebuild_all.sh')"; then
 rm -rf ${LOGFILE}
fi


echo "start rebuild_all.sh" | adddate >> ${LOGFILE}

if test -z "$(cat ${LOGFILE} | grep 'fresh_start.sh finished')"; then
./fresh_start.sh
echo "fresh_start.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'clean-all-packages.sh finished')"; then
./clean-all-packages.sh --pkgroot=${PKGROOT}
echo "clean-all-packages.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-gcc.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-gcc.sh --pkgroot=${PKGROOT} --arch=i686
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-gcc.sh --pkgroot=${PKGROOT} --arch=x86_64
}
echo "rebuild-gcc.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-curl.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-curl.sh --pkgroot=${PKGROOT} --arch=i686 --do-not-reinstall --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-curl.sh --pkgroot=${PKGROOT} --arch=x86_64 --do-not-reinstall --check-recipe-quality
}
echo "rebuild-curl.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-cmake.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-cmake.sh --pkgroot=${PKGROOT} --arch=i686 --do-not-reinstall --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-cmake.sh --pkgroot=${PKGROOT} --arch=x86_64 --do-not-reinstall --check-recipe-quality
}
echo "rebuild-cmake.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-cmake-second-run.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-cmake-second-run.sh --pkgroot=${PKGROOT} --arch=i686 --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-cmake-second-run.sh --pkgroot=${PKGROOT} --arch=x86_64 --check-recipe-quality
}
echo "rebuild-cmake-second-run.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-python.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-python.sh --pkgroot=${PKGROOT} --arch=i686 --do-not-reinstall --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-python.sh --pkgroot=${PKGROOT} --arch=x86_64 --do-not-reinstall --check-recipe-quality
}
echo "rebuild-python.sh finished" | adddate >> ${LOGFILE}
fi


if test -z "$(cat ${LOGFILE} | grep 'rebuild-doxygen.sh finished')"; then
#pacman --noprogressbar --noconfirm -S mingw-w64-i686-clang  mingw-w64-x86_64-clang 
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-doxygen.sh --pkgroot=${PKGROOT} --arch=i686 --do-not-reinstall --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-doxygen.sh --pkgroot=${PKGROOT} --arch=x86_64 --do-not-reinstall --check-recipe-quality
}
echo "rebuild-doxygen.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-harfbuzz.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-harfbuzz.sh --pkgroot=${PKGROOT} --arch=i686 --do-not-reinstall --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-harfbuzz.sh --pkgroot=${PKGROOT} --arch=x86_64 --do-not-reinstall --check-recipe-quality
}
echo "rebuild-harfbuzz.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-harfbuzz-second_run.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-harfbuzz-second_run.sh --pkgroot=${PKGROOT}  --arch=i686
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-harfbuzz-second_run.sh --pkgroot=${PKGROOT}  --arch=x86_64
}
echo "rebuild-harfbuzz-second_run.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-cairo.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-cairo.sh --pkgroot=${PKGROOT} --arch=i686 --do-not-reinstall --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-cairo.sh --pkgroot=${PKGROOT} --arch=x86_64 --do-not-reinstall --check-recipe-quality
}
echo "rebuild-cairo.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-cairo-second-run.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-cairo-second-run.sh --pkgroot=${PKGROOT}  --arch=i686
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-cairo-second-run.sh --pkgroot=${PKGROOT}  --arch=x86_64
}
echo "rebuild-cairo-second-run.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-imagemagick.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-imagemagick.sh --pkgroot=${PKGROOT} --arch=i686 --do-not-reinstall --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-imagemagick.sh --pkgroot=${PKGROOT} --arch=x86_64 --do-not-reinstall --check-recipe-quality
}
echo "rebuild-imagemagick.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-qt5.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-qt5.sh --pkgroot=${PKGROOT} --arch=i686 --do-not-reinstall --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-qt5.sh --pkgroot=${PKGROOT} --arch=x86_64 --do-not-reinstall --check-recipe-quality
}
echo "rebuild-qt5.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-qt5-second-run.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-qt5-second-run.sh --pkgroot=${PKGROOT}  --arch=i686
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-qt5-second-run.sh --pkgroot=${PKGROOT}  --arch=x86_64
}
echo "rebuild-qt5-second-run.sh finished" | adddate >> ${LOGFILE}
fi

if test -z "$(cat ${LOGFILE} | grep 'rebuild-qtcreator.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-qtcreator.sh --pkgroot=${PKGROOT} --arch=i686 --do-not-reinstall --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-qtcreator.sh --pkgroot=${PKGROOT} --arch=x86_64 --do-not-reinstall --check-recipe-quality
}
echo "rebuild-qtcreator.sh finished" | adddate >> ${LOGFILE}
fi


if test -z "$(cat ${LOGFILE} | grep 'rebuild-gstreamer.sh finished')"; then
[[ $BUILD_mingw32 == yes ]] && {
./rebuild-gstreamer.sh --pkgroot=${PKGROOT} --arch=i686 --do-not-reinstall --check-recipe-quality
}
[[ $BUILD_mingw64 == yes ]] && {
./rebuild-gstreamer.sh --pkgroot=${PKGROOT} --arch=x86_64 --do-not-reinstall --check-recipe-quality
}
echo "rebuild-gstreamer.sh finished" | adddate >> ${LOGFILE}
fi

echo "finished rebuild_all.sh" | adddate >> ${LOGFILE}

trap : 0

echo >&2 '
************
*** DONE *** 
************
'