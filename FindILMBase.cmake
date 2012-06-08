#
# In:
#  ILMBASE_ROOT
#
# Out:
#  ILMBASE_FOUND
#  ILMBASE_VERSION
#  ILMBASE_INCLUDE_DIRS
#  ILMBASE_LIBRARY_DIRS
#


set(ILMBASE_FOUND FALSE)
find_path(IlmBaseRoot NAMES include/OpenEXR/IlmBaseConfig.h HINTS ${ILMBASE_ROOT})

if( IlmBaseRoot )
    set(ILMBASE_INCLUDE_DIRS ${IlmBaseRoot}/include ${IlmBaseRoot}/include/OpenEXR)
    set(ILMBASE_LIBRARY_DIRS ${IlmBaseRoot}/lib )
    file(READ "${ILMBASE_LIBRARY_DIRS}/pkgconfig/IlmBase.pc" _ILMBASE_PC_CONTENTS)
    string(REGEX REPLACE
        ".*Version: ([1-9]+\\.[0-9]+\\.[0-9]+).*" "\\1"
        ILMBASE_VERSION "${_ILMBASE_PC_CONTENTS}")
    set(ILMBASE_FOUND TRUE)
endif( IlmBaseRoot )

if( ILMBase_FIND_REQUIRED AND NOT ILMBASE_FOUND )
    message(FATAL_ERROR "Could not find ilmbase")
endif( ILMBase_FIND_REQUIRED AND NOT ILMBASE_FOUND )


#
# Copyright 2012, Allan Johns
#
# vfxgal is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# vfxgal is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with vfxgal.  If not, see <http://www.gnu.org/licenses/>.
#
