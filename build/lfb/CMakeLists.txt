cmake_minimum_required(VERSION 3.13)

include("../cmake/source_group_by_dir.cmake")

project(lfb)

# add_subdirectory(third_party/flatbuffers)
# add_subdirectory(../lua binary_dir EXCLUDE_FROM_ALL)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -L${CMAKE_CURRENT_SOURCE_DIR} -std=gnu++11")

file(GLOB_RECURSE lfb_sources ./src/flatbuffers/*.cpp ./src/*.cpp ./src/*.hpp )


source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} lfb_sources)


include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/
  ${CMAKE_CURRENT_SOURCE_DIR}/src
  ${CMAKE_CURRENT_SOURCE_DIR}/../lua
  ${CMAKE_CURRENT_SOURCE_DIR}/src/flatbuffers/include
)

link_directories(
    # ${CMAKE_LIBRARY_OUTPUT_DIRECTORY}
)

add_library(lfb SHARED ${lfb_sources})
target_link_libraries(lfb liblua)

install_library(lfb)

