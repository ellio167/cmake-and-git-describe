cmake_minimum_required(VERSION 3.4)
project(MAIN VERSION 0.2.0 LANGUAGES C)

find_package(Git REQUIRED)

##

file(GLOB _depend_file CONFIGURE_DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/*-sentinel")

if (NOT EXISTS "${_depend_file}")
  set(_depend_file "${CMAKE_CURRENT_BINARY_DIR}/git-sentinel")
endif ()

set_property(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}" APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${_depend_file}")

execute_process(
  COMMAND ${GIT_EXECUTABLE} -C "${MAIN_SOURCE_DIR}" describe --dirty --always
  OUTPUT_STRIP_TRAILING_WHITESPACE
  OUTPUT_VARIABLE git_describe)

file(WRITE ${_depend_file} ${git_describe})

add_custom_target(update-sentinel COMMAND ${CMAKE_COMMAND} -E touch "$<SHELL_PATH:${_depend_file}>")

##

set(PROJECT_VERSION_STRING "${PROJECT_VERSION}+${git_describe}")

##

add_executable(main)
add_dependencies(main update-sentinel)

add_subdirectory(include)
add_subdirectory(src)
