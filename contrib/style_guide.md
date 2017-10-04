vfxcmake Style Guide
====================

**By Nathan Rusch**

This document proposes some conventions for code style within the vfxcmake
project, based mostly on conventions observed in the original modules, with
some minor changes aimed at minimizing clutter.

Though CMake does not define any syntactic or stylistic conventions for Find
modules, this makes an attempt to adhere to a few de facto conventions that
align with the CMake recommendations and documented examples where possible.


Spacing
-------
- Nested blocks are each indented 4 spaces, in line with Python's PEP-8 style
guide.

```cmake
if(APPLE)
    message(STATUS "I think this is a Mac")
elseif(WIN32)
    message(STATUS "This appears to be Windows")
else()
    message(STATUS "I'm going to assume this is Linux")
endif()
```

- Line splitting for command flags and arguments is left to the discretion of
the module author. Hanging indents should be to the next block level.

```cmake
find_path(MAYA_INCLUDE_DIRS maya/MFn.h
    HINTS ${MAYA_LOCATION}
    PATH_SUFFIXES
        include               # linux and windows
        ../../devkit/include  # osx
    DOC "Maya's include path")
```

- Leading and trailing spaces should be omitted from commands and parenthesized
expressions.

```cmake
foreach(version ${_maya_KNOWN_VERSIONS})
    if(NOT "${version}" VERSION_LESS "${Maya_FIND_VERSION}")
        list(APPEND _maya_TEST_VERSIONS "${version}")
    endif()
endforeach()
```

- Hanging opening or closing parentheses should be avoided.


Keywords
--------
- Keywords for commands (e.g. `find_package`), flow control (e.g. `if`,
`foreach`), or anything else included in the "Commands" section of the CMake
documentation are lower-case.
- Keywords that serve as flags or arguments to commands, comparison operators,
etc. are upper-case (e.g. `STREQUAL`, `APPEND`).


Variables
---------
- Input variables should be prefixed with the
target name cased to match the package name as it is represented in the "Find"
module's filename (e.g. `Maya_FIND_VERSION`).
- Output variables should be prefixed with
the target name in **upper-case** (e.g. `MAYA_FOUND`, `MAYA_LIBRARY_DIRS`).
- Private module variables should begin with an underscore and some
variation the target name, typically in **lower-case** (e.g. `_maya_DEFINES`).
- Path output variable should generally be plural (e.g. `MAYA_INCLUDE_DIRS`)

Functions and Macros
--------------------
- Definition termination commands for functions and macros are called with the
name of the function or macro (e.g. `endmacro(MAYA_SET_PLUGIN_PROPERTIES)`).


Flow Control
------------
- Flow control termination commmands are invoked without the expressions from
the matching start commands (e.g. `endif()`, `endforeach()`).
- Flow control start/end commands should be at the same indent level.

Documentation
-------------

Each `Find*.cmake` file should have a header describing the input and output variables, macros, and environment variables that influence discovery.

```cmake
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
```
