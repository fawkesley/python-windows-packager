#!/bin/bash -e

THIS_SCRIPT_PATH=`readlink -f $0`
THIS_SCRIPT_DIR=`dirname ${THIS_SCRIPT_PATH}`

WINE_TARBALL=${THIS_SCRIPT_DIR}/wine.tar.gz

if [ "$WINEPREFIX" = "" ]; then
    echo "WINEPREFIX is not set. This script freezes WINEPREFIX to ${WINE_TARBALL}"
    exit 1
fi

echo "Freezing $WINEPREFIX to ${WINE_TARBALL}"

cd ${WINEPREFIX}
tar -czf "${WINE_TARBALL}" .

