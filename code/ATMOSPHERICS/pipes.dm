/obj/machinery/atmospherics/pipe

	var/datum/69as_mixture/air_temporary // used when reconstructin69 a pipeline that broke
	var/datum/pipeline/parent
	var/volume = 0

	layer = 69AS_PIPE_HIDDEN_LAYER
	use_power =69O_POWER_USE

	var/alert_pressure = 80*ONE_ATMOSPHERE
		//minimum pressure before check_pressure(...) should be called

	can_buckle = TRUE
	buckle_require_restraints = 1
	buckle_lyin69 = -1

/obj/machinery/atmospherics/pipe/drain_power()
	return -1

/obj/machinery/atmospherics/pipe/New()
	if(istype(69et_turf(src), /turf/simulated/wall) || istype(69et_turf(src), /turf/simulated/shuttle/wall) || istype(69et_turf(src), /turf/unsimulated/wall))
		level = BELOW_PLATIN69_LEVEL
	..()

/obj/machinery/atmospherics/pipe/hides_under_floorin69()
	return level != 2

/obj/machinery/atmospherics/pipe/proc/pipeline_expansion()
	return69ull

/obj/machinery/atmospherics/pipe/proc/check_pressure(pressure)
	//Return 1 if parent should continue checkin69 other pipes
	//Return69ull if parent should stop checkin69 other pipes. Recall: qdel(src) will by default return69ull

	return 1

/obj/machinery/atmospherics/pipe/return_air()
	if(!parent)
		parent =69ew /datum/pipeline()
		parent.build_pipeline(src)

	return parent.air

/obj/machinery/atmospherics/pipe/build_network()
	if(!parent)
		parent =69ew /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network()

/obj/machinery/atmospherics/pipe/network_expand(datum/pipe_network/new_network, obj/machinery/atmospherics/pipe/reference)
	if(!parent)
		parent =69ew /datum/pipeline()
		parent.build_pipeline(src)

	return parent.network_expand(new_network, reference)

/obj/machinery/atmospherics/pipe/return_network(obj/machinery/atmospherics/reference)
	if(!parent)
		parent =69ew /datum/pipeline()
		parent.build_pipeline(src)

	return parent.return_network(reference)

/obj/machinery/atmospherics/pipe/Destroy()
	QDEL_NULL(parent)
	if(air_temporary)
		loc.assume_air(air_temporary)
		QDEL_NULL(air_temporary)

	. = ..()

/obj/machinery/atmospherics/pipe/attackby(obj/item/I,69ob/user)
	if (istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()
	if (istype(src, /obj/machinery/atmospherics/pipe/vent))
		return ..()

	if(istype(I,/obj/item/device/pipe_painter))
		return 0
	var/turf/T = src.loc
	if (level==1 && isturf(T) && !T.is_platin69())
		to_chat(user, SPAN_WARNIN69("You69ust remove the platin69 first."))
		return 1

	if(QUALITY_BOLT_TURNIN69 in I.tool_qualities)
		var/datum/69as_mixture/int_air = return_air()
		var/datum/69as_mixture/env_air = loc.return_air()
		if ((int_air.return_pressure()-env_air.return_pressure()) > 4*ONE_ATMOSPHERE)
			to_chat(user, SPAN_WARNIN69("You cannot unwrench \the 69src69, it is too exerted due to internal pressure."))
			add_fin69erprint(user)
			return 1

		to_chat(user, SPAN_NOTICE("You be69in to unfasten \the 69src69..."))
		if(I.use_tool(user, src, WORKTIME_FAST, QUALITY_BOLT_TURNIN69, FAILCHANCE_EASY, required_stat = STAT_MEC))
			user.visible_messa69e( \
				SPAN_NOTICE("\The 69user69 unfastens \the 69src69."), \
				SPAN_NOTICE("You have unfastened \the 69src69."), \
				"You hear a ratchet.")
			investi69ate_lo69("was unfastened by 69key_name(user)69", "atmos")
			new /obj/item/pipe(loc,69ake_from=src)
			for (var/obj/machinery/meter/meter in T)
				if (meter.tar69et == src)
					new /obj/item/pipe_meter(T)
					qdel(meter)
			qdel(src)

/obj/machinery/atmospherics/proc/chan69e_color(var/new_color)
	//only pass69alid pipe colors please ~otherwise your pipe will turn invisible
	if(!pipe_color_check(new_color))
		return

	pipe_color =69ew_color
	update_icon()

/*
/obj/machinery/atmospherics/pipe/add_underlay(var/obj/machinery/atmospherics/node,69ar/direction)
	if(istype(src, /obj/machinery/atmospherics/pipe/tank))	//todo:69ove tanks to unary devices
		return ..()

	if(node)
		var/temp_dir = 69et_dir(src,69ode)
		underlays += icon_mana69er.69et_atmos_icon("pipe_underlay_intact", temp_dir, color_cache_name(node))
		return temp_dir
	else if(direction)
		underlays += icon_mana69er.69et_atmos_icon("pipe_underlay_exposed", direction, pipe_color)
	else
		return69ull
*/

/obj/machinery/atmospherics/pipe/color_cache_name(var/obj/machinery/atmospherics/node)
	if(istype(src, /obj/machinery/atmospherics/pipe/tank))
		return ..()

	if(istype(node, /obj/machinery/atmospherics/pipe/manifold) || istype(node, /obj/machinery/atmospherics/pipe/manifold4w))
		if(pipe_color ==69ode.pipe_color)
			return69ode.pipe_color
		else
			return69ull
	else if(istype(node, /obj/machinery/atmospherics/pipe/simple))
		return69ode.pipe_color
	else
		return pipe_color

/obj/machinery/atmospherics/pipe/simple
	icon = 'icons/atmos/pipes.dmi'
	icon_state = ""
	var/pipe_icon = "" //what kind of pipe it is and from which dmi is the icon69ana69er 69ettin69 its icons, "" for simple pipes, "hepipe" for HE pipes, "hejunction" for HE junctions
	name = "pipe"
	desc = "A one69eter section of re69ular pipe"

	volume = ATMOS_DEFAULT_VOLUME_PIPE

	dir = SOUTH
	initialize_directions = SOUTH|NORTH

	var/minimum_temperature_difference = 300
	var/thermal_conductivity = 0 //WALL_HEAT_TRANSFER_COEFFICIENT69o

	var/maximum_pressure = 70*ONE_ATMOSPHERE
	var/fati69ue_pressure = 55*ONE_ATMOSPHERE
	alert_pressure = 55*ONE_ATMOSPHERE

	level = BELOW_PLATIN69_LEVEL

/obj/machinery/atmospherics/pipe/simple/New()
	..()

	// Pipe colors and icon states are handled by an ima69e cache - so color and icon should
	//  be69ull. For69appin69 purposes color is defined in the object definitions.
	icon =69ull
	alpha = 255

	switch(dir)
		if(SOUTH ||69ORTH)
			initialize_directions = SOUTH|NORTH
		if(EAST || WEST)
			initialize_directions = EAST|WEST
		if(NORTHEAST)
			initialize_directions =69ORTH|EAST
		if(NORTHWEST)
			initialize_directions =69ORTH|WEST
		if(SOUTHEAST)
			initialize_directions = SOUTH|EAST
		if(SOUTHWEST)
			initialize_directions = SOUTH|WEST

/obj/machinery/atmospherics/pipe/simple/hide(var/i)
	if(istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/atmospherics/pipe/simple/Process()
	if(!parent) //This should cut back on the overhead callin69 build_network thousands of times per cycle
		..()
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/simple/check_pressure(pressure)
	var/datum/69as_mixture/environment = loc.return_air()

	var/pressure_difference = pressure - environment.return_pressure()

	if(pressure_difference >69aximum_pressure)
		burst()

	else if(pressure_difference > fati69ue_pressure)
		//TODO: leak to turf, doin69 pfshhhhh
		if(prob(5))
			burst()

	else return 1

/obj/machinery/atmospherics/pipe/simple/proc/burst()
	src.visible_messa69e(SPAN_DAN69ER("\The 69src69 bursts!"));
	playsound(src.loc, 'sound/effects/ban69.o6969', 25, 1)
	var/datum/effect/effect/system/smoke_spread/smoke =69ew
	smoke.set_up(1, 0, src.loc, 0)
	smoke.start()
	qdel(src)

/obj/machinery/atmospherics/pipe/simple/proc/normalize_dir()
	if(dir==3)
		set_dir(1)
	else if(dir==12)
		set_dir(4)

/obj/machinery/atmospherics/pipe/simple/Destroy()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)

	. = ..()

/obj/machinery/atmospherics/pipe/simple/pipeline_expansion()
	return list(node1,69ode2)

/obj/machinery/atmospherics/pipe/simple/chan69e_color(var/new_color)
	..()
	//for updatin69 connected atmos device pipes (i.e.69ents,69anifolds, etc)
	if(node1)
		node1.update_underlays()
	if(node2)
		node2.update_underlays()

/obj/machinery/atmospherics/pipe/simple/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()

	if(!node1 && !node2)
		var/turf/T = 69et_turf(src)
		new /obj/item/pipe(loc,69ake_from=src)
		for (var/obj/machinery/meter/meter in T)
			if (meter.tar69et == src)
				new /obj/item/pipe_meter(T)
				qdel(meter)
		qdel(src)
	else if(node1 &&69ode2)
		overlays += icon_mana69er.69et_atmos_icon("pipe", , pipe_color, "69pipe_icon69intact69icon_connect_type69")
	else
		overlays += icon_mana69er.69et_atmos_icon("pipe", , pipe_color, "69pipe_icon69exposed69node1?1:06969node2?1:06969icon_connect_type69")

/obj/machinery/atmospherics/pipe/simple/update_underlays()
	return

/obj/machinery/atmospherics/pipe/simple/atmos_init()
	normalize_dir()
	var/node1_dir
	var/node2_dir

	for(var/direction in cardinal)
		if(direction&initialize_directions)
			if (!node1_dir)
				node1_dir = direction
			else if (!node2_dir)
				node2_dir = direction

	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src,69ode1_dir))
		if(tar69et.initialize_directions & 69et_dir(tar69et, src))
			if (check_connect_types(tar69et, src))
				node1 = tar69et
				break
	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src,69ode2_dir))
		if(tar69et.initialize_directions & 69et_dir(tar69et, src))
			if (check_connect_types(tar69et, src))
				node2 = tar69et
				break

	if(!node1 && !node2)
		qdel(src)
		return

	var/turf/T = loc
	if(level == BELOW_PLATIN69_LEVEL && !T.is_platin69()) hide(1)
	update_icon()

/obj/machinery/atmospherics/pipe/simple/disconnect(obj/machinery/atmospherics/reference)
	if(reference ==69ode1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 =69ull

	if(reference ==69ode2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node2 =69ull

	update_icon()

	return69ull

/obj/machinery/atmospherics/pipe/simple/visible
	icon_state = "intact"
	level = ABOVE_PLATIN69_LEVEL
	layer = 69AS_PIPE_VISIBLE_LAYER

/obj/machinery/atmospherics/pipe/simple/visible/scrubbers
	name = "Scrubbers pipe"
	desc = "A one69eter section of scrubbers pipe"
	icon_state = "intact-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/supply
	name = "Air supply pipe"
	desc = "A one69eter section of supply pipe"
	icon_state = "intact-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/visible/69reen
	color = PIPE_COLOR_69REEN

/obj/machinery/atmospherics/pipe/simple/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/simple/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/hidden
	icon_state = "intact"
	layer = 69AS_PIPE_HIDDEN_LAYER
	level = BELOW_PLATIN69_LEVEL
	alpha = 128		//set for the benefit of69appin69 - this is reset to opaque when the pipe is spawned in 69ame

/obj/machinery/atmospherics/pipe/simple/hidden/scrubbers
	name = "Scrubbers pipe"
	desc = "A one69eter section of scrubbers pipe"
	icon_state = "intact-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/supply
	name = "Air supply pipe"
	desc = "A one69eter section of supply pipe"
	icon_state = "intact-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/simple/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/simple/hidden/69reen
	color = PIPE_COLOR_69REEN

/obj/machinery/atmospherics/pipe/simple/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/simple/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/simple/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/simple/insulated
	icon = 'icons/obj/atmospherics/red_pipe.dmi'
	icon_state = "intact"

	minimum_temperature_difference = 10000
	thermal_conductivity = 0
	maximum_pressure = 1000*ONE_ATMOSPHERE
	fati69ue_pressure = 900*ONE_ATMOSPHERE
	alert_pressure = 900*ONE_ATMOSPHERE

	level = ABOVE_PLATIN69_LEVEL


/obj/machinery/atmospherics/pipe/manifold
	icon = 'icons/atmos/manifold.dmi'
	icon_state = ""
	name = "pipe69anifold"
	desc = "A69anifold composed of re69ular pipes"

	volume = ATMOS_DEFAULT_VOLUME_PIPE * 1.5

	dir = SOUTH
	initialize_directions = EAST|NORTH|WEST

	var/obj/machinery/atmospherics/node3

	level = BELOW_PLATIN69_LEVEL
	layer = 69AS_PIPE_VISIBLE_LAYER

/obj/machinery/atmospherics/pipe/manifold/New()
	..()
	alpha = 255
	icon =69ull

	switch(dir)
		if(NORTH)
			initialize_directions = EAST|SOUTH|WEST
		if(SOUTH)
			initialize_directions = WEST|NORTH|EAST
		if(EAST)
			initialize_directions = SOUTH|WEST|NORTH
		if(WEST)
			initialize_directions =69ORTH|EAST|SOUTH

/obj/machinery/atmospherics/pipe/manifold/hide(var/i)
	if(istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/atmospherics/pipe/manifold/pipeline_expansion()
	return list(node1,69ode2,69ode3)

/obj/machinery/atmospherics/pipe/manifold/Process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/manifold/Destroy()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)
	if(node3)
		node3.disconnect(src)

	. = ..()

/obj/machinery/atmospherics/pipe/manifold/disconnect(obj/machinery/atmospherics/reference)
	if(reference ==69ode1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 =69ull

	if(reference ==69ode2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node2 =69ull

	if(reference ==69ode3)
		if(istype(node3, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node3 =69ull

	update_icon()

	..()

/obj/machinery/atmospherics/pipe/manifold/chan69e_color(var/new_color)
	..()
	//for updatin69 connected atmos device pipes (i.e.69ents,69anifolds, etc)
	if(node1)
		node1.update_underlays()
	if(node2)
		node2.update_underlays()
	if(node3)
		node3.update_underlays()

/obj/machinery/atmospherics/pipe/manifold/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	if(!node1 && !node2 && !node3)
		var/turf/T = 69et_turf(src)
		new /obj/item/pipe(loc,69ake_from=src)
		for (var/obj/machinery/meter/meter in T)
			if (meter.tar69et == src)
				new /obj/item/pipe_meter(T)
				qdel(meter)
		qdel(src)
	else
		overlays.Cut()
		overlays += icon_mana69er.69et_atmos_icon("manifold", , pipe_color, "core" + icon_connect_type)
		overlays += icon_mana69er.69et_atmos_icon("manifold", , , "clamps" + icon_connect_type)
		underlays.Cut()

		var/turf/T = 69et_turf(src)
		var/list/directions = list(NORTH, SOUTH, EAST, WEST)
		var/node1_direction = 69et_dir(src,69ode1)
		var/node2_direction = 69et_dir(src,69ode2)
		var/node3_direction = 69et_dir(src,69ode3)

		directions -= dir

		directions -= add_underlay(T,69ode1,69ode1_direction, icon_connect_type)
		directions -= add_underlay(T,69ode2,69ode2_direction, icon_connect_type)
		directions -= add_underlay(T,69ode3,69ode3_direction, icon_connect_type)

		for(var/D in directions)
			add_underlay(T,,D, icon_connect_type)


/obj/machinery/atmospherics/pipe/manifold/update_underlays()
	..()
	update_icon()

/obj/machinery/atmospherics/pipe/manifold/atmos_init()
	var/connect_directions = (NORTH|SOUTH|EAST|WEST)&(~dir)

	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, direction))
				if(tar69et.initialize_directions & 69et_dir(tar69et, src))
					if (check_connect_types(tar69et, src))
						node1 = tar69et
						connect_directions &= ~direction
						break
			if (node1)
				break


	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, direction))
				if(tar69et.initialize_directions & 69et_dir(tar69et, src))
					if (check_connect_types(tar69et, src))
						node2 = tar69et
						connect_directions &= ~direction
						break
			if (node2)
				break


	for(var/direction in cardinal)
		if(direction&connect_directions)
			for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, direction))
				if(tar69et.initialize_directions & 69et_dir(tar69et, src))
					if (check_connect_types(tar69et, src))
						node3 = tar69et
						connect_directions &= ~direction
						break
			if (node3)
				break

	if(!node1 && !node2 && !node3)
		qdel(src)
		return

	var/turf/T = 69et_turf(src)
	if(level == BELOW_PLATIN69_LEVEL && !T.is_platin69()) hide(1)
	update_icon()

/obj/machinery/atmospherics/pipe/manifold/visible
	icon_state = "map"
	level = ABOVE_PLATIN69_LEVEL

/obj/machinery/atmospherics/pipe/manifold/visible/scrubbers
	name="Scrubbers pipe69anifold"
	desc = "A69anifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/supply
	name="Air supply pipe69anifold"
	desc = "A69anifold composed of supply pipes"
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/visible/69reen
	color = PIPE_COLOR_69REEN

/obj/machinery/atmospherics/pipe/manifold/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/visible/blue
	color = PIPE_COLOR_BLUE


/obj/machinery/atmospherics/pipe/manifold/hidden
	icon_state = "map"
	level = BELOW_PLATIN69_LEVEL
	alpha = 128		//set for the benefit of69appin69 - this is reset to opaque when the pipe is spawned in 69ame

/obj/machinery/atmospherics/pipe/manifold/hidden/scrubbers
	name="Scrubbers pipe69anifold"
	desc = "A69anifold composed of scrubbers pipes"
	icon_state = "map-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/supply
	name="Air supply pipe69anifold"
	desc = "A69anifold composed of supply pipes"
	icon_state = "map-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold/hidden/69reen
	color = PIPE_COLOR_69REEN

/obj/machinery/atmospherics/pipe/manifold/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w
	icon = 'icons/atmos/manifold.dmi'
	icon_state = ""
	name = "4-way pipe69anifold"
	desc = "A69anifold composed of re69ular pipes"

	volume = ATMOS_DEFAULT_VOLUME_PIPE * 2

	dir = SOUTH
	initialize_directions =69ORTH|SOUTH|EAST|WEST

	var/obj/machinery/atmospherics/node3
	var/obj/machinery/atmospherics/node4

	level = BELOW_PLATIN69_LEVEL
	layer = 69AS_PIPE_VISIBLE_LAYER

/obj/machinery/atmospherics/pipe/manifold4w/New()
	..()
	alpha = 255
	icon =69ull

/obj/machinery/atmospherics/pipe/manifold4w/pipeline_expansion()
	return list(node1,69ode2,69ode3,69ode4)

/obj/machinery/atmospherics/pipe/manifold4w/Process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/manifold4w/Destroy()
	if(node1)
		node1.disconnect(src)
	if(node2)
		node2.disconnect(src)
	if(node3)
		node3.disconnect(src)
	if(node4)
		node4.disconnect(src)

	. = ..()

/obj/machinery/atmospherics/pipe/manifold4w/disconnect(obj/machinery/atmospherics/reference)
	if(reference ==69ode1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 =69ull

	if(reference ==69ode2)
		if(istype(node2, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node2 =69ull

	if(reference ==69ode3)
		if(istype(node3, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node3 =69ull

	if(reference ==69ode4)
		if(istype(node4, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node4 =69ull

	update_icon()

	..()

/obj/machinery/atmospherics/pipe/manifold4w/chan69e_color(var/new_color)
	..()
	//for updatin69 connected atmos device pipes (i.e.69ents,69anifolds, etc)
	if(node1)
		node1.update_underlays()
	if(node2)
		node2.update_underlays()
	if(node3)
		node3.update_underlays()
	if(node4)
		node4.update_underlays()

/obj/machinery/atmospherics/pipe/manifold4w/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	if(!node1 && !node2 && !node3 && !node4)
		var/turf/T = 69et_turf(src)
		new /obj/item/pipe(loc,69ake_from=src)
		for (var/obj/machinery/meter/meter in T)
			if (meter.tar69et == src)
				new /obj/item/pipe_meter(T)
				qdel(meter)
		qdel(src)
	else
		overlays.Cut()
		overlays += icon_mana69er.69et_atmos_icon("manifold", , pipe_color, "4way" + icon_connect_type)
		overlays += icon_mana69er.69et_atmos_icon("manifold", , , "clamps_4way" + icon_connect_type)
		underlays.Cut()

		/*
		var/list/directions = list(NORTH, SOUTH, EAST, WEST)


		directions -= add_underlay(node1)
		directions -= add_underlay(node2)
		directions -= add_underlay(node3)
		directions -= add_underlay(node4)

		for(var/D in directions)
			add_underlay(, D)
		*/

		var/turf/T = 69et_turf(src)
		var/list/directions = list(NORTH, SOUTH, EAST, WEST)
		var/node1_direction = 69et_dir(src,69ode1)
		var/node2_direction = 69et_dir(src,69ode2)
		var/node3_direction = 69et_dir(src,69ode3)
		var/node4_direction = 69et_dir(src,69ode4)

		directions -= dir

		directions -= add_underlay(T,69ode1,69ode1_direction, icon_connect_type)
		directions -= add_underlay(T,69ode2,69ode2_direction, icon_connect_type)
		directions -= add_underlay(T,69ode3,69ode3_direction, icon_connect_type)
		directions -= add_underlay(T,69ode4,69ode4_direction, icon_connect_type)

		for(var/D in directions)
			add_underlay(T,,D, icon_connect_type)


/obj/machinery/atmospherics/pipe/manifold4w/update_underlays()
	..()
	update_icon()

/obj/machinery/atmospherics/pipe/manifold4w/hide(var/i)
	if(istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/atmospherics/pipe/manifold4w/atmos_init()

	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, 1))
		if(tar69et.initialize_directions & 2)
			if (check_connect_types(tar69et, src))
				node1 = tar69et
				break

	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, 2))
		if(tar69et.initialize_directions & 1)
			if (check_connect_types(tar69et, src))
				node2 = tar69et
				break

	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, 4))
		if(tar69et.initialize_directions & 8)
			if (check_connect_types(tar69et, src))
				node3 = tar69et
				break

	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, 8))
		if(tar69et.initialize_directions & 4)
			if (check_connect_types(tar69et, src))
				node4 = tar69et
				break

	if(!node1 && !node2 && !node3 && !node4)
		qdel(src)
		return

	var/turf/T = 69et_turf(src)
	if(level == BELOW_PLATIN69_LEVEL && !T.is_platin69()) hide(1)
	update_icon()

/obj/machinery/atmospherics/pipe/manifold4w/visible
	icon_state = "map_4way"
	level = ABOVE_PLATIN69_LEVEL

/obj/machinery/atmospherics/pipe/manifold4w/visible/scrubbers
	name="4-way scrubbers pipe69anifold"
	desc = "A69anifold composed of scrubbers pipes"
	icon_state = "map_4way-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/visible/supply
	name="4-way air supply pipe69anifold"
	desc = "A69anifold composed of supply pipes"
	icon_state = "map_4way-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/visible/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold4w/visible/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/visible/69reen
	color = PIPE_COLOR_69REEN

/obj/machinery/atmospherics/pipe/manifold4w/visible/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold4w/visible/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/visible/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/hidden
	icon_state = "map_4way"
	level = BELOW_PLATIN69_LEVEL
	alpha = 128		//set for the benefit of69appin69 - this is reset to opaque when the pipe is spawned in 69ame

/obj/machinery/atmospherics/pipe/manifold4w/hidden/scrubbers
	name="4-way scrubbers pipe69anifold"
	desc = "A69anifold composed of scrubbers pipes"
	icon_state = "map_4way-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/hidden/supply
	name="4-way air supply pipe69anifold"
	desc = "A69anifold composed of supply pipes"
	icon_state = "map_4way-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	layer = 69AS_PIPE_VISIBLE_LAYER
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/manifold4w/hidden/yellow
	color = PIPE_COLOR_YELLOW

/obj/machinery/atmospherics/pipe/manifold4w/hidden/cyan
	color = PIPE_COLOR_CYAN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/69reen
	color = PIPE_COLOR_69REEN

/obj/machinery/atmospherics/pipe/manifold4w/hidden/black
	color = PIPE_COLOR_BLACK

/obj/machinery/atmospherics/pipe/manifold4w/hidden/red
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/manifold4w/hidden/blue
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/cap
	name = "pipe endcap"
	desc = "An endcap for pipes"
	icon = 'icons/atmos/pipes.dmi'
	icon_state = ""
	level = ABOVE_PLATIN69_LEVEL
	layer = 69AS_PIPE_VISIBLE_LAYER

	volume = 35

	dir = SOUTH
	initialize_directions = SOUTH

	var/obj/machinery/atmospherics/node

/obj/machinery/atmospherics/pipe/cap/New()
	..()
	initialize_directions = dir

/obj/machinery/atmospherics/pipe/cap/hide(var/i)
	if(istype(loc, /turf/simulated))
		invisibility = i ? 101 : 0
	update_icon()

/obj/machinery/atmospherics/pipe/cap/pipeline_expansion()
	return list(node)

/obj/machinery/atmospherics/pipe/cap/Process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL
/obj/machinery/atmospherics/pipe/cap/Destroy()
	if(node)
		node.disconnect(src)

	. = ..()

/obj/machinery/atmospherics/pipe/cap/disconnect(obj/machinery/atmospherics/reference)
	if(reference ==69ode)
		if(istype(node, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node =69ull

	update_icon()

	..()

/obj/machinery/atmospherics/pipe/cap/chan69e_color(var/new_color)
	..()
	//for updatin69 connected atmos device pipes (i.e.69ents,69anifolds, etc)
	if(node)
		node.update_underlays()

/obj/machinery/atmospherics/pipe/cap/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()
	overlays += icon_mana69er.69et_atmos_icon("pipe", , pipe_color, "cap")

/obj/machinery/atmospherics/pipe/cap/atmos_init()
	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, dir))
		if(tar69et.initialize_directions & 69et_dir(tar69et, src))
			if (check_connect_types(tar69et, src))
				node = tar69et
				break

	var/turf/T = src.loc			// hide if turf is69ot intact
	if(level == BELOW_PLATIN69_LEVEL && !T.is_platin69()) hide(1)
	update_icon()

/obj/machinery/atmospherics/pipe/cap/visible
	level = ABOVE_PLATIN69_LEVEL
	icon_state = "cap"

/obj/machinery/atmospherics/pipe/cap/visible/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes"
	icon_state = "cap-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/visible/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes"
	icon_state = "cap-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE

/obj/machinery/atmospherics/pipe/cap/hidden
	level = BELOW_PLATIN69_LEVEL
	icon_state = "cap"
	alpha = 128

/obj/machinery/atmospherics/pipe/cap/hidden/scrubbers
	name = "scrubbers pipe endcap"
	desc = "An endcap for scrubbers pipes"
	icon_state = "cap-f-scrubbers"
	connect_types = CONNECT_TYPE_SCRUBBER
	icon_connect_type = "-scrubbers"
	color = PIPE_COLOR_RED

/obj/machinery/atmospherics/pipe/cap/hidden/supply
	name = "supply pipe endcap"
	desc = "An endcap for supply pipes"
	icon_state = "cap-f-supply"
	connect_types = CONNECT_TYPE_SUPPLY
	icon_connect_type = "-supply"
	color = PIPE_COLOR_BLUE


/obj/machinery/atmospherics/pipe/tank
	icon = 'icons/atmos/tank.dmi'
	icon_state = "air_map"

	name = "Pressure Tank"
	desc = "A lar69e69essel containin69 pressurized 69as."

	volume = 10000 //in liters, 169eters by 169eters by 269eters ~tweaked it a little to simulate a pressure tank without69eedin69 to recode them yet
	var/start_pressure = 25*ONE_ATMOSPHERE

	level = BELOW_PLATIN69_LEVEL
	dir = SOUTH
	initialize_directions = SOUTH
	density = TRUE
	layer = ABOVE_WINDOW_LAYER

/obj/machinery/atmospherics/pipe/tank/New()
	icon_state = "air"
	initialize_directions = dir
	..()

/obj/machinery/atmospherics/pipe/tank/Process()
	if(!parent)
		..()
	else
		. = PROCESS_KILL

/obj/machinery/atmospherics/pipe/tank/Destroy()
	if(node1)
		node1.disconnect(src)

	. = ..()

/obj/machinery/atmospherics/pipe/tank/pipeline_expansion()
	return list(node1)

/obj/machinery/atmospherics/pipe/tank/update_underlays()
	if(..())
		underlays.Cut()
		var/turf/T = 69et_turf(src)
		if(!istype(T))
			return
		add_underlay(T,69ode1, dir)

/obj/machinery/atmospherics/pipe/tank/hide()
	update_underlays()

/obj/machinery/atmospherics/pipe/tank/atmos_init()
	var/connect_direction = dir

	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, connect_direction))
		if(tar69et.initialize_directions & 69et_dir(tar69et, src))
			if (check_connect_types(tar69et, src))
				node1 = tar69et
				break

	update_underlays()

/obj/machinery/atmospherics/pipe/tank/disconnect(obj/machinery/atmospherics/reference)
	if(reference ==69ode1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 =69ull

	update_underlays()

	return69ull

/obj/machinery/atmospherics/pipe/tank/attackby(var/obj/item/W as obj,69ar/mob/user as69ob)
	if(istype(W, /obj/item/device/pipe_painter))
		return

/obj/machinery/atmospherics/pipe/tank/air
	name = "Pressure Tank (Air)"
	icon_state = "air_map"

/obj/machinery/atmospherics/pipe/tank/air/New()
	air_temporary =69ew
	air_temporary.volume =69olume
	air_temporary.temperature = T20C

	air_temporary.adjust_multi("oxy69en",  (start_pressure*O2STANDARD)*(air_temporary.volume)/(R_IDEAL_69AS_EQUATION*air_temporary.temperature), \
	                           "nitro69en",(start_pressure*N2STANDARD)*(air_temporary.volume)/(R_IDEAL_69AS_EQUATION*air_temporary.temperature))


	..()
	icon_state = "air"

/obj/machinery/atmospherics/pipe/tank/oxy69en
	name = "Pressure Tank (Oxy69en)"
	icon_state = "o2_map"

/obj/machinery/atmospherics/pipe/tank/oxy69en/New()
	air_temporary =69ew
	air_temporary.volume =69olume
	air_temporary.temperature = T20C

	air_temporary.adjust_69as("oxy69en", (start_pressure)*(air_temporary.volume)/(R_IDEAL_69AS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "o2"

/obj/machinery/atmospherics/pipe/tank/nitro69en
	name = "Pressure Tank (Nitro69en)"
	icon_state = "n2_map"

/obj/machinery/atmospherics/pipe/tank/nitro69en/New()
	air_temporary =69ew
	air_temporary.volume =69olume
	air_temporary.temperature = T20C

	air_temporary.adjust_69as("nitro69en", (start_pressure)*(air_temporary.volume)/(R_IDEAL_69AS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "n2"

/obj/machinery/atmospherics/pipe/tank/carbon_dioxide
	name = "Pressure Tank (Carbon Dioxide)"
	icon_state = "co2_map"

/obj/machinery/atmospherics/pipe/tank/carbon_dioxide/New()
	air_temporary =69ew
	air_temporary.volume =69olume
	air_temporary.temperature = T20C

	air_temporary.adjust_69as("carbon_dioxide", (start_pressure)*(air_temporary.volume)/(R_IDEAL_69AS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "co2"

/obj/machinery/atmospherics/pipe/tank/plasma
	name = "Pressure Tank (Plasma)"
	icon_state = "plasma_map"

/obj/machinery/atmospherics/pipe/tank/plasma/New()
	air_temporary =69ew
	air_temporary.volume =69olume
	air_temporary.temperature = T20C

	air_temporary.adjust_69as("plasma", (start_pressure)*(air_temporary.volume)/(R_IDEAL_69AS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "plasma"

/obj/machinery/atmospherics/pipe/tank/nitrous_oxide
	name = "Pressure Tank (Nitrous Oxide)"
	icon_state = "n2o_map"

/obj/machinery/atmospherics/pipe/tank/nitrous_oxide/New()
	air_temporary =69ew
	air_temporary.volume =69olume
	air_temporary.temperature = T0C

	air_temporary.adjust_69as("sleepin69_a69ent", (start_pressure)*(air_temporary.volume)/(R_IDEAL_69AS_EQUATION*air_temporary.temperature))

	..()
	icon_state = "n2o"

/obj/machinery/atmospherics/pipe/vent
	icon = 'icons/obj/atmospherics/pipe_vent.dmi'
	icon_state = "intact"

	name = "Vent"
	desc = "A lar69e air69ent"

	level = BELOW_PLATIN69_LEVEL

	volume = 250

	dir = SOUTH
	initialize_directions = SOUTH

	var/build_killswitch = 1


/obj/machinery/atmospherics/pipe/vent/New()
	initialize_directions = dir
	..()

/obj/machinery/atmospherics/pipe/vent/hi69h_volume
	name = "Lar69er69ent"
	volume = 1000

/obj/machinery/atmospherics/pipe/vent/Process()
	if(!parent)
		if(build_killswitch <= 0)
			. = PROCESS_KILL
		else
			build_killswitch--
		..()
		return
	else
		parent.min69le_with_turf(loc,69olume)

/obj/machinery/atmospherics/pipe/vent/Destroy()
	if(node1)
		node1.disconnect(src)

	. = ..()

/obj/machinery/atmospherics/pipe/vent/pipeline_expansion()
	return list(node1)

/obj/machinery/atmospherics/pipe/vent/update_icon()
	if(node1)
		icon_state = "intact"

		set_dir(69et_dir(src,69ode1))

	else
		icon_state = "exposed"

/obj/machinery/atmospherics/pipe/vent/atmos_init()
	var/connect_direction = dir

	for(var/obj/machinery/atmospherics/tar69et in 69et_step(src, connect_direction))
		if(tar69et.initialize_directions & 69et_dir(tar69et, src))
			if (check_connect_types(tar69et, src))
				node1 = tar69et
				break

	update_icon()

/obj/machinery/atmospherics/pipe/vent/disconnect(obj/machinery/atmospherics/reference)
	if(reference ==69ode1)
		if(istype(node1, /obj/machinery/atmospherics/pipe))
			qdel(parent)
		node1 =69ull

	update_icon()

	return69ull

/obj/machinery/atmospherics/pipe/vent/hide(var/i) //to69ake the little pipe section invisible, the icon chan69es.
	if(node1)
		icon_state = "69i == 1 && istype(loc, /turf/simulated) ? "h" : "" 69intact"
		set_dir(69et_dir(src,69ode1))
	else
		icon_state = "exposed"


/obj/machinery/atmospherics/pipe/simple/visible/universal
	name="Universal pipe adapter"
	desc = "An adapter for re69ular, supply and scrubbers pipes"
	connect_types = CONNECT_TYPE_RE69ULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER
	icon_state = "map_universal"

/obj/machinery/atmospherics/pipe/simple/visible/universal/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()
	overlays += icon_mana69er.69et_atmos_icon("pipe", , pipe_color, "universal")
	underlays.Cut()

	if (node1)
		universal_underlays(node1)
		if(node2)
			universal_underlays(node2)
		else
			var/node2_dir = turn(69et_dir(src,69ode1), -180)
			universal_underlays(,69ode2_dir)
	else if (node2)
		universal_underlays(node2)
		var/node1_dir = turn(69et_dir(src,69ode2), -180)
		universal_underlays(,69ode1_dir)
	else
		universal_underlays(, dir)
		universal_underlays(, turn(dir, -180))

/obj/machinery/atmospherics/pipe/simple/visible/universal/update_underlays()
	..()
	update_icon()



/obj/machinery/atmospherics/pipe/simple/hidden/universal
	name="Universal pipe adapter"
	desc = "An adapter for re69ular, supply and scrubbers pipes"
	connect_types = CONNECT_TYPE_RE69ULAR|CONNECT_TYPE_SUPPLY|CONNECT_TYPE_SCRUBBER
	icon_state = "map_universal"

/obj/machinery/atmospherics/pipe/simple/hidden/universal/update_icon(var/safety = 0)
	if(!check_icon_cache())
		return

	alpha = 255

	overlays.Cut()
	overlays += icon_mana69er.69et_atmos_icon("pipe", , pipe_color, "universal")
	underlays.Cut()

	if (node1)
		universal_underlays(node1)
		if(node2)
			universal_underlays(node2)
		else
			var/node2_dir = turn(69et_dir(src,69ode1), -180)
			universal_underlays(,69ode2_dir)
	else if (node2)
		universal_underlays(node2)
		var/node1_dir = turn(69et_dir(src,69ode2), -180)
		universal_underlays(,69ode1_dir)
	else
		universal_underlays(, dir)
		universal_underlays(, turn(dir, -180))

/obj/machinery/atmospherics/pipe/simple/hidden/universal/update_underlays()
	..()
	update_icon()

/obj/machinery/atmospherics/proc/universal_underlays(var/obj/machinery/atmospherics/node,69ar/direction)
	var/turf/T = loc
	if(node)
		var/node_dir = 69et_dir(src,69ode)
		if(node.icon_connect_type == "-supply")
			add_underlay_adapter(T, ,69ode_dir, "")
			add_underlay_adapter(T,69ode,69ode_dir, "-supply")
			add_underlay_adapter(T, ,69ode_dir, "-scrubbers")
		else if (node.icon_connect_type == "-scrubbers")
			add_underlay_adapter(T, ,69ode_dir, "")
			add_underlay_adapter(T, ,69ode_dir, "-supply")
			add_underlay_adapter(T,69ode,69ode_dir, "-scrubbers")
		else
			add_underlay_adapter(T,69ode,69ode_dir, "")
			add_underlay_adapter(T, ,69ode_dir, "-supply")
			add_underlay_adapter(T, ,69ode_dir, "-scrubbers")
	else
		add_underlay_adapter(T, , direction, "-supply")
		add_underlay_adapter(T, , direction, "-scrubbers")
		add_underlay_adapter(T, , direction, "")

/obj/machinery/atmospherics/proc/add_underlay_adapter(var/turf/T,69ar/obj/machinery/atmospherics/node,69ar/direction,69ar/icon_connect_type) //modified from add_underlay, does69ot69ake exposed underlays
	if(node)
		if(!T.is_platin69() &&69ode.level == BELOW_PLATIN69_LEVEL && istype(node, /obj/machinery/atmospherics/pipe))
			underlays += icon_mana69er.69et_atmos_icon("underlay", direction, color_cache_name(node), "down" + icon_connect_type)
		else
			underlays += icon_mana69er.69et_atmos_icon("underlay", direction, color_cache_name(node), "intact" + icon_connect_type)
	else
		underlays += icon_mana69er.69et_atmos_icon("underlay", direction, color_cache_name(node), "retracted" + icon_connect_type)
