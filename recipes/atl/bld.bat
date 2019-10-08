REM Install library with DillConfig.cmake files with cmake

mkdir build
cd build

set CURRENTDIR="%cd%"

cmake ^
    -G "NMake Makefiles"        ^
    -DCMAKE_BUILD_TYPE=Release  ^
    -DBUILD_SHARED_LIBS=ON      ^
    -DCMAKE_INSTALL_LIBDIR=lib  ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX%  ^
    -DCMAKE_PYTHON_OUTPUT_DIRECTORY=%CURRENTDIR%\lib\site-packages  ^
    %SRC_DIR%
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake test
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1
