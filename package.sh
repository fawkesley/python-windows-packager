#!/bin/bash -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 /path/to/main.py ProjectName"
    exit 1
else
    FULL_PY_PATH=`readlink -f $1`
    SOURCE_DIR_LINUX=`dirname ${FULL_PY_PATH}`
    MAIN_PY=`basename ${FULL_PY_PATH}`
    PROJECT_NAME="$2"
fi

THIS_SCRIPT_PATH=`readlink -f $0`
THIS_SCRIPT_DIR=`dirname ${THIS_SCRIPT_PATH}`



PYTHON_EXE_WIN="C:\\Python27\\python.exe"

WINE_TARBALL=${THIS_SCRIPT_DIR}/build_environment/wine.tar.gz

if [ ! -e "${WINE_TARBALL}" ]; then
    echo "ERROR: You don't have a frozen wine environment at"
    echo "${WINE_TARBALL}"
    echo
    echo "Option 1:"
    echo "    Create a new wine environment by running build_environment/create.sh"
    echo "    and following the instructions."
    echo "Option 2:"
    echo "    Use an existing wine environment (with Python installed) by doing:"
    echo "    $ export WINEPREFIX=~/.wine    # path to your existing wine env"
    echo "    $ build_environment/freeze.sh"

    exit 2
else
    export WINEPREFIX=`mktemp -d --suffix=_wine`

    # Unpack wine environment
    tar "--directory=${WINEPREFIX}" -xzf ${WINE_TARBALL}

fi

BUILD_DIR_LINUX=${WINEPREFIX}/drive_c/build
PY_DIR_WIN="C:\\Python27"
BUILD_DIR_WIN="C:\\build"
mkdir -p ${BUILD_DIR_LINUX}

# Create symbolic link to source directory so Windows can access it
ln -s ${SOURCE_DIR_LINUX} ${BUILD_DIR_LINUX}/src_symlink
SOURCE_DIR_WIN=${BUILD_DIR_WIN}\\src_symlink

set -x

# PIP FETCH
echo builddir is ${BUILD_DIR_LINUX}
if [ -x "$(command -v wget)" ]; then
  wget https://bootstrap.pypa.io/get-pip.py -O ${BUILD_DIR_LINUX}/get-pip.py
elif [ -x "$(command -v curl)" ]; then
  curl https://bootstrap.pypa.io/get-pip.py >${BUILD_DIR_LINUX}/get-pip.py
else
  echo "couldn't find a way to retrieve get-pip.py from the web"
  exit 1
fi # PIP FETCH

wine "${PYTHON_EXE_WIN}" "${BUILD_DIR_WIN}\\get-pip.py"

wine "${PYTHON_EXE_WIN}" "-m" "pip" "install" "pyinstaller"

if [ -f ${SOURCE_DIR_LINUX}/requirements.txt ]; then
    wine "${PYTHON_EXE_WIN}" "-m" "pip" "install" "-r" \
        "${SOURCE_DIR_WIN}\\requirements.txt"
fi # [ -f requirements.txt ]

# NOTE - if using hooks, your spec'file should have a line like:
# hookspath=["C:\\build\\src_symlink\\hooks\\"],

echo -e -n "#\n# RUNNING PYINSTALLER\n#\n"

wine "${PYTHON_EXE_WIN}" "-m" "PyInstaller" \
    "--name=${PROJECT_NAME}" \
    --onefile \
    --noconsole \
    "${SOURCE_DIR_WIN}\\${MAIN_PY}"

rm -rf ${WINEPREFIX}

echo "Executable available at dist/${PROJECT_NAME}.exe"

