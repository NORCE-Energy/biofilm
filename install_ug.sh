#! /bin/bash
# Original script written by Roland Kaufmann

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPODIR="$SCRIPT_DIR"
WHAT_TO_INSTALL="UG" "$REPODIR"/check_install_environment_is_ok.sh || exit 1
TARGET="$DUNE_DUMUX_INSTALL_DIR"
cd "$TARGET"

mkdir -p src/ug
wget https://launchpad.net/ubuntu/+archive/primary/+files/ug_3.12.1.orig.tar.xz
tar -Jxf ug_3.12.1.orig.tar.xz --strip-components=1 -C src/ug
rm ug_3.12.1.orig.tar.xz
sed -i "s,AM_INIT_AUTOMAKE,AM_INIT_AUTOMAKE([subdir-objects])," src/ug/configure.ac
sed -i "/AC_CONFIG_HEADERS/aAC_CONFIG_MACRO_DIR([m4])" src/ug/configure.ac
(cd src/ug; autoreconf -is)
mkdir -p bld/ug
(cd bld/ug
../../src/ug/configure --enable-dune --enable-parallel --prefix=${TARGET} && make && make install)
