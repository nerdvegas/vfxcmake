#
# Wrapper for cmake's native FindBoost that adds some functionality. Don't use cmake's find_package()
# function here - call GetBoost() instead, and pass the args you would have passed to find_package,
# minus the leading 'Boost' argument.
#
# Extra out:
#  Boost_NORMALIZED_VERSION: Version in the form X.X.X
#
macro(GetBoost)
    # so we can be called multiple times
    unset(Boost_INCLUDE_DIR CACHE)
    unset(Boost_LIBRARY_DIRS CACHE)
    unset(Boost_FOUND)
    
    set(Boost_DETAILED_FAILURE_MSG 1)
    find_package(Boost ${ARGV})
    
    if(Boost_FOUND)
        set(Boost_NORMALIZED_VERSION ${Boost_MAJOR_VERSION}.${Boost_MINOR_VERSION}.${Boost_SUBMINOR_VERSION})
    endif(Boost_FOUND)
endmacro(GetBoost)


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
