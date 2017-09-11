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
	echo "    --add-depend-pkg           - add dependend packages"
	echo "    --define-build-order       - automatically define build order"
	echo "    --simulate                 - do not build"
	echo "    --check-recipe-quality     - check recipe quality"
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
		--add-depend-pkg) ADD_DEPEND_PKG=yes ;;
		--define-build-order) DEFINE_BUILD_ORDER=yes ;;
		--simulate) SIMULATE=yes ;;
		--check-recipe-quality) CHECK_RECIPE_QUALITY=yes ;;
		*)	die "Unsupported line"  ;;
	esac
	shift
done

message 'Package root' "${PKGROOT}"


packages=()
packages+=("mingw-w64-graphite2")
packages+=("mingw-w64-libpng")
packages+=("mingw-w64-pixman")

packages+=("mingw-w64-SDL")
packages+=("mingw-w64-opus")
packages+=("mingw-w64-orc")
packages+=("mingw-w64-pango")

packages+=("mingw-w64-make")
packages+=("mingw-w64-intel-tbb")
packages+=("mingw-w64-libcroco")
packages+=("mingw-w64-libdvdcss")
packages+=("mingw-w64-libdvdread")

packages+=("mingw-w64-libogg")
packages+=("mingw-w64-speexdsp")
packages+=("mingw-w64-flac")
packages+=("mingw-w64-libvorbis")
packages+=("mingw-w64-speex")



packages+=("mingw-w64-libsndfile")
packages+=("mingw-w64-portaudio")

packages+=("mingw-w64-celt")
packages+=("mingw-w64-chromaprint")

packages+=("mingw-w64-gsl")
packages+=("mingw-w64-gstreamer")
packages+=("mingw-w64-libtheora")
packages+=("mingw-w64-libvorbisidec-svn")
packages+=("mingw-w64-gst-plugins-base")
packages+=("mingw-w64-cogl")

packages+=("mingw-w64-clutter")

#packages+=("mingw-w64-daala-git")
packages+=("mingw-w64-faac")
packages+=("mingw-w64-faad2")
packages+=("mingw-w64-fluidsynth")
packages+=("mingw-w64-graphene")
packages+=("mingw-w64-yasm")
packages+=("mingw-w64-gsm")

packages+=("mingw-w64-libass")
packages+=("mingw-w64-libbs2b")

packages+=("mingw-w64-libdca-git")
packages+=("mingw-w64-libdvdnav")
packages+=("mingw-w64-libexif")
packages+=("mingw-w64-libgme")
packages+=("mingw-w64-libmodplug")
packages+=("mingw-w64-libmpeg2-git")

packages+=("mingw-w64-openal")
packages+=("mingw-w64-libsrtp")

packages+=("mingw-w64-zziplib")
packages+=("mingw-w64-assimp")
packages+=("mingw-w64-l-smash")

packages+=("mingw-w64-mpg123")
packages+=("mingw-w64-lame")
packages+=("mingw-w64-leptonica")
packages+=("mingw-w64-libbluray")
packages+=("mingw-w64-libmng")

packages+=("mingw-w64-tesseract-ocr")

packages+=("mingw-w64-opencore-amr")
packages+=("mingw-w64-szip")
packages+=("mingw-w64-x264-git")
packages+=("mingw-w64-xvidcore")
packages+=("mingw-w64-schroedinger")
packages+=("mingw-w64-x265")

packages+=("mingw-w64-cppunit")
packages+=("mingw-w64-libcaca")
packages+=("mingw-w64-libvpx")
packages+=("mingw-w64-wavpack")
packages+=("mingw-w64-ffmpeg")

packages+=("mingw-w64-hdf5")

packages+=("mingw-w64-libiconv")
packages+=("mingw-w64-boost")

packages+=("mingw-w64-libmariadbclient")
packages+=("mingw-w64-postgresql")
packages+=("mingw-w64-libharu")
packages+=("mingw-w64-vtk")

packages+=("mingw-w64-openblas")

packages+=("mingw-w64-eigen3")
packages+=("mingw-w64-python-nose")
packages+=("mingw-w64-python-numpy")

packages+=("mingw-w64-opencv")

packages+=("mingw-w64-openh264")

packages+=("mingw-w64-soundtouch")

packages+=("mingw-w64-zbar")

packages+=("mingw-w64-check")
packages+=("mingw-w64-daala-git")


packages+=("mingw-w64-glib-networking")
packages+=("mingw-w64-libshout")
packages+=("mingw-w64-libsoup")
packages+=("mingw-w64-taglib")


packages+=("mingw-w64-gst-plugins-good")
packages+=("mingw-w64-gst-plugins-bad")


packages+=("mingw-w64-libcddb")
packages+=("mingw-w64-a52dec")
packages+=("mingw-w64-libcdio")
packages+=("mingw-w64-twolame")

packages+=("mingw-w64-gst-plugins-ugly")
packages+=("mingw-w64-gst-libav")
packages+=("mingw-w64-gst-editing-services")

 



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
[[ $CHECK_RECIPE_QUALITY == yes ]] && {
	execute 'Approving recipe quality' check_recipe_quality
}
[[ $SIMULATE == yes ]] && {
	success 'Simulate only'
}

for package in "${packages[@]}"; do
	rm -rf "${PKGROOT}/${package}"/pkg
    rm -rf "${PKGROOT}/${package}"/src

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
