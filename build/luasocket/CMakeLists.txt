cmake_minimum_required(VERSION 3.13)

include("../cmake/source_group_by_dir.cmake")

project(socket)

# add_subdirectory(third_party/flatbuffers)
# add_subdirectory(../lua binary_dir EXCLUDE_FROM_ALL)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -L${CMAKE_CURRENT_SOURCE_DIR} -std=gnu++11")

file(GLOB_RECURSE socket_sources *.c *.h **/*.lua)
file(GLOB_RECURSE socket_mime_sources mime/*.c mime/*.h)
file(GLOB_RECURSE socket_serial_sources serial/*.c serial/*.h)


source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} socket_sources)


include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/
  ${CMAKE_CURRENT_SOURCE_DIR}/../lua
)

link_directories(
    # ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
)

add_library(socket SHARED ${socket_sources})
add_library(mime   SHARED ${socket_mime_sources})
add_library(serial SHARED ${socket_serial_sources})
target_link_libraries(socket liblua)
target_link_libraries(mime socket liblua)
target_link_libraries(serial socket liblua)

install_library(socket)

