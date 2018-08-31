#! /bin/bash

if [[ -z $DUNE_DUMUX_INSTALL_DIR ]] ; then
    echo "Environment variable DUNE_DUMUX_INSTALL_DIR is not set"
    echo -n "Please set the variable to the desired installation directory "
    echo "before proceeding. Abort."
    exit 1
fi
if [[ $DUNE_DUMUX_INSTALL_DIR =~ "dumux" ]] ; then
    echo -n "Environment variable DUNE_DUMUX_INSTALL_DIR is set to "
    echo "\"$DUNE_DUMUX_INSTALL_DIR\"."
    echo -n "Due to a bug (?) the installation path cannot contain the string \"dumux\"."
    echo " Please choose another name for the installation path. Abort."
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

TARGET="$DUNE_DUMUX_INSTALL_DIR"
mkdir -p "$TARGET"
cd "$TARGET"
mkdir -p src
mkdir -p bld

read -p "Install $WHAT_TO_INSTALL into directory \"$TARGET\" ? " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]] ; then
    echo "Abort."
    exit 1
fi

exit 0
