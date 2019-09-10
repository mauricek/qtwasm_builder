#!/usr/bin/env bash

if [ -f "/project/source/CMakeLists.txt" ]; then
    cmake -H/project/source -B/project/build & cmake --build /project/build -j `grep -c '^processor' /proc/cpuinfo`
else
    qmake /project/source && make -j `grep -c '^processor' /proc/cpuinfo`
fi
