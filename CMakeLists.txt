cmake_minimum_required(VERSION 2.8.0)
project(pango C)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_SOURCE_DIR}/cmake/")
include(GLibHelpers)

find_package(PkgConfig)
pkg_check_modules(glib REQUIRED glib-2.0)
pkg_check_modules(gobject REQUIRED gobject-2.0)
pkg_check_modules(gmodule REQUIRED gmodule-2.0)
pkg_check_modules(cairo cairo)
pkg_check_modules(freetype freetype2)
pkg_check_modules(harfbuzz harfbuzz)
link_directories(${glib_LIBRARY_DIRS}
  ${gmodule_LIBRARY_DIRS}
  ${gobject_LIBRARY_DIRS}
  ${cairo_LIBRARY_DIRS}
  ${freetype_LIBRARY_DIRS}
  ${harfbuzz_LIBRARY_DIRS})

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

if(${CAIRO_WIN32_BACKEND})
  LIST(APPEND PANGOCAIRO_HEADERS "pango/pangocairo-win32.h")
  LIST(APPEND PANGOCAIRO_SOURCES "pango/pangocairo-win32font.c" "pango/pangocairo-win32fontmap.c")
  LIST(APPEND PANGOCAIRO_LIBRARIES  pangowin32 "gdi32")
endif()

# Pango defines
set(PangoDummyPrefix /dummy)
add_definitions(-DG_LOG_DOMAIN="Pango"
                -DG_LOG_USE_STRUCTURED=1
                -DPANGO_COMPILATION # just for pango?
                -DPANGO_ENABLE_BACKEND
                -DPANGO_ENABLE_ENGINE
                # -DHAVE_CONFIG_H # Still used?
                # -DG_DISABLE_SINGLE_INCLUDES # No clue
                -DSYSCONFDIR="${PangoDummyPrefix}/etc"
                -DLIBDIR="${PangoDummyPrefix}/lib"
                # -DPANGO_VERSION_MAJOR=1
                # -DPANGO_VERSION_MINOR=41
                # -DPANGO_VERSION_MICRO=0
                # -DPANGO_API_VERSION=1.0
                # -DPANGO_CURRENT_MINUS_AGE=0
)

# Setup config.h with
# _PANGO_EXTERN => '__declspec(dllexport) extern'/'__attribute__((visibility("default"))) extern'

# See cairo_dep@meson.build:258 for full cairo options to support.
# # On windows you dont want HAVE_CAIRO_FREETYPE since it requires fontconfig
# add_definitions(-DHAVE_CAIRO_FREETYPE=1)

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
set(PANGO_ENUM_NAME "${CMAKE_CURRENT_BINARY_DIR}/pango-enum-types")
add_glib_enumtypes("pango/pango-enum-types.h.template" "pango/pango-enum-types.c.template" "${PANGO_ENUM_NAME}" ${PANGO_HEADERS})
LIST(APPEND PANGO_HEADERS "${PANGO_ENUM_NAME}.h")

# Setup pango includes
include_directories(pango PRIVATE
  ${CMAKE_SOURCE_DIR}
  ${CMAKE_SOURCE_DIR}/pango # Needed for generated sources to find pango.h
  ${glib_INCLUDE_DIRS}
  ${cairo_INCLUDE_DIRS}
  ${png_INCLUDE_DIRS}
  ${freetype_INCLUDE_DIRS}
  ${harfbuzz_INCLUDE_DIRS})

message(${freetype_INCLUDE_DIRS})

# Make the actual library
add_library(pango SHARED ${PANGO_HEADERS} ${PANGO_SOURCES} "${PANGO_ENUM_NAME}.c" config.h)
target_link_libraries(pango ${PANGO_LIBRARIES})


# Freetype2 support depends on FontConfig, probably dont care about it then
# add_library(pangoft2 SHARED ${PANGOFT2_HEADERS} ${PANGOFT2_SOURCES} config.h)
# target_link_libraries(pangoft2 pango ${glib_LIBRARIES} ${gmodule_LIBRARIES} ${gobject_LIBRARIES} ${freetype_LIBRARIES} ${fontconfig_LIBRARIES})
# '-DPANGO_DISABLE_DEPRECATION_WARNINGS',

add_library(pangowin32 SHARED ${PANGOWIN32_HEADERS} ${PANGOWIN32_SOURCES} config.h)
target_link_libraries(pangowin32 ${PANGOWIN32_LIBRARIES})

add_library(pangocairo SHARED ${PANGOCAIRO_HEADERS} ${PANGOCAIRO_SOURCES} config.h)
target_link_libraries(pangocairo ${PANGOCAIRO_LIBRARIES})

# Add an example to excercise the libraries
add_executable(cairosimple examples/cairosimple.c)
target_link_libraries(cairosimple pango pangocairo)

install(TARGETS pango pangowin32 pangocairo cairosimple
    ARCHIVE DESTINATION lib
    LIBRARY DESTINATION lib
    RUNTIME DESTINATION bin)

install(FILES
    ${PANGO_HEADERS}
    ${PANGOWIN32_HEADERS}
    ${PANGOCAIRO_HEADERS}
    DESTINATION include/pango
    )
