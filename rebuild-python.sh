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
	echo "    --arch=<i686|x86_64>       - specifies the architecture"
    echo "    --do-not-reinstall         - stop if package is already installed"
	echo "    --add_depend_pkg           - add dependend packages"
	echo "    --define_build_order       - automatically define build order"
	echo "    --simulate                 - do not build"
	exit 0
}

# **************************************************************************
PKGROOT=${TOP_DIR}
BUILD_ARCHITECTURE="x86_64"
[[ ${MINGW_INSTALLS} == mingw32 ]] && {
	BUILD_ARCHITECTURE="i686"
}
while [[ $# > 0 ]]; do
	case $1 in
		--arch=*)
			BUILD_ARCHITECTURE=${1/--arch=/}
			case $BUILD_ARCHITECTURE in
				i686)
				export MINGW_INSTALLS=mingw32
				;;
				x86_64)
				export MINGW_INSTALLS=mingw64
				;;
				*) die "Unsupported architecture: \"$BUILD_ARCHITECTURE\". terminate."  ;;
			esac
		;;
		--pkgroot=*)
			PKGROOT=$(realpath ${1/--pkgroot=/})
		;;
		--do-not-reinstall) NOT_REINSTALL=yes ;;
		--add_depend_pkg) ADD_DEPEND_PKG=yes ;;
		--define_build_order) DEFINE_BUILD_ORDER=yes ;;
		--simulate) SIMULATE=yes ;;
		*)	die "Unsupported line"  ;;
	esac
	shift
done

message 'Package root' "${PKGROOT}"

packages=()

packages+=("mingw-w64-libxml2") 
packages+=("mingw-w64-libgpg-error")
packages+=("mingw-w64-libgcrypt")

packages+=("mingw-w64-libxslt")
packages+=("mingw-w64-python3")
packages+=("mingw-w64-python2")


packages+=("mingw-w64-python-setuptools")
packages+=("mingw-w64-python-colorama")		
packages+=("mingw-w64-python-docutils")
packages+=("mingw-w64-python-imagesize")
packages+=("mingw-w64-python-markupsafe")
packages+=("mingw-w64-python-jinja")
packages+=("mingw-w64-python-pygments")

packages+=("mingw-w64-python-requests")
packages+=("mingw-w64-python-six")

packages+=("mingw-w64-python-sphinx")
packages+=("mingw-w64-python-pyasn1")
packages+=("mingw-w64-python-pycparser")

packages+=("mingw-w64-python-cffi")
packages+=("mingw-w64-python-idna")

packages+=("mingw-w64-python-asn1crypto")
packages+=("mingw-w64-python2-enum34")
packages+=("mingw-w64-python2-ipaddress")
packages+=("mingw-w64-python-cryptography")

packages+=("mingw-w64-python-pyopenssl")

packages+=("mingw-w64-python-ndg-httpsclient")
packages+=("mingw-w64-python-funcsigs")
packages+=("mingw-w64-python-pbr")
packages+=("mingw-w64-python-mock")
packages+=("mingw-w64-python-urllib3")

		
packages+=("mingw-w64-python-csssselect") 
packages+=("mingw-w64-python2-typing")
packages+=("mingw-w64-python-lxml") 
packages+=("mingw-w64-python-whoosh")
packages+=("mingw-w64-python-beaker")
packages+=("mingw-w64-python-mako")

packages+=("mingw-w64-python-pytz")
packages+=("mingw-w64-python-babel")
packages+=("mingw-w64-python-certifi")
packages+=("mingw-w64-python-chardet")


packages+=("mingw-w64-python-snowballstemmer")


packages+=("mingw-w64-python-sphinx-alabaster-theme")
packages+=("mingw-w64-python-sphinx_rtd_theme")
packages+=("mingw-w64-python-sphinxcontrib-websupport")




message 'Processing changes' "${commits[@]}"

[[ $ADD_DEPEND_PKG == yes ]] && {
	add_dependencies
}


[[ $NOT_REINSTALL == yes ]] && {
	execute 'Check for installed packages' check_for_installed_packages "${BUILD_ARCHITECTURE}"
}


test -z "${packages}" && success 'No changes in package recipes'

[[ $DEFINE_BUILD_ORDER == yes ]] && {
	define_build_order || failure 'Could not determine build order'
}


#export MINGW_INSTALLS=mingw64

# Build
message 'Building packages' "${packages[@]}"
#execute 'Updating system' update_system
execute 'Approving recipe quality' check_recipe_quality

[[ $SIMULATE == yes ]] && {
	success 'Simulate only'
}

for package in "${packages[@]}"; do
	execute 'Delete pkg' rm -rf "${PKGROOT}/${package}"/pkg
    execute 'Delete src' rm -rf "${PKGROOT}/${package}"/src

	deploy_enabled &&  mv "${PKGROOT}/${package}"/*.pkg.tar.xz $TOP_DIR/artifacts
    execute 'Building binary' makepkg-mingw --log --force --noprogressbar --skippgpcheck --nocheck --syncdeps --cleanbuild
    execute 'Building source' makepkg --noconfirm --force --noprogressbar --skippgpcheck --allsource --config '/etc/makepkg_mingw64.conf'
    execute 'Installing' pacman --noprogressbar --noconfirm --upgrade *.pkg.tar.xz
    deploy_enabled && mv "${PKGROOT}/${package}"/*.pkg.tar.xz $TOP_DIR/artifacts
    deploy_enabled && mv "${PKGROOT}/${package}"/*.src.tar.gz $TOP_DIR/artifacts_src
    unset package
done

# Deploy
#deploy_enabled && cd artifacts || success 'All packages built successfully'
#execute 'Generating pacman repository' create_pacman_repository "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'Generating build references'  create_build_references  "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'
