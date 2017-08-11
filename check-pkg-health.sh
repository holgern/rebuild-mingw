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
packages+=("mingw-w64-3proxy")
packages+=("mingw-w64-a52dec")
packages+=("mingw-w64-adns")
packages+=("mingw-w64-adwaita-icon-theme")
packages+=("mingw-w64-ag")
packages+=("mingw-w64-allegro")
packages+=("mingw-w64-angleproject-git")
packages+=("mingw-w64-ansicon-git")
packages+=("mingw-w64-antiword")
packages+=("mingw-w64-antlr3")
packages+=("mingw-w64-antlr4-runtime-cpp")
packages+=("mingw-w64-apr")
packages+=("mingw-w64-apr-util")
packages+=("mingw-w64-aria2")
packages+=("mingw-w64-aribb24")
packages+=("mingw-w64-arm-none-eabi-binutils")
packages+=("mingw-w64-arm-none-eabi-gcc")
packages+=("mingw-w64-arm-none-eabi-gdb")
packages+=("mingw-w64-arm-none-eabi-newlib")
packages+=("mingw-w64-armadillo")
packages+=("mingw-w64-arpack")
packages+=("mingw-w64-asciidoctor")
packages+=("mingw-w64-aspell")
packages+=("mingw-w64-aspell-de")
packages+=("mingw-w64-aspell-en")
packages+=("mingw-w64-aspell-es")
packages+=("mingw-w64-aspell-fr")
packages+=("mingw-w64-aspell-ru")
packages+=("mingw-w64-assimp")
packages+=("mingw-w64-assimp-git")
packages+=("mingw-w64-astyle")
packages+=("mingw-w64-atk")
packages+=("mingw-w64-atkmm")
packages+=("mingw-w64-atom-editor")
packages+=("mingw-w64-atom-shell")
packages+=("mingw-w64-attica-qt5")
packages+=("mingw-w64-avrdude")
packages+=("mingw-w64-aztecgen")
packages+=("mingw-w64-babl")
packages+=("mingw-w64-badvpn")
packages+=("mingw-w64-bc")
packages+=("mingw-w64-binaryen")
packages+=("mingw-w64-binutils")
packages+=("mingw-w64-binutils-git")
packages+=("mingw-w64-bison")
packages+=("mingw-w64-blender")
packages+=("mingw-w64-blender-git")
packages+=("mingw-w64-boost")
packages+=("mingw-w64-box2d")
packages+=("mingw-w64-breakpad-git")
packages+=("mingw-w64-bsdfprocessor")
packages+=("mingw-w64-btyacc")
packages+=("mingw-w64-bullet")
packages+=("mingw-w64-bwidget")
packages+=("mingw-w64-bzip2")
packages+=("mingw-w64-c-ares")
packages+=("mingw-w64-c99-to-c89")
packages+=("mingw-w64-ca-certificates")
packages+=("mingw-w64-cairo")
packages+=("mingw-w64-cairomm")
packages+=("mingw-w64-catch")
packages+=("mingw-w64-ccache")
packages+=("mingw-w64-cccl")
packages+=("mingw-w64-cego")
packages+=("mingw-w64-cegui")
packages+=("mingw-w64-celt")
packages+=("mingw-w64-cereal")
packages+=("mingw-w64-ceres-solver")
packages+=("mingw-w64-cfitsio")
packages+=("mingw-w64-cgal")
packages+=("mingw-w64-check")
packages+=("mingw-w64-chipmunk")
packages+=("mingw-w64-chromaprint")
packages+=("mingw-w64-chromium-dev")
packages+=("mingw-w64-clang")
packages+=("mingw-w64-clang-svn")
packages+=("mingw-w64-clang35")
packages+=("mingw-w64-cling-git")
packages+=("mingw-w64-clink-git")
packages+=("mingw-w64-cloog")
packages+=("mingw-w64-clucene")
packages+=("mingw-w64-clutter")
packages+=("mingw-w64-clutter-gst")
packages+=("mingw-w64-clutter-gtk")
packages+=("mingw-w64-cmake")
packages+=("mingw-w64-cmake-doc-qt")
packages+=("mingw-w64-cmake-git")
packages+=("mingw-w64-cmocka")
packages+=("mingw-w64-cocos2dx")
packages+=("mingw-w64-cocos2dx-console-git")
packages+=("mingw-w64-cocos2dx-git")
packages+=("mingw-w64-codelite-git")
packages+=("mingw-w64-cogl")
packages+=("mingw-w64-coin3d-hg")
packages+=("mingw-w64-collada-dom-svn")
packages+=("mingw-w64-conemu-git")
packages+=("mingw-w64-confuse")
packages+=("mingw-w64-connect")
packages+=("mingw-w64-coq")
packages+=("mingw-w64-cotire")
packages+=("mingw-w64-cppcheck")
packages+=("mingw-w64-cppreference-qt")
packages+=("mingw-w64-cpptest")
packages+=("mingw-w64-cppunit")
packages+=("mingw-w64-creduce")
packages+=("mingw-w64-creduce-git")
packages+=("mingw-w64-crt-git")
packages+=("mingw-w64-crypto++")
packages+=("mingw-w64-crypto++-git")
packages+=("mingw-w64-csfml")
packages+=("mingw-w64-ctags")
packages+=("mingw-w64-ctpl-git")
packages+=("mingw-w64-cunit")
packages+=("mingw-w64-curl")
packages+=("mingw-w64-cyrus-sasl")
packages+=("mingw-w64-cython")
packages+=("mingw-w64-cython-git")
packages+=("mingw-w64-d-feet")
packages+=("mingw-w64-daala-git")
packages+=("mingw-w64-db")
packages+=("mingw-w64-dbus")
packages+=("mingw-w64-dbus-glib")
packages+=("mingw-w64-dcadec")
packages+=("mingw-w64-desktop-file-utils")
packages+=("mingw-w64-devcon-git")
packages+=("mingw-w64-devhelp")
packages+=("mingw-w64-devil")
packages+=("mingw-w64-diffutils")
packages+=("mingw-w64-dime-hg")
packages+=("mingw-w64-discount")
packages+=("mingw-w64-distorm")
packages+=("mingw-w64-djvulibre")
packages+=("mingw-w64-dlfcn")
packages+=("mingw-w64-dlfcn-git")
packages+=("mingw-w64-dmake")
packages+=("mingw-w64-dnscrypt-proxy")
packages+=("mingw-w64-dnssec-anchors")
packages+=("mingw-w64-docbook-dsssl")
packages+=("mingw-w64-docbook-mathml")
packages+=("mingw-w64-docbook-sgml")
packages+=("mingw-w64-docbook-sgml31")
packages+=("mingw-w64-docbook-xml")
packages+=("mingw-w64-docbook-xsl")
packages+=("mingw-w64-doxygen")
packages+=("mingw-w64-dragon")
packages+=("mingw-w64-drmingw")
packages+=("mingw-w64-drmingw-git")
packages+=("mingw-w64-dsdp")
packages+=("mingw-w64-ducible-git")
packages+=("mingw-w64-dumb")
packages+=("mingw-w64-edd-dbg")
packages+=("mingw-w64-edd-fungo")
packages+=("mingw-w64-editrights")
packages+=("mingw-w64-eigen3")
packages+=("mingw-w64-emacs")
packages+=("mingw-w64-emacs-git")
packages+=("mingw-w64-enca")
packages+=("mingw-w64-enchant")
packages+=("mingw-w64-enet")
packages+=("mingw-w64-eog")
packages+=("mingw-w64-eog-plugins")
packages+=("mingw-w64-evince")
packages+=("mingw-w64-exiv2")
packages+=("mingw-w64-expat")
packages+=("mingw-w64-extra-cmake-modules")
packages+=("mingw-w64-faac")
packages+=("mingw-w64-faad2")
packages+=("mingw-w64-fann")
packages+=("mingw-w64-farstream")
packages+=("mingw-w64-fdk-aac")
packages+=("mingw-w64-ffmpeg")
packages+=("mingw-w64-ffms2")
packages+=("mingw-w64-fftw")
packages+=("mingw-w64-field3d")
packages+=("mingw-w64-file")
packages+=("mingw-w64-firebird-git")
packages+=("mingw-w64-firebird2-git")
packages+=("mingw-w64-firefox")
packages+=("mingw-w64-flac")
packages+=("mingw-w64-flatbuffers")
packages+=("mingw-w64-flex")
packages+=("mingw-w64-flexdll")
packages+=("mingw-w64-flickcurl")
packages+=("mingw-w64-fltk")
packages+=("mingw-w64-fluidsynth")
packages+=("mingw-w64-fmt")
packages+=("mingw-w64-fontconfig")
packages+=("mingw-w64-fossil")
packages+=("mingw-w64-fossil-fossil")
packages+=("mingw-w64-fox")
packages+=("mingw-w64-freeglut")
packages+=("mingw-w64-FreeImage")
packages+=("mingw-w64-freerdp-git")
packages+=("mingw-w64-freetds")
packages+=("mingw-w64-freetype")
packages+=("mingw-w64-fribidi")
packages+=("mingw-w64-ftgl")
packages+=("mingw-w64-gc")
packages+=("mingw-w64-gcc")
packages+=("mingw-w64-gcc-git")
packages+=("mingw-w64-gd")
packages+=("mingw-w64-gdal")
packages+=("mingw-w64-gdb")
packages+=("mingw-w64-gdb-git")
packages+=("mingw-w64-gdbm")
packages+=("mingw-w64-gdcm")
packages+=("mingw-w64-gdk-pixbuf2")
packages+=("mingw-w64-gdl")
packages+=("mingw-w64-gdl2")
packages+=("mingw-w64-gdlmm2")
packages+=("mingw-w64-geany")
packages+=("mingw-w64-geany-plugins")
packages+=("mingw-w64-gedit")
packages+=("mingw-w64-gedit-plugins")
packages+=("mingw-w64-gegl")
packages+=("mingw-w64-geoclue")
packages+=("mingw-w64-geocode-glib")
packages+=("mingw-w64-geoip")
packages+=("mingw-w64-geoip2-database")
packages+=("mingw-w64-geos")
packages+=("mingw-w64-gettext")
packages+=("mingw-w64-gexiv2")
packages+=("mingw-w64-gflags")
packages+=("mingw-w64-ghc")
packages+=("mingw-w64-ghex")
packages+=("mingw-w64-ghostscript")
packages+=("mingw-w64-giflib")
packages+=("mingw-w64-gimp")
packages+=("mingw-w64-gimp-ufraw")
packages+=("mingw-w64-git")
packages+=("mingw-w64-git-git")
packages+=("mingw-w64-git-lfs")
packages+=("mingw-w64-git-repo")
packages+=("mingw-w64-gitg")
packages+=("mingw-w64-gl2ps")
packages+=("mingw-w64-glade")
packages+=("mingw-w64-glade3")
packages+=("mingw-w64-glbinding")
packages+=("mingw-w64-glew")
packages+=("mingw-w64-glfw")
packages+=("mingw-w64-glib-networking")
packages+=("mingw-w64-glib2")
packages+=("mingw-w64-glib2-git")
packages+=("mingw-w64-glibmm")
packages+=("mingw-w64-glm")
packages+=("mingw-w64-global")
packages+=("mingw-w64-globjects")
packages+=("mingw-w64-glog")
packages+=("mingw-w64-glpk")
packages+=("mingw-w64-glsl-optimizer")
packages+=("mingw-w64-glslang")
packages+=("mingw-w64-gmime")
packages+=("mingw-w64-gmp")
packages+=("mingw-w64-gnome-calculator")
packages+=("mingw-w64-gnome-common")
packages+=("mingw-w64-gnome-doc-utils")
packages+=("mingw-w64-gnome-icon-theme")
packages+=("mingw-w64-gnome-icon-theme-symbolic")
packages+=("mingw-w64-gnome-js-common")
packages+=("mingw-w64-gnu-cobol-svn")
packages+=("mingw-w64-gnupg")
packages+=("mingw-w64-gnutls")
packages+=("mingw-w64-go")
packages+=("mingw-w64-gobject-introspection")
packages+=("mingw-w64-goocanvas")
packages+=("mingw-w64-googletest-git")
packages+=("mingw-w64-gperf")
packages+=("mingw-w64-gpgme")
packages+=("mingw-w64-gplugin")
packages+=("mingw-w64-gprbuild-gpl")
packages+=("mingw-w64-graphene")
packages+=("mingw-w64-graphicsmagick")
packages+=("mingw-w64-graphite2")
packages+=("mingw-w64-graphviz")
packages+=("mingw-w64-grep")
packages+=("mingw-w64-grpc")
packages+=("mingw-w64-gsasl")
packages+=("mingw-w64-gsettings-desktop-schemas")
packages+=("mingw-w64-gsl")
packages+=("mingw-w64-gsm")
packages+=("mingw-w64-gspell")
packages+=("mingw-w64-gss")
packages+=("mingw-w64-gst-editing-services")
packages+=("mingw-w64-gst-editing-services-git")
packages+=("mingw-w64-gst-libav")
packages+=("mingw-w64-gst-libav-git")
packages+=("mingw-w64-gst-plugins-bad")
packages+=("mingw-w64-gst-plugins-bad-git")
packages+=("mingw-w64-gst-plugins-base")
packages+=("mingw-w64-gst-plugins-base-git")
packages+=("mingw-w64-gst-plugins-good")
packages+=("mingw-w64-gst-plugins-good-git")
packages+=("mingw-w64-gst-plugins-ugly")
packages+=("mingw-w64-gst-plugins-ugly-git")
packages+=("mingw-w64-gst-python")
packages+=("mingw-w64-gst-python-git")
packages+=("mingw-w64-gst-rtsp-server")
packages+=("mingw-w64-gst-rtsp-server-git")
packages+=("mingw-w64-gstreamer")
packages+=("mingw-w64-gstreamer-git")
packages+=("mingw-w64-gtef")
packages+=("mingw-w64-gtest")
packages+=("mingw-w64-gtk-doc")
packages+=("mingw-w64-gtk-engine-murrine")
packages+=("mingw-w64-gtk-engine-unico")
packages+=("mingw-w64-gtk-engines")
packages+=("mingw-w64-gtk-vnc")
packages+=("mingw-w64-gtk2")
packages+=("mingw-w64-gtk3")
packages+=("mingw-w64-gtk3-git")
packages+=("mingw-w64-gtkada")
packages+=("mingw-w64-gtkglext")
packages+=("mingw-w64-gtkhtml3")
packages+=("mingw-w64-gtkimageview")
packages+=("mingw-w64-gtkmm")
packages+=("mingw-w64-gtkmm3")
packages+=("mingw-w64-gtksourceview2")
packages+=("mingw-w64-gtksourceview3")
packages+=("mingw-w64-gtksourceviewmm2")
packages+=("mingw-w64-gtksourceviewmm3")
packages+=("mingw-w64-gtkspell")
packages+=("mingw-w64-gtkspell3")
packages+=("mingw-w64-gtkwave")
packages+=("mingw-w64-guile")
packages+=("mingw-w64-gxml")
packages+=("mingw-w64-h2o")
packages+=("mingw-w64-harfbuzz")
packages+=("mingw-w64-hclient")
packages+=("mingw-w64-hdf5")
packages+=("mingw-w64-headers-git")
packages+=("mingw-w64-hicolor-icon-theme")
packages+=("mingw-w64-hidapi")
packages+=("mingw-w64-hlsl2glsl")
packages+=("mingw-w64-http-parser")
packages+=("mingw-w64-hub")
packages+=("mingw-w64-hunspell")
packages+=("mingw-w64-hunspell-en")
packages+=("mingw-w64-hyphen")
packages+=("mingw-w64-icon-naming-utils")
packages+=("mingw-w64-icoutils")
packages+=("mingw-w64-icu")
packages+=("mingw-w64-id3lib")
packages+=("mingw-w64-ilmbase")
packages+=("mingw-w64-imagemagick")
packages+=("mingw-w64-indent")
packages+=("mingw-w64-inkscape")
packages+=("mingw-w64-innoextract")
packages+=("mingw-w64-insight")
packages+=("mingw-w64-intel-tbb")
packages+=("mingw-w64-irrlicht")
packages+=("mingw-w64-isl")
packages+=("mingw-w64-iso-codes")
packages+=("mingw-w64-itk")
packages+=("mingw-w64-jansson")
packages+=("mingw-w64-jasper")
packages+=("mingw-w64-jbigkit")
packages+=("mingw-w64-jemalloc")
packages+=("mingw-w64-jpegoptim")
packages+=("mingw-w64-jq")
packages+=("mingw-w64-json-c")
packages+=("mingw-w64-json-glib")
packages+=("mingw-w64-jsoncpp")
packages+=("mingw-w64-jsonrpc-glib")
packages+=("mingw-w64-jucipp-git")
packages+=("mingw-w64-jxrlib")
packages+=("mingw-w64-karchive-qt5")
packages+=("mingw-w64-kcodecs-qt5")
packages+=("mingw-w64-kconfig-qt5")
packages+=("mingw-w64-kcoreaddons-qt5")
packages+=("mingw-w64-kcrash-qt5")
packages+=("mingw-w64-kcwsh-qt5-git")
packages+=("mingw-w64-kdbusaddons-qt5")
packages+=("mingw-w64-kglobalaccel-qt5")
packages+=("mingw-w64-kguiaddons-qt5")
packages+=("mingw-w64-ki18n-qt5")
packages+=("mingw-w64-kicad-doc")
packages+=("mingw-w64-kicad-git")
packages+=("mingw-w64-kidletime-qt5")
packages+=("mingw-w64-kimageformats-qt5")
packages+=("mingw-w64-kiss_fft")
packages+=("mingw-w64-kitemmodels-qt5")
packages+=("mingw-w64-kitemviews-qt5")
packages+=("mingw-w64-kjs-qt5")
packages+=("mingw-w64-kplotting-qt5")
packages+=("mingw-w64-kqoauth-qt4")
packages+=("mingw-w64-krita-git")
packages+=("mingw-w64-kwidgetsaddons-qt5")
packages+=("mingw-w64-kwindowsystem-qt5")
packages+=("mingw-w64-l-smash")
packages+=("mingw-w64-ladspa-sdk")
packages+=("mingw-w64-lame")
packages+=("mingw-w64-lapack")
packages+=("mingw-w64-LASzip")
packages+=("mingw-w64-latexila")
packages+=("mingw-w64-lcms")
packages+=("mingw-w64-lcms2")
packages+=("mingw-w64-lcov")
packages+=("mingw-w64-ldns")
packages+=("mingw-w64-leechcraft-git")
packages+=("mingw-w64-lensfun")
packages+=("mingw-w64-leptonica")
packages+=("mingw-w64-lfcbase")
packages+=("mingw-w64-lfcxml")
packages+=("mingw-w64-libarchive")
packages+=("mingw-w64-libart_lgpl")
packages+=("mingw-w64-libass")
packages+=("mingw-w64-libassuan")
packages+=("mingw-w64-libatomic_ops")
packages+=("mingw-w64-libbluray")
packages+=("mingw-w64-libbotan")
packages+=("mingw-w64-libbs2b")
packages+=("mingw-w64-libbsdf")
packages+=("mingw-w64-libc++")
packages+=("mingw-w64-libc++abi")
packages+=("mingw-w64-libcaca")
packages+=("mingw-w64-libcddb")
packages+=("mingw-w64-libcdio")
packages+=("mingw-w64-libcdio-paranoia")
packages+=("mingw-w64-libcdr")
packages+=("mingw-w64-libcello-git")
packages+=("mingw-w64-libcerf")
packages+=("mingw-w64-libchamplain")
packages+=("mingw-w64-libcmis")
packages+=("mingw-w64-libconfig")
packages+=("mingw-w64-libcroco")
packages+=("mingw-w64-libdca-svn")
packages+=("mingw-w64-libdvbpsi")
packages+=("mingw-w64-libdvdcss")
packages+=("mingw-w64-libdvdnav")
packages+=("mingw-w64-libdvdread")
packages+=("mingw-w64-libebml")
packages+=("mingw-w64-libelf")
packages+=("mingw-w64-libepoxy")
packages+=("mingw-w64-libevent")
packages+=("mingw-w64-libexif")
packages+=("mingw-w64-libffi")
packages+=("mingw-w64-libfreexl")
packages+=("mingw-w64-libftdi")
packages+=("mingw-w64-libgadu")
packages+=("mingw-w64-libgcrypt")
packages+=("mingw-w64-libgd")
packages+=("mingw-w64-libgda")
packages+=("mingw-w64-libgdata")
packages+=("mingw-w64-libgee")
packages+=("mingw-w64-libgeotiff")
packages+=("mingw-w64-libgit2")
packages+=("mingw-w64-libgit2-glib")
packages+=("mingw-w64-libglade")
packages+=("mingw-w64-libgme")
packages+=("mingw-w64-libgnomecanvas")
packages+=("mingw-w64-libgnurx")
packages+=("mingw-w64-libgoom2")
packages+=("mingw-w64-libgpg-error")
packages+=("mingw-w64-libgphoto2")
packages+=("mingw-w64-libgsf")
packages+=("mingw-w64-libguess")
packages+=("mingw-w64-libgusb")
packages+=("mingw-w64-libgweather")
packages+=("mingw-w64-libgxps")
packages+=("mingw-w64-libharu")
packages+=("mingw-w64-libical")
packages+=("mingw-w64-libical-glib")
packages+=("mingw-w64-libiconv")
packages+=("mingw-w64-libid3tag")
packages+=("mingw-w64-libidn")
packages+=("mingw-w64-libimagequant")
packages+=("mingw-w64-libimobiledevice")
packages+=("mingw-w64-libjpeg-turbo")
packages+=("mingw-w64-libkcw-qt5-git")
packages+=("mingw-w64-libkml")
packages+=("mingw-w64-libksba")
packages+=("mingw-w64-libLAS")
packages+=("mingw-w64-liblastfm")
packages+=("mingw-w64-liblastfm-qt4")
packages+=("mingw-w64-liblqr")
packages+=("mingw-w64-libmad")
packages+=("mingw-w64-libmangle-git")
packages+=("mingw-w64-libmariadbclient")
packages+=("mingw-w64-libmatroska")
packages+=("mingw-w64-libmaxminddb")
packages+=("mingw-w64-libmetalink")
packages+=("mingw-w64-libmicrohttpd")
packages+=("mingw-w64-libmicroutils")
packages+=("mingw-w64-libmikmod")
packages+=("mingw-w64-libmimic")
packages+=("mingw-w64-libmng")
packages+=("mingw-w64-libmodbus-git")
packages+=("mingw-w64-libmodplug")
packages+=("mingw-w64-libmongoose")
packages+=("mingw-w64-libmongoose-git")
packages+=("mingw-w64-libmowgli")
packages+=("mingw-w64-libmpcdec")
packages+=("mingw-w64-libmpeg2-svn")
packages+=("mingw-w64-libmypaint")
packages+=("mingw-w64-libmypaint-git")
packages+=("mingw-w64-libnice")
packages+=("mingw-w64-libnotify")
packages+=("mingw-w64-libntlm")
packages+=("mingw-w64-liboauth")
packages+=("mingw-w64-libodfgen")
packages+=("mingw-w64-libogg")
packages+=("mingw-w64-libosmpbf-git")
packages+=("mingw-w64-libotr")
packages+=("mingw-w64-libpaper")
packages+=("mingw-w64-libpeas")
packages+=("mingw-w64-libplist")
packages+=("mingw-w64-libpng")
packages+=("mingw-w64-libproxy")
packages+=("mingw-w64-libraqm")
packages+=("mingw-w64-LibRaw")
packages+=("mingw-w64-librdf")
packages+=("mingw-w64-librescl")
packages+=("mingw-w64-librest")
packages+=("mingw-w64-librevenge")
packages+=("mingw-w64-librocket-git")
packages+=("mingw-w64-librsvg")
packages+=("mingw-w64-librsync")
packages+=("mingw-w64-libsamplerate")
packages+=("mingw-w64-libsass")
packages+=("mingw-w64-libsecret")
packages+=("mingw-w64-libshout")
packages+=("mingw-w64-libsigc++")
packages+=("mingw-w64-libsignal-protocol-c-git")
packages+=("mingw-w64-libsmallchange-hg")
packages+=("mingw-w64-libsndfile")
packages+=("mingw-w64-libsodium")
packages+=("mingw-w64-libsoup")
packages+=("mingw-w64-libspatialite")
packages+=("mingw-w64-libspectre")
packages+=("mingw-w64-libspiro")
packages+=("mingw-w64-libsquish")
packages+=("mingw-w64-libsrtp")
packages+=("mingw-w64-libssh")
packages+=("mingw-w64-libssh2")
packages+=("mingw-w64-libswift")
packages+=("mingw-w64-libsystre")
packages+=("mingw-w64-libtasn1")
packages+=("mingw-w64-libtheora")
packages+=("mingw-w64-libtiff")
packages+=("mingw-w64-libtommath")
packages+=("mingw-w64-libtool")
packages+=("mingw-w64-libtorrent-rasterbar")
packages+=("mingw-w64-libtre-git")
packages+=("mingw-w64-libunistring")
packages+=("mingw-w64-libunwind-svn")
packages+=("mingw-w64-libusb")
packages+=("mingw-w64-libusb-compat-git")
packages+=("mingw-w64-libusbmuxd")
packages+=("mingw-w64-libuv")
packages+=("mingw-w64-libview")
packages+=("mingw-w64-libvirt")
packages+=("mingw-w64-libvirt-glib")
packages+=("mingw-w64-libvisio")
packages+=("mingw-w64-libvmime-git")
packages+=("mingw-w64-libvorbis")
packages+=("mingw-w64-libvorbisidec-svn")
packages+=("mingw-w64-libvpx")
packages+=("mingw-w64-libvterm-bzr")
packages+=("mingw-w64-libwebp")
packages+=("mingw-w64-libwebsockets")
packages+=("mingw-w64-libwmf")
packages+=("mingw-w64-libwpd")
packages+=("mingw-w64-libwpg")
packages+=("mingw-w64-libxml++")
packages+=("mingw-w64-libxml++2.6")
packages+=("mingw-w64-libxml2")
packages+=("mingw-w64-libxslt")
packages+=("mingw-w64-libyaml")
packages+=("mingw-w64-libzip")
packages+=("mingw-w64-live-media")
packages+=("mingw-w64-lmdb")
packages+=("mingw-w64-lmdbxx")
packages+=("mingw-w64-lua")
packages+=("mingw-w64-lua-bitop")
packages+=("mingw-w64-lua-lgi")
packages+=("mingw-w64-lua-lpeg")
packages+=("mingw-w64-lua-lsqlite3")
packages+=("mingw-w64-lua-luacom-git")
packages+=("mingw-w64-lua-luarocks")
packages+=("mingw-w64-lua51")
packages+=("mingw-w64-luabind-git")
packages+=("mingw-w64-luajit-git")
packages+=("mingw-w64-luatex-svn")
packages+=("mingw-w64-lz4")
packages+=("mingw-w64-lzo2")
packages+=("mingw-w64-m4")
packages+=("mingw-w64-make")
packages+=("mingw-w64-mathgl")
packages+=("mingw-w64-matio")
packages+=("mingw-w64-mbedtls")
packages+=("mingw-w64-mcfgthread-git")
packages+=("mingw-w64-mcpp")
packages+=("mingw-w64-meanwhile")
packages+=("mingw-w64-meld3")
packages+=("mingw-w64-memphis")
packages+=("mingw-w64-mesa")
packages+=("mingw-w64-meson")
packages+=("mingw-w64-metis")
packages+=("mingw-w64-mhook")
packages+=("mingw-w64-midori")
packages+=("mingw-w64-mingw-w64-libsigsegv-git")
packages+=("mingw-w64-MinHook")
packages+=("mingw-w64-miniupnpc")
packages+=("mingw-w64-mlpack")
packages+=("mingw-w64-mpc")
packages+=("mingw-w64-mpdecimal")
packages+=("mingw-w64-mpfr")
packages+=("mingw-w64-mpg123")
packages+=("mingw-w64-mpv")
packages+=("mingw-w64-msgpack-c")
packages+=("mingw-w64-msmtp")
packages+=("mingw-w64-muparser")
packages+=("mingw-w64-mypaint")
packages+=("mingw-w64-mypaint-git")
packages+=("mingw-w64-nanodbc")
packages+=("mingw-w64-nanovg-git")
packages+=("mingw-w64-nasm")
packages+=("mingw-w64-ncurses")
packages+=("mingw-w64-netcdf")
packages+=("mingw-w64-nettle")
packages+=("mingw-w64-nghttp2")
packages+=("mingw-w64-ngraph-gtk")
packages+=("mingw-w64-ngspice")
packages+=("mingw-w64-ngspice-git")
packages+=("mingw-w64-nim")
packages+=("mingw-w64-nimble")
packages+=("mingw-w64-ninja")
packages+=("mingw-w64-nlopt")
packages+=("mingw-w64-nodejs")
packages+=("mingw-w64-npm")
packages+=("mingw-w64-npth")
packages+=("mingw-w64-nsis")
packages+=("mingw-w64-nsis-nsisunz")
packages+=("mingw-w64-nsis-svn")
packages+=("mingw-w64-nspr")
packages+=("mingw-w64-nss")
packages+=("mingw-w64-ntldd-git")
packages+=("mingw-w64-nutsnbolts-hg")
packages+=("mingw-w64-nvidia-cg-toolkit")
packages+=("mingw-w64-ocaml")
packages+=("mingw-w64-ocaml-camlp4")
packages+=("mingw-w64-ocaml-findlib")
packages+=("mingw-w64-ocaml-lablgtk")
packages+=("mingw-w64-oce")
packages+=("mingw-w64-octave-hg")
packages+=("mingw-w64-octopi-git")
packages+=("mingw-w64-ogitor")
packages+=("mingw-w64-ogre")
packages+=("mingw-w64-ogre3d-hg")
packages+=("mingw-w64-ogreassimp-hg")
packages+=("mingw-w64-ois")
packages+=("mingw-w64-ois-git")
packages+=("mingw-w64-oniguruma")
packages+=("mingw-w64-openal")
packages+=("mingw-w64-openblas")
packages+=("mingw-w64-OpenBLAS-git")
packages+=("mingw-w64-opencl-headers")
packages+=("mingw-w64-opencollada-git")
packages+=("mingw-w64-opencolorio-git")
packages+=("mingw-w64-opencore-amr")
packages+=("mingw-w64-opencsg")
packages+=("mingw-w64-opencv")
packages+=("mingw-w64-openexr")
packages+=("mingw-w64-openh264")
packages+=("mingw-w64-openimageio")
packages+=("mingw-w64-openjpeg")
packages+=("mingw-w64-openjpeg2")
packages+=("mingw-w64-openldap")
packages+=("mingw-w64-openocd")
packages+=("mingw-w64-openocd-git")
packages+=("mingw-w64-openscad")
packages+=("mingw-w64-openscad-git")
packages+=("mingw-w64-openscenegraph")
packages+=("mingw-w64-openscenegraph-git")
packages+=("mingw-w64-openshadinglanguage")
packages+=("mingw-w64-openshadinglanguage-git")
packages+=("mingw-w64-openssl")
packages+=("mingw-w64-optipng")
packages+=("mingw-w64-opus")
packages+=("mingw-w64-opus-git")
packages+=("mingw-w64-opus-tools")
packages+=("mingw-w64-opusfile")
packages+=("mingw-w64-orc")
packages+=("mingw-w64-osgbullet-git")
packages+=("mingw-w64-osgearth")
packages+=("mingw-w64-osgearth-git")
packages+=("mingw-w64-osgocean-git")
packages+=("mingw-w64-osgqt")
packages+=("mingw-w64-osgqtquick")
packages+=("mingw-w64-osgworks-git")
packages+=("mingw-w64-osm-gps-map")
packages+=("mingw-w64-osmgpsmap-git")
packages+=("mingw-w64-osslsigncode")
packages+=("mingw-w64-p11-kit")
packages+=("mingw-w64-paho.mqtt.c")
packages+=("mingw-w64-pango")
packages+=("mingw-w64-pangomm")
packages+=("mingw-w64-pathtools")
packages+=("mingw-w64-pcre")
packages+=("mingw-w64-pdcurses")
packages+=("mingw-w64-pdfium-git")
packages+=("mingw-w64-pdftex-svn")
packages+=("mingw-w64-perl")
packages+=("mingw-w64-phodav")
packages+=("mingw-w64-physfs")
packages+=("mingw-w64-physfs-hg")
packages+=("mingw-w64-pidgin")
packages+=("mingw-w64-pidgin-hg")
packages+=("mingw-w64-pidgin++")
packages+=("mingw-w64-pidgin++-bzr")
packages+=("mingw-w64-pitivi-git")
packages+=("mingw-w64-pixman")
packages+=("mingw-w64-pkg-config")
packages+=("mingw-w64-pkgconf")
packages+=("mingw-w64-plplot")
packages+=("mingw-w64-png2ico")
packages+=("mingw-w64-pngcrush")
packages+=("mingw-w64-pngnq")
packages+=("mingw-w64-poco")
packages+=("mingw-w64-podofo")
packages+=("mingw-w64-polipo")
packages+=("mingw-w64-poppler")
packages+=("mingw-w64-poppler-data")
packages+=("mingw-w64-poppler-qt4")
packages+=("mingw-w64-popt")
packages+=("mingw-w64-port-scanner")
packages+=("mingw-w64-portablexdr")
packages+=("mingw-w64-portaudio")
packages+=("mingw-w64-portmidi")
packages+=("mingw-w64-postgresql")
packages+=("mingw-w64-postr")
packages+=("mingw-w64-potrace")
packages+=("mingw-w64-premake")
packages+=("mingw-w64-profit-hg")
packages+=("mingw-w64-proj")
packages+=("mingw-w64-protobuf")
packages+=("mingw-w64-protobuf-c")
packages+=("mingw-w64-pugixml")
packages+=("mingw-w64-purple-facebook")
packages+=("mingw-w64-purple-facebook-git")
packages+=("mingw-w64-purple-hangouts-hg")
packages+=("mingw-w64-purple-skypeweb")
packages+=("mingw-w64-purple-skypeweb-git")
packages+=("mingw-w64-putty")
packages+=("mingw-w64-putty-git")
packages+=("mingw-w64-putty-ssh")
packages+=("mingw-w64-pycairo")
packages+=("mingw-w64-pygobject")
packages+=("mingw-w64-pygobject2")
packages+=("mingw-w64-pygtksourceview2")
packages+=("mingw-w64-pyqt4")
packages+=("mingw-w64-pyqt5")
packages+=("mingw-w64-pyside-qt4")
packages+=("mingw-w64-pyside-tools-qt4")
packages+=("mingw-w64-python-appdirs")
packages+=("mingw-w64-python-asn1crypto")
packages+=("mingw-w64-python-babel")
packages+=("mingw-w64-python-beaker")
packages+=("mingw-w64-python-beautifulsoup4")
packages+=("mingw-w64-python-binwalk")
packages+=("mingw-w64-python-bsddb3")
packages+=("mingw-w64-python-certifi")
packages+=("mingw-w64-python-cffi")
packages+=("mingw-w64-python-characteristic")
packages+=("mingw-w64-python-chardet")
packages+=("mingw-w64-python-colorama")
packages+=("mingw-w64-python-coverage")
packages+=("mingw-w64-python-cryptography")
packages+=("mingw-w64-python-csssselect")
packages+=("mingw-w64-python-cvxopt")
packages+=("mingw-w64-python-cx_Freeze")
packages+=("mingw-w64-python-cycler")
packages+=("mingw-w64-python-dateutil")
packages+=("mingw-w64-python-decorator")
packages+=("mingw-w64-python-distutils-extra")
packages+=("mingw-w64-python-docutils")
packages+=("mingw-w64-python-et-xmlfile")
packages+=("mingw-w64-python-funcsigs")
packages+=("mingw-w64-python-h5py")
packages+=("mingw-w64-python-html5lib")
packages+=("mingw-w64-python-httplib2")
packages+=("mingw-w64-python-icu")
packages+=("mingw-w64-python-idna")
packages+=("mingw-w64-python-imagesize")
packages+=("mingw-w64-python-ipykernel")
packages+=("mingw-w64-python-ipython_genutils")
packages+=("mingw-w64-python-jdcal")
packages+=("mingw-w64-python-jinja")
packages+=("mingw-w64-python-jsonschema")
packages+=("mingw-w64-python-jupyter_client")
packages+=("mingw-w64-python-jupyter_console")
packages+=("mingw-w64-python-jupyter_core")
packages+=("mingw-w64-python-lhafile")
packages+=("mingw-w64-python-lxml")
packages+=("mingw-w64-python-mako")
packages+=("mingw-w64-python-markupsafe")
packages+=("mingw-w64-python-matplotlib")
packages+=("mingw-w64-python-mistune")
packages+=("mingw-w64-python-mock")
packages+=("mingw-w64-python-ndg-httpsclient")
packages+=("mingw-w64-python-networkx")
packages+=("mingw-w64-python-nose")
packages+=("mingw-w64-python-nuitka")
packages+=("mingw-w64-python-numexpr")
packages+=("mingw-w64-python-numpy")
packages+=("mingw-w64-python-openmdao")
packages+=("mingw-w64-python-openpyxl")
packages+=("mingw-w64-python-packaging")
packages+=("mingw-w64-python-pandas")
packages+=("mingw-w64-python-path")
packages+=("mingw-w64-python-pathlib2")
packages+=("mingw-w64-python-patsy")
packages+=("mingw-w64-python-pbr")
packages+=("mingw-w64-python-pdfrw")
packages+=("mingw-w64-python-pgen2")
packages+=("mingw-w64-python-pickleshare")
packages+=("mingw-w64-python-pillow")
packages+=("mingw-w64-python-pip")
packages+=("mingw-w64-python-pluggy")
packages+=("mingw-w64-python-pptx")
packages+=("mingw-w64-python-pretend")
packages+=("mingw-w64-python-prompt_toolkit")
packages+=("mingw-w64-python-psutil")
packages+=("mingw-w64-python-py")
packages+=("mingw-w64-python-pyasn1")
packages+=("mingw-w64-python-pyasn1-modules")
packages+=("mingw-w64-python-pycparser")
packages+=("mingw-w64-python-pygments")
packages+=("mingw-w64-python-pyopenssl")
packages+=("mingw-w64-python-pyparsing")
packages+=("mingw-w64-python-pytest")
packages+=("mingw-w64-python-pytz")
packages+=("mingw-w64-python-pywin32")
packages+=("mingw-w64-python-pyzmq")
packages+=("mingw-w64-python-qtconsole")
packages+=("mingw-w64-python-reportlab")
packages+=("mingw-w64-python-requests")
packages+=("mingw-w64-python-rst2pdf")
packages+=("mingw-w64-python-scandir")
packages+=("mingw-w64-python-scipy")
packages+=("mingw-w64-python-setuptools")
packages+=("mingw-w64-python-simplegeneric")
packages+=("mingw-w64-python-six")
packages+=("mingw-w64-python-snowballstemmer")
packages+=("mingw-w64-python-sphinx")
packages+=("mingw-w64-python-sphinx-alabaster-theme")
packages+=("mingw-w64-python-sphinx_rtd_theme")
packages+=("mingw-w64-python-sphinxcontrib-websupport")
packages+=("mingw-w64-python-sqlitedict")
packages+=("mingw-w64-python-statsmodels")
packages+=("mingw-w64-python-traitlets")
packages+=("mingw-w64-python-urllib3")
packages+=("mingw-w64-python-wcwidth")
packages+=("mingw-w64-python-webencodings")
packages+=("mingw-w64-python-whoosh")
packages+=("mingw-w64-python-win_unicode_console")
packages+=("mingw-w64-python-xlsxwriter")
packages+=("mingw-w64-python-yaml")
packages+=("mingw-w64-python-zope.event")
packages+=("mingw-w64-python-zope.interface")
packages+=("mingw-w64-python2")
packages+=("mingw-w64-python2-backports")
packages+=("mingw-w64-python2-backports.shutil_get_terminal_size")
packages+=("mingw-w64-python2-beautifulsoup3")
packages+=("mingw-w64-python2-cjson")
packages+=("mingw-w64-python2-enum34")
packages+=("mingw-w64-python2-ipaddress")
packages+=("mingw-w64-python2-ipython")
packages+=("mingw-w64-python2-pygtk")
packages+=("mingw-w64-python2-typing")
packages+=("mingw-w64-python3")
packages+=("mingw-w64-python3-ipython")
packages+=("mingw-w64-qbs")
packages+=("mingw-w64-qbs-git")
packages+=("mingw-w64-qca-qt4-git")
packages+=("mingw-w64-qca-qt5-git")
packages+=("mingw-w64-qemu")
packages+=("mingw-w64-qhull-git")
packages+=("mingw-w64-qjson-qt4")
packages+=("mingw-w64-qrencode")
packages+=("mingw-w64-qrupdate-svn")
packages+=("mingw-w64-qscintilla")
packages+=("mingw-w64-qt-installer-framework")
packages+=("mingw-w64-qt-solutions-git")
packages+=("mingw-w64-qt4")
packages+=("mingw-w64-qt5")
packages+=("mingw-w64-qt5-git")
packages+=("mingw-w64-qt5-static")
packages+=("mingw-w64-qtbinpatcher")
packages+=("mingw-w64-qtcreator")
packages+=("mingw-w64-qtwebkit")
packages+=("mingw-w64-quantlib")
packages+=("mingw-w64-quarter-hg")
packages+=("mingw-w64-quassel")
packages+=("mingw-w64-quazip")
packages+=("mingw-w64-qwt-qt4")
packages+=("mingw-w64-qwt-qt5")
packages+=("mingw-w64-qxmpp")
packages+=("mingw-w64-qxmpp-qt4")
packages+=("mingw-w64-rabbitmq-c")
packages+=("mingw-w64-ragel")
packages+=("mingw-w64-rapidjson")
packages+=("mingw-w64-raptor2")
packages+=("mingw-w64-rasqal")
packages+=("mingw-w64-readline")
packages+=("mingw-w64-readosm")
packages+=("mingw-w64-recode")
packages+=("mingw-w64-remake-git")
packages+=("mingw-w64-rhash")
packages+=("mingw-w64-rtmpdump-git")
packages+=("mingw-w64-rubberband")
packages+=("mingw-w64-ruby")
packages+=("mingw-w64-rust")
packages+=("mingw-w64-rust-git")
packages+=("mingw-w64-rxspencer")
packages+=("mingw-w64-sassc")
packages+=("mingw-w64-schroedinger")
packages+=("mingw-w64-scite")
packages+=("mingw-w64-scite-git")
packages+=("mingw-w64-SDL")
packages+=("mingw-w64-SDL_gfx")
packages+=("mingw-w64-SDL_image")
packages+=("mingw-w64-SDL_mixer")
packages+=("mingw-w64-SDL_net")
packages+=("mingw-w64-SDL_ttf")
packages+=("mingw-w64-SDL2")
packages+=("mingw-w64-SDL2_gfx")
packages+=("mingw-w64-SDL2_image")
packages+=("mingw-w64-SDL2_mixer")
packages+=("mingw-w64-SDL2_net")
packages+=("mingw-w64-SDL2_sound-hg")
packages+=("mingw-w64-SDL2_ttf")
packages+=("mingw-w64-sed")
packages+=("mingw-w64-sfml")
packages+=("mingw-w64-sgml-common")
packages+=("mingw-w64-shapelib")
packages+=("mingw-w64-shared-mime-info")
packages+=("mingw-w64-shiboken-qt4")
packages+=("mingw-w64-shishi-git")
packages+=("mingw-w64-silc-toolkit")
packages+=("mingw-w64-simage-hg")
packages+=("mingw-w64-simvoleon-hg")
packages+=("mingw-w64-sip")
packages+=("mingw-w64-smpeg")
packages+=("mingw-w64-smpeg2")
packages+=("mingw-w64-snappy")
packages+=("mingw-w64-snoregrowl")
packages+=("mingw-w64-snorenotify")
packages+=("mingw-w64-soci")
packages+=("mingw-w64-sofia-sip-git")
packages+=("mingw-w64-solid-qt5")
packages+=("mingw-w64-soqt-hg")
packages+=("mingw-w64-soundtouch")
packages+=("mingw-w64-source-highlight")
packages+=("mingw-w64-sparsehash")
packages+=("mingw-w64-spatialite-tools")
packages+=("mingw-w64-spdylay")
packages+=("mingw-w64-speex")
packages+=("mingw-w64-speexdsp")
packages+=("mingw-w64-spice-gtk")
packages+=("mingw-w64-spice-protocol")
packages+=("mingw-w64-spirv-tools")
packages+=("mingw-w64-sqlcipher")
packages+=("mingw-w64-sqlheavy")
packages+=("mingw-w64-sqlightning-git")
packages+=("mingw-w64-sqlite-analyzer")
packages+=("mingw-w64-sqlite3")
packages+=("mingw-w64-stxxl-git")
packages+=("mingw-w64-styrene-git")
packages+=("mingw-w64-suitesparse")
packages+=("mingw-w64-swig")
packages+=("mingw-w64-szip")
packages+=("mingw-w64-taglib")
packages+=("mingw-w64-tcl")
packages+=("mingw-w64-tcl-nsf")
packages+=("mingw-w64-tcllib")
packages+=("mingw-w64-tclvfs")
packages+=("mingw-w64-tclx")
packages+=("mingw-w64-termcap")
packages+=("mingw-w64-tesseract-data")
packages+=("mingw-w64-tesseract-ocr")
packages+=("mingw-w64-thrift")
packages+=("mingw-w64-tidyhtml")
packages+=("mingw-w64-tinyformat")
packages+=("mingw-w64-tinyxml")
packages+=("mingw-w64-tinyxml2")
packages+=("mingw-w64-tk")
packages+=("mingw-w64-tkimg")
packages+=("mingw-w64-tklib")
packages+=("mingw-w64-tktable")
packages+=("mingw-w64-tolua")
packages+=("mingw-w64-tools-git")
packages+=("mingw-w64-tor")
packages+=("mingw-w64-totem-pl-parser")
packages+=("mingw-w64-tulip")
packages+=("mingw-w64-twolame")
packages+=("mingw-w64-uchardet")
packages+=("mingw-w64-udis86")
packages+=("mingw-w64-uhttpmock")
packages+=("mingw-w64-unbound")
packages+=("mingw-w64-unibilium")
packages+=("mingw-w64-universal-ctags-git")
packages+=("mingw-w64-uriparser")
packages+=("mingw-w64-usbmuxd")
packages+=("mingw-w64-usbredir")
packages+=("mingw-w64-usbview-git")
packages+=("mingw-w64-usql")
packages+=("mingw-w64-usrsctp")
packages+=("mingw-w64-v8")
packages+=("mingw-w64-vala")
packages+=("mingw-w64-vamp-plugin-sdk")
packages+=("mingw-w64-vcdimager")
packages+=("mingw-w64-verilator")
packages+=("mingw-w64-vid.stab")
packages+=("mingw-w64-vigra")
packages+=("mingw-w64-virt-viewer")
packages+=("mingw-w64-vlc-git")
packages+=("mingw-w64-vpp-git")
packages+=("mingw-w64-vtk")
packages+=("mingw-w64-vulkan")
packages+=("mingw-w64-vulkan-docs")
packages+=("mingw-w64-w32pth")
packages+=("mingw-w64-waf")
packages+=("mingw-w64-wavpack")
packages+=("mingw-w64-webkitgtk2")
packages+=("mingw-w64-webkitgtk3")
packages+=("mingw-w64-wget")
packages+=("mingw-w64-win7appid")
packages+=("mingw-w64-windows-default-manifest")
packages+=("mingw-w64-wined3d")
packages+=("mingw-w64-wineditline")
packages+=("mingw-w64-winico")
packages+=("mingw-w64-winpthreads-git")
packages+=("mingw-w64-winsparkle")
packages+=("mingw-w64-winsparkle-git")
packages+=("mingw-w64-winstorecompat-git")
packages+=("mingw-w64-wintab-sdk")
packages+=("mingw-w64-wkhtmltopdf-git")
packages+=("mingw-w64-wslay")
packages+=("mingw-w64-wxPython")
packages+=("mingw-w64-wxwidgets")
packages+=("mingw-w64-x264-git")
packages+=("mingw-w64-x265")
packages+=("mingw-w64-xalan-c")
packages+=("mingw-w64-xapian-core")
packages+=("mingw-w64-xerces-c")
packages+=("mingw-w64-xlnt")
packages+=("mingw-w64-xmlada-gpl")
packages+=("mingw-w64-xmlsec")
packages+=("mingw-w64-xmlstarlet")
packages+=("mingw-w64-xpdf")
packages+=("mingw-w64-xpm-nox")
packages+=("mingw-w64-xvidcore")
packages+=("mingw-w64-xxhash")
packages+=("mingw-w64-xz")
packages+=("mingw-w64-xz-git")
packages+=("mingw-w64-yajl")
packages+=("mingw-w64-yaml-cpp")
packages+=("mingw-w64-yaml-cpp0.3")
packages+=("mingw-w64-yasm")
packages+=("mingw-w64-zbar")
packages+=("mingw-w64-zeromq")
packages+=("mingw-w64-zlib")
packages+=("mingw-w64-zopfli")
packages+=("mingw-w64-zstd")
packages+=("mingw-w64-zziplib")




message 'Processing changes' "${commits[@]}"


test -z "${packages}" && success 'No changes in package recipes'



#export MINGW_INSTALLS=mingw64

# Build
message 'Building packages' "${packages[@]}"
#execute 'Updating system' update_system
execute 'Approving recipe quality' check_recipe_quality
