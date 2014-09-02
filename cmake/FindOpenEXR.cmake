# - Find module for the OpenEXR headers and libraries
#
# Input variables:
#  OpenEXR_ROOT
#  OpenEXR_USE_STATIC_LIBS
#
# Output variables:
#  OPENEXR_FOUND
#  OPENEXR_INCLUDE_DIRS
#  OPENEXR_<lib>_LIBRARY
#  OPENEXR_LIBRARIES
#

# Handle deprecated root hint
if(OPENEXR_ROOT)
    message(WARNING "OPENEXR_ROOT variable is deprecated. Use OpenEXR_ROOT instead.")
    set(_openexr_ROOT_HINT ${OPENEXR_ROOT})
elseif(OpenEXR_ROOT)
    set(_openexr_ROOT_HINT ${OpenEXR_ROOT})
elseif(NOT $ENV{OPENEXR_ROOT} STREQUAL "")
    set(_openexr_ROOT_HINT $ENV{OPENEXR_ROOT})
endif()

find_path(OPENEXR_INCLUDE_DIRS NAMES OpenEXR/ImfArray.h
    HINTS ${_openexr_ROOT_HINT}/include/)

if(NOT _openexr_ROOT_HINT)
    get_filename_component(_openexr_ROOT_HINT ${OPENEXR_INCLUDE_DIRS} DIRECTORY)
endif()

# (Static lib search logic taken from FindBoost.cmake)
if(OpenEXR_USE_STATIC_LIBS)
    set(_openexr_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    if(WIN32)
        set(CMAKE_FIND_LIBRARY_SUFFIXES .lib .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
    else()
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
    endif()
endif()

# Determine which libraries must be found (default is all)
set(_openexr_VALID_COMPONENTS
    IlmImf)

if(OpenEXR_FIND_COMPONENTS)
    set(_openexr_REQUIRED_LIBS ${OpenEXR_FIND_COMPONENTS})
else()
    set(_openexr_REQUIRED_LIBS ${_openexr_VALID_COMPONENTS})
endif()

# Grab the library paths
set(_openexr_LIB_VARS)
set(OPENEXR_LIBRARIES)
foreach(_openexr_lib ${_openexr_REQUIRED_LIBS})
    list(FIND _openexr_VALID_COMPONENTS ${_openexr_lib} _openexr_requested_index)
    if(_openexr_requested_index EQUAL -1)
        if(OpenEXR_FIND_REQUIRED)
            # If they "required" a lib we don't recognize, just abort here
            message(FATAL_ERROR "Requested component ${_openexr_lib} is not a recognized OpenEXR library")
        else()
            message(WARNING "Requested component '${_openexr_lib}' is not a recognized OpenEXR library and will be skipped")
        endif()
    else()
        find_library(OPENEXR_${_openexr_lib}_LIBRARY ${_openexr_lib}
            ${_openexr_ROOT_HINT}/lib
            ${_openexr_ROOT_HINT}/lib64
            DOC "OpenEXR ${_openexr_lib} library path")
        list(APPEND _openexr_LIB_VARS "OPENEXR_${_openexr_lib}_LIBRARY")
        list(APPEND OPENEXR_LIBRARIES ${OPENEXR_${_openexr_lib}_LIBRARY})
    endif()
endforeach()

# Reset lib search suffix
if(OpenEXR_USE_STATIC_LIBS)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_openexr_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endif()

# Finalize package search
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(OpenEXR
    REQUIRED_VARS ${_openexr_LIB_VARS} OPENEXR_INCLUDE_DIRS OPENEXR_LIBRARIES)
