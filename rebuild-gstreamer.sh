#!/bin/bash

# AppVeyor and Drone Continuous Integration for MSYS2
# Author: Renato Silva <br.renatosilva@gmail.com>
# Author: Qian Hong <fracting@gmail.com>
# Author: Holger Nahrstaedt <holger@nahrstaedt>

# Configure
cd "$(dirname "$0")"
source 'ci-library.sh'
deploy_enabled && mkdir artifacts
deploy_enabled && mkdir artifacts_src
git_config user.email 'ci@msys2.org'
git_config user.name  'MSYS2 Continuous Integration'
#git remote add upstream 'https://github.com/Alexpux/MINGW-packages'
#git fetch --quiet upstream

# Detect
#list_commits  || failure 'Could not detect added commits'
#list_packages || failure 'Could not detect changed files'


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

packages+=("mingw-w64-libsndfile")
packages+=("mingw-w64-portaudio")

packages+=("mingw-w64-celt")
packages+=("mingw-w64-chromaprint")

packages+=("mingw-w64-clutter")

#packages+=("mingw-w64-daala-git")
packages+=("mingw-w64-faac")
packages+=("mingw-w64-faad2")
packages+=("mingw-w64-fluidsynth")
packages+=("mingw-w64-graphene")
packages+=("mingw-w64-gsm")

packages+=("mingw-w64-libass")
packages+=("mingw-w64-libbs2b")

packages+=("mingw-w64-libdca-svn")
packages+=("mingw-w64-libdvdnav")
packages+=("mingw-w64-libexif")
packages+=("mingw-w64-libgme")
packages+=("mingw-w64-libmodplug")
packages+=("mingw-w64-libmpeg2-svn")

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
packages+=("mingw-w64-ffmpeg")

packages+=("mingw-w64-hdf5")

packages+=("mingw-w64-libiconv")
packages+=("mingw-w64-boost")

packages+=("mingw-w64-libmariadbclient")
packages+=("mingw-w64-postgresql")

packages+=("mingw-w64-vtk")

packages+=("mingw-w64-openblas")

packages+=("mingw-w64-eigen3")

packages+=("mingw-w64-python-nose")
packages+=("mingw-w64-python-numpy")

packages+=("mingw-w64-opencv")

packages+=("mingw-w64-openh264")
packages+=("mingw-w64-schroedinger")
packages+=("mingw-w64-soundtouch")
packages+=("mingw-w64-x265")
packages+=("mingw-w64-zbar")

packages+=("mingw-w64-daala-git")

packages+=("mingw-w64-gstreamer")
packages+=("mingw-w64-gst-plugins-base")
packages+=("mingw-w64-gst-plugins-good")
packages+=("mingw-w64-gst-plugins-bad")
packages+=("mingw-w64-gst-plugins-ugly")
packages+=("mingw-w64-gst-libav")
packages+=("mingw-w64-gst-editing-services")


message 'Processing changes' "${commits[@]}"
check_for_installed_packages
test -z "${packages}" && success 'No changes in package recipes'
define_build_order || failure 'Could not determine build order'

export MINGW_INSTALLS=mingw32

# Build
message 'Building packages' "${packages[@]}"
#execute 'Updating system' update_system
execute 'Approving recipe quality' check_recipe_quality
for package in "${packages[@]}"; do
	execute 'delete pkg' rm -rf "${package}"/pkg
	deploy_enabled && mv "${package}"/*.pkg.tar.xz artifacts
    execute 'Building binary' makepkg-mingw --log --force --noprogressbar --skippgpcheck --nocheck --syncdeps --cleanbuild
    execute 'Building source' makepkg --noconfirm --force --noprogressbar --skippgpcheck --allsource --config '/etc/makepkg_mingw64.conf'
    execute 'Installing' pacman --noprogressbar --noconfirm --upgrade *.pkg.tar.xz
    deploy_enabled && mv "${package}"/*.pkg.tar.xz artifacts
    deploy_enabled && mv "${package}"/*.src.tar.gz artifacts
    unset package
done

# Deploy
#deploy_enabled && cd artifacts || success 'All packages built successfully'
#execute 'Generating pacman repository' create_pacman_repository "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'Generating build references'  create_build_references  "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'
