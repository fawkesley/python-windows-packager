# Python Packager
## Overview

Develop Python on Linux, deploy on Windows.

Uses Pyinstaller and Wine to "freeze" Python programs to a standalone Windows
executable, all from your Linux box.

## Quick start

To quickly build your Wine environment, then create a standalone EXE,
run the following commands:

    $ wget "http://www.python.org/ftp/python/2.7.3/python-2.7.3.msi" 
    $ wget "http://downloads.sourceforge.net/project/pywin32/pywin32/Build%20218/pywin32-218.win32-py2.7.exe?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpywin32%2Ffiles%2Fpywin32%2FBuild%2520218%2F&ts=1359740579&use_mirror=netcologne"

    $ build_environment/create.sh
    $ export WINEPREFIX=/tmp/path-outputted-from-create
    $ wine start python-2.7.3.msi
    $ wine pywin32-218.win32-py2.7.exe
    $ build_environment/freeze.sh
    $ ./package sample-application/src/main.py MySampleProgram

This will create a Wine environment in a tarball at 
./build_environment/wine.tar.gz.

## Modifying the Python Windows environment

If you want to use a different Python version or add additional Python
modules, just do the above with different Windows Python installers.

