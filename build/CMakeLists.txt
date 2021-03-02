# Tencent is pleased to support the open source community by making xLua available.
# Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
# Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
# http://opensource.org/licenses/MIT
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

cmake_minimum_required(VERSION 3.10)

if(x${ROOT_PROJECT_NAME} STREQUAL "x")
    set(ROOT_PROJECT_NAME XLua)
endif()


project(${ROOT_PROJECT_NAME})

include("cmake/source_group_by_dir.cmake")
include ( lua/cmake/dist.cmake )

if ( WIN32 AND NOT CYGWIN AND NOT ( CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" ) AND NOT ANDROID)
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /MT" CACHE STRING "")
	set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /MTd" CACHE STRING "")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT" CACHE STRING "")
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd" CACHE STRING "")
endif ()


set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

# set(CMAKE_SHARED_LIBRARY_PREFIX "lib")

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-unused-command-line-argument")
if(ANDROID)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DANDROID_NDK -fexceptions -DNDEBUG -D_REENTRANT -DENV_UNIX")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBREAK_HANDLER -DUNICODE -D_UNICODE -DUNIX_USE_WIN_FILE -fPIC")
    message("android CMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}")
endif(ANDROID)

if(APPLE)
    set(CMAKE_MACOSX_RPATH ON)
    SET(CMAKE_SKIP_BUILD_RPATH TRUE)
    SET(CMAKE_BUILD_WITH_INSTALL_RPATH TRUE)
    SET(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
    set(CMAKE_INSTALL_RPATH "@loader_path")
    set(CMAKE_XCODE_ATTRIBUTE_ONLY_ACTIVE_ARCH NO)
    if(IOS)
        SET (CMAKE_OSX_SYSROOT "iphoneos") # Base SDK
        # SET (CMAKE_XCODE_EFFECTIVE_PLATFORMS "macosx")
        set(CMAKE_XCODE_ATTRIBUTE_SUPPORTED_PLATFORMS "iphonesimulator iphoneos") # Supported Platforms: iOS
        # set(CMAKE_XCODE_ATTRIBUTE_SUPPORTED_PLATFORMS "iphonesimulator iphoneos macosx")
        # set(CMAKE_XCODE_ATTRIBUTE_SUPPORTS_MACCATALYST YES)
        # set(CMAKE_XCODE_ATTRIBUTE_SUPPORTS_MAC_DESIGNED_FOR_IPHONE_IPAD YES)
    else()
        set(CMAKE_XCODE_ATTRIBUTE_SUPPORTED_PLATFORMS "macosx")
        set(CMAKE_XCODE_ATTRIBUTE_SDKROOT "macosx")
    endif(IOS)
    
endif(APPLE)

# # set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -x c++")
# # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -DLUAINTF_LINK_LUA_COMPILED_IN_CXX=1")
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -DLUAINTF_LINK_LUA_COMPILED_IN_CXX=1 -DLUAINTF_HEADERS_ONLY=1 -DENV_HAVE_WCTYPE_H=1 -Wno-macro-redefined")

option ( UINT_ESPECIALLY "using custom ulong" OFF )
option ( USING_LUAJIT "using luajit" OFF )
option ( GC64 "using gc64" OFF )
option ( LUAC_COMPATIBLE_FORMAT "compatible format" OFF )

find_path(XLUA_PROJECT_DIR NAMES SConstruct
    PATHS 
    ${CMAKE_SOURCE_DIR}
    NO_DEFAULT_PATH
)

MARK_AS_ADVANCED(XLUA_PROJECT_DIR)

add_subdirectory(lua)

#begin lpeg
add_subdirectory(lpeg)
#end lpeg

#begin FFI
add_subdirectory(ffi)
#end FFI

#begin LFB
add_subdirectory(lfb)
#end LFB

#begin P7ZIP
add_subdirectory(lua-intf)
add_subdirectory(p7zip)
#end P7ZIP


#begin luasqlite
add_subdirectory(lsqlite3)
#end lsqlite3

#begin lxp
add_subdirectory(libexpat/expat)
add_subdirectory(luaexpat)
add_subdirectory(lfs)

# if( NOT OSX  && NOT WINDOWS)
#     add_subdirectory(mariadb-connector-c)
# endif(NOT OSX )
# add_subdirectory(luasql)

add_subdirectory(luasocket)

# add_subdirectory(openssllua)

set(LUA_SRC_PATH lua/)

include_directories(
    ${CMAKE_SOURCE_DIR}
    ${LUA_SRC_PATH}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${THIRDPART_INC}
)

set ( XLUA_CORE
    i64lib.c
    xlua.c
)

if (NOT USING_LUAJIT)
    list (APPEND XLUA_CORE memory_leak_checker.c)
endif ( )

source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} LUA_SOCKET)
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} LUA_CORE)
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} LUA_LIB)
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} XLUA_CORE)


link_directories(
    ${CMAKE_BINARY_DIR}/bin
    ${CMAKE_BINARY_DIR}/lib
)

add_library(xlua SHARED
    ${XLUA_CORE}
)

# find_library(LIBLUA liblua ../lua)
target_link_libraries(xlua
    liblua
)
install_library(xlua)

if (APPLE)
    set_target_properties(xlua PROPERTIES MACOSX_FRAMEWORK_INFO_PLIST ../Info-xlua.plist)
    set_target_properties(xlua PROPERTIES 
        INSTALL_RPATH "@executable_path/Frameworks;@loader_path;@loader_path/libs;@loader_path/Frameworks"
    )
endif()
# target_link_libraries(xlua expat)
# target_link_libraries(xlua p7zip)

# # p7zip
# add_library(p7zip SHARED ${P7ZIP_SRC})
# target_link_libraries(p7zip xlua)
# set_target_properties(p7zip PROPERTIES MACOSX_FRAMEWORK_INFO_PLIST ../Info-p7zip.plist)

# # lsqlite3
# add_library(lsqlite3 SHARED ${LSQLITE_SRC})
# target_link_libraries(lsqlite3 xlua)
# set_target_properties(lsqlite3 PROPERTIES MACOSX_FRAMEWORK_INFO_PLIST ../Info-lsqlite3.plist)

if (APPLE)
    add_subdirectory(nslua)
    if (OSX) # osx
        ADD_DEFINITIONS(-DLUA_USE_MACOSX) #osx platform emmylua debugger must have this option or can not load cpath
        # set(CMAKE_OSX_ARCHITECTURES "$(ARCHS_STANDARD)")

        # set_target_properties (xlua PROPERTIES SUFFIX .so)
        # set_target_properties (p7zip PROPERTIES SUFFIX .so)
        # set_target_properties (lsqlite3 PROPERTIES SUFFIX .so)

    endif ()


elseif ("${CMAKE_SYSTEM_NAME}" STREQUAL "Switch")
    add_library(xlua STATIC
        ${LUA_CORE}
        ${LUA_LIB}
        ${XLUA_CORE}
        ${THIRDPART_SRC}
        ${P7ZIP_SRC}
    )
    target_compile_options(xlua PRIVATE -m64 -mcpu=cortex-a57+fp+simd+crypto+crc -fno-common -fno-short-enums -ffunction-sections -fdata-sections -fPIC -fms-extensions)
endif ( )

if ( WIN32 AND NOT CYGWIN )
    target_compile_definitions (xlua PRIVATE LUA_BUILD_AS_DLL)
endif ( )

if (GC64 AND USING_LUAJIT)
    target_compile_definitions (xlua PRIVATE LUAJIT_ENABLE_GC64)
endif ()

if (LUAC_COMPATIBLE_FORMAT AND NOT USING_LUAJIT)
    target_compile_definitions (xlua PRIVATE LUAC_COMPATIBLE_FORMAT)
endif ()

set_property(
	SOURCE ${LUA_SOCKET}
	APPEND
	PROPERTY COMPILE_DEFINITIONS
	LUA_COMPAT_APIINTCASTS LUA_LIB _CRT_SECURE_NO_WARNINGS _WINSOCK_DEPRECATED_NO_WARNINGS
)

if(UINT_ESPECIALLY)
    ADD_DEFINITIONS(-DUINT_ESPECIALLY)
endif()
	
if ( WIN32 AND NOT CYGWIN )
    target_link_libraries(xlua
        ws2_32
        ${THIRDPART_LIB} 
    )
else ( )
    target_link_libraries(xlua
        m
        ${THIRDPART_LIB} 
    )
endif ( )
