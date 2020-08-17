target_include_directories(main PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")

configure_file(version.h.in "${CMAKE_CURRENT_BINARY_DIR}/version.h")
target_include_directories(main PRIVATE "${CMAKE_CURRENT_BINARY_DIR}")
