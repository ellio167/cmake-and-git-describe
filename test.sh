#!/bin/bash

echo "Dirty between configure and first make"
rm -rf build
cmake -DCMAKE_BUILD_TYPE=Debug -S . -B build >/dev/null 2>&1
echo "// comment" >> src/main.c
cmake --build build >/dev/null 2>&1
./build/main

echo "Reset repo and rebuild"
git checkout -- .
cmake --build build >/dev/null 2>&1
./build/main

echo "Remove build dir and fresh build"
rm -rf build
cmake -DCMAKE_BUILD_TYPE=Debug -S . -B build >/dev/null 2>&1
cmake --build build >/dev/null 2>&1
./build/main
