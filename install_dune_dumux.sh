#! /bin/bash
# Original script by Roland Kaufmann

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPODIR="$SCRIPT_DIR"
WHAT_TO_INSTALL="DUNE and DuMuX" "$REPODIR"/check_install_environment_is_ok.sh || exit 1

DUNE_VERSION="2.3"
DUMUX_VERSION="2.7"
TARGET="$DUNE_DUMUX_INSTALL_DIR"
cd "$TARGET"

# download source from repositories
for module in common istl geometry localfunctions grid; do
    git clone -b releases/"$DUNE_VERSION" \
        https://github.com/dune-project/dune-$module src/dune-$module
done

for module in common istl geometry localfunctions grid; do
    mkdir -p bld/dune-$module
    (cd bld/dune-$module
     cmake ../../src/dune-$module -DCMAKE_INSTALL_PREFIX="${TARGET}" \
           -Ddune-common_DIR=$(readlink -f ../dune-common) \
           -Ddune-geometry_DIR=$(readlink -f ../dune-geometry) \
           -DUG_DIR="${TARGET}"/lib/cmake/ug
     make)
done

# download dumux
git clone -b releases/"$DUMUX_VERSION" \
    https://git.iws.uni-stuttgart.de/dumux-repositories/dumux.git src/dumux

# build and install dumux
mkdir -p bld/dumux
(cd bld/dumux
 cmake ../../src/dumux -DCMAKE_INSTALL_PREFIX="${TARGET}" \
       -Ddune-common_DIR=$(readlink -f ../dune-common) \
       -Ddune-grid_DIR=$(readlink -f ../dune-grid) \
       -Ddune-geometry_DIR=$(readlink -f ../dune-geometry) \
       -Ddune-localfunctions_DIR=$(readlink -f ../dune-localfunctions) \
       -DUG_DIR="${TARGET}"/lib/cmake/ug && make)
