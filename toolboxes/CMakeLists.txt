if (WIN32)
    add_definitions(-DTIXML_USE_STL)
endif ()

if (MKL_FOUND)
    include_directories( ${MKL_INCLUDE_DIR} )
    link_directories( ${MKL_LIB_DIR} ${MKL_COMPILER_LIB_DIR} )
    link_libraries(${MKL_LIBRARIES})
endif ()

add_subdirectory(log)
add_subdirectory(node_discovery)

add_subdirectory(operators)
add_subdirectory(solvers)

if (FFTW3_FOUND)
  add_subdirectory(fft)
  add_subdirectory(core)
  if(ARMADILLO_FOUND)
    add_subdirectory(mri_core)
  endif()
  add_subdirectory(mri)
  if(ARMADILLO_FOUND)
    add_subdirectory(cmr)
  endif()
  # if (NOT(WIN32))
    add_subdirectory(ct)
  # endif()

  if (ISMRMRD_FOUND)
    add_subdirectory(mri_image)
  endif()
endif()

if(ARMADILLO_FOUND)
  add_subdirectory(klt)
endif()
add_subdirectory(nfft)
add_subdirectory(dwt)
add_subdirectory(registration)
add_subdirectory(rest)

add_subdirectory(ffd)
add_subdirectory(image)
add_subdirectory(pattern_recognition)
add_subdirectory(denoise)

if (ACE_FOUND)
  add_subdirectory(gadgettools)
  add_subdirectory(cloudbus)
endif()

add_subdirectory(image_io)

find_package(BLAS)
find_package(LAPACK)



if (CERES_FOUND)
  message("Ceres found, compiling fat/water toolbox")
  add_subdirectory(fatwater)
else()
  message("Ceres not found, skipping fat/water toolbox")
endif()

if (MATLAB_FOUND)
  message("Compiling MATLAB toolbox")
  add_subdirectory(matlab)
endif()


# Should we compile the python toolbox
if (BUILD_PYTHON_SUPPORT AND PYTHONLIBS_FOUND AND NUMPY_FOUND)

  if(BUILD_WITH_PYTHON3)
    find_package(Boost COMPONENTS python3 system thread)
    message("Boost_PYTHON3_FOUND is ${Boost_PYTHON3_FOUND}")
  else()
    find_package(Boost COMPONENTS python system thread)
    message("Boost_PYTHON_FOUND is ${Boost_PYTHON_FOUND}")
  endif()

  message("Boost_SYSTEM_FOUND is ${Boost_SYSTEM_FOUND}")
  message("Boost_THREAD_FOUND is ${Boost_THREAD_FOUND}")
  if ((Boost_PYTHON3_FOUND OR Boost_PYTHON_FOUND) AND PYTHONLIBS_FOUND AND NUMPY_FOUND)
    message("Find python; build gadgetron toolbox python")
    add_subdirectory(python)
  else()
    message("Cannot find python; do not build gadgetron toolbox python")
  endif ()
else()
  message("Cannot find python; do not build gadgetron toolbox python")
  set(BUILD_PYTHON_SUPPORT OFF)
endif()

if (ARMADILLO_FOUND AND Boost_FOUND AND PLPLOT_FOUND)
    add_subdirectory(plplot)
endif ()
