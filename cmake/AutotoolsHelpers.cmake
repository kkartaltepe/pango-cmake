function(add_autotools_config inconfig outconfig)
	set(IR_FILE "${CMAKE_CURRENT_BINARY_DIR}/${outconfig}.cmake.in")
	file(READ ${inconfig} CONFIG_TEXT)
	STRING(REGEX REPLACE "#undef (HAVE[^\n]+)" # Set or undef entirely for HAVE variables.
           "#cmakedefine \\1" CONFIG_TEXT
	       ${CONFIG_TEXT})
	STRING(REGEX REPLACE "#undef ([^\n]+)"
           "#define \\1 \${\\1}" CONFIG_TEXT  # Doesnt hold for STDC_HEADERS. Plz dont try to compiler if you dont have normal C
	       ${CONFIG_TEXT})
	file(WRITE "${IR_FILE}" "${CONFIG_TEXT}")
	configure_file("${IR_FILE}" "${outconfig}")
endfunction()