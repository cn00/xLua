cmake_minimum_required(VERSION 3.13)

project(lfb)

# add_subdirectory(third_party/flatbuffers)
# add_subdirectory(../lua binary_dir EXCLUDE_FROM_ALL)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -L${CMAKE_CURRENT_SOURCE_DIR} -std=gnu++11 -stdlib=libc++ ")

file(GLOB_RECURSE lfb_sources ./src/flatbuffers/*.cpp ./src/*.cpp ./src/*.hpp )

macro(source_group_by_dir proj_dir source_files)
  if(MSVC OR APPLE)
    get_filename_component(sgbd_cur_dir ${proj_dir} ABSOLUTE)
    foreach(sgbd_file ${${source_files}})
      get_filename_component(sgbd_abs_file ${sgbd_file} ABSOLUTE)
        file(RELATIVE_PATH sgbd_fpath ${sgbd_cur_dir} ${sgbd_abs_file})
        string(REGEX REPLACE "\(.*\)/.*" \\1 sgbd_group_name ${sgbd_fpath})
        string(COMPARE EQUAL ${sgbd_fpath} ${sgbd_group_name} sgbd_nogroup)
        string(REPLACE "/" "\\" sgbd_group_name ${sgbd_group_name})
        if(sgbd_nogroup)
            set(sgbd_group_name "\\")
        endif(sgbd_nogroup)
        source_group(${sgbd_group_name} FILES ${sgbd_file})
    endforeach(sgbd_file)
  endif(MSVC OR APPLE)
endmacro(source_group_by_dir)

source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} lfb_sources)


include_directories(
  ${CMAKE_CURRENT_SOURCE_DIR}/
  ${CMAKE_CURRENT_SOURCE_DIR}/src
  ${CMAKE_CURRENT_SOURCE_DIR}/../lua/src
  ${CMAKE_CURRENT_SOURCE_DIR}/src/flatbuffers/include
)

link_directories(
    ${CMAKE_SOURCE_DIR}/lib
)

add_library(lfb SHARED ${lfb_sources})
target_link_libraries(lfb lua)



