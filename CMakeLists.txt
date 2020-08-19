cmake_minimum_required(VERSION 3.4)

project(MAIN VERSION 0.3.0 LANGUAGES C)

# FC: means "for conciseness"
find_package(Git)  # FC: assume found
# FC: assume that ${PROJECT_SOURCE_DIR} is git repo toplevel dir

# set configuration to depend on _depend_file; then touch depend with every invocation of make
set(_git_describe_sentinel "git-describe-sentinel")
set(_depend_file "${CMAKE_CURRENT_BINARY_DIR}/${_git_describe_sentinel}-file")

find_program(_touch touch)
if(_touch)
  # set modification/access time of _depend_file to 1min in the future
  string(TIMESTAMP _time "1%m%d%H%M")
  math(EXPR _time "${_time} + 1")
  string(REGEX REPLACE "^.(.*)$" "\\1" _time "${_time}")
  execute_process(COMMAND ${_touch} -t "${_time}" "${_depend_file}")
else()
  execute_process(COMMAND ${CMAKE_COMMAND} -E touch "${_depend_file}")
  add_custom_target(${_git_describe_sentinel}-target ALL COMMAND ${CMAKE_COMMAND} -E touch "${_depend_file}")
endif()
set_property(DIRECTORY "${CURRENT_SOURCE_DIR}" APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${_depend_file}")

# FC: assume the git index is refreshed
execute_process(
  COMMAND ${GIT_EXECUTABLE} -C "${PROJECT_SOURCE_DIR}" describe --dirty --always
  OUTPUT_STRIP_TRAILING_WHITESPACE
  OUTPUT_VARIABLE _git_describe
  )
set(PROJECT_VERSION_STRING "${PROJECT_VERSION}+${_git_describe}")

add_executable(main "")

add_subdirectory(include)
add_subdirectory(src)
