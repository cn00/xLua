# Sets the minimum version of CMake required to build the native
# library. You should either keep the default value or only pass a
# value of 3.4.0 or lower.
# by huzongyao

cmake_minimum_required(VERSION 3.4.1)

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


# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds it for you.
# Gradle automatically packages shared libraries with your APK.
file(GLOB_RECURSE SRCS 
    ${CMAKE_CURRENT_SOURCE_DIR}/*.h
    ${CMAKE_CURRENT_SOURCE_DIR}/*.c
)

include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR}/
)

add_library(lsqlite3 SHARED ${SRCS})
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} SRCS)

set_target_properties(lsqlite3 PROPERTIES
    # SUFFIX .so
    # FRAMEWORK begin
    FRAMEWORK TRUE
    FRAMEWORK_VERSION C
    MACOSX_FRAMEWORK_IDENTIFIER com.cmake.sqlite3
    MACOSX_FRAMEWORK_INFO_PLIST ../Info.plist
    PUBLIC_HEADER sqlite3.h
    # FRAMEWORK end
    IPHONEOS_DEPLOYMENT_TARGET "8.0"
    DYLIB_INSTALL_NAME_BASE "@rpath"
    XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development: navy cool (海军 冷)"
    # https://stackoverflow.com/questions/40664125/cmake-and-code-signing-in-xcode-8-for-ios-projects
    DEVELOPMENT_TEAM "3SZSPFHS9S"
)

target_link_libraries(lsqlite3
    xlua
)