/obj/effect/overmap/ship
	name = "generic ship"
	desc = "Space faring vessel."
	name_stages = list("generic ship", "unknown vessel", "unknown spatial phenomenon")
	icon_stages = list("htu_cruiser", "ship", "poi")
	var/vessel_mass = 100 				//tonnes, arbitrary number, affects acceleration provided by engines
	var/default_delay = 6 SECONDS 		//time it takes to move to next tile on overmap
	var/speed_mod = 10					//multiplier for how much ship's speed reduces above time
	var/list/speed = list(0,0)			//speed in x,y direction
	var/last_burn = 0					//worldtime when ship last acceleated
	var/burn_delay = 10					//how often ship can do burns
	var/list/last_movement = list(0,0)	//worldtime when ship last moved in x,y direction
	var/fore_dir = NORTH				//what dir ship flies towards for purpose of moving stars effect procs

	var/obj/machinery/computer/helm/nav_control
	var/list/engines = list()  // contains /datum/ship_engine
	var/list/scanners = list() // contains /obj/machinery/power/shipside/long_range_scanner
	var/engines_state = 1 //global on/off toggle for all engines
	var/thrust_limit = 1 //global thrust limit for all engines, 0..1
	var/triggers_events = 1

	var/scan_range = PASSIVE_SCAN_RANGE
	var/pulsing = FALSE

	Crossed(var/obj/effect/overmap_event/movable/ME)
		..()
		if(ME)
			if(istype(ME, /obj/effect/overmap_event/movable))
				if(ME.OE)
					if(istype(src, /obj/effect/overmap/ship))
						ME.OE:enter(src)

	Uncrossed(var/obj/effect/overmap_event/movable/ME)
		..()
		if(ME)
			if(istype(ME, /obj/effect/overmap_event/movable))
				if(ME.OE)
					if(istype(src, /obj/effect/overmap/ship))
						ME.OE:leave(src)

/obj/effect/overmap/ship/New()
	GLOB.ships += src
	. = ..()

/obj/effect/overmap/ship/Destroy()
	GLOB.ships -= src
	. = ..()

/obj/effect/overmap/ship/Initialize()
	. = ..()
	for(var/datum/ship_engine/E in ship_engines)
		if (E.holder.z in map_z)
			engines |= E
			//testing("Engine at level [E.holder.z] linked to overmap object '[name]'.")
	for(var/obj/machinery/computer/engines/E in GLOB.computer_list)
		if (E.z in map_z)
			E.linked = src
			//testing("Engines console at level [E.z] linked to overmap object '[name]'.")

	for(var/obj/machinery/power/shipside/long_range_scanner/LRS in ship_scanners)
		if (LRS.z in map_z)
			//testing("Scanner at level [LRS.z] linked to overmap object '[name]'.")
			scanners |= LRS

	for(var/obj/machinery/computer/helm/H in GLOB.computer_list)
		if (H.z in map_z)
			nav_control = H
			H.linked = src
			H.get_known_sectors()
			//testing("Helm console at level [H.z] linked to overmap object '[name]'.")
	for(var/obj/machinery/computer/navigation/N in GLOB.computer_list)
		if (N.z in map_z)
			N.linked = src
			//testing("Navigation console at level [N.z] linked to overmap object '[name]'.")

	START_PROCESSING(SSobj, src)

/obj/effect/overmap/ship/proc/check_link()
	// Depending on initialization order the Initialize() does not properly make the links

	for(var/datum/ship_engine/E in ship_engines)
		if (E.holder.z in map_z)
			engines |= E
			//testing("Engine at level [E.holder.z] linked to overmap object '[name]'.")
	for(var/obj/machinery/computer/engines/E in GLOB.computer_list)
		if (E.z in map_z)
			E.linked = src
			//testing("Engines console at level [E.z] linked to overmap object '[name]'.")

	for(var/obj/machinery/power/shipside/long_range_scanner/LRS in ship_scanners)
		if (LRS.z in map_z)
			//testing("Scanner at level [LRS.z] linked to overmap object '[name]'.")
			scanners |= LRS

	for(var/obj/machinery/computer/helm/H in GLOB.computer_list)
		if (H.z in map_z)
			nav_control = H
			H.linked = src
			H.get_known_sectors()
			//testing("Helm console at level [H.z] linked to overmap object '[name]'.")
	for(var/obj/machinery/computer/navigation/N in GLOB.computer_list)
		if (N.z in map_z)
			N.linked = src
			//testing("Navigation console at level [N.z] linked to overmap object '[name]'.")

/obj/effect/overmap/ship/relaymove(mob/user, direction)
	accelerate(direction)

/obj/effect/overmap/ship/proc/is_still()
	return !(speed[1] || speed[2])

//Projected acceleration based on information from engines
/obj/effect/overmap/ship/proc/get_acceleration()
	return round(get_total_thrust()/vessel_mass, 0.1)

//Does actual burn and returns the resulting acceleration
/obj/effect/overmap/ship/proc/get_burn_acceleration()
	return round(burn() / vessel_mass, 0.1)

/obj/effect/overmap/ship/proc/get_speed()
	return round(sqrt(speed[1]*speed[1] + speed[2]*speed[2]), 0.1)

/obj/effect/overmap/ship/proc/get_heading()
	var/res = 0
	if(speed[1])
		if(speed[1] > 0)
			res |= EAST
		else
			res |= WEST
	if(speed[2])
		if(speed[2] > 0)
			res |= NORTH
		else
			res |= SOUTH
	return res

/obj/effect/overmap/ship/proc/adjust_speed(n_x, n_y)
	speed[1] = round(CLAMP(speed[1] + n_x, -default_delay, default_delay),0.1)
	speed[2] = round(CLAMP(speed[2] + n_y, -default_delay, default_delay),0.1)
	for(var/zz in map_z)
		if(is_still())
			toggle_move_stars(zz)
		else
			toggle_move_stars(zz, fore_dir)
	update_icon()

/obj/effect/overmap/ship/proc/get_brake_path()
	if(!get_acceleration())
		return INFINITY
	var/num_burns = get_speed()/get_acceleration() + 2 //some padding in case acceleration drops form fuel usage
	var/burns_per_grid = (default_delay - speed_mod*get_speed())/burn_delay
	if (burns_per_grid == 0)
		error("ship attempted get_brake_path, burns_per_grid is 0")
		return INFINITY
	return round(num_burns/burns_per_grid)

/obj/effect/overmap/ship/proc/decelerate()
	if(!is_still() && can_burn())
		if (speed[1])
			adjust_speed(-SIGN(speed[1]) * min(get_burn_acceleration(),abs(speed[1])), 0)
		if (speed[2])
			adjust_speed(0, -SIGN(speed[2]) * min(get_burn_acceleration(),abs(speed[2])))
		last_burn = world.time

/obj/effect/overmap/ship/proc/accelerate(direction)
	if(can_burn())
		last_burn = world.time

		if(direction & EAST)
			adjust_speed(get_burn_acceleration(), 0)
		if(direction & WEST)
			adjust_speed(-get_burn_acceleration(), 0)
		if(direction & NORTH)
			adjust_speed(0, get_burn_acceleration())
		if(direction & SOUTH)
			adjust_speed(0, -get_burn_acceleration())

/obj/effect/overmap/ship/Process()
	if(!is_still())
		var/list/deltas = list(0,0)
		for(var/i=1, i<=2, i++)
			if(speed[i] && world.time > last_movement[i] + default_delay - speed_mod*abs(speed[i]))
				deltas[i] = speed[i] > 0 ? 1 : -1
				last_movement[i] = world.time
		var/turf/newloc = locate(x + deltas[1], y + deltas[2], z)
		if(newloc)
			Move(newloc)
			handle_wraparound()
		update_icon()
	SEND_SIGNAL_OLD(src, COMSIG_SHIP_STILL, x, y, is_still())

/obj/effect/overmap/ship/update_icon()
	cut_overlays()
	if(!is_still())
		dir = get_heading()
		overlays += image('icons/obj/overmap.dmi', "vector", "dir"=dir)

/obj/effect/overmap/ship/proc/burn()

	for(var/datum/ship_engine/E in engines)
		. += E.burn()

/obj/effect/overmap/ship/proc/get_total_thrust()

	for(var/datum/ship_engine/E in engines)
		. += E.get_thrust()

/obj/effect/overmap/ship/proc/can_burn()

	if (world.time < last_burn + burn_delay)
		return 0
	for(var/datum/ship_engine/E in engines)
		. |= E.can_burn()


//deciseconds to next step
/obj/effect/overmap/ship/proc/ETA()
	. = INFINITY
	for(var/i=1, i<=2, i++)
		if(speed[i])
			. = min(last_movement[i] + default_delay - speed_mod*abs(speed[i]) - world.time, .)
	. = max(.,0)

/obj/effect/overmap/ship/proc/handle_wraparound()
    var/nx = x
    var/ny = y
    var/low_edge = 1
    var/high_edge = GLOB.maps_data.overmap_size

    if(x <= low_edge)
        nx = high_edge
    if(x >= high_edge)
        nx = low_edge

    if(y <= low_edge)
        ny =high_edge
    if(y >= high_edge)
        ny = low_edge

    var/turf/T = locate(nx,ny,z)
    if(T)
        forceMove(T)

/obj/effect/overmap/ship/Bump(var/atom/A)
	if(istype(A,/turf/map/edge))
		handle_wraparound()
	..()

/obj/effect/overmap/ship/proc/pulse()

	if(pulsing)  // Should not happen but better to check
		return

	var/obj/machinery/power/shipside/long_range_scanner/enough_LRS = null
	for(var/obj/machinery/power/shipside/long_range_scanner/LRS in scanners)  // Among all ship's scanners get one with enough energy
		if(LRS.running && (LRS.current_energy > round(ENERGY_PER_SCAN * LRS.as_energy_multiplier)))
			enough_LRS = LRS

	if(!enough_LRS)
		nav_control.visible_message(SPAN_DANGER("The [src] buzzes an insistent warning as it fails to find any sensors with enough power to pulse"))
		playsound(nav_control.loc, 'sound/machines/buzz-two.ogg', 100, 1, 5)

	if(enough_LRS.consume_energy_scan())
		pulsing = TRUE
		scan_range = ACTIVE_SCAN_RANGE
		spawn(ACTIVE_SCAN_DURATION * enough_LRS.as_duration_multiplier)
			pulsing = FALSE
			scan_range = initial(scan_range) // get back to PASSIVE_SCAN_RANGE
			// Reset icons far from the ship to unknown state otherwise they remain discovered
			overmap_event_handler.scan_loc(src, loc, can_scan(), ACTIVE_SCAN_RANGE - initial(scan_range) + 3)

/obj/effect/overmap/ship/proc/can_scan()

	for(var/obj/machinery/power/shipside/long_range_scanner/LRS in scanners)
		. |= (LRS.running)

/obj/effect/overmap/ship/proc/can_pulse()

	if(pulsing)  // If the ship is already pulsing it cannot pulse again
		return FALSE

	// Check if one of the ship's scanners has enough energy to pulse
	for(var/obj/machinery/power/shipside/long_range_scanner/LRS in scanners)
		. |= (LRS.running && (LRS.current_energy > round(ENERGY_PER_SCAN * LRS.as_energy_multiplier)))

/obj/effect/overmap/ship/proc/can_scan_poi()

	if(!is_still())  // Ship must be immobile
		return FALSE

	for(var/obj/machinery/power/shipside/long_range_scanner/LRS in scanners)
		. |= (LRS.running)

/obj/effect/overmap/ship/proc/scan_poi()
	overmap_event_handler.scan_poi(src, loc) // Eris uses its sensors to scan a nearby point of interest
	return
