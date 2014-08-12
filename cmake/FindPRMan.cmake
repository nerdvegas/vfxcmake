#==========
#
# Copyright (c) 2010, Dan Bethell.
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
# Variables defined by this module:
#   PRMan_FOUND
#   PRMan_INCLUDE_DIR
#   PRMan_COMPILE_FLAGS
#   PRMan_LIBRARIES
#   PRMan_LIBRARY_DIR
#
# Usage:
#   FIND_PACKAGE( PRMan )
#   FIND_PACKAGE( PRMan REQUIRED )
#
# Note:
# You can tell the module where PRMan is installed by setting
# the PRMan_INSTALL_PATH (or setting the RMANTREE environment
# variable) before calling FIND_PACKAGE.
#
# E.g.
#   SET( PRMan_INSTALL_PATH "/opt/pixar/RenderManProServer-15.0" )
#   FIND_PACKAGE( PRMan REQUIRED )
#
#==========

# our includes
find_path( PRMan_INCLUDE_DIR ri.h
  $ENV{RMANTREE}/include
  ${PRMan_INSTALL_PATH}/include
  )

# our library itself
find_library( PRMan_LIBRARIES prman
  $ENV{RMANTREE}/lib
  ${PRMan_INSTALL_PATH}/lib
  )

# our compilation flags
SET( PRMan_COMPILE_FLAGS "-DPRMAN -fPIC" )

# did we find everything?
include( FindPackageHandleStandardArgs )
FIND_PACKAGE_HANDLE_STANDARD_ARGS( "PRMan" DEFAULT_MSG
  PRMan_INCLUDE_DIR
  PRMan_LIBRARIES
  )
