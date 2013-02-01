#!/bin/bash -e

THIS_SCRIPT_PATH=`readlink -f $0`
THIS_SCRIPT_DIR=`dirname ${THIS_SCRIPT_PATH}`

WINE_TARBALL=${THIS_SCRIPT_DIR}/wine.tar.gz

export WINEPREFIX=`mktemp -d --suffix=_wine`
echo "Created wine environment at $WINEPREFIX"

if [ "$1" = "--update" ]; then
    echo "Update option given. Starting from existing wine.tar.gz"
    tar --directory=${WINEPREFIX} -xzf ${WINE_TARBALL}
fi

echo "# STEP 1 #"
echo "    $ export WINEPREFIX=${WINEPREFIX}"
echo
echo "# STEP 2 #"
echo "    Run your python installers with wine, eg:"
echo "    $ wine start installers/python-2.7.3.msi"
echo "    $ wine installers/pywin32-218.win32-py2.7.exe"
echo
echo "# STEP 3 #"
echo "    Run ./freeze.sh to save back to {WINE_TARBALL}"


