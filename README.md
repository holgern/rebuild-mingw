# rebuild-mingw
scripts for rebuilding MinGW-w64 targets from scratch

Beginning with the following packages:

mingw-w64-i686-binutils
mingw-w64-i686-bzip2
mingw-w64-i686-crt-git
mingw-w64-i686-expat
mingw-w64-i686-gcc
mingw-w64-i686-gcc-fortran
mingw-w64-i686-gcc-libgfortran
mingw-w64-i686-gcc-libs
mingw-w64-i686-gcc-objc
mingw-w64-i686-gdb
mingw-w64-i686-gdbm
mingw-w64-i686-gettext
mingw-w64-i686-gmp
mingw-w64-i686-headers-git
mingw-w64-i686-isl
mingw-w64-i686-libffi
mingw-w64-i686-libiconv
mingw-w64-i686-libsystre
mingw-w64-i686-libtre-git
mingw-w64-i686-libwinpthread-git
mingw-w64-i686-make
mingw-w64-i686-mpc
mingw-w64-i686-mpfr
mingw-w64-i686-ncurses
mingw-w64-i686-openssl
mingw-w64-i686-python2
mingw-w64-i686-readline
mingw-w64-i686-sqlite3
mingw-w64-i686-tcl
mingw-w64-i686-termcap
mingw-w64-i686-tk
mingw-w64-i686-windows-default-manifest
mingw-w64-i686-winpthreads-git
mingw-w64-i686-zlib

The provided scripts can be used to compile several mingw-packages from https://github.com/Alexpux/MINGW-packages.
Copy the scripts in the base directory of MINGW-packages.

Problematic are circular dependencies:
cmake - jsoncpp - qt5
doxygen - clang - qt5
fontconfig - freetype - harfbuzz - cairo

Order of using scripts is:
rebuild-curl.sh
rebuild-cmake.sh
pacman -S mingw-w64-i686-cmake
rebuild-cmake.sh
rebuild-python.sh
rebuild-cairo.sh
pacman -S mingw-w64-i686-fontconfig mingw-w64-i686-freetype mingw-w64-i686-harfbuzz mingw-w64-i686-cairo
rebuild-cairo.sh
rebuild-doxygen.sh
rebuild-qt5.sh
rebuild-poppler.sh
rebuild-imagemagick.sh
rebuild-gstreamer.sh
 