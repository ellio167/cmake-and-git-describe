cmake_minimum_required(VERSION 3.4)

# Expects variables:
#   -DPROJECT_SOURCE_DIR - from parent build
#   -DPROJECT_VERSION    - from parent build

find_package(Git REQUIRED QUIET)

execute_process(
  COMMAND ${GIT_EXECUTABLE} -C "${PROJECT_SOURCE_DIR}" describe --dirty --always
  OUTPUT_STRIP_TRAILING_WHITESPACE
  OUTPUT_VARIABLE new_version)

if (EXISTS ".sentinel")
  file(READ ".sentinel" old_version)
endif ()

set(PROJECT_VERSION_STRING "${PROJECT_VERSION}+${new_version}")

if (NOT "${old_version}" STREQUAL "${new_version}")
  file(WRITE ".sentinel" "${new_version}")
  file(WRITE "version.h.in" [[
#define VERSION "@PROJECT_VERSION@"
#define VERSION_STRING "@PROJECT_VERSION_STRING@"
]])
  configure_file("version.h.in" "version.h" @ONLY)
endif ()
