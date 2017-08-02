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
packages+=("mingw-w64-SDL2")
packages+=("mingw-w64-librsvg")
packages+=("mingw-w64-hicolor-icon-theme")
packages+=("mingw-w64-adwaita-icon-theme")
packages+=("mingw-w64-gnome-common")
packages+=("mingw-w64-atk")
packages+=("mingw-w64-cogl")
packages+=("mingw-w64-djvulibre")
packages+=("mingw-w64-fftw")
packages+=("mingw-w64-fribidi")

packages+=("mingw-w64-ilmbase")
packages+=("mingw-w64-jbigkit")
packages+=("mingw-w64-libraqm")
packages+=("mingw-w64-lcms2")
packages+=("mingw-w64-libtool")
packages+=("mingw-w64-giflib")
packages+=("mingw-w64-libwebp")

packages+=("mingw-w64-openexr")
packages+=("mingw-w64-openjpeg2")
packages+=("mingw-w64-liblqr")
packages+=("mingw-w64-dbus")
packages+=("mingw-w64-libpaper")
packages+=("mingw-w64-json-glib")
packages+=("mingw-w64-libepoxy")
packages+=("mingw-w64-shared-mime-info")
packages+=("mingw-w64-gtk3")
packages+=("mingw-w64-ghostscript")
packages+=("mingw-w64-imagemagick")

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
    execute 'Building binary' makepkg-mingw --log --force --noprogressbar --skippgpcheck --nocheck --syncdeps --cleanbuild
    execute 'Building source' makepkg --noconfirm --force --noprogressbar --skippgpcheck --allsource --config '/etc/makepkg_mingw32.conf'
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
