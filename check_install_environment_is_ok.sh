#! /bin/bash

if [[ -z $DUNE_DUMUX_INSTALL_DIR ]] ; then
    echo "Enviornment variable DUNE_DUMUX_INSTALL_DIR is not set"
    echo -n "Please set the variable to the desired installation directory "
    echo "before proceeding. Abort."
    exit 1
fi
packages=( autoconf bison cmake g++ libblas-dev libopenmpi-dev libtool make flex )

DUNE_DUMUX_INSTALL_DIR=${DUNE_DUMUX_INSTALL_DIR%/}  # strip possible trailing slash

echo "Checking for installed packages.."
for package in "${packages[@]}" ; do
    echo -n "..$package"
    dpkg -l "$package" >/dev/null 2>&1
    if (($? == 0 )) ; then
        echo "..installed"
    else
        echo "..not installed. Abort."
        echo "Please install package \"$package\" first."
        exit 1
    fi
done
echo "looks ok.."
exit 0
