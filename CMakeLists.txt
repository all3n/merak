cmake_minimum_required(VERSION 3.14)
project(merak VERSION 1.0)
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)

set(BUILD_GMOCK OFF CACHE BOOL "")
set(BUILD_GTEST OFF CACHE BOOL "")
set(INSTALL_GTEST OFF)

file(GLOB_RECURSE SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/merak/*.cpp")
file(GLOB_RECURSE HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/merak/*.h")

option(ENABLE_TESTING "Enable testing of ${PROJECT_NAME}" OFF)
option(DEBUG "DEBUG build ${PROJECT_NAME}" OFF)

message(STATUS "sources:${SOURCES}")
message(STATUS "headers:${HEADERS}")

find_package(gflags REQUIRED)
find_package(glog REQUIRED)
find_package(yaml-cpp REQUIRED)
find_package(Backward)

if (DEBUG)
  get_cmake_property(_variableNames VARIABLES)
  list (SORT _variableNames)
  foreach (_variableName ${_variableNames})
      message(STATUS "${_variableName}=${${_variableName}}")
  endforeach()
endif()


include_directories(.)



add_executable(${PROJECT_NAME} ${SOURCES} ${HEADERS})
target_include_directories(${PROJECT_NAME} PRIVATE ${AC_HOME}/include)
target_link_directories(${PROJECT_NAME} PRIVATE ${AC_HOME}/lib)
target_link_libraries(${PROJECT_NAME} gflags glog::glog yaml-cpp ac Backward::Backward)
#target_link_libraries(${PROJECT_NAME} gflags glog::glog yaml-cpp ac)

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
