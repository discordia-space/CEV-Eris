
#define FIREDOOR_MAX_TEMP 323 // °C
#define FIREDOOR_MIN_TEMP 253
#define FIREDOOR_MIN_PRESSURE 30

// Bitflags
#define FIREDOOR_ALERT_HOT      1
#define FIREDOOR_ALERT_COLD     2
// Not used #define FIREDOOR_ALERT_LOWPRESS 4

#define F_NORTH "North"
#define F_SOUTH "South"
#define F_EAST "East"
#define F_WEST "West"
#define FIREDOOR_TURF 1
#define FIREDOOR_ATMOS 2
#define FIREDOOR_ALERT 3
/obj/machinery/door/firedoor
	name = "\improper Emergency Shutter"
	desc = "Emergency air-tight shutter, capable of sealing off breached areas."
	icon = 'icons/obj/doors/DoorHazard.dmi'
	description_info = "Can be deconstructed by welding closed, screwing and crowbaring the circuits out."
	icon_state = "door_open"
	req_one_access = list(access_atmospherics, access_engine_equip, access_medical_equip)
	opacity = FALSE
	density = FALSE
	layer = BELOW_OPEN_DOOR_LAYER
	open_layer = BELOW_OPEN_DOOR_LAYER // Just below doors when open
	closed_layer = CLOSED_FIREDOOR_LAYER // Just above doors when closed
	var/last_time_since_link = 0
	var/minimum_link_cooldown = 2 SECONDS

	//These are frequenly used with windows, so make sure zones can pass.
	//Generally if a firedoor is at a place where there should be a zone boundery then there will be a regular door underneath it.
	block_air_zones = FALSE

	var/blocked = FALSE
	var/lockdown = FALSE // When the door has detected a problem, it locks.
	var/net_id
	var/list/areas_added
	var/list/users_to_open = new

	var/hatch_open = FALSE

	power_channel = STATIC_ENVIRON
	use_power = IDLE_POWER_USE
	idle_power_usage = 5

/obj/machinery/door/firedoor/New()
	..()

	var/area/A = get_area(src)
	ASSERT(istype(A))

	A.all_doors.Add(src)
	areas_added = list(A)

	for(var/direction in cardinal)
		A = get_area(get_step(src,direction))
		if(istype(A) && !(A in areas_added))
			A.all_doors.Add(src)
			areas_added += A

/obj/machinery/door/firedoor/Destroy()
	for(var/area/A in areas_added)
		A.all_doors.Remove(src)
	. = ..()

/obj/machinery/door/firedoor/get_material()
	return get_material_by_name(MATERIAL_STEEL)

/obj/machinery/door/firedoor/examine(mob/user)
	if(!density || !..(user, 1))
		return FALSE

	to_chat(user, "<b> EMERGENCY SENSOR READINGS </b>")
	for(var/possible_cardinal in cardinal)
		var/turf/simulated/turf_sim = get_step(src, possible_cardinal)
		var/text_to_say = "&nbsp;&nbsp" // Magic bullshit im not even gonna question from the old proc
		text_to_say += "[uppertext(dir2text(possible_cardinal))] : "
		if(!istype(turf_sim) || turf_sim.is_wall || !turf_sim.zone)
			text_to_say += SPAN_NOTICE("NO DATA")
			to_chat(user, text_to_say)
			continue
		var/dangerous = FALSE
		var/datum/gas_mixture/air_data = turf_sim.zone.air
		if(air_data.return_pressure() < FIREDOOR_MIN_PRESSURE)
			text_to_say += SPAN_DANGER("LOW PRESSURE ")
			dangerous = TRUE
		if(air_data.temperature > FIREDOOR_MAX_TEMP)
			text_to_say += SPAN_DANGER("HIGH TEMPERATURE ")
			dangerous = TRUE
		else if(air_data.temperature < FIREDOOR_MIN_TEMP)
			text_to_say += SPAN_DANGER("LOW TEMPERATURE ")
			dangerous = TRUE
		if(dangerous)
			to_chat(user, text_to_say)
			continue
		text_to_say += span_green("SAFE")
		to_chat(user, text_to_say)

/obj/machinery/door/firedoor/Bumped(atom/AM)
	if(p_open || operating)
		return
	if(!density)
		return ..()
	if(istype(AM, /mob/living/exosuit))
		var/mob/living/exosuit/exosuit = AM
		if(exosuit.pilots.len)
			for(var/mob/M in exosuit.pilots)
				if(world.time - M.last_bumped <= 10) return //Can bump-open one airlock per second. This is to prevent popup message spam.
				M.last_bumped = world.time
				attack_hand(M)
	return FALSE

/obj/machinery/door/firedoor/proc/checkAlarmed()
	var/alarmed = FALSE
	for(var/area/A in areas_added) //Checks if there are fire alarms in any areas associated with that firedoor
		if(A.fire || A.air_doors_activated)
			alarmed = TRUE
	return alarmed

/obj/machinery/door/firedoor/attack_hand(mob/user as mob)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.

	if(blocked)
		to_chat(user, SPAN_WARNING("\The [src] is welded solid!"))
		return

	var/alarmed = lockdown || checkAlarmed()

	if(user.incapacitated() || (get_dist(src, user) > 1  && !issilicon(user)))
		to_chat(user, "You must remain able bodied and close to \the [src] in order to use it.")
		return
	if(density && (stat & (BROKEN|NOPOWER))) //can still close without power
		to_chat(user, "\The [src] is not functioning, you'll have to force it open manually.")
		return

	if(density && alarmed && !allowed(user))
		to_chat(user, SPAN_WARNING("Access denied.  Please wait for authorities to arrive, or for the alert to clear."))
		return
	else
		user.visible_message("<span class='notice'>\The [src] [density ? "open" : "close"]s for \the [user].</span>",\
		"\The [src] [density ? "open" : "close"]s.",\
		"You hear a beep, and a door opening.")

	if(density)
		if(alarmed)
			// Accountability!
			users_to_open |= user.name
		open()
	else
		close()

/obj/machinery/door/firedoor/attackby(obj/item/I, mob/user)
	add_fingerprint(user)
	if(operating)
		return//Already doing something.

	if(repairing)
		return ..()

	var/list/usable_qualities = list(QUALITY_WELDING,QUALITY_SCREW_DRIVING,QUALITY_PRYING)
	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		if(QUALITY_WELDING)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
				blocked = !blocked
				user.visible_message("<span class='danger'>\The [user] [blocked ? "welds" : "unwelds"] \the [src] with \a [I].</span>",\
				"You [blocked ? "weld" : "unweld"] \the [src] with \the [I].",\
				"You hear something being welded.")
				update_icon()
				return
			return

		if(QUALITY_SCREW_DRIVING)
			if(density)
				var/used_sound = hatch_open ? 'sound/machines/Custom_screwdriveropen.ogg' :  'sound/machines/Custom_screwdriverclose.ogg'
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
					hatch_open = !hatch_open
					user.visible_message("<span class='danger'>[user] has [hatch_open ? "opened" : "closed"] \the [src] maintenance hatch.</span>",
												"You have [hatch_open ? "opened" : "closed"] the [src] maintenance hatch.")
					update_icon()
					return
			else
				to_chat(user, SPAN_NOTICE("You must close \the [src] first."))
			return

		if(QUALITY_PRYING)
			if(blocked && hatch_open)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					user.visible_message(SPAN_DANGER("[user] has removed the electronics from \the [src]."),
										"You have removed the electronics from [src].")
					if (stat & BROKEN)
						new /obj/item/electronics/circuitboard/broken(src.loc)
					else
						new/obj/item/electronics/airalarm(src.loc)
					var/obj/structure/firedoor_assembly/FA = new/obj/structure/firedoor_assembly(src.loc)
					FA.anchored = TRUE
					FA.density = TRUE
					FA.wired = 1
					FA.update_icon()
					qdel(src)
					return
				return
			if(blocked)
				to_chat(user, SPAN_DANGER("\The [src] is welded shut!"))
				return
			if(!operating)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC))
					user.visible_message("<span class='danger'>\The [user] forces \the [src] [density ? "open" : "closed"] with \a [I]!</span>",\
					"You force \the [src] [density ? "open" : "closed"] with \the [I]!",\
					"You hear metal strain, and a door [density ? "open" : "close"].")
					if(density)
						open(1)
					else
						close(1)
					return
				return
			return

		if(ABORT_CHECK)
			return

	return ..()


/obj/machinery/door/firedoor/close(var/forced = 0)
	if (blocked) //welded
		return

	if(!forced)
		if(stat & (BROKEN|NOPOWER))
			return //needs power to close unless it was forced
		else
			use_power(360)

	return ..()

/obj/machinery/door/firedoor/open(var/forced = 0)
	if (blocked) //welded
		return

	if(hatch_open)
		hatch_open = FALSE
		visible_message("The maintenance hatch of \the [src] closes.")
		update_icon()

	if(!forced)
		if(stat & (BROKEN|NOPOWER))
			return //needs power to open unless it was forced
		else
			use_power(360)

	if(checkAlarmed())
		spawn(150)
			if(checkAlarmed())
				close()

	return ..()

/obj/machinery/door/firedoor/do_animate(animation)
	switch(animation)
		if("opening")
			flick("door_opening", src)
			playsound(src, 'sound/machines/airlock_ext_open.ogg', 37, 1)
		if("closing")
			flick("door_opening", src)
			playsound(src, 'sound/machines/airlock_ext_close.ogg', 37, 1)
	return


/obj/machinery/door/firedoor/update_icon()
	cut_overlays()
	set_light(0)
	var/do_set_light = FALSE

	if(density)
		icon_state = "door_closed"
		if(hatch_open)
			overlays += "hatch"
		if(blocked)
			overlays += "welded"
			do_set_light = TRUE
	else
		icon_state = "door_open"
		if(blocked)
			overlays += "welded_open"

	if(do_set_light)
		set_light(1.5, 0.5, COLOR_SUN)


/obj/machinery/door/firedoor/multi_tile
	icon = 'icons/obj/doors/DoorHazard2x1.dmi'
	width = 2
