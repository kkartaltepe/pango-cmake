# templatec: The name of the c/cpp template to use 
# templateh: The name of the header template to use 
# outputname: Destination of the template files (will have .c/.h appended)
# ARGN: A list of headers to use in generating the glib enums
macro(add_glib_enumtypes templateh templatec outputname)
  find_package(GLIB-MKENUMS REQUIRED)

  add_custom_command(
    OUTPUT "${outputname}.h"
    COMMAND perl ${GLIB-MKENUMS_EXECUTABLE} --template ${templateh} --output ${outputname}.h ${ARGN}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${ARGN}
  )

  add_custom_command(
    OUTPUT "${outputname}.c"
    COMMAND perl ${GLIB-MKENUMS_EXECUTABLE} --template ${templatec} --output ${outputname}.c ${ARGN}
    WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    DEPENDS ${ARGN} "${outputname}.h"
  )
endmacro(add_glib_enumtypes)
