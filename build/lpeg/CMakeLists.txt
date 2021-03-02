cmake_minimum_required(VERSION 3.13)

include("../cmake/source_group_by_dir.cmake")

project(lpeg)

# add_subdirectory(third_party/flatbuffers)
# add_subdirectory(../lua binary_dir EXCLUDE_FROM_ALL)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -L${CMAKE_CURRENT_SOURCE_DIR} -std=gnu++11")

file(GLOB_RECURSE lpeg_sources 
  lpcap.c
  lpcode.c
  lpprint.c
  lptree.c
  lpvm.c
)
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} lpeg_sources)

include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/
  ${CMAKE_CURRENT_SOURCE_DIR}/../lua
)

add_library(lpeg SHARED ${lpeg_sources})
target_link_libraries(lpeg liblua)

install_library(lpeg)

