cmake_minimum_required(VERSION 3.14)
project(merak VERSION 1.0)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(BUILD_GMOCK OFF CACHE BOOL "")
set(BUILD_GTEST OFF CACHE BOOL "")
set(INSTALL_GTEST OFF)

file(GLOB_RECURSE SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp")
file(GLOB_RECURSE HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/src/*.h")

option(ENABLE_TESTING "Enable testing of ${PROJECT_NAME}" OFF)
option(DEBUG "DEBUG build ${PROJECT_NAME}" OFF)

message(STATUS "sources:${SOURCES}")
message(STATUS "headers:${HEADERS}")

find_package(gflags REQUIRED)
find_package(glog REQUIRED)

if (DEBUG)
  get_cmake_property(_variableNames VARIABLES)
  list (SORT _variableNames)
  foreach (_variableName ${_variableNames})
      message(STATUS "${_variableName}=${${_variableName}}")
  endforeach()
endif()


add_executable(${PROJECT_NAME} ${SOURCES})
target_link_libraries(${PROJECT_NAME} gflags glog::glog)

install(TARGETS ${PROJECT_NAME} DESTINATION bin)


if (ENABLE_TESTING)
  file(GLOB_RECURSE TEST_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/tests/*.cpp")
  message(STATUS "test sources:${TEST_SOURCES}")

  find_package(GTest REQUIRED)
  enable_testing()
  add_executable(
    ${PROJECT_NAME}_tests
    ${TEST_SOURCES}
  )
  include(GoogleTest)
  target_link_libraries(${PROJECT_NAME}_tests GTest::gtest_main)
  gtest_discover_tests(${PROJECT_NAME}_tests)
endif()
