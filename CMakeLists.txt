cmake_minimum_required(VERSION 3.4)
project(MAIN VERSION 0.2.0 LANGUAGES C)

add_executable(main)

add_subdirectory(include)
add_subdirectory(src)

