#
# In:
#  TBB_ROOT
#
# Out:
#  TBB_FOUND
#  TBB_VERSION
#  TBB_MAJOR_VERSION
#  TBB_MINOR_VERSION
#  TBB_INCLUDE_DIRS
#  TBB_LIBRARY_DIRS
#

set(TBB_FOUND FALSE)
unset(TBBROOT CACHE) # so we can be called multiple times
find_path(TBBROOT NAMES include/tbb/tbb.h HINTS ${TBB_ROOT})

if(TBBROOT)
    set(TBB_INCLUDE_DIRS ${TBBROOT}/include)
    set(TBB_LIBRARY_DIRS ${TBBROOT}/lib)

    file(READ "${TBB_INCLUDE_DIRS}/tbb/tbb_stddef.h" _TBB_CONTENTS)
    string(REGEX REPLACE ".*#define TBB_VERSION_MAJOR ([0-9]+).*" "\\1" TBB_MAJOR_VERSION "${_TBB_CONTENTS}")
    string(REGEX REPLACE ".*#define TBB_VERSION_MINOR ([0-9]+).*" "\\1" TBB_MINOR_VERSION "${_TBB_CONTENTS}")
    set(TBB_VERSION "${TBB_MAJOR_VERSION}.${TBB_MINOR_VERSION}")

    set(TBB_FOUND TRUE)
endif()

if(Tbb_FIND_REQUIRED AND NOT TBB_FOUND)
    message(FATAL_ERROR "Could not find tbb")
endif()


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
