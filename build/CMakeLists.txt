# Tencent is pleased to support the open source community by making xLua available.
# Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
# Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
# http://opensource.org/licenses/MIT
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

cmake_minimum_required(VERSION 3.3)

project(XLua)

# if(APPLE AND IOS)
#     project(XLua-iOS)
# endif(APPLE AND IOS)


if ( WIN32 AND NOT CYGWIN AND NOT ( CMAKE_SYSTEM_NAME STREQUAL "WindowsStore" ) AND NOT ANDROID)
	set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} /MT" CACHE STRING "")
	set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} /MTd" CACHE STRING "")
	set(CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} /MT" CACHE STRING "")
	set(CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG} /MTd" CACHE STRING "")
endif ()


set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)

if ( IOS )
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fembed-bitcode")
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fembed-bitcode")
endif ()

if(ANDROID)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DANDROID_NDK -fexceptions -DNDEBUG -D_REENTRANT -DENV_UNIX")
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DBREAK_HANDLER -DUNICODE -D_UNICODE -DUNIX_USE_WIN_FILE -fPIC")
    message("android CMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS}")
endif(ANDROID)

# set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -x c++")
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -DLUAINTF_LINK_LUA_COMPILED_IN_CXX=1")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -DLUAINTF_LINK_LUA_COMPILED_IN_CXX=1 -DLUAINTF_HEADERS_ONLY=1 -DENV_HAVE_WCTYPE_H=1 -Wno-macro-redefined")
# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}  -lm")

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

#begin lpeg
set ( LPEG_SRC
    lpeg/lpcap.c
    lpeg/lpcode.c
    lpeg/lpprint.c
    lpeg/lptree.c
    lpeg/lpvm.c
)
set_property(
    SOURCE ${LPEG_SRC}
    APPEND
    PROPERTY COMPILE_DEFINITIONS
    LUA_LIB
)
list(APPEND THIRDPART_INC  lpeg)
set (THIRDPART_SRC ${THIRDPART_SRC} ${LPEG_SRC})
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} LPEG_SRC)
#end lpeg

#begin FFI
include_directories(
    ${CMAKE_SOURCE_DIR}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${THIRDPART_INC}
    ffi
)
set (FFI_SRC 
    ffi/parser.c 
    ffi/ctype.c 
    ffi/call.c
    ffi/ffi.c
)
set_property(
    SOURCE ${FFI_SRC}
    APPEND
    PROPERTY COMPILE_DEFINITIONS
    LUA_LIB
)
list(APPEND THIRDPART_INC  ffi)
set (THIRDPART_SRC ${THIRDPART_SRC} ${FFI_SRC})
source_group_by_dir(${CMAKE_CURRENT_SOURCE_DIR} FFI_SRC)
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

if( APPLE AND NOT IOS)
    add_subdirectory(luasql) 
endif(NOT IOS)


set(LUA_SRC_PATH lua/src)

set ( LUA_IDSIZE 120 CACHE STRING "gives the maximum size for the description of the source." )

configure_file ( ${LUA_SRC_PATH}/luaconf.h.in ${CMAKE_CURRENT_BINARY_DIR}/luaconf.h )

include_directories(
    ${CMAKE_SOURCE_DIR}
    ${LUA_SRC_PATH}
    ${CMAKE_CURRENT_BINARY_DIR}
    ${THIRDPART_INC}
)

add_subdirectory(lua)

set ( LUA_SOCKET
    luasocket/auxiliar.c
    luasocket/buffer.c
    luasocket/except.c
    luasocket/inet.c
    luasocket/io.c
    luasocket/luasocket.c
    luasocket/mime.c
    luasocket/options.c
    luasocket/select.c
    luasocket/tcp.c
    luasocket/timeout.c
    luasocket/udp.c 
)

if ( WIN32 AND NOT CYGWIN )
    list (APPEND LUA_SOCKET luasocket/wsocket.c)
else ( )
    list (APPEND LUA_SOCKET luasocket/usocket.c)
endif ( )

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
    ${LUA_CORE}
    ${LUA_LIB}
    ${LUA_SOCKET}
    ${XLUA_CORE}
    ${THIRDPART_SRC}
    ${LSQLITE_SRC}
)
set_target_properties(xlua PROPERTIES MACOSX_FRAMEWORK_INFO_PLIST ../Info-xlua.plist)

find_library(LIBLUA liblua ../lua)
target_link_libraries(xlua
    liblua
)
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
    if (IOS)
   else () # osx
        ADD_DEFINITIONS(-DLUA_USE_MACOSX) #osx platform emmylua debugger must have this option or can not load cpath
        set(CMAKE_OSX_ARCHITECTURES "$(ARCHS_STANDARD_64_BIT)")
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
