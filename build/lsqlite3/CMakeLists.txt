# Sets the minimum version of CMake required to build the native
# library. You should either keep the default value or only pass a
# value of 3.4.0 or lower.
# by huzongyao

cmake_minimum_required(VERSION 3.4.1)

include("../cmake/source_group_by_dir.cmake")

set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DSQLITE_ENABLE_LOAD_EXTENSION")

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
    ${CMAKE_CURRENT_SOURCE_DIR}/../lua
)

add_library(lsqlite3 SHARED ${SRCS})
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} SRCS)

# set_target_properties(lsqlite3 PROPERTIES
#     # SUFFIX .so
#     # FRAMEWORK begin
#     FRAMEWORK TRUE
#     FRAMEWORK_VERSION C
#     MACOSX_FRAMEWORK_IDENTIFIER com.cmake.sqlite3
#     MACOSX_FRAMEWORK_INFO_PLIST ../Info.plist
#     PUBLIC_HEADER sqlite3.h
#     # FRAMEWORK end
#     IPHONEOS_DEPLOYMENT_TARGET "8.0"
#     DYLIB_INSTALL_NAME_BASE "@rpath"
#     XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY "Apple Development: navy cool (海军 冷)"
#     # https://stackoverflow.com/questions/40664125/cmake-and-code-signing-in-xcode-8-for-ios-projects
#     DEVELOPMENT_TEAM "3SZSPFHS9S"
# )
target_link_libraries(lsqlite3
    liblua
    # libsqlite3
)
install_library(lsqlite3)