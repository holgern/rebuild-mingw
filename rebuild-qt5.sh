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


packages+=("mingw-w64-xpm-nox")
packages+=("mingw-w64-qtbinpatcher")

packages+=("mingw-w64-libyaml")

packages+=("mingw-w64-libatomic_ops")
#packages+=("mingw-w64-firebird2-git")

packages+=("mingw-w64-ninja")
packages+=("mingw-w64-ruby")
packages+=("mingw-w64-giflib")
packages+=("mingw-w64-zziplib")
packages+=("mingw-w64-assimp")
packages+=("mingw-w64-libmng")
packages+=("mingw-w64-libwebp")


packages+=("mingw-w64-qt5")
 





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
    deploy_enabled && mv "${package}"/*.src.tar.gz artifacts_src
    unset package
done

# Deploy
#deploy_enabled && cd artifacts || success 'All packages built successfully'
#execute 'Generating pacman repository' create_pacman_repository "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'Generating build references'  create_build_references  "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'
