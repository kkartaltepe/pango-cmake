cmake_minimum_required(VERSION 3.0.0)
project(pango-view C)

set(PGV_SOURCES 
  "pango-view.c"
  "viewer-main.c"
  "viewer-render.c")

if(${CAIRO_FOUND})
	list(APPEND PGV_SOURCES 
		"viewer-cairo.c"
		"viewer-pangocairo.c")
endif()

add_executable(pango-view ${PGV_SOURCES})
target_link_libraries(pango-view pangocairo pangoft2 pangowin32 pango ${PANGO_LIBRARIES} ${PANGOWIN32_LIBRARIES} ${FONTCONFIG_LIBRARIES} ${CAIRO_LIBRARIES}  ${HARFBUZZ_LIBRARIES} 
	pixman-1_static
	freetype
	zlib
	libpng16
	expat)