cmake_minimum_required(VERSION 3.4)

project(MAIN VERSION 0.1.0 LANGUAGES C)
set(PROJECT_VERSION_STRING "${PROJECT_VERSION}+prerelease")

add_executable(main "")

add_subdirectory(include)
add_subdirectory(src)
