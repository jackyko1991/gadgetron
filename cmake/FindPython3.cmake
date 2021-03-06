# - Find the python 3 libraries
#   This module defines
#   PYTHONLIBS_FOUND           - have the Python libs been found
#   PYTHON_EXECUTABLE          - path to python executable
#   PYTHON_LIBRARIES           - path to the python library
#   PYTHON_INCLUDE_PATH        - path to where Python.h is found (deprecated)
#   PYTHON_INCLUDE_DIRS        - path to where Python.h is found
#   PYTHON_DEBUG_LIBRARIES     - path to the debug library (deprecated)
#   PYTHONLIBS_VERSION_STRING  - version of the Python libs found (since CMake 2.8.8)

message("Find python 3")

if ( WIN32 )
    if(NOT DEFINED ENV{PYTHON3_PATH})
        set(PYTHON3_PATH "C:/Python36" CACHE PATH "Where the python 3 are stored")
    else()
        message("PYTHON3_PATH is set as the corresponding environmental variable ... ")
        set(PYTHON3_PATH $ENV{PYTHON3_PATH} CACHE PATH "Where the python 3 are stored")
    endif() 

    find_file(PYTHON_EXECUTABLE NAMES python.exe HINTS "#{PYTHON3_PATH}")
    if (PYTHON_EXECUTABLE)
        message("PYTHON_EXECUTABLE is ${PYTHON_EXECUTABLE}")
        set(PYTHON_EXECUTABLE ${PYTHON_EXECUTABLE} CACHE FILEPATH "Where the python3 exe are stored")
        set(PYTHONLIBS_FOUND 1)
        set(PYTHON_EXECUTABLE ${PYTHON_EXECUTABLE} CACHE FILEPATH "Where the python3 exe are stored")
        set(PYTHON_INCLUDE_DIRS ${PYTHON3_PATH}/include CACHE FILEPATH "Path to python.h")
        set(PYTHON_INCLUDE_DIR ${PYTHON_INCLUDE_DIRS})

        FILE(GLOB var "${PYTHON3_PATH}/libs/python*.lib")

        set(PYTHON_INCLUDE_PATH "${PYTHON_INCLUDE_DIR}")
        message("PYTHON_INCLUDE_PATH is ${PYTHON_INCLUDE_PATH}")
        if(PYTHON_INCLUDE_DIR AND EXISTS "${PYTHON_INCLUDE_DIR}/patchlevel.h")
            file(STRINGS "${PYTHON_INCLUDE_DIR}/patchlevel.h" python_version_str
                REGEX "^#define[ \t]+PY_VERSION[ \t]+\"[^\"]+\"")
            string(REGEX REPLACE "^#define[ \t]+PY_VERSION[ \t]+\"([^\"]+)\".*" "\\1"
                                PYTHONLIBS_VERSION_STRING "${python_version_str}")
            unset(python_version_str)
            message("Found python ${PYTHONLIBS_VERSION_STRING}")
        endif()

        string(FIND ${PYTHONLIBS_VERSION_STRING} "3.6" pos)
        if ( ${pos} GREATER -1)
            set(PYTHON_LIBRARIES ${PYTHON3_PATH}/libs/python36.lib CACHE FILEPATH "Python3 lib")
            set(PYTHON_DEBUG_LIBRARIES ${PYTHON3_PATH}/libs/python36_d.lib CACHE FILEPATH "Python3 lib for debug")
            message("Found python lib ${PYTHON_LIBRARIES}")
        else ()
            string(FIND ${PYTHONLIBS_VERSION_STRING} "3.5" pos)
            if (${pos} GREATER -1)
                set(PYTHON_LIBRARIES ${PYTHON3_PATH}/libs/python35.lib CACHE FILEPATH "Python3 lib")
                set(PYTHON_DEBUG_LIBRARIES ${PYTHON3_PATH}/libs/python35_d.lib CACHE FILEPATH "Python3 lib for debug")
                message("Found python lib ${PYTHON_LIBRARIES}")
            else ()
                string(FIND ${PYTHONLIBS_VERSION_STRING} "3.4" pos)
                if (${pos} GREATER -1)
                    set(PYTHON_LIBRARIES ${PYTHON3_PATH}/libs/python34.lib CACHE FILEPATH "Python3 lib")
                    set(PYTHON_DEBUG_LIBRARIES ${PYTHON3_PATH}/libs/python34_d.lib CACHE FILEPATH "Python3 lib for debug")
                    message("Found python lib ${PYTHON_LIBRARIES}")
                else()
                    message("Cannot find python lib")
                endif ()
            endif ()
        endif ()
    else()
        message("Python3 is not found")
        set(PYTHONLIBS_FOUND 0)
    endif()
else ()
    find_path(PYTHON3_PATH bin/python3 HINTS ENV{PYTHON3_PATH} PATHS /usr /usr/ /usr/local)
#


    find_path(PYTHON_INCLUDE_DIR3 NAMES python3.6/patchlevel.h python3.6m/patchlevel.h python3.5/patchlevel.h python3.5m/patchlevel.h  PATHS /usr/include /usr/local/include )
    if (EXISTS ${PYTHON_INCLUDE_DIR3}/python3.6m/patchlevel.h)
        set(PYTHON_INCLUDE_DIRS ${PYTHON_INCLUDE_DIR3}/python3.6m)
    elseif(EXISTS ${PYTHON_INCLUDE_DIR3}/python3.5m/patchlevel.h)
        set(PYTHON_INCLUDE_DIRS ${PYTHON_INCLUDE_DIR3}/python3.5m)
    endif()
            # find the python version
    if(EXISTS "${PYTHON_INCLUDE_DIRS}/patchlevel.h")
        file(STRINGS "${PYTHON_INCLUDE_DIRS}/patchlevel.h" python_version_str
            REGEX "^#define[ \t]+PY_VERSION[ \t]+\"[^\"]+\"")
        string(REGEX REPLACE "^#define[ \t]+PY_VERSION[ \t]+\"([^\"]+)\".*" "\\1"
                            PYTHONLIBS_VERSION_STRING "${python_version_str}")
        unset(python_version_str)
        message("Found python ${PYTHONLIBS_VERSION_STRING}")
    endif()

    string(REGEX MATCH "[0-9].[0-9]" PYTHON_MAJOR_VERSION ${PYTHONLIBS_VERSION_STRING})
    find_library(PYTHON_LIBRARIES libpython${PYTHON_MAJOR_VERSION}m.so)
    set(PYTHON_LIBRARY ${PYTHON_LIBRARIES})
    UNSET(PYTHON_EXECUTABLE CACHE)
    find_file(PYTHON_EXECUTABLE python3 PATHS /usr/bin /bin /usr/local/bin)
    set(PYTHON_INCLUDE_DIR ${PYTHON_INCLUDE_DIRS} )
    set(PYTHON_INCLUDE_PATH ${PYTHON_INCLUDE_DIRS})
    set(PYTHONLIBS_FOUND 1)

endif ()

