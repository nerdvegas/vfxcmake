#
# Wrapper for cmake's native FindPythonLibs that adds some functionality. Don't use cmake's 
# find_package() function here - call GetPython() instead, and pass the args you would have passed 
# to find_package, minus the leading 'PythonLibs' argument.
#
# Extra In:
#  PYTHON_ROOT: Where to find python. If not supplied, this code will look for a visible python 
#    binary and work it out from there. If that still fails, we fall back to cmake's FindPythonLibs.
#
# Extra Out:
#  PYTHON_FOUND
#  PYTHON_VERSION
#  PYTHON_VERSION_MAJOR
#  PYTHON_VERSION_MINOR
#  PYTHON_VERSION_PATCH
#  PYTHON_LIBRARY_DIRS
#  PYTHON_LIBRARIES
#

macro(GetPython)
    set(PYTHON_FOUND FALSE)
    unset(PYROOT CACHE)
    unset(_PYROOT_VERIFY CACHE)
    unset(PYTHON_INCLUDE_DIR CACHE)
    unset(PYTHON_LIBRARY CACHE)
    unset(PYTHON_LIBRARIES CACHE)
    unset(PYTHON_EXECUTABLE CACHE)
    
    if(PYTHON_ROOT)
        find_path(PYROOT NAMES bin/python HINTS ${PYTHON_ROOT} )
    endif(PYTHON_ROOT)
    
    if(NOT PYROOT)
        find_package(PythonInterp ${ARGV} QUIET)
        if(PYTHONINTERP_FOUND)
            get_filename_component(PYROOT ${PYTHON_EXECUTABLE} PATH)
            get_filename_component(PYROOT ${PYROOT} PATH)
            find_path(_PYROOT_VERIFY NAMES bin/python HINTS ${PYROOT} )
            if(NOT _PYROOT_VERIFY)
                unset(PYROOT)
            endif(NOT _PYROOT_VERIFY)
        endif(PYTHONINTERP_FOUND)
    endif(NOT PYROOT)
    
    if(PYROOT)
        execute_process(COMMAND "${PYROOT}/bin/python" --version 
            ERROR_VARIABLE _VERSION OUTPUT_QUIET ERROR_STRIP_TRAILING_WHITESPACE)
        string(REPLACE "Python " "" PYTHON_VERSION "${_VERSION}")
        string(REGEX REPLACE "^([0-9]+)\\.[0-9]+\\.[0-9]+.*" "\\1" PYTHON_VERSION_MAJOR "${PYTHON_VERSION}")
        string(REGEX REPLACE "^[0-9]+\\.([0-9])+\\.[0-9]+.*" "\\1" PYTHON_VERSION_MINOR "${PYTHON_VERSION}")
        string(REGEX REPLACE "^[0-9]+\\.[0-9]+\\.([0-9]+).*" "\\1" PYTHON_VERSION_PATCH "${PYTHON_VERSION}")
        
        # TODO do more checks here instead of assuming pythonX.X
        set(PYNAME "python${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}")
        set(PYTHON_INCLUDE_PATH ${PYROOT}/include/${PYNAME})
        set(PYTHON_INCLUDE_DIRS ${PYTHON_INCLUDE_PATH})
        set(PYTHON_LIBRARY_DIRS ${PYROOT}/lib)
        set(PYTHON_LIBRARIES ${PYROOT}/lib/lib${PYNAME}.so)
    else(PYROOT)
        find_package(PythonLibs ${ARGV})
        if(PYTHONLIBS_FOUND)
            set(PYTHON_FOUND TRUE)
            get_filename_component(PYTHON_LIBRARY_DIRS ${PYTHON_LIBRARIES} PATH)
            get_filename_component(PYTHON_LIBRARIES ${PYTHON_LIBRARIES} NAME)
        endif(PYTHONLIBS_FOUND)
    endif(PYROOT)
endmacro(GetPython)
















