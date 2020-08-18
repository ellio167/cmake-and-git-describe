add_custom_target(
  update-version-h
  COMMAND ${CMAKE_COMMAND}
    -DPROJECT_SOURCE_DIR=${PROJECT_SOURCE_DIR}
    -DPROJECT_VERSION=${PROJECT_VERSION}
    -P ${CMAKE_CURRENT_SOURCE_DIR}/update-version.cmake
  DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/update-version.cmake
  VERBATIM)

add_dependencies(main update-version-h)

target_include_directories(
  main 
  PRIVATE 
    "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_BINARY_DIR}")
