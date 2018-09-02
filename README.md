# DuMuX Hommel2015a biofilm simulator
A collection of scripts to install the DuMuX
biofilm simulator (written in C++) from the PhD thesis of J. Hommel [3]. The
source code has been maid publicly available [1].

The scripts will install the simulator assuming you neither have DUNE
nor DuMuX installed, and we assume a Linux system (tested on Ubuntu 18.04).

# Required packages

Before you run the scripts make sure you have the following packages
installed:

- autoconf
- bison
- cmake
- g++
- libblas-dev
- libopenmpi-dev
- libtool
- make
- flex

# Installation directory

Before running the scripts specify an installation directory by setting
the `DUNE_DUMUX_INSTALL_DIR` environment variable:
```
export DUNE_DUMUX_INSTALL_DIR=/path/to/install_dir
```
In the above line, replace `/path/to/install_dir` with your desired installation directory.

# Installation

The simulator consists of four components:
- UG [4],
- DUNE [5],
- DuMuX [6],
- Hommel2015a [1].

The biofilm simulator (Hommel2105a) is based on DUNE version 2.3, DuMuX version 2.7,
and UG version 3.12. 
All software installed by the scripts below will be put in a common
directory given by the environment variable `DUNE_DUMUX_INSTALL_DIR`.
The order of installation is also important. You should first install UG, then
DUNE, DuMuX, and finally the biofilm simulator. From the terminal
window, start by installing UG by running `install_ug.sh`. If it completes
successfully, proceed by running the `install_dune_dumux.sh`
script. And finally, if the previous two scripts completed
successfully, run `install_hommel.sh`:

```
$ ./install_ug.sh  # installs UG
$ ./install_dune_dumux.sh # installs DUNE and DuMuX
$ ./install_hommel.sh # installs Hommel2015a
```

# Compiling and running a test case

Compilation of a test case is done using `make` from the `biomin`
build folder:
```
$ cd $DUNE_DUMUX_INSTALL_DIR/bld/Hommel2015a/appl/co2/biomin
$ make biomin  #compiles biomin.cc
```
this will create the executable `$DUNE_DUMUX_INSTALL_DIR/bld/Hommel2015a/appl/co2/biomin/biomin`.
The source file `biomin.cc` is located in the source folder:
```
$ cd $DUNE_DUMUX_INSTALL_DIR/src/Hommel2015a/appl/co2/biomin
$ vim biomin.cc
```
After compiling, running the simulation is done from the build folder:
```
$ cd $DUNE_DUMUX_INSTALL_DIR/bld/Hommel2015a/appl/co2/biomin
$ ./biomin -ParameterFile biomin.input  # biomin.input is the input file
```
See Chapter 4, *Structure, Guidelines, New Folder Setup*, of 
the DuMuX manual [7] for more information about the build system.

# Input files

In the above test case, the main input file is
`$DUNE_DUMUX_INSTALL_DIR/bld/Hommel2015a/appl/co2/biomin/biomin.input`. This
file will again refer to the grid file:
`$DUNE_DUMUX_INSTALL_DIR/bld/Hommel2015a/appl/co2/biomin/grids/VanoGrid.dgf`
and the injection scheme file
`$DUNE_DUMUX_INSTALL_DIR/bld/Hommel2015a/appl/co2/biomin/BikeRim1Inj.dat`.

# References

[1] Hommel2015a: *A fully working version of the DuMuX code used for
the investigation of the influence of the initial biomass amount and distribution and
the injection strategy on the results of MICP as published in [2].*
[git.iws.uni-stuttgart.de/dumux-pub/Hommel2015a](https://git.iws.uni-stuttgart.de/dumux-pub/Hommel2015a).

[2] J. Hommel, E. Lauchnor, R. Gerlach, A.B. Cunningham, A. Ebigbo, R. Helmig,
and H. Class. *Investigating the influence of the initial biomass distribution and
injection strategies on biofilm-mediated calcite precipitation in porous media.*
Transp. Porous Media, 114(2):557–579, 2016.

[3] J. Hommel. *Modeling biogeochemical and mass transport processes in the
subsurface: Investigation of microbially induced calcite precipitation*. PhD
thesis, University of Stuttgart, 2016.

[4] P. Bastian, K. Birken, K. Johannsen, S. Lang, N. Neuß, H. Rentz-reichert, and
C. Wieners. *UG – a flexible software toolbox for solving partial differential
equations.* Computing and Visualization in Science, 1(1):27–40, 1997.

[5] P. Bastian, M. Blatt, A. Dedner, C. Engwer, R. Klöfkorn, R. Kurnhuber,
M. Ohlberger, and O. Sander. *A generic grid interface for parallel and adaptive
scientific computing. part II: Implementation and tests in DUNE.* Computing,
82:121–138, 2008.

[6] B. Flemisch, M. Darcis, K. Erbertseder, Faigle B., Lauser A., K. Mosthaf,
S. Müthing, P. Nuske, A. Tatomir, M. Wolff, and R. Helmig. *DuMuX: DUNE
for multi-{phase, component, scale, physics, . . .} flow and transport in porous
media.* Adv. Water Resour., 34:1102–1112, 2011.

[7] *DuMux Handbook.* Lehrstuhl für Hydromechanik und
 Hydrosystemmodellierung, Universität Stuttgart, 2013. See [dumux.org](http://dumux.org).
