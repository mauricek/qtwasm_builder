#!/usr/bin/env bash

if [ -f "/project/source/CMakeLists.txt" ]; then
     emcmake cmake -H/project/source -B/project/build -DQt5_DIR=/usr/local/Qt/lib/cmake/Qt5 -DQT_QMAKE_EXECUTABLE=/usr/local/Qt/bin/qmake -DCMAKE_TOOLCHAIN_FILE=/polly/emscripten-cxx14.cmake -DQt5Core_DIR=/usr/local/Qt/lib/cmake/Qt5Core/ -DQt5Quick_DIR=/usr/local/Qt/lib/cmake/Qt5Quick/ -DQt5Gui_DIR=/usr/local/Qt/lib/cmake/Qt5Gui/ -DQt5Qml_DIR=/usr/local/Qt/lib/cmake/Qt5Qml/ -DQt5Network_DIR=/usr/local/Qt/lib/cmake/Qt5Network/ -DCMAKE_CXX_FLAGS="--bind" & cmake --build /project/build -- -j `grep -c '^processor' /proc/cpuinfo`
else
    qmake /project/source && make -j `grep -c '^processor' /proc/cpuinfo`
fi

