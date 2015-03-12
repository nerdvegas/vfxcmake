vfxcmake
========

Cmake Find modules for common vfx software, and general Cmake utility code, licensed under LGPL.

Please fork this project, improve it, and add new applications!


Maya Example
------------

```cmake
# can optionally specify a version: FIND_PACKAGE( Maya 2012 REQUIRED )
FIND_PACKAGE( Maya REQUIRED )
# find a local install of Qt that matches the version required for Maya, as determined above
FIND_PACKAGE( Qt4 ${MAYA_QT_VERSION_SHORT} REQUIRED )

# load the Qt tools
INCLUDE( ${QT_USE_FILE} )

SET( myplugin_SRCS
    ../src/QMyCoreLib.cpp
)

SET( myplugin_MOC_HDRS
  ../src/QMyCoreLib.h
)

# generate the Qt moc files
QT4_WRAP_CPP( myplugin_MOC_SRCS ${myplugin_MOC_HDRS} )

# the maya-specific plugin code (w/ initializePlugin, etc)
SET( plugin_SRCS plugin.cpp )

INCLUDE_DIRECTORIES( ${PUBLIC_INCLUDE_DIRS} ${myplugin_proj_SOURCE_DIR}/src ${MAYA_INCLUDE_DIR} )

# create the plugin
ADD_LIBRARY( myplugin_plugin SHARED
  ${plugin_SRCS}
  ${myplugin_SRCS} ${myplugin_MOC_SRCS}
)

TARGET_LINK_LIBRARIES( myplugin_plugin
   ${MAYA_Foundation_LIBRARY} ${MAYA_OpenMaya_LIBRARY} ${MAYA_OpenMayaUI_LIBRARY}
   ${QT_LIBRARIES}
)

SET_TARGET_PROPERTIES( myplugin_plugin PROPERTIES 
  OUTPUT_NAME myplugin
  CLEAN_DIRECT_OUTPUT 1
)

# this is a macro defined in FindMaya that sets up our plugin with standard Maya build settings
MAYA_SET_PLUGIN_PROPERTIES( myplugin_plugin )
```
