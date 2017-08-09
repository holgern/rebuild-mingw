# rebuild-mingw
scripts for rebuilding MinGW-w64 targets from scratch

Beginning with the following packages:
"""
mingw-w64-<arch>-binutils
mingw-w64-<arch>-bzip2
mingw-w64-<arch>-crt-git
mingw-w64-<arch>-expat
mingw-w64-<arch>-gcc
mingw-w64-<arch>-gcc-fortran
mingw-w64-<arch>-gcc-libgfortran
mingw-w64-<arch>-gcc-libs
mingw-w64-<arch>-gcc-objc
mingw-w64-<arch>-gdb
mingw-w64-<arch>-gdbm
mingw-w64-<arch>-gettext
mingw-w64-<arch>-gmp
mingw-w64-<arch>-headers-git
mingw-w64-<arch>-isl
mingw-w64-<arch>-libffi
mingw-w64-<arch>-libiconv
mingw-w64-<arch>-libsystre
mingw-w64-<arch>-libtre-git
mingw-w64-<arch>-libwinpthread-git
mingw-w64-<arch>-make
mingw-w64-<arch>-mpc
mingw-w64-<arch>-mpfr
mingw-w64-<arch>-ncurses
mingw-w64-<arch>-openssl
mingw-w64-<arch>-python2
mingw-w64-<arch>-readline
mingw-w64-<arch>-sqlite3
mingw-w64-<arch>-tcl
mingw-w64-<arch>-termcap
mingw-w64-<arch>-tk
mingw-w64-<arch>-windows-default-manifest
mingw-w64-<arch>-winpthreads-git
mingw-w64-<arch>-zlib
"""
The provided scripts can be used to compile several mingw-packages from https://github.com/Alexpux/MINGW-packages.
Copy the scripts in the base directory of MINGW-packages.

Problematic are circular dependencies:
cmake - jsoncpp - qt5
doxygen - clang - qt5
fontconfig - freetype - harfbuzz - cairo - poppler

Order of using scripts is:
* install msys2 from http://www.msys2.org/ to c:/msys64
* clone https://github.com/Alexpux/MINGW-packages.git to c:/MINGW-packages
* clone https://github.com/holgern/rebuild-mingw.git to c:/rebuild-mingw
* cp all mingw-w64-* directories from c:/rebuild-mingw to c:/MINGW-packages
* Modify packages in MINGW-packages as you wish
* start msys2-terminal
* do pacman -Syu
* close
* pacman -S $(cat /c/rebuild-mingw/package_list_msys.txt)
* remove all mingw-w64 packages with pacman -R $(pacman -Qq | grep mingw-w64)
* pacman -Syu 
* pacman -S mingw-w64-i686-toolchain mingw-w64-x86_64-toolchain
* ./rebuild_all.sh
