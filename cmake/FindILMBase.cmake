# - Find module for the ILMBase headers and libraries
#
# Input variables:
#  ILMBase_ROOT
#  ILMBase_USE_STATIC_LIBS
#  ILMBASE_ROOT (deprecated, use ILMBase_ROOT instead)
#
# Output variables:
#  ILMBASE_FOUND
#  ILMBASE_VERSION
#  ILMBASE_INCLUDE_DIRS
#  ILMBASE_LIBRARY_DIRS
#  ILMBASE_<lib>_LIBRARY
#  ILMBASE_LIBRARIES
#

# Handle deprecated root hint
if(ILMBASE_ROOT)
    message(WARNING "ILMBASE_ROOT variable is deprecated. Use ILMBase_ROOT instead.")
    set(_ilmbase_ROOT_HINT ${ILMBASE_ROOT})
else()
    set(_ilmbase_ROOT_HINT ${ILMBase_ROOT})
endif()

find_path(ILMBASE_INCLUDE_DIRS NAMES OpenEXR/IlmBaseConfig.h
    HINTS ${_ilmbase_ROOT_HINT}/include/)

if(NOT _ilmbase_ROOT_HINT)
    get_filename_component(_ilmbase_ROOT_HINT ${ILMBASE_INCLUDE_DIRS} DIRECTORY)
endif()

set(ILMBASE_INCLUDE_DIRS ${ILMBASE_INCLUDE_DIRS} ${ILMBASE_INCLUDE_DIRS}/OpenEXR)

# (Static lib search logic taken from FindBoost.cmake)
if(ILMBase_USE_STATIC_LIBS)
    set(_ilmbase_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    if(WIN32)
        set(CMAKE_FIND_LIBRARY_SUFFIXES .lib .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
    else()
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
    endif()
endif()

# Determine which libraries must be found (default is all)
set(_ilmbase_VALID_COMPONENTS Half Iex IexMath IlmThread Imath)
if(ILMBase_FIND_COMPONENTS)
    set(_ilmbase_REQUIRED_LIBS ${ILMBase_FIND_COMPONENTS})
else()
    set(_ilmbase_REQUIRED_LIBS ${_ilmbase_VALID_COMPONENTS})
endif()

# Grab the library paths
set(_ilmbase_LIB_VARS)
set(ILMBASE_LIBRARIES)
foreach(_ilmbase_lib ${_ilmbase_REQUIRED_LIBS})
    list(FIND _ilmbase_VALID_COMPONENTS ${_ilmbase_lib} _ilmbase_requested_index)
    if(_ilmbase_requested_index EQUAL -1)
        if(ILMBase_FIND_REQUIRED)
            # If they "required" a lib we don't recognize, just abort here
            message(FATAL_ERROR "Requested component ${_ilmbase_lib} is not a recognized ILMBase library")
        else()
            message(WARNING "Requested component '${_ilmbase_lib}' is not a recognized ILMBase library and will be skipped")
        endif()
    else()
        find_library(ILMBASE_${_ilmbase_lib}_LIBRARY ${_ilmbase_lib}
            HINTS ${_ilmbase_ROOT_HINT}/lib
            DOC "ILMBase ${_ilmbase_lib} library path")
        list(APPEND _ilmbase_LIB_VARS "ILMBASE_${_ilmbase_lib}_LIBRARY")
        list(APPEND ILMBASE_LIBRARIES ${ILMBASE_${_ilmbase_lib}_LIBRARY})
    endif()
endforeach()

# Reset lib search suffix
if(ILMBase_USE_STATIC_LIBS)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_ilmbase_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endif()

get_filename_component(ILMBASE_LIBRARY_DIRS ${ILMBASE_Half_LIBRARY} DIRECTORY)

file(READ "${ILMBASE_LIBRARY_DIRS}/pkgconfig/IlmBase.pc" _ilmbase_PC_CONTENTS)
string(REGEX REPLACE
    ".*Version: ([1-9]+\\.[0-9]+\\.[0-9]+).*" "\\1"
    ILMBASE_VERSION "${_ilmbase_PC_CONTENTS}")

# Finalize package search
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ILMBase
    REQUIRED_VARS ${_ilmbase_LIB_VARS} ILMBASE_INCLUDE_DIRS ILMBASE_LIBRARY_DIRS ILMBASE_LIBRARIES
    VERSION_VAR ILMBASE_VERSION)


#
# Copyright 2012, Allan Johns
#
# vfxcmake is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# vfxcmake is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with vfxcmake.  If not, see <http://www.gnu.org/licenses/>.
#
