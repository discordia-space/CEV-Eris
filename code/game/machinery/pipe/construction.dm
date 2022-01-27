/obj/item/pipe
	name = "pipe"
	desc = "A pipe"
	var/pipe_type = 0
	//var/pipe_dir = 0
	var/pipename
	var/connect_types = CONNECT_TYPE_RE69ULAR
	force = 7
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "simple"
	item_state = "buildpipe"
	w_class = ITEM_SIZE_NORMAL
	level = ABOVE_PLATIN69_LEVEL

/obj/item/pipe/can_fall()
	var/turf/below = 69etBelow(69et_turf(src))
	var/pipe_below = istype(below)
	if(pipe_below)
		pipe_below = locate(/obj/machinery/atmospherics/pipe/zpipe/up) in below
	return !(anchored || pipe_below)

/obj/item/pipe/New(var/loc,69ar/pipe_type as num,69ar/dir as num,69ar/obj/machinery/atmospherics/make_from = null)
	..()
	if (make_from)
		src.set_dir(make_from.dir)
		src.pipename =69ake_from.name
		color =69ake_from.pipe_color
		var/is_bent
		if  (make_from.initialize_directions in list(NORTH|SOUTH, WEST|EAST))
			is_bent = 0
		else
			is_bent = 1
		if     (istype(make_from, /obj/machinery/atmospherics/pipe/simple/heat_exchan69in69/junction))
			src.pipe_type = PIPE_JUNCTION
			connect_types = CONNECT_TYPE_RE69ULAR|CONNECT_TYPE_HE
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/simple/heat_exchan69in69))
			src.pipe_type = PIPE_HE_STRAI69HT + is_bent
			connect_types = CONNECT_TYPE_HE
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/simple/insulated))
			src.pipe_type = PIPE_INSULATED_STRAI69HT + is_bent
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/simple/visible/supply) || istype(make_from, /obj/machinery/atmospherics/pipe/simple/hidden/supply))
			src.pipe_type = PIPE_SUPPLY_STRAI69HT + is_bent
			connect_types = CONNECT_TYPE_SUPPLY
			src.color = PIPE_COLOR_BLUE
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/simple/visible/scrubbers) || istype(make_from, /obj/machinery/atmospherics/pipe/simple/hidden/scrubbers))
			src.pipe_type = PIPE_SCRUBBERS_STRAI69HT + is_bent
			connect_types = CONNECT_TYPE_SCRUBBER
			src.color = PIPE_COLOR_RED
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/simple/visible/universal) || istype(make_from, /obj/machinery/atmospherics/pipe/simple/hidden/universal))
			src.pipe_type = PIPE_UNIVERSAL
			connect_types = CONNECT_TYPE_RE69ULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/simple))
			src.pipe_type = PIPE_SIMPLE_STRAI69HT + is_bent
		else if(istype(make_from, /obj/machinery/atmospherics/portables_connector))
			src.pipe_type = PIPE_CONNECTOR
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/manifold/visible/supply) || istype(make_from, /obj/machinery/atmospherics/pipe/manifold/hidden/supply))
			src.pipe_type = PIPE_SUPPLY_MANIFOLD
			connect_types = CONNECT_TYPE_SUPPLY
			src.color = PIPE_COLOR_BLUE
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/manifold/visible/scrubbers) || istype(make_from, /obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers))
			src.pipe_type = PIPE_SCRUBBERS_MANIFOLD
			connect_types = CONNECT_TYPE_SCRUBBER
			src.color = PIPE_COLOR_RED
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/manifold))
			src.pipe_type = PIPE_MANIFOLD
		else if(istype(make_from, /obj/machinery/atmospherics/unary/vent_pump))
			src.pipe_type = PIPE_UVENT
		else if(istype(make_from, /obj/machinery/atmospherics/valve))
			src.pipe_type = PIPE_MVALVE
		else if(istype(make_from, /obj/machinery/atmospherics/binary/pump/hi69h_power))
			src.pipe_type = PIPE_VOLUME_PUMP
		else if(istype(make_from, /obj/machinery/atmospherics/binary/pump))
			src.pipe_type = PIPE_PUMP
		else if(istype(make_from, /obj/machinery/atmospherics/trinary/filter/m_filter))
			src.pipe_type = PIPE_69AS_FILTER_M
		else if(istype(make_from, /obj/machinery/atmospherics/trinary/mixer/t_mixer))
			src.pipe_type = PIPE_69AS_MIXER_T
		else if(istype(make_from, /obj/machinery/atmospherics/trinary/mixer/m_mixer))
			src.pipe_type = PIPE_69AS_MIXER_M
		else if(istype(make_from, /obj/machinery/atmospherics/trinary/filter))
			src.pipe_type = PIPE_69AS_FILTER
		else if(istype(make_from, /obj/machinery/atmospherics/trinary/mixer))
			src.pipe_type = PIPE_69AS_MIXER
		else if(istype(make_from, /obj/machinery/atmospherics/unary/vent_scrubber))
			src.pipe_type = PIPE_SCRUBBER
		else if(istype(make_from, /obj/machinery/atmospherics/binary/passive_69ate))
			src.pipe_type = PIPE_PASSIVE_69ATE
		else if(istype(make_from, /obj/machinery/atmospherics/unary/heat_exchan69er))
			src.pipe_type = PIPE_HEAT_EXCHAN69E
		else if(istype(make_from, /obj/machinery/atmospherics/tvalve/mirrored))
			src.pipe_type = PIPE_MTVALVEM
		else if(istype(make_from, /obj/machinery/atmospherics/tvalve))
			src.pipe_type = PIPE_MTVALVE
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/manifold4w/visible/supply) || istype(make_from, /obj/machinery/atmospherics/pipe/manifold4w/hidden/supply))
			src.pipe_type = PIPE_SUPPLY_MANIFOLD4W
			connect_types = CONNECT_TYPE_SUPPLY
			src.color = PIPE_COLOR_BLUE
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/manifold4w/visible/scrubbers) || istype(make_from, /obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers))
			src.pipe_type = PIPE_SCRUBBERS_MANIFOLD4W
			connect_types = CONNECT_TYPE_SCRUBBER
			src.color = PIPE_COLOR_RED
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/manifold4w))
			src.pipe_type = PIPE_MANIFOLD4W
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/cap/visible/supply) || istype(make_from, /obj/machinery/atmospherics/pipe/cap/hidden/supply))
			src.pipe_type = PIPE_SUPPLY_CAP
			connect_types = CONNECT_TYPE_SUPPLY
			src.color = PIPE_COLOR_BLUE
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/cap/visible/scrubbers) || istype(make_from, /obj/machinery/atmospherics/pipe/cap/hidden/scrubbers))
			src.pipe_type = PIPE_SCRUBBERS_CAP
			connect_types = CONNECT_TYPE_SCRUBBER
			src.color = PIPE_COLOR_RED
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/cap))
			src.pipe_type = PIPE_CAP
		else if(istype(make_from, /obj/machinery/atmospherics/omni/mixer))
			src.pipe_type = PIPE_OMNI_MIXER
		else if(istype(make_from, /obj/machinery/atmospherics/omni/filter))
			src.pipe_type = PIPE_OMNI_FILTER
///// Z-Level stuff
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/zpipe/up/supply))
			src.pipe_type = PIPE_SUPPLY_UP
			connect_types = CONNECT_TYPE_SUPPLY
			src.color = PIPE_COLOR_BLUE
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/zpipe/up/scrubbers))
			src.pipe_type = PIPE_SCRUBBERS_UP
			connect_types = CONNECT_TYPE_SCRUBBER
			src.color = PIPE_COLOR_RED
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/zpipe/up))
			src.pipe_type = PIPE_UP
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/zpipe/down/supply))
			src.pipe_type = PIPE_SUPPLY_DOWN
			connect_types = CONNECT_TYPE_SUPPLY
			src.color = PIPE_COLOR_BLUE
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/zpipe/down/scrubbers))
			src.pipe_type = PIPE_SCRUBBERS_DOWN
			connect_types = CONNECT_TYPE_SCRUBBER
			src.color = PIPE_COLOR_RED
		else if(istype(make_from, /obj/machinery/atmospherics/pipe/zpipe/down))
			src.pipe_type = PIPE_DOWN
///// Z-Level stuff
	else
		src.pipe_type = pipe_type
		src.set_dir(dir)
		if (pipe_type == 29 || pipe_type == 30 || pipe_type == 33 || pipe_type == 35 || pipe_type == 37 || pipe_type == 39 || pipe_type == 41)
			connect_types = CONNECT_TYPE_SUPPLY
			src.color = PIPE_COLOR_BLUE
		else if (pipe_type == 31 || pipe_type == 32 || pipe_type == 34 || pipe_type == 36 || pipe_type == 38 || pipe_type == 40 || pipe_type == 42)
			connect_types = CONNECT_TYPE_SCRUBBER
			src.color = PIPE_COLOR_RED
		else if (pipe_type == 2 || pipe_type == 3)
			connect_types = CONNECT_TYPE_HE
		else if (pipe_type == 6)
			connect_types = CONNECT_TYPE_RE69ULAR|CONNECT_TYPE_HE
		else if (pipe_type == 28)
			connect_types = CONNECT_TYPE_RE69ULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER
	//src.pipe_dir = 69et_pipe_dir()
	update()
	src.pixel_x = rand(-5, 5)
	src.pixel_y = rand(-5, 5)

//update the name and icon of the pipe item dependin69 on the type

/obj/item/pipe/proc/update()
	var/list/nlist = list( \
		"pipe", \
		"bent pipe", \
		"h/e pipe", \
		"bent h/e pipe", \
		"connector", \
		"manifold", \
		"junction", \
		"uvent", \
		"mvalve", \
		"pump", \
		"scrubber", \
		"insulated pipe", \
		"bent insulated pipe", \
		"69as filter", \
		"69as69ixer", \
		"pressure re69ulator", \
		"hi69h power pump", \
		"heat exchan69er", \
		"t-valve", \
		"4-way69anifold", \
		"pipe cap", \
///// Z-Level stuff
		"pipe up", \
		"pipe down", \
///// Z-Level stuff
		"69as filter69", \
		"69as69ixer t", \
		"69as69ixer69", \
		"omni69ixer", \
		"omni filter", \
///// Supply and scrubbers pipes
		"universal pipe adapter", \
		"supply pipe", \
		"bent supply pipe", \
		"scrubbers pipe", \
		"bent scrubbers pipe", \
		"supply69anifold", \
		"scrubbers69anifold", \
		"supply 4-way69anifold", \
		"scrubbers 4-way69anifold", \
		"supply pipe up", \
		"scrubbers pipe up", \
		"supply pipe down", \
		"scrubbers pipe down", \
		"supply pipe cap", \
		"scrubbers pipe cap", \
		"t-valve69", \
	)
	name = nlist69pipe_type+169 + " fittin69"
	var/list/islist = list( \
		"simple", \
		"simple", \
		"he", \
		"he", \
		"connector", \
		"manifold", \
		"junction", \
		"uvent", \
		"mvalve", \
		"pump", \
		"scrubber", \
		"insulated", \
		"insulated", \
		"filter", \
		"mixer", \
		"passive69ate", \
		"volumepump", \
		"heunary", \
		"mtvalve", \
		"manifold4w", \
		"cap", \
///// Z-Level stuff
		"cap", \
		"cap", \
///// Z-Level stuff
		"m_filter", \
		"t_mixer", \
		"m_mixer", \
		"omni_mixer", \
		"omni_filter", \
///// Supply and scrubbers pipes
		"universal", \
		"simple", \
		"simple", \
		"simple", \
		"simple", \
		"manifold", \
		"manifold", \
		"manifold4w", \
		"manifold4w", \
		"cap", \
		"cap", \
		"cap", \
		"cap", \
		"cap", \
		"cap", \
		"mtvalvem", \
	)
	icon_state = islist69pipe_type + 169

//called when a turf is attacked with a pipe item
/obj/item/pipe/afterattack(turf/simulated/floor/tar69et,69ob/user, proximity)
	if(!proximity) return
	if(istype(tar69et))
		user.drop_from_inventory(src, tar69et)
	else
		return ..()

// rotate the pipe item clockwise

/obj/item/pipe/verb/rotate()
	set cate69ory = "Object"
	set name = "Rotate Pipe"
	set src in69iew(1)

	if ( usr.stat || usr.restrained() )
		return

	src.set_dir(turn(src.dir, -90))

	if (pipe_type in list (PIPE_SIMPLE_STRAI69HT, PIPE_SUPPLY_STRAI69HT, PIPE_SCRUBBERS_STRAI69HT, PIPE_UNIVERSAL, PIPE_HE_STRAI69HT, PIPE_INSULATED_STRAI69HT, PIPE_MVALVE))
		if(dir==2)
			set_dir(1)
		else if(dir==8)
			set_dir(4)
	else if (pipe_type in list (PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W))
		set_dir(2)
	//src.pipe_set_dir(69et_pipe_dir())
	return

/obj/item/pipe/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	. = ..()
	if ((pipe_type in list (PIPE_SIMPLE_BENT, PIPE_SUPPLY_BENT, PIPE_SCRUBBERS_BENT, PIPE_HE_BENT, PIPE_INSULATED_BENT)) \
		&& (src.dir in cardinal))
		src.set_dir(src.dir|turn(src.dir, 90))
	else if (pipe_type in list (PIPE_SIMPLE_STRAI69HT, PIPE_SUPPLY_STRAI69HT, PIPE_SCRUBBERS_STRAI69HT, PIPE_UNIVERSAL, PIPE_HE_STRAI69HT, PIPE_INSULATED_STRAI69HT, PIPE_MVALVE))
		if(dir==2)
			set_dir(1)
		else if(dir==8)
			set_dir(4)

// returns all pipe's endpoints

/obj/item/pipe/proc/69et_pipe_dir()
	if (!dir)
		return 0
	var/flip = turn(dir, 180)
	var/cw = turn(dir, -90)
	var/acw = turn(dir, 90)

	switch(pipe_type)
		if(	PIPE_SIMPLE_STRAI69HT, \
			PIPE_INSULATED_STRAI69HT, \
			PIPE_HE_STRAI69HT, \
			PIPE_JUNCTION ,\
			PIPE_PUMP ,\
			PIPE_VOLUME_PUMP ,\
			PIPE_PASSIVE_69ATE ,\
			PIPE_MVALVE, \
			PIPE_SUPPLY_STRAI69HT, \
			PIPE_SCRUBBERS_STRAI69HT, \
			PIPE_UNIVERSAL, \
		)
			return dir|flip
		if(PIPE_SIMPLE_BENT, PIPE_INSULATED_BENT, PIPE_HE_BENT, PIPE_SUPPLY_BENT, PIPE_SCRUBBERS_BENT)
			return dir //dir|acw
		if(PIPE_CONNECTOR,PIPE_UVENT,PIPE_SCRUBBER,PIPE_HEAT_EXCHAN69E)
			return dir
		if(PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W, PIPE_OMNI_MIXER, PIPE_OMNI_FILTER)
			return dir|flip|cw|acw
		if(PIPE_MANIFOLD, PIPE_SUPPLY_MANIFOLD, PIPE_SCRUBBERS_MANIFOLD)
			return flip|cw|acw
		if(PIPE_69AS_FILTER, PIPE_69AS_MIXER, PIPE_MTVALVE)
			return dir|flip|cw
		if(PIPE_69AS_FILTER_M, PIPE_69AS_MIXER_M, PIPE_MTVALVEM)
			return dir|flip|acw
		if(PIPE_69AS_MIXER_T)
			return dir|cw|acw
		if(PIPE_CAP, PIPE_SUPPLY_CAP, PIPE_SCRUBBERS_CAP)
			return dir
///// Z-Level stuff
		if(PIPE_UP,PIPE_DOWN,PIPE_SUPPLY_UP,PIPE_SUPPLY_DOWN,PIPE_SCRUBBERS_UP,PIPE_SCRUBBERS_DOWN)
			return dir
///// Z-Level stuff
	return 0

/obj/item/pipe/proc/69et_pdir() //endpoints for re69ular pipes

	var/flip = turn(dir, 180)
//	var/cw = turn(dir, -90)
//	var/acw = turn(dir, 90)

	if (!(pipe_type in list(PIPE_HE_STRAI69HT, PIPE_HE_BENT, PIPE_JUNCTION)))
		return 69et_pipe_dir()
	switch(pipe_type)
		if(PIPE_HE_STRAI69HT,PIPE_HE_BENT)
			return 0
		if(PIPE_JUNCTION)
			return flip
	return 0

// return the h_dir (heat-exchan69e pipes) from the type and the dir

/obj/item/pipe/proc/69et_hdir() //endpoints for h/e pipes

//	var/flip = turn(dir, 180)
//	var/cw = turn(dir, -90)

	switch(pipe_type)
		if(PIPE_HE_STRAI69HT)
			return 69et_pipe_dir()
		if(PIPE_HE_BENT)
			return 69et_pipe_dir()
		if(PIPE_JUNCTION)
			return dir
		else
			return 0

/obj/item/pipe/attack_self(mob/user as69ob)
	return rotate()

/obj/item/pipe/attackby(var/obj/item/W as obj,69ar/mob/user as69ob)
	..()
	//*
	var/obj/item/tool/tool = W
	if (!tool)
		return ..()
	if (!tool.has_69uality(69UALITY_BOLT_TURNIN69))
		return ..()
	if (!tool.check_tool_effects(WORKTIME_NEAR_INSTANT))
		return ..()
	if (!isturf(src.loc))
		return 1
	if (pipe_type in list (PIPE_SIMPLE_STRAI69HT, PIPE_SUPPLY_STRAI69HT, PIPE_SCRUBBERS_STRAI69HT, PIPE_HE_STRAI69HT, PIPE_INSULATED_STRAI69HT, PIPE_MVALVE))
		if(dir==2)
			set_dir(1)
		else if(dir==8)
			set_dir(4)
	else if (pipe_type in list(PIPE_MANIFOLD4W, PIPE_SUPPLY_MANIFOLD4W, PIPE_SCRUBBERS_MANIFOLD4W, PIPE_OMNI_MIXER, PIPE_OMNI_FILTER))
		set_dir(2)
	var/pipe_dir = 69et_pipe_dir()

	for(var/obj/machinery/atmospherics/M in src.loc)
		if((M.initialize_directions & pipe_dir) &&69.check_connect_types_construction(M,src))	//69atches at least one direction on either type of pipe & same connection type
			to_chat(user, SPAN_WARNIN69("There is already a pipe of the same type at this location."))
			return 1
	// no conflicts found

	var/pipefailtext = SPAN_WARNIN69("There's nothin69 to connect this pipe section to!") //(with how the pipe code works, at least one end needs to be connected to somethin69, otherwise the 69ame deletes the se69ment)"

	//TODO:69ove all of this stuff into the69arious pipe constructors.
	switch(pipe_type)
		if(PIPE_SIMPLE_STRAI69HT, PIPE_SIMPLE_BENT)
			var/obj/machinery/atmospherics/pipe/simple/P = new( src.loc )
			P.pipe_color = color
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			if (69DELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_SUPPLY_STRAI69HT, PIPE_SUPPLY_BENT)
			var/obj/machinery/atmospherics/pipe/simple/hidden/supply/P = new( src.loc )
			P.color = color
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			if (69DELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_SCRUBBERS_STRAI69HT, PIPE_SCRUBBERS_BENT)
			var/obj/machinery/atmospherics/pipe/simple/hidden/scrubbers/P = new( src.loc )
			P.color = color
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			if (69DELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_UNIVERSAL)
			var/obj/machinery/atmospherics/pipe/simple/hidden/universal/P = new( src.loc )
			P.color = color
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			if (69DELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_HE_STRAI69HT, PIPE_HE_BENT)
			var/obj/machinery/atmospherics/pipe/simple/heat_exchan69in69/P = new ( src.loc )
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir //this69ar it's used to know if the pipe is bent or not
			P.initialize_directions_he = pipe_dir
			P.atmos_init()
			if (69DELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_CONNECTOR)		// connector
			var/obj/machinery/atmospherics/portables_connector/C = new( src.loc )
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			if (pipename)
				C.name = pipename
			var/turf/T = C.loc
			C.level = !T.is_platin69() ? 2 : 1
			C.atmos_init()
			C.build_network()
			if (C.node)
				C.node.atmos_init()
				C.node.build_network()


		if(PIPE_MANIFOLD)		//manifold
			var/obj/machinery/atmospherics/pipe/manifold/M = new( src.loc )
			M.pipe_color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			//M.New()
			var/turf/T =69.loc
			M.level = !T.is_platin69() ? 2 : 1
			M.atmos_init()
			if (69DELETED(M))
				to_chat(usr, pipefailtext)
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()

		if(PIPE_SUPPLY_MANIFOLD)		//manifold
			var/obj/machinery/atmospherics/pipe/manifold/hidden/supply/M = new( src.loc )
			M.color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			//M.New()
			var/turf/T =69.loc
			M.level = !T.is_platin69() ? 2 : 1
			M.atmos_init()
			if (!M)
				to_chat(usr, "There's nothin69 to connect this69anifold to! (with how the pipe code works, at least one end needs to be connected to somethin69, otherwise the 69ame deletes the se69ment)")
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()

		if(PIPE_SCRUBBERS_MANIFOLD)		//manifold
			var/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers/M = new( src.loc )
			M.color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			//M.New()
			var/turf/T =69.loc
			M.level = !T.is_platin69() ? 2 : 1
			M.atmos_init()
			if (!M)
				to_chat(usr, "There's nothin69 to connect this69anifold to! (with how the pipe code works, at least one end needs to be connected to somethin69, otherwise the 69ame deletes the se69ment)")
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()

		if(PIPE_MANIFOLD4W)		//4-way69anifold
			var/obj/machinery/atmospherics/pipe/manifold4w/M = new( src.loc )
			M.pipe_color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			//M.New()
			var/turf/T =69.loc
			M.level = !T.is_platin69() ? 2 : 1
			M.atmos_init()
			if (69DELETED(M))
				to_chat(usr, pipefailtext)
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()
			if (M.node4)
				M.node4.atmos_init()
				M.node4.build_network()

		if(PIPE_SUPPLY_MANIFOLD4W)		//4-way69anifold
			var/obj/machinery/atmospherics/pipe/manifold4w/hidden/supply/M = new( src.loc )
			M.color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			M.connect_types = src.connect_types
			//M.New()
			var/turf/T =69.loc
			M.level = !T.is_platin69() ? 2 : 1
			M.atmos_init()
			if (!M)
				to_chat(usr, "There's nothin69 to connect this69anifold to! (with how the pipe code works, at least one end needs to be connected to somethin69, otherwise the 69ame deletes the se69ment)")
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()
			if (M.node4)
				M.node4.atmos_init()
				M.node4.build_network()

		if(PIPE_SCRUBBERS_MANIFOLD4W)		//4-way69anifold
			var/obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers/M = new( src.loc )
			M.color = color
			M.set_dir(dir)
			M.initialize_directions = pipe_dir
			M.connect_types = src.connect_types
			//M.New()
			var/turf/T =69.loc
			M.level = !T.is_platin69() ? 2 : 1
			M.atmos_init()
			if (!M)
				to_chat(usr, "There's nothin69 to connect this69anifold to! (with how the pipe code works, at least one end needs to be connected to somethin69, otherwise the 69ame deletes the se69ment)")
				return 1
			M.build_network()
			if (M.node1)
				M.node1.atmos_init()
				M.node1.build_network()
			if (M.node2)
				M.node2.atmos_init()
				M.node2.build_network()
			if (M.node3)
				M.node3.atmos_init()
				M.node3.build_network()
			if (M.node4)
				M.node4.atmos_init()
				M.node4.build_network()

		if(PIPE_JUNCTION)
			var/obj/machinery/atmospherics/pipe/simple/heat_exchan69in69/junction/P = new ( src.loc )
			P.set_dir(src.dir)
			P.initialize_directions = src.69et_pdir()
			P.initialize_directions_he = src.69et_hdir()
			P.atmos_init()
			if (69DELETED(P))
				to_chat(usr, pipefailtext) //"There's nothin69 to connect this pipe to! (with how the pipe code works, at least one end needs to be connected to somethin69, otherwise the 69ame deletes the se69ment)")
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_UVENT)		//unary69ent
			var/obj/machinery/atmospherics/unary/vent_pump/V = new( src.loc )
			V.set_dir(dir)
			V.initialize_directions = pipe_dir
			if (pipename)
				V.name = pipename
			var/turf/T =69.loc
			V.level = !T.is_platin69() ? 2 : 1
			V.atmos_init()
			V.build_network()
			if (V.node1)
				V.node1.atmos_init()
				V.node1.build_network()


		if(PIPE_MVALVE)		//manual69alve
			var/obj/machinery/atmospherics/valve/V = new( src.loc)
			V.set_dir(dir)
			V.initialize_directions = pipe_dir
			if (pipename)
				V.name = pipename
			var/turf/T =69.loc
			V.level = !T.is_platin69() ? 2 : 1
			V.atmos_init()
			V.build_network()
			if (V.node1)
//					world << "69V.node1.name69 is connected to69alve, forcin69 it to update its nodes."
				V.node1.atmos_init()
				V.node1.build_network()
			if (V.node2)
//					world << "69V.node2.name69 is connected to69alve, forcin69 it to update its nodes."
				V.node2.atmos_init()
				V.node2.build_network()

		if(PIPE_PUMP)		//69as pump
			var/obj/machinery/atmospherics/binary/pump/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_69AS_FILTER)		//69as filter
			var/obj/machinery/atmospherics/trinary/filter/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
			if (P.node3)
				P.node3.atmos_init()
				P.node3.build_network()

		if(PIPE_69AS_MIXER)		//69as69ixer
			var/obj/machinery/atmospherics/trinary/mixer/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
			if (P.node3)
				P.node3.atmos_init()
				P.node3.build_network()

		if(PIPE_69AS_FILTER_M)		//69as filter69irrored
			var/obj/machinery/atmospherics/trinary/filter/m_filter/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
			if (P.node3)
				P.node3.atmos_init()
				P.node3.build_network()

		if(PIPE_69AS_MIXER_T)		//69as69ixer-t
			var/obj/machinery/atmospherics/trinary/mixer/t_mixer/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
			if (P.node3)
				P.node3.atmos_init()
				P.node3.build_network()

		if(PIPE_69AS_MIXER_M)		//69as69ixer69irrored
			var/obj/machinery/atmospherics/trinary/mixer/m_mixer/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
			if (P.node3)
				P.node3.atmos_init()
				P.node3.build_network()

		if(PIPE_SCRUBBER)		//scrubber
			var/obj/machinery/atmospherics/unary/vent_scrubber/S = new(src.loc)
			S.set_dir(dir)
			S.initialize_directions = pipe_dir
			if (pipename)
				S.name = pipename
			var/turf/T = S.loc
			S.level = !T.is_platin69() ? 2 : 1
			S.atmos_init()
			S.build_network()
			if (S.node1)
				S.node1.atmos_init()
				S.node1.build_network()

		if(PIPE_INSULATED_STRAI69HT, PIPE_INSULATED_BENT)
			var/obj/machinery/atmospherics/pipe/simple/insulated/P = new( src.loc )
			P.set_dir(src.dir)
			P.initialize_directions = pipe_dir
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			if (69DELETED(P))
				to_chat(usr, pipefailtext)
				return 1
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_MTVALVE)		//manual t-valve
			var/obj/machinery/atmospherics/tvalve/V = new(src.loc)
			V.set_dir(dir)
			V.initialize_directions = pipe_dir
			if (pipename)
				V.name = pipename
			var/turf/T =69.loc
			V.level = !T.is_platin69() ? 2 : 1
			V.atmos_init()
			V.build_network()
			if (V.node1)
				V.node1.atmos_init()
				V.node1.build_network()
			if (V.node2)
				V.node2.atmos_init()
				V.node2.build_network()
			if (V.node3)
				V.node3.atmos_init()
				V.node3.build_network()

		if(PIPE_MTVALVEM)		//manual t-valve
			var/obj/machinery/atmospherics/tvalve/mirrored/V = new(src.loc)
			V.set_dir(dir)
			V.initialize_directions = pipe_dir
			if (pipename)
				V.name = pipename
			var/turf/T =69.loc
			V.level = !T.is_platin69() ? 2 : 1
			V.atmos_init()
			V.build_network()
			if (V.node1)
				V.node1.atmos_init()
				V.node1.build_network()
			if (V.node2)
				V.node2.atmos_init()
				V.node2.build_network()
			if (V.node3)
				V.node3.atmos_init()
				V.node3.build_network()

		if(PIPE_CAP)
			var/obj/machinery/atmospherics/pipe/cap/C = new(src.loc)
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			C.atmos_init()
			C.build_network()
			if(C.node)
				C.node.atmos_init()
				C.node.build_network()

		if(PIPE_SUPPLY_CAP)
			var/obj/machinery/atmospherics/pipe/cap/hidden/supply/C = new(src.loc)
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			C.atmos_init()
			C.build_network()
			if(C.node)
				C.node.atmos_init()
				C.node.build_network()

		if(PIPE_SCRUBBERS_CAP)
			var/obj/machinery/atmospherics/pipe/cap/hidden/scrubbers/C = new(src.loc)
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			C.atmos_init()
			C.build_network()
			if(C.node)
				C.node.atmos_init()
				C.node.build_network()

		if(PIPE_PASSIVE_69ATE)		//passive 69ate
			var/obj/machinery/atmospherics/binary/passive_69ate/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_VOLUME_PUMP)		//volume pump
			var/obj/machinery/atmospherics/binary/pump/hi69h_power/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()

		if(PIPE_HEAT_EXCHAN69E)		// heat exchan69er
			var/obj/machinery/atmospherics/unary/heat_exchan69er/C = new( src.loc )
			C.set_dir(dir)
			C.initialize_directions = pipe_dir
			if (pipename)
				C.name = pipename
			var/turf/T = C.loc
			C.level = !T.is_platin69() ? 2 : 1
			C.atmos_init()
			C.build_network()
			if (C.node1)
				C.node1.atmos_init()
				C.node1.build_network()
///// Z-Level stuff
		if(PIPE_UP)
			var/obj/machinery/atmospherics/pipe/zpipe/up/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_DOWN)
			var/obj/machinery/atmospherics/pipe/zpipe/down/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_SUPPLY_UP)
			var/obj/machinery/atmospherics/pipe/zpipe/up/supply/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_SUPPLY_DOWN)
			var/obj/machinery/atmospherics/pipe/zpipe/down/supply/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_SCRUBBERS_UP)
			var/obj/machinery/atmospherics/pipe/zpipe/up/scrubbers/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
		if(PIPE_SCRUBBERS_DOWN)
			var/obj/machinery/atmospherics/pipe/zpipe/down/scrubbers/P = new(src.loc)
			P.set_dir(dir)
			P.initialize_directions = pipe_dir
			if (pipename)
				P.name = pipename
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
			if (P.node1)
				P.node1.atmos_init()
				P.node1.build_network()
			if (P.node2)
				P.node2.atmos_init()
				P.node2.build_network()
///// Z-Level stuff
		if(PIPE_OMNI_MIXER)
			var/obj/machinery/atmospherics/omni/mixer/P = new(loc)
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
		if(PIPE_OMNI_FILTER)
			var/obj/machinery/atmospherics/omni/filter/P = new(loc)
			var/turf/T = P.loc
			P.level = !T.is_platin69() ? 2 : 1
			P.atmos_init()
			P.build_network()
	// there was some code, but it is handled in ../tool/ now.
	W.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_BOLT_TURNIN69, FAILCHANCE_ZERO, re69uired_stat = STAT_MEC)
	69del(src)	// remove the pipe item

	return
	 //TODO: DEFERRED

// ensure that setterm() is called for a newly connected pipeline



/obj/item/pipe_meter
	name = "meter"
	desc = "A69eter that can be laid on pipes"
	icon = 'icons/obj/pipe-item.dmi'
	icon_state = "meter"
	item_state = "buildpipe"
	w_class = ITEM_SIZE_BULKY

/obj/item/pipe_meter/attackby(var/obj/item/W as obj,69ar/mob/user as69ob)
	..()

	var/obj/item/tool/tool = W
	if (!tool)
		return ..()
	if (!tool.has_69uality(69UALITY_BOLT_TURNIN69))
		return ..()
	if (!tool.check_tool_effects(WORKTIME_NEAR_INSTANT))
		return ..()
	if(!locate(/obj/machinery/atmospherics/pipe, src.loc))
		to_chat(user, SPAN_WARNIN69("You need to fasten it to a pipe"))
		return 1
	new/obj/machinery/meter( src.loc )
	W.use_tool(user, src, WORKTIME_NEAR_INSTANT, 69UALITY_BOLT_TURNIN69, FAILCHANCE_ZERO, re69uired_stat = STAT_MEC)
	69del(src)