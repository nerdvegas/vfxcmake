# - Find module for the Alembic headers and libraries
#
# Input variables:
#  Alembic_ROOT
#  Alembic_USE_STATIC_LIBS
#
# Input environment variables:
#  ALEMBIC_ROOT
#
# Output variables:
#  ALEMBIC_FOUND
#  ALEMBIC_INCLUDE_DIRS
#  ALEMBIC_<lib>_LIBRARY
#  ALEMBIC_LIBRARIES
#

# Handle deprecated root hint
if(ALEMBIC_ROOT)
    message(WARNING "ALEMBIC_ROOT variable is deprecated. Use Alembic_ROOT instead.")
    set(_alembic_ROOT_HINT ${ALEMBIC_ROOT})
elseif(Alembic_ROOT)
    set(_alembic_ROOT_HINT ${Alembic_ROOT})
elseif(NOT $ENV{ALEMBIC_ROOT} STREQUAL "")
    set(_alembic_ROOT_HINT $ENV{ALEMBIC_ROOT})
endif()

find_path(ALEMBIC_INCLUDE_DIRS NAMES Alembic/Abc/All.h
    HINTS ${_alembic_ROOT_HINT}/include/)

if(NOT _alembic_ROOT_HINT)
    get_filename_component(_alembic_ROOT_HINT ${ALEMBIC_INCLUDE_DIRS} DIRECTORY)
endif()

# (Static lib search logic taken from FindBoost.cmake)
if(Alembic_USE_STATIC_LIBS)
    set(_alembic_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
    if(WIN32)
        set(CMAKE_FIND_LIBRARY_SUFFIXES .lib .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
    else()
        set(CMAKE_FIND_LIBRARY_SUFFIXES .a)
    endif()
endif()

# Determine which libraries must be found (default is all)
# ORDER here is very important to prevent undefined symbols (order taken from Alembic CMakeLists.txt)
set(_alembic_VALID_COMPONENTS
    AlembicAbcGeom
    AlembicAbcCoreFactory
    AlembicAbc
    AlembicAbcCoreHDF5
    AlembicAbcCoreOgawa
    AlembicAbcCoreAbstract
    AlembicAbcCollection
    AlembicAbcMaterial
    AlembicAbcOpenGL
    AlembicOgawa
    AlembicUtil)

if(Alembic_FIND_COMPONENTS)
    set(_alembic_REQUIRED_LIBS ${Alembic_FIND_COMPONENTS})
else()
    set(_alembic_REQUIRED_LIBS ${_alembic_VALID_COMPONENTS})
endif()

# Grab the library paths
set(_alembic_LIB_VARS)
set(ALEMBIC_LIBRARIES)
foreach(_alembic_lib ${_alembic_REQUIRED_LIBS})
    list(FIND _alembic_VALID_COMPONENTS ${_alembic_lib} _alembic_requested_index)
    if(_alembic_requested_index EQUAL -1)
        if(Alembic_FIND_REQUIRED)
            # If they "required" a lib we don't recognize, just abort here
            message(FATAL_ERROR "Requested component ${_alembic_lib} is not a recognized Alembic library")
        else()
            message(WARNING "Requested component '${_alembic_lib}' is not a recognized Alembic library and will be skipped")
        endif()
    else()
        find_library(ALEMBIC_${_alembic_lib}_LIBRARY ${_alembic_lib}
            ${_alembic_ROOT_HINT}/lib
            ${_alembic_ROOT_HINT}/lib/static
            DOC "Alembic ${_alembic_lib} library path")
        list(APPEND _alembic_LIB_VARS "ALEMBIC_${_alembic_lib}_LIBRARY")
        list(APPEND ALEMBIC_LIBRARIES ${ALEMBIC_${_alembic_lib}_LIBRARY})
    endif()
endforeach()

# Reset lib search suffix
if(Alembic_USE_STATIC_LIBS)
    set(CMAKE_FIND_LIBRARY_SUFFIXES ${_alembic_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endif()

# Finalize package search
include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(Alembic
    REQUIRED_VARS ${_alembic_LIB_VARS} ALEMBIC_INCLUDE_DIRS ALEMBIC_LIBRARIES)
