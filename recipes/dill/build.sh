#!/bin/bash

mkdir build
cd build


declare -a CMAKE_PLATFORM_FLAGS
if [[ ${target_platform} =~ osx.* ]]; then
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-osx.cmake")
elif [[ ${target_platform} =~ linux.* ]]; then
    CMAKE_PLATFORM_FLAGS+=(-DCMAKE_TOOLCHAIN_FILE="${RECIPE_DIR}/cross-linux.cmake")
fi

# FIXME: the compiler activation on aarch64 is outdated and forgets
#        to set -rpath-link
# "warning: libXYZ.so.0, needed by libABC.so, not found (try using -rpath or -rpath-link)"
if [[ ${target_platform} =~ .*aarch64.* ]]; then
    export LDFLAGS="${LDFLAGS} -Wl,-rpath-link,${PREFIX}/lib"
fi


cmake \
    -DCMAKE_BUILD_TYPE=Release                \
    -DBUILD_SHARED_LIBS=ON                    \
    -DCMAKE_INSTALL_LIBDIR=lib        \
    -DCMAKE_INSTALL_PREFIX=${PREFIX}  \
    ${CMAKE_PLATFORM_FLAGS[@]}        \
    ${SRC_DIR}

make ${VERBOSE_CM} -j${CPU_COUNT}
CTEST_OUTPUT_ON_FAILURE=1 make ${VERBOSE_CM} test
make install
