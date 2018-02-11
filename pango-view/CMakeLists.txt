cmake_minimum_required(VERSION 3.0.0)
project(pango-view C)

set(PGV_SOURCES 
  "pango-view.c"
  "viewer-main.c"
  "viewer-render.c")

if(${cairo_FOUND})
	list(APPEND PGV_SOURCES 
		"viewer-cairo.c"
		"viewer-pangocairo.c")
endif()

add_executable(pango-view ${PGV_SOURCES})
target_link_libraries(pango-view pangocairo pangowin32 pango ${PANGO_LIBRARIES} ${PANGOWIN32_LIBRARIES} ${fontconfig_LIBRARIES} ${cairo_LIBRARIES}  ${harfbuzz_LIBRARIES} )