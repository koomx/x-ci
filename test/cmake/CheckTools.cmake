# x-ci self-test: verify pre-installed tools per platform

macro(check_tool name)
    find_program(HAVE_${name} ${name})
    if(NOT HAVE_${name})
        message(FATAL_ERROR "MISSING: ${name} is required but not found")
    endif()
    execute_process(COMMAND "${HAVE_${name}}" --version
        OUTPUT_VARIABLE ${name}_VER
        ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    string(REGEX REPLACE "\n.*" "" ${name}_VER_FIRST "${${name}_VER}")
    message(STATUS "  ${name}: ${HAVE_${name}}  (${${name}_VER_FIRST})")
endmacro()

message(STATUS "Checking tools for ${CMAKE_SYSTEM_NAME} ${CMAKE_SYSTEM_PROCESSOR}")

# All platforms
check_tool(cmake)
check_tool(git)
check_tool(python3)

if(WIN32)
    check_tool(find)      # actually tests if PowerShell/cmd is usable
    check_tool(choco)
elseif(APPLE)
    check_tool(brew)
    check_tool(autoconf)
    check_tool(automake)
    check_tool(libtool)
    check_tool(pkg-config)
    check_tool(sw_vers)   # macOS version check (built-in)
else()
    check_tool(make)
    # At least one package manager should be present
    foreach(pkgmgr IN ITEMS dpkg rpm apk)
        find_program(HAVE_${pkgmgr} ${pkgmgr})
        if(HAVE_${pkgmgr})
            message(STATUS "  ${pkgmgr}: ${HAVE_${pkgmgr}}")
            break()
        endif()
    endforeach()
    if(NOT HAVE_dpkg AND NOT HAVE_rpm AND NOT HAVE_apk)
        message(FATAL_ERROR "No package manager found (tried dpkg, rpm, apk)")
    endif()
endif()

# Try ninja (optional on some platforms, but preferred)
find_program(HAVE_ninja ninja)
if(HAVE_ninja)
    execute_process(COMMAND "${HAVE_ninja}" --version
        OUTPUT_VARIABLE ninja_VER ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE)
    message(STATUS "  ninja: ${HAVE_ninja}  (${ninja_VER})")
else()
    message(STATUS "  ninja: not found (using fallback generator)")
endif()

# Check compiler
message(STATUS "  C compiler:   ${CMAKE_C_COMPILER}")
message(STATUS "  C++ compiler: ${CMAKE_CXX_COMPILER}")

message(STATUS "All required tools found.")
