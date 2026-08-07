cmake_minimum_required(VERSION 3.20)
project(x-ci-self-test LANGUAGES C CXX)

# Build a minimal executable to verify compilation works
add_executable(hello src/main.cpp)

# Register as ctest test
enable_testing()
add_test(NAME hello COMMAND hello)

# Register tool check as a test (runs at CMake configure time)
add_test(NAME check-tools
    COMMAND "${CMAKE_COMMAND}"
    -DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}
    -DCMAKE_SYSTEM_PROCESSOR=${CMAKE_SYSTEM_PROCESSOR}
    -DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}
    -DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}
    -P "${CMAKE_CURRENT_SOURCE_DIR}/cmake/CheckTools.cmake"
)
