cmake_minimum_required(VERSION 3.0.0)
project(pango C)

# add some helpers to our path
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")
include(GLibHelpers)
include(AutotoolsHelpers)
include(CheckAnsiC)
include(CMakeDependentOption)
include(CheckIncludeFiles)
include(CheckFunctionExists)
include(CheckSymbolExists)


# Need to be defined quoted. Trying not to modify the autotools config.h.in
set(PACKAGE "\"pango\"")
set(PACKAGE_BUGREPORT "\"http://bugzilla.gnome.org/enter_bug.cgi?product=pango\"")
set(PACKAGE_NAME "\"pango\"")
set(PACKAGE_STRING "\"pango ${PANGO_VERSION}\"")
set(PACKAGE_TARNAME "\"pango\"")
set(PACKAGE_URL "\"\"")
set(PACKAGE_VERSION "\"${PANGO_VERSION}\"")
set(VERSION "\"${PANGO_VERSION}\"")

set(PANGO_VERSION_MAJOR "1"  CACHE STRING "Major Version")
set(PANGO_VERSION_MINOR "42" CACHE STRING "Minor Version")
set(PANGO_VERSION_MICRO "0"  CACHE STRING "Micro Version")
set(PANGO_VERSION ${PANGO_VERSION_MAJOR}.${PANGO_VERSION_MINOR}.${PANGO_VERSION_MICRO} CACHE INTERNAL "Version tuple")
set(PANGO_API_VERSION "${PANGO_VERSION_MAJOR}.0" CACHE INTERNAL "API version")
set(PANGO_INTERFACE_AGE "${PANGO_VERSION_MICRO}") # Or set to 0 for _odd_ minor versions (unstable release) 
math(EXPR PANGO_BINARY_AGE "${PANGO_VERSION_MINOR} * 100 + ${PANGO_VERSION_MICRO}")


find_package(PkgConfig)
pkg_check_modules(glib REQUIRED glib-2.0)
pkg_check_modules(gobject REQUIRED gobject-2.0)
pkg_check_modules(gmodule REQUIRED gmodule-2.0)
pkg_check_modules(cairo cairo)
if(NOT cairo_FOUND)
  find_package(cairo)
endif()
pkg_check_modules(freetype freetype2)
if(NOT freetype_FOUND)
  find_package(freetype)
endif()
pkg_check_modules(fontconfig fontconfig)
if(NOT fontconfig_FOUND)
  find_package(fontconfig)
endif()
pkg_check_modules(harfbuzz harfbuzz)
if(NOT harfbuzz_FOUND)
  find_package(harfbuzz)
endif()
link_directories(${glib_LIBRARY_DIRS}
  ${gmodule_LIBRARY_DIRS}
  ${gobject_LIBRARY_DIRS}
  ${cairo_LIBRARY_DIRS}
  ${freetype_LIBRARY_DIRS}
  ${harfbuzz_LIBRARY_DIRS})

# Library options
cmake_dependent_option(HAVE_CAIRO "Have usable Cairo library and font backend"
  ON "cairo_FOUND" OFF)
pkg_check_modules(cairo_ft QUIET cairo-ft)
cmake_dependent_option(HAVE_CAIRO_FREETYPE "Whether Cairo can use FreeType for fonts"
  ON "cairo_ft_FOUND;fontconfig_FOUND" OFF)
pkg_check_modules(cairo_win32 QUIET cairo-win32)
cmake_dependent_option(HAVE_CAIRO_WIN32 "Whether Cairo can use the Win32 GDI for fonts"
  ON "cairo_win32_FOUND" OFF)
pkg_check_modules(cairo_png QUIET cairo-png)
cmake_dependent_option(HAVE_CAIRO_PNG "Whether Cairo has PNG support"
  ON "cairo_png_FOUND" OFF)
cmake_dependent_option(HAVE_FREETYPE "Have FreeType 2 library"
  ON "freetype_FOUND" OFF)
cmake_dependent_option(HAVE_LIBTHAI "Whether libthai is available"
  ON "libthai_FOUND" OFF)
cmake_dependent_option(HAVE_XFT "Have Xft library"
  ON "xft_FOUND" OFF)

# Compiler settings
check_include_files(dlfcn.h HAVE_DLFCN_H)
check_include_files(inttypes.h HAVE_INTTYPES_H)
check_include_files(memory.h HAVE_MEMORY_H)
check_symbol_exists(DIR ndir.h HAVE_NDIR_H)
check_symbol_exists(DIR "sys/dir.h" HAVE_SYS_DIR_H)
check_symbol_exists(DIR "sys/ndir.h" HAVE_SYS_NDIR_H)
check_include_files("sys/mman.h" HAVE_SYS_MMAN_H)
check_include_files("sys/stat.h" HAVE_SYS_STAT_H)
check_include_files("sys/types.h" HAVE_SYS_TYPES_H)
check_include_files(unistd.h HAVE_UNISTD_H)
check_include_files(stdint.h HAVE_STDINT_H)
check_include_files(stdlib.h HAVE_STDLIB_H)
check_include_files(strings.h HAVE_STRINGS_H)
check_include_files(string.h HAVE_STRING_H)
check_function_exists(FcWeightFromOpenTypeDouble HAVE_FCWEIGHTFROMOPENTYPEDOUBLE)
check_function_exists(flockfile HAVE_FLOCKFILE)
check_function_exists(getpagesize HAVE_GETPAGESIZE)
check_function_exists(strtok_r HAVE_STRTOK_R)
check_function_exists(sysconf HAVE_SYSCONF)
check_function_exists(flockfile HAVE_FLOCKFILE)
check_ansi_c(STDC_HEADERS)
if(MSVC)
  set(_PANGO_EXTERN "__declspec(dllexport) extern")
else()
  set(_PANGO_EXTERN "__attribute__((visibility(\"default\"))) extern")
endif()

# Handle dumping out autotools config.h correctly for pango specifically.
add_autotools_config("config.h.win32.in" "config.h")
set(PANGO_PRIVATE_CONFIG_HEADER "${CMAKE_CURRENT_BINARY_DIR}/config.h")
include_directories(${CMAKE_CURRENT_BINARY_DIR})

set(PANGO_SOURCES   
  "pango/break.c"
  "pango/ellipsize.c"
  "pango/fonts.c"
  "pango/glyphstring.c"
  "pango/modules.c"
  "pango/pango-attributes.c"
  "pango/pango-bidi-type.c"
  "pango/pango-color.c"
  "pango/pango-context.c"
  "pango/pango-coverage.c"
  "pango/pango-emoji.c"
  "pango/pango-engine.c"
  "pango/pango-fontmap.c"
  "pango/pango-fontset.c"
  "pango/pango-glyph-item.c"
  "pango/pango-gravity.c"
  "pango/pango-item.c"
  "pango/pango-language.c"
  "pango/pango-layout.c"
  "pango/pango-markup.c"
  "pango/pango-matrix.c"
  "pango/pango-renderer.c"
  "pango/pango-script.c"
  "pango/pango-tabs.c"
  "pango/pango-utils.c"
  "pango/reorder-items.c"
  "pango/shape.c")

set(PANGO_HEADERS
  "pango/pango.h"
  "pango/pango-attributes.h"
  "pango/pango-bidi-type.h"
  "pango/pango-break.h"
  "pango/pango-context.h"
  "pango/pango-coverage.h"
  "pango/pango-engine.h"
  "pango/pango-features.h"
  "pango/pango-font.h"
  "pango/pango-fontmap.h"
  "pango/pango-fontset.h"
  "pango/pango-glyph.h"
  "pango/pango-glyph-item.h"
  "pango/pango-gravity.h"
  "pango/pango-item.h"
  "pango/pango-language.h"
  "pango/pango-layout.h"
  "pango/pango-matrix.h"
  "pango/pango-modules.h"
  "pango/pango-renderer.h"
  "pango/pango-script.h"
  "pango/pango-tabs.h"
  "pango/pango-types.h"
  "pango/pango-utils.h"
  "pango/pango-version-macros.h"
)
add_autotools_config("pango-features.h.cmake.in" "pango/pango-features.h")
list(APPEND PANGO_HEADERS "${CMAKE_CURRENT_BINARY_DIR}/pango/pango-features.h")

set(FRIBIDI_SOURCES 
  "pango/mini-fribidi/fribidi.c"
  "pango/mini-fribidi/fribidi_char_type.c"
  "pango/mini-fribidi/fribidi_types.c"
)


set(PANGOFT2_HEADERS
    "pango/pango-ot.h"
    "pango/pangofc-font.h"
    "pango/pangofc-fontmap.h"
    "pango/pangofc-decoder.h"
    "pango/pangoft2.h"
)

set(PANGOFT2_PUBLIC_SOURCES
    "pango/pangofc-font.c"
    "pango/pangofc-fontmap.c"
    "pango/pangofc-decoder.c"
    "pango/pangofc-shape.c"
    "pango/pangoft2.c"
)

set(PANGOFT2_SOURCES
    ${PANGOFT2_PUBLIC_SOURCES}
    "pango/pangoft2-fontmap.c"
    "pango/pangoft2-render.c"
    "pango/pango-ot-buffer.c"
    "pango/pango-ot-info.c"
    "pango/pango-ot-ruleset.c"
    "pango/pango-ot-tag.c"
)

set(PANGOWIN32_HEADERS
    "pango/pangowin32.h"
)

set(PANGOWIN32_SOURCES
    "pango/pangowin32.c"
    "pango/pangowin32-fontcache.c"
    "pango/pangowin32-fontmap.c"
    "pango/pangowin32-shape.c"
)

set(PANGOCAIRO_HEADERS
    "pango/pangocairo.h"
)

set(PANGOCAIRO_SOURCES
    "pango/pangocairo-context.c"
    "pango/pangocairo-font.c"
    "pango/pangocairo-fontmap.c"
    "pango/pangocairo-render.c"
)

set(GLIB_COMMON_LIBRARIES ${glib_LIBRARIES} ${gmodule_LIBRARIES} ${gobject_LIBRARIES})
set(PANGO_LIBRARIES ${GLIB_COMMON_LIBRARIES} mini-fribidi)
set(PANGOWIN32_LIBRARIES pango gdi32 usp10)
set(PANGOCAIRO_LIBRARIES pango ${cairo_LIBRARIES})


if(${cairo_win32_FOUND})
  LIST(APPEND PANGOCAIRO_HEADERS "pango/pangocairo-win32.h")
  LIST(APPEND PANGOCAIRO_SOURCES "pango/pangocairo-win32font.c" "pango/pangocairo-win32fontmap.c")
  LIST(APPEND PANGOCAIRO_LIBRARIES  pangowin32 "gdi32")
endif()

if(fontconfig_FOUND)
  LIST(APPEND PANGO_HEADERS pango/pangofc-decoder.h pango/pangofc-fontmap.h pango/pangofc-font.h pango/pangofc-private.h)
  LIST(APPEND PANGO_SOURCES pango/pangofc-decoder.c pango/pangofc-fontmap.c pango/pangofc-font.c pango/pangofc-shape.c)
  LIST(APPEND PANGOCAIRO_HEADERS "pango/pangocairo-fc.h")
  LIST(APPEND PANGOCAIRO_SOURCES "pango/pangocairo-fcfont.c" "pango/pangocairo-fcfontmap.c")
  LIST(APPEND PANGOCAIRO_LIBRARIES  ${fontconfig_LIBRARIES})
endif()


# Pango defines from vs solutions
set(PangoDummyPrefix /dummy)
add_definitions(-DG_LOG_DOMAIN="Pango"
                -DG_LOG_USE_STRUCTURED=1
                -DPANGO_COMPILATION # just for pango?
                -DPANGO_ENABLE_BACKEND
                -DPANGO_ENABLE_ENGINE
                ${CAIRO_C_FLAGS}
                # -DG_DISABLE_SINGLE_INCLUDES # No clue
                -DSYSCONFDIR="${PangoDummyPrefix}/etc"
                -DLIBDIR="${PangoDummyPrefix}/lib"
)


# #PangoFT cflags
# add_definitions(-DHAVE_STDINT_H=1)

# Fribidi Library
add_library(mini-fribidi STATIC ${FRIBIDI_SOURCES} config.h)
target_link_libraries(mini-fribidi ${gobject_LIBRARIES}) # Depends on m on linux
target_include_directories(mini-fribidi PRIVATE
  ${glib_INCLUDE_DIRS} ${CMAKE_SOURCE_DIR}
)

# Pango Library
if(MSVC)
  add_definitions(/FI"msvc_recommended_pragmas.h")
endif()
# Make enums
set(PANGO_ENUM_NAME "${CMAKE_BINARY_DIR}/pango-enum-types")
# Bug 390877 - Don't feed pango-features.h to glib-mkenums
add_glib_enumtypes("pango/pango-enum-types.h.template" "pango/pango-enum-types.c.template" "${PANGO_ENUM_NAME}" ${PANGO_HEADERS})
LIST(APPEND PANGO_SOURCES "${PANGO_ENUM_NAME}.c")
LIST(APPEND PANGO_HEADERS "${PANGO_ENUM_NAME}.h")

# Setup pango includes
include_directories(pango PRIVATE
  ${CMAKE_SOURCE_DIR}
  ${CMAKE_BINARY_DIR}/pango # Needed for generated sources to find pango.h
  ${CMAKE_BINARY_DIR}
  ${glib_INCLUDE_DIRS}
  ${CAIRO_INCLUDE_DIRS}
  ${png_INCLUDE_DIRS}
  ${freetype_INCLUDE_DIRS}
  ${harfbuzz_INCLUDE_DIRS})


# Make the actual library
add_library(pango STATIC ${PANGO_HEADERS} ${PANGO_SOURCES} ${PANGO_PRIVATE_CONFIG_HEADER})
target_link_libraries(pango ${PANGO_LIBRARIES})


# Freetype2 support depends on FontConfig, probably dont care about it then
# add_library(pangoft2 SHARED ${PANGOFT2_HEADERS} ${PANGOFT2_SOURCES} config.h)
# target_link_libraries(pangoft2 pango ${glib_LIBRARIES} ${gmodule_LIBRARIES} ${gobject_LIBRARIES} ${freetype_LIBRARIES} ${cairo_ft_LIBRARIES})
# '-DPANGO_DISABLE_DEPRECATION_WARNINGS',

add_library(pangowin32 STATIC ${PANGOWIN32_HEADERS} ${PANGOWIN32_SOURCES} ${PANGO_PRIVATE_CONFIG_HEADER})
target_link_libraries(pangowin32 ${PANGOWIN32_LIBRARIES})

add_library(pangocairo STATIC ${PANGOCAIRO_HEADERS} ${PANGOCAIRO_SOURCES} ${PANGO_PRIVATE_CONFIG_HEADER})
target_compile_definitions(pangocairo PUBLIC ${cairo_CFLAGS})
target_link_libraries(pangocairo ${PANGOCAIRO_LIBRARIES})

# Add an example to excercise the libraries,left out for static builds
# add_executable(cairosimple examples/cairosimple.c)
# target_link_libraries(cairosimple PRIVATE pangocairo pangowin32 pango ${PANGO_LIBRARIES} ${PANGOWIN32_LIBRARIES} ${fontconfig_LIBRARIES} ${cairo_LIBRARIES}  ${harfbuzz_LIBRARIES})

# subdirs(pango-view)

install(TARGETS pango pangowin32 pangocairo
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin)

install(FILES
    ${PANGO_HEADERS}
    ${PANGOWIN32_HEADERS}
    ${PANGOCAIRO_HEADERS}
    DESTINATION include/pango
    )
