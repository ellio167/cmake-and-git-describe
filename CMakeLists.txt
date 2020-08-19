cmake_minimum_required(VERSION 3.4)

project(MAIN VERSION 0.4.0 LANGUAGES C)

find_package(Git)
unset(GIT_FOUND)
if(GIT_FOUND)
  execute_process(COMMAND ${GIT_EXECUTABLE} -C "${PROJECT_SOURCE_DIR}" rev-parse --show-toplevel
    OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE _toplevel
    RESULT_VARIABLE _isGitRepo
    ERROR_QUIET
    )

  if((_isGitRepo EQUAL 0) AND ("${_toplevel}" STREQUAL "${PROJECT_SOURCE_DIR}"))
    # set configuration to depend on _depend_file
    set(_git_describe_sentinel "git-describe-sentinel")
    set(_depend_file "${CMAKE_CURRENT_BINARY_DIR}/${_git_describe_sentinel}-file")

    find_program(_touch touch)
    if(${CMAKE_MINOR_VERSION} GREATER 11)  # use file(GLOB <var> CONFIGURE_DEPENDS ...) mechanism
      if(EXISTS "${_depend_file}")
        file(REMOVE "${_depend_file}")
      endif()
      file(GLOB _t CONFIGURE_DEPENDS "${_depend_file}")
      file(TOUCH "${_depend_file}")
    elseif(_touch)  # use system 'touch' with future timestamp and CMAKE_CONFIGURE_DEPENDS mechanism
      string(TIMESTAMP _time "1%m%d%H%M")
      math(EXPR _time "${_time} + 1")
      string(REGEX REPLACE "^.(.*)$" "\\1" _time "${_time}")
      execute_process(COMMAND ${_touch} -t "${_time}" "${_depend_file}")   # set modification/access time 1min in the future
      set_property(DIRECTORY "${CURRENT_SOURCE_DIR}" APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${_depend_file}")
    else()  # use CMAKE_CONFIGURE_DEPENDS property mechanism [has a number of corner cases]
      execute_process(COMMAND ${CMAKE_COMMAND} -E touch "${_depend_file}")
      add_custom_target(${_git_describe_sentinel}-target ALL COMMAND ${CMAKE_COMMAND} -E touch "${_depend_file}")
      set_property(DIRECTORY "${CURRENT_SOURCE_DIR}" APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${_depend_file}")
    endif()

    execute_process(COMMAND ${GIT_EXECUTABLE} -C "${PROJECT_SOURCE_DIR}" update-index -q --refresh
      TIMEOUT 5
      OUTPUT_QUIET
      ERROR_QUIET
      )
    execute_process(
      COMMAND ${GIT_EXECUTABLE} -C "${PROJECT_SOURCE_DIR}" describe --dirty --always
      OUTPUT_STRIP_TRAILING_WHITESPACE
      OUTPUT_VARIABLE _git_describe
      )
  endif()
endif()

if(_git_describe)
  set(_build_metadata "+${_git_describe}")
else()
  set(_build_metadata "")
endif()
set(PROJECT_VERSION_STRING "${PROJECT_VERSION}${_build_metadata}")

add_executable(main "")

add_subdirectory(include)
add_subdirectory(src)
