#! /bin/bash
# Original script written by Roland Kaufmann

./check_install_environment_is_ok.sh || exit 1

NAME=Hommel2015a
TARGET="$DUNE_DUMUX_INSTALL_DIR"
read -p "Install biofilm simulator ($NAME) into directory \"$TARGET\" ? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
    echo "Abort."
fi

mkdir -p $TARGET
cd $TARGET
mkdir -p src
mkdir -p bld

# application
git clone https://git.iws.uni-stuttgart.de/dumux-pub/"$NAME" src/"$NAME"
mkdir -p bld/"$NAME"

# With a newer version of gcc, isnan and isinf should be changed to
#  std::isnan and std::isinf. See https://stackoverflow.com/q/39130040/2173773

for file in dumux/material/chemistry/biogeochemistry/biocarbonicacid.hh dumux/implicit/2pbiomin/2pbiominvolumevariables.hh test/modelcoupling/ncchem2pnctransp/modelfiles/2pbiochemvolumevariables.hh dumux/material/chemistry/biogeochemistry/biocarbonicacidnoattachment.hh ; do
    path=src/"$NAME"/"$file"
    if [[ -f $path ]] ; then
        perl -pi -E 's/(?<!std::)(isnan|isinf)/std::$1/g' $path
    fi
done

(cd bld/"$NAME"
 cmake ../../src/"$NAME" -DCMAKE_INSTALL_PREFIX=${TARGET}  -Ddune-common_DIR=$(readlink -f ../dune-common) -Ddune-geometry_DIR=$(readlink -f ../dune-geometry) -Ddune-istl_DIR=$(readlink -f ../dune-istl) -Ddune-grid_DIR=$(readlink -f ../dune-grid) -Ddune-localfunctions_DIR=$(readlink -f ../dune-localfunctions) -Ddumux_DIR=$(readlink -f ../dumux) -DUG_DIR=${TARGET}/lib/cmake/ug && make)


