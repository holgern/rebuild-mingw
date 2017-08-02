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

#packages to install
#mingw-w64-libcaca
#mingw-w64-sqlite3
#mingw-w64-gnutls
#mingw-w64-libunistring
#mingw-w64-nettle



packages=()

packages+=("mingw-w64-lib	xml2") 
packages+=("mingw-w64-libgcrypt")
packages+=("mingw-w64-libgpg-error")
packages+=("mingw-w64-libxslt")
packages+=("mingw-w64-python3")
packages+=("mingw-w64-python2")
packages+=("mingw-w64-python-csssselect") 

packages+=("mingw-w64-python-lxml") 

packages+=("mingw-w64-python-setuptools")
packages+=("mingw-w64-python-six")

packages+=("mingw-w64-python-beaker")
packages+=("mingw-w64-python-mako")
packages+=("mingw-w64-python-markupsafe")

packages+=("mingw-w64-python-babel")
packages+=("mingw-w64-python-certifi")
packages+=("mingw-w64-python-chardet")
packages+=("mingw-w64-python-colorama")
packages+=("mingw-w64-python-docutils")
packages+=("mingw-w64-python-idna")
packages+=("mingw-w64-python-imagesize")
packages+=("mingw-w64-python-jinja")
packages+=("mingw-w64-python-pygments")
packages+=("mingw-w64-python-pytz")
packages+=("mingw-w64-python-requests")
packages+=("mingw-w64-python-six")
packages+=("mingw-w64-python-snowballstemmer")
packages+=("mingw-w64-python-sphinx-alabaster-theme")
packages+=("mingw-w64-python-sphinx_rtd_theme")
packages+=("mingw-w64-python-sphinxcontrib-websupport")
packages+=("mingw-w64-python-urllib3")
packages+=("mingw-w64-python-whoosh")

packages+=("mingw-w64-python-sphinx")


packages+=("mingw-w64-python-pyasn1")
packages+=("mingw-w64-python-pycparser")
packages+=("mingw-w64-python-cffi")
packages+=("mingw-w64-python-asn1crypto")


packages+=("mingw-w64-python2-typing")

packages+=("mingw-w64-python2-enum34")
packages+=("mingw-w64-python2-ipaddress")

packages+=("mingw-w64-python-cryptography")

packages+=("mingw-w64-python-funcsigs")
packages+=("mingw-w64-python-pbr")
packages+=("mingw-w64-python-mock")
packages+=("mingw-w64-python-ndg-httpsclient")
packages+=("mingw-w64-python-pyopenssl")

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
deploy_enabled && cd artifacts || success 'All packages built successfully'
#execute 'Generating pacman repository' create_pacman_repository "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'Generating build references'  create_build_references  "${PACMAN_REPOSITORY_NAME:-ci-build}"
#execute 'SHA-256 checksums' sha256sum *
success 'All artifacts built successfully'
