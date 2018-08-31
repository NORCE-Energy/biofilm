#! /bin/bash
# Original script written by Roland Kaufmann

REPODIR="$PWD"
NAME=Hommel2015a
WHAT_TO_INSTALL="biofilm simulator ($NAME)" ./check_install_environment_is_ok.sh \
    || exit 1

TARGET="$DUNE_DUMUX_INSTALL_DIR"
cd "$TARGET"

# application
git clone https://git.iws.uni-stuttgart.de/dumux-pub/"$NAME" src/"$NAME"
mkdir -p bld/"$NAME"

# With a newer version of gcc, isnan and isinf should be changed to
#  std::isnan and std::isinf. See https://stackoverflow.com/q/39130040/2173773

for file in dumux/material/chemistry/biogeochemistry/biocarbonicacid.hh \
                dumux/implicit/2pbiomin/2pbiominvolumevariables.hh \
                test/modelcoupling/ncchem2pnctransp/modelfiles/2pbiochemvolumevariables.hh\
                dumux/material/chemistry/biogeochemistry/biocarbonicacidnoattachment.hh\
            ; do
    path=src/"$NAME"/"$file"
    if [[ -f $path ]] ; then
        perl -pi -E 's/(?<!std::)(isnan|isinf)/std::$1/g' "$path"
    fi
done

(cd bld/"$NAME"
 cmake ../../src/"$NAME" -DCMAKE_INSTALL_PREFIX="${TARGET}"  \
       -Ddune-common_DIR=$(readlink -f ../dune-common) \
       -Ddune-geometry_DIR=$(readlink -f ../dune-geometry) \
       -Ddune-istl_DIR=$(readlink -f ../dune-istl) \
       -Ddune-grid_DIR=$(readlink -f ../dune-grid) \
       -Ddune-localfunctions_DIR=$(readlink -f ../dune-localfunctions) \
       -Ddumux_DIR=$(readlink -f ../dumux) \
       -DUG_DIR="${TARGET}"/lib/cmake/ug && make)

# A weird bug (?) seems to introduce spurious semicolons and duplicate "-pthread" into
#  some of the generated files. I was not able to figure out the cause of this..
(cd bld/"$NAME"/appl/co2/biomin/CMakeFiles/biomin.dir
 perl -pi -E 's/-pthread;-pthread/-pthread/' flags.make
 perl -pi -E 's/-pthread-pthread/-pthread/' link.txt)


# The input file biomin.input refers to a grid "coefficient-study-radial.dgf" that does
# not exits. We will replace it with VanoGrid.dgf (a 1D grid for a columnproblem)

(cd bld/"$NAME"/appl/co2/biomin
 perl -pi -E 's{^File\s*=\s*grids/\Kcoefficient-study-radial.dgf}{VanoGrid.dgf}' biomin.input
 )

# The input file biomin.input also refers to an injection file
#    InjectionParamFile = injections/BikeRim1Inj.dat
# that does not exist
# Let's copy in a version taken from dumux-devel
#
(cd bld/"$NAME"/appl/co2/biomin
 cp "$REPODIR"/injection_schemes/BikeRim1Inj.dat .
 perl -pi -E 's{^InjectionParamFile\s*=\s*\Kinjections/BikeRim1Inj.dat}
      {BikeRim1Inj.dat}' biomin.input
 )

# The simulator entrypoint source file biomin.cc includes the header
#     initialbiofilmcolumnproblem.hh
# This header seems not to be consistent with the input file biomin.input
# Running ("biomin -ParameterFile biomin.input") gives a runtime error:
#    Mandatory parameter 'Initial.initBiofilmDistribution' was not specified. Abort!
# Instead we will use the columnproblemgeneral.hh:

(cd src/"$NAME"/appl/co2/biomin
 perl -pi -E 's{^//#include "columnproblemgeneral.hh"}
               {#include "columnproblemgeneral.hh"};
              s{^#include "initialbiofilmcolumnproblem.hh"}
               {^//#include "initialbiofilmcolumnproblem.hh"}' biomin.cc
 )
