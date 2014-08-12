#==========
#
# Copyright (c) 2009, Dan Bethell.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#
#     * Neither the name of Dan Bethell nor the names of any
#       other contributors to this software may be used to endorse or
#       promote products derived from this software without specific prior
#       written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
# IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#==========
#
# Input Variables:
#   OpenImageIO_USE_STATIC_LIBS
#
# Variables defined by this module:
#   OpenImageIO_FOUND
#   OpenImageIO_INCLUDE_DIR
#   OpenImageIO_LIBRARY
#
# Usage:
#   FIND_PACKAGE( OpenImageIO )
#   FIND_PACKAGE( OpenImageIO REQUIRED )
#
# Note:
# OpenImageIO is often not installed in a system location.
# If this is the case, set the IMAGEIO_PATH envvar or
# OpenImageIO_INSTALL_PATH cmake variable before calling
# FIND_PACKAGE.
#
# E.g.
#   SET( OpenImageIO_INSTALL_PATH "/path/to/oiio/dist/linux64" )
#   FIND_PACKAGE( OpenImageIO REQUIRED )
#
#==========

# try to find header
find_path( OpenImageIO_INCLUDE_DIR OpenImageIO/imageio.h
  $ENV{IMAGEIO_PATH}/include
  ${OpenImageIO_INSTALL_PATH}/include
  )

# Support preference of static libs by adjusting CMAKE_FIND_LIBRARY_SUFFIXES
if( OpenImageIO_USE_STATIC_LIBS )
  set( _oiio_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
  if(WIN32)
    set(CMAKE_FIND_LIBRARY_SUFFIXES .lib .a ${CMAKE_FIND_LIBRARY_SUFFIXES})
  else()
    set(CMAKE_FIND_LIBRARY_SUFFIXES .a )
  endif()
endif()

# try to find libs
find_library( OpenImageIO_LIBRARY OpenImageIO
  $ENV{IMAGEIO_PATH}/lib
  $ENV{IMAGEIO_LIBRARY_PATH}
  ${OpenImageIO_INSTALL_PATH}/lib
  )

# Restore the original find library ordering
if( OpenImageIO_USE_STATIC_LIBS )
  set(CMAKE_FIND_LIBRARY_SUFFIXES ${_oiio_ORIG_CMAKE_FIND_LIBRARY_SUFFIXES})
endif()

# did we find everything?
include( FindPackageHandleStandardArgs )
FIND_PACKAGE_HANDLE_STANDARD_ARGS( "OpenImageIO" DEFAULT_MSG
  OpenImageIO_INCLUDE_DIR
  OpenImageIO_LIBRARY
  )
