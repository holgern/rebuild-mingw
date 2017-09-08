#!/bin/bash

readonly TOP_DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# AppVeyor and Drone Continuous Integration for MSYS2
# Author: Renato Silva <br.renatosilva@gmail.com>
# Author: Qian Hong <fracting@gmail.com>
# Author: Holger Nahrstaedt <holger@nahrstaedt>

# Configure
cd "$(dirname "$0")"
source $TOP_DIR/rebuild-library.sh
deploy_enabled && mkdir -p artifacts
deploy_enabled && mkdir -p artifacts_src
git_config user.email 'ci@msys2.org'
git_config user.name  'MSYS2 Continuous Integration'
#git remote add upstream 'https://github.com/Alexpux/MINGW-packages'
#git fetch --quiet upstream

# Detect
#list_commits  || failure 'Could not detect added commits'
#list_packages || failure 'Could not detect changed files'


readonly RUN_ARGS="$@"
[[ $# == 1 && $1 == --help || $[ $# == 0 ] == 1 ]] && {
	echo "usage:"
	echo "  ./${0##*/} --arch=<i686|x86_64> [OPTIONS] packagename"
	echo "  help:"
	echo "    --pkgroot=<path>           - specifies the packages root directory"
	exit 0
}

# **************************************************************************
PKGROOT=${TOP_DIR}
BUILD_ARCHITECTURE="x86_64"
while [[ $# > 0 ]]; do
	case $1 in
		--pkgroot=*)
			PKGROOT=$(realpath ${1/--pkgroot=/})
		;;
		*)	die "Unsupported line"  ;;
	esac
	shift
done

message 'Package root' "${PKGROOT}"


packages=()
for package in ${PKGROOT}/*; do
    if [[ -d $package ]]; then
	   packages+=("$package")
	fi
    unset package
done


message 'Processing changes' "${commits[@]}"


test -z "${packages}" && success 'No changes in package recipes'



#export MINGW_INSTALLS=mingw64

# Build
message 'Building packages' "${packages[@]}"
#execute 'Updating system' update_system


for package in "${packages[@]}"; do
	rm -rf "${PKGROOT}/${package}"/pkg
    rm -rf "${PKGROOT}/${package}"/src


    execute 'Building binary' makepkg-mingw --log --force --noprogressbar --skippgpcheck --nocheck --nodeps --cleanbuild --nobuild --noarchive --clean

    unset package
done