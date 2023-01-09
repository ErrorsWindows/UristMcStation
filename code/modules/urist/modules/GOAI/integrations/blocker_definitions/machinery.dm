# ifdef GOAI_SS13_SUPPORT

// MACHINERY

/obj/machinery
	blocker_gen_enabled = TRUE

/obj/machinery/GenerateBlocker()
	return GenerateGenericFullBlocker(src)

/obj/machinery/artifact
	blocker_gen_enabled = TRUE

/obj/machinery/artifact/GenerateBlocker()
	return GenerateGenericFullBlocker(src)


/obj/machinery/artifact_analyser
	blocker_gen_enabled = TRUE

/obj/machinery/artifact_analyser/GenerateBlocker()
	return GenerateGenericFullBlocker(src)


/obj/machinery/artifact_harvester
	blocker_gen_enabled = TRUE

/obj/machinery/artifact_harvester/GenerateBlocker()
	return GenerateGenericFullBlocker(src)


/obj/machinery/artillerycontrol
	blocker_gen_enabled = TRUE

/obj/machinery/artillerycontrol/GenerateBlocker()
	return GenerateGenericFullBlocker(src)


/obj/machinery/autolathe
	blocker_gen_enabled = TRUE

/obj/machinery/autolathe/GenerateBlocker()
	return GenerateGenericFullBlocker(src)


/obj/machinery/beehive
	blocker_gen_enabled = TRUE

/obj/machinery/beehive/GenerateBlocker()
	return GenerateGenericFullBlocker(src)


/obj/machinery/biogenerator
	blocker_gen_enabled = TRUE

/obj/machinery/biogenerator/GenerateBlocker()
	return GenerateGenericFullBlocker(src)


/obj/machinery/bodyscanner
	blocker_gen_enabled = TRUE

/obj/machinery/bodyscanner/GenerateBlocker()
	return GenerateGenericFullBlocker(src)

/obj/machinery/door/GenerateBlocker()
	return GenerateDynamicFullBlocker(src)

/obj/machinery/door/UpdateBlocker()
	return UpdateDynamicFullBlocker(src)

/obj/machinery/door/window/GenerateBlocker()
	return GenerateDynamicDirBlocker(src)

/obj/machinery/door/window/UpdateBlocker()
	return UpdateDynamicDirBlocker(src)

# endif