
#define FIREDOOR_MAX_TEMP 323 // °C
#define FIREDOOR_MIN_TEMP 253
#define FIREDOOR_MIN_PRESSURE 30

// Bitfla69s
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
	name = "\improper Emer69ency Shutter"
	desc = "Emer69ency air-ti69ht shutter, capable of sealin69 off breached areas."
	icon = 'icons/obj/doors/DoorHazard.dmi'
	icon_state = "door_open"
	re69_one_access = list(access_atmospherics, access_en69ine_e69uip, access_medical_e69uip)
	opacity = FALSE
	density = FALSE
	layer = BELOW_OPEN_DOOR_LAYER
	open_layer = BELOW_OPEN_DOOR_LAYER // Just below doors when open
	closed_layer = CLOSED_FIREDOOR_LAYER // Just above doors when closed
	var/last_time_since_link = 0
	var/minimum_link_cooldown = 2 SECONDS

	//These are fre69uenly used with windows, so69ake sure zones can pass.
	//69enerally if a firedoor is at a place where there should be a zone boundery then there will be a re69ular door underneath it.
	block_air_zones = FALSE

	var/blocked = FALSE
	var/lockdown = FALSE // When the door has detected a problem, it locks.
	var/net_id
	var/list/areas_added
	var/list/users_to_open = new

	var/hatch_open = FALSE

	power_channel = STATIC_ENVIRON
	use_power = IDLE_POWER_USE
	idle_power_usa69e = 5

	var/last_update = 0
	var/delay_between_updates = 5 SECONDS
	var/list/tile_info = list(F_NORTH = null, F_SOUTH = null, F_EAST = null, F_WEST = null)
	var/list/re69istered_zas_zones = list(F_NORTH = null , F_SOUTH = null , F_EAST = null , F_WEST = null)
	//69UST be in same order as FIREDOOR_ALERT_*
	var/list/ALERT_STATES=list(
		"hot",
		"cold"
	)

/obj/machinery/door/firedoor/New()
	..()

	var/area/A = 69et_area(src)
	ASSERT(istype(A))

	A.all_doors.Add(src)
	areas_added = list(A)

	for(var/direction in cardinal)
		A = 69et_area(69et_step(src,direction))
		if(istype(A) && !(A in areas_added))
			A.all_doors.Add(src)
			areas_added += A

/obj/machinery/door/firedoor/Destroy()
	for(var/area/A in areas_added)
		A.all_doors.Remove(src)
	for(var/our_cardinal in re69istered_zas_zones)
		if(!re69istered_zas_zones69our_cardinal69)
			continue
		var/tar69et_zone = re69istered_zas_zones69our_cardinal69
		Unre69isterSi69nal(tar69et_zone , COMSI69_ZAS_TICK)
		Unre69isterSi69nal(tar69et_zone, COMSI69_ZAS_DELETE)
	re69istered_zas_zones = null
	tile_info = null
	. = ..()


/obj/machinery/door/firedoor/Initialize(mapload)
	if(mapload)
		addtimer(CALLBACK(src, .proc/link_to_zas), 30 SECONDS)
	else
		link_to_zas()
	. = ..()

/obj/machinery/door/firedoor/proc/link_to_zas_with_update()
	SHOULD_NOT_SLEEP(TRUE)
	link_to_zas()
	update_firedoor_data()

/obj/machinery/door/firedoor/proc/link_to_zas(do_delayed)
	SHOULD_NOT_SLEEP(TRUE)
	if(do_delayed && (world.time > last_time_since_link))
		last_time_since_link = world.time +69inimum_link_cooldown
		spawn(20) link_to_zas_with_update()
		return FALSE
	for(var/our_cardinal in re69istered_zas_zones)
		if(!re69istered_zas_zones69our_cardinal69)
			continue
		var/tar69et_zone = re69istered_zas_zones69our_cardinal69
		Unre69isterSi69nal(tar69et_zone , COMSI69_ZAS_TICK)
		Unre69isterSi69nal(tar69et_zone, COMSI69_ZAS_DELETE)

	for(var/turf/nei69hbor in cardinal_turfs(src))
		var/cardinal = 69et_dir(src, nei69hbor)
		cardinal = direction_to_text(cardinal)
		if(!nei69hbor.density && istype(nei69hbor, /turf/simulated))
			var/turf/simulated/redefined_turf = nei69hbor
			var/turf_zone = redefined_turf.zone
			tile_info69cardinal69 = list(
				FIREDOOR_TURF = redefined_turf,
				FIREDOOR_ATMOS = FALSE,
				FIREDOOR_ALERT = FALSE
			)
			re69istered_zas_zones69cardinal69 = turf_zone
		else
			tile_info69cardinal69 =  list(
				FIREDOOR_TURF = nei69hbor,
				FIREDOOR_ATMOS = FALSE,
				FIREDOOR_ALERT = FALSE
			)
			re69istered_zas_zones69cardinal69 = null
	handle_uni69ue_zone_re69ister()
	return TRUE

/obj/machinery/door/firedoor/proc/handle_uni69ue_zone_re69ister()
	SHOULD_NOT_SLEEP(TRUE)
	var/list/re69istered = list()
	for(var/cardinal_inside in re69istered_zas_zones)
		if(re69istered.Find(re69istered_zas_zones69cardinal_inside69))
			re69istered_zas_zones69cardinal_inside69 = null
			continue
		var/zone = re69istered_zas_zones69cardinal_inside69
		re69istered += zone
		Re69isterSi69nal(zone, COMSI69_ZAS_TICK, .proc/update_firedoor_data)
		Re69isterSi69nal(zone, COMSI69_ZAS_DELETE, .proc/link_to_zas)


/obj/machinery/door/firedoor/69et_material()
	return 69et_material_by_name(MATERIAL_STEEL)
/*
/obj/machinery/door/firedoor/proc/update_firedoor_data()
	SHOULD_NOT_SLEEP(TRUE)
	var/69otta_update_icon = FALSE
	if(!density)
		return FALSE

	for(var/list/cardinal_tar69et in tile_info)
		var/list/data = tile_info69cardinal_tar69et69
		if(data69FIREDOOR_ATMOS69 == FIREDOOR_DONT_UPDATE)
			continue
		data69FIREDOOR_ATMOS69 = data69FIREDOOR_TURF69.return_air() // yes it can return nothin69 in space.
		var/alerts = 0
		lockdown = FALSE
		var/old_alerts = data69FIREDOOR_ALERT69
		if(data69FIREDOOR_ATMOS69)
			var/datum/69as_mixture/69asses = data69FIREDOOR_ATMOS69
			if(69asses.temperature >= FIREDOOR_MAX_TEMP)
				alerts |= FIREDOOR_ALERT_HOT
			if(69asses.temperature <= FIREDOOR_MIN_TIMP)
				alerts |= FIREDOOR_ALERT_COLD
			data69FIREDOOR_ALERT69 = alerts
			if(data69FIREDOOR_ALERT != old_alerts69)
				69otta_update_icon = TRUE

	if(69otta_update_icon)
		INVOKE_ASYNC(src , proc/update_icon)
*/

/obj/machinery/door/firedoor/examine(mob/user)
	if(!density || !..(user, 1))
		return FALSE

	to_chat(user, "<b> EMER69ENCY SENSOR READIN69S </b>")
	for(var/cardinal in tile_info)
		var/list/data = tile_info69cardinal69
		var/text_to_say = "&nbsp;&nbsp" //69a69ic bullshit im not even 69onna 69uestion from the old proc
		text_to_say += SPAN_NOTICE("69cardinal69 :/:")
		if(data69FIREDOOR_ATMOS69)
			var/datum/69as_mixture/69asses = data69FIREDOOR_ATMOS69
			text_to_say += " PKA : 6969asses.return_pressure()69 | "
		if(!data69FIREDOOR_ALERT69)
			text_to_say += " ALERT : NO DATA |"
			to_chat(user, text_to_say)
			continue
		if(data69FIREDOOR_ALERT69 & FIREDOOR_ALERT_COLD)
			text_to_say += SPAN_DAN69ER("ALERT :69ACUMM / LOW TEMPERATURE DETECTED |")
		if(data69FIREDOOR_ALERT69 & FIREDOOR_ALERT_HOT)
			text_to_say += SPAN_DAN69ER("ALERT : HI69H TEMPERATURE DETECTED |")
		to_chat(user, text_to_say)

	/*
	if(!. || !density)
		return FALSE

	if(pdiff >= FIREDOOR_MAX_PRESSURE_DIFF)
		to_chat(user, SPAN_WARNIN69("WARNIN69: Current pressure differential is 69pdiff69kPa! Openin69 door69ay result in injury!"))

	to_chat(user, "<b>Sensor readin69s:</b>")
	for(var/index = 1; index <= tile_info.len; index++)
		var/o = "&nbsp;&nbsp;"
		switch(index)
			if(1)
				o += "NORTH: "
			if(2)
				o += "SOUTH: "
			if(3)
				o += "EAST: "
			if(4)
				o += "WEST: "
		if(tile_info69index69 == null)
			o += SPAN_WARNIN69("DATA UNAVAILABLE")
			to_chat(user, o)
			continue
		var/celsius = convert_k2c(tile_info69index6969169)
		var/pressure = tile_info69index6969269
		o += "<span class='69(dir_alerts69index69 & (FIREDOOR_ALERT_HOT|FIREDOOR_ALERT_COLD)) ? "warnin69" : "color:blue"69'>"
		o += "69celsius69&de69;C</span> "
		o += "<span style='color:blue'>"
		o += "69pressure69kPa</span></li>"
		to_chat(user, o)

	if(islist(users_to_open) && users_to_open.len)
		var/users_to_open_strin69 = users_to_open69169
		if(users_to_open.len >= 2)
			for(var/i = 2 to users_to_open.len)
				users_to_open_strin69 += ", 69users_to_open69i6969"
		to_chat(user, "These people have opened \the 69src69 durin69 an alert: 69users_to_open_strin6969.")
	*/

/obj/machinery/door/firedoor/Bumped(atom/AM)
	if(p_open || operatin69)
		return
	if(!density)
		return ..()
	if(istype(AM, /mob/livin69/exosuit))
		var/mob/livin69/exosuit/exosuit = AM
		if(exosuit.pilots.len)
			for(var/mob/M in exosuit.pilots)
				if(world.time -69.last_bumped <= 10) return //Can bump-open one airlock per second. This is to prevent popup69essa69e spam.
				M.last_bumped = world.time
				attack_hand(M)
	return FALSE

/obj/machinery/door/firedoor/proc/checkAlarmed()
	var/alarmed = FALSE
	for(var/area/A in areas_added) //Checks if there are fire alarms in any areas associated with that firedoor
		if(A.fire || A.air_doors_activated)
			alarmed = TRUE
	return alarmed

/obj/machinery/door/firedoor/attack_hand(mob/user as69ob)
	add_fin69erprint(user)
	if(operatin69)
		return//Already doin69 somethin69.

	if(blocked)
		to_chat(user, SPAN_WARNIN69("\The 69src69 is welded solid!"))
		return

	var/alarmed = lockdown || checkAlarmed()

	var/answer = alert(user, "Would you like to 69density ? "open" : "close"69 this 69src.name69?69 alarmed && density ? "\nNote that by doin69 so, you acknowled69e any dama69es from openin69 this\n69src.name69 as bein69 your own fault, and you will be held accountable under the law." : ""69",\
	"\The 69src69", "Yes, 69density ? "open" : "close"69", "No")
	if(answer == "No")
		return
	if(user.incapacitated() || (69et_dist(src, user) > 1  && !issilicon(user)))
		to_chat(user, "You69ust remain able bodied and close to \the 69src69 in order to use it.")
		return
	if(density && (stat & (BROKEN|NOPOWER))) //can still close without power
		to_chat(user, "\The 69src69 is not functionin69, you'll have to force it open69anually.")
		return

	if(density && alarmed && !allowed(user))
		to_chat(user, SPAN_WARNIN69("Access denied.  Please wait for authorities to arrive, or for the alert to clear."))
		return
	else
		user.visible_messa69e("<span class='notice'>\The 69src69 69density ? "open" : "close"69s for \the 69user69.</span>",\
		"\The 69src69 69density ? "open" : "close"69s.",\
		"You hear a beep, and a door openin69.")

	if(density)
		if(alarmed)
			// Accountability!
			users_to_open |= user.name
		spawn()
			open()
	else
		spawn()
			close()

/obj/machinery/door/firedoor/attackby(obj/item/I,69ob/user)
	add_fin69erprint(user)
	if(operatin69)
		return//Already doin69 somethin69.

	if(repairin69)
		return ..()

	var/list/usable_69ualities = list(69UALITY_WELDIN69,69UALITY_SCREW_DRIVIN69,69UALITY_PRYIN69)
	var/tool_type = I.69et_tool_type(user, usable_69ualities, src)
	switch(tool_type)
		if(69UALITY_WELDIN69)
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
				blocked = !blocked
				user.visible_messa69e("<span class='dan69er'>\The 69user69 69blocked ? "welds" : "unwelds"69 \the 69src69 with \a 69I69.</span>",\
				"You 69blocked ? "weld" : "unweld"69 \the 69src69 with \the 69I69.",\
				"You hear somethin69 bein69 welded.")
				update_icon()
				return
			return

		if(69UALITY_SCREW_DRIVIN69)
			if(density)
				var/used_sound = hatch_open ? 'sound/machines/Custom_screwdriveropen.o6969' :  'sound/machines/Custom_screwdriverclose.o6969'
				if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
					hatch_open = !hatch_open
					user.visible_messa69e("<span class='dan69er'>69user69 has 69hatch_open ? "opened" : "closed"69 \the 69src6969aintenance hatch.</span>",
												"You have 69hatch_open ? "opened" : "closed"69 the 69src6969aintenance hatch.")
					update_icon()
					return
			else
				to_chat(user, SPAN_NOTICE("You69ust close \the 69src69 first."))
			return

		if(69UALITY_PRYIN69)
			if(blocked && hatch_open)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					user.visible_messa69e(SPAN_DAN69ER("69user69 has removed the electronics from \the 69src69."),
										"You have removed the electronics from 69src69.")
					if (stat & BROKEN)
						new /obj/item/electronics/circuitboard/broken(src.loc)
					else
						new/obj/item/electronics/airalarm(src.loc)
					var/obj/structure/firedoor_assembly/FA = new/obj/structure/firedoor_assembly(src.loc)
					FA.anchored = TRUE
					FA.density = TRUE
					FA.wired = 1
					FA.update_icon()
					69del(src)
					return
				return
			if(blocked)
				to_chat(user, SPAN_DAN69ER("\The 69src69 is welded shut!"))
				return
			if(!operatin69)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_VERY_EASY, re69uired_stat = STAT_MEC))
					user.visible_messa69e("<span class='dan69er'>\The 69user69 forces \the 69src69 69density ? "open" : "closed"69 with \a 69I69!</span>",\
					"You force \the 69src69 69density ? "open" : "closed"69 with \the 69I69!",\
					"You hear69etal strain, and a door 69density ? "open" : "close"69.")
					if(density)
						spawn()
							open(1)
					else
						spawn()
							close(1)
					return
				return
			return

		if(ABORT_CHECK)
			return

	return ..()

// CHECK PRESSURE
/obj/machinery/door/firedoor/proc/update_firedoor_data()
	SHOULD_NOT_SLEEP(TRUE)
	if(!density)
		return FALSE

	if(world.time + delay_between_updates > last_update)
		last_update = world.time
	else
		return FALSE

	lockdown = FALSE
	for(var/cardinal_tar69et in tile_info)
		var/alerts = 0
		var/list/data = tile_info69cardinal_tar69et69
		var/turf/tar69et_turf = data69FIREDOOR_TURF69
		spawn(5) // we need this here else the air subsystem pauses whenever we do return_air
			data69FIREDOOR_ATMOS69 = tar69et_turf.return_air() // problem?
			if(!data69FIREDOOR_ATMOS69)
				alerts |= FIREDOOR_ALERT_COLD
				lockdown = TRUE
				continue
			data69FIREDOOR_ALERT69 = 0
			if(data69FIREDOOR_ATMOS69)
				var/datum/69as_mixture/69asses = data69FIREDOOR_ATMOS69
				if(69asses.temperature >= FIREDOOR_MAX_TEMP)
					alerts |= FIREDOOR_ALERT_HOT
					lockdown = TRUE
				if(69asses.temperature <= FIREDOOR_MIN_TEMP)
					alerts |= FIREDOOR_ALERT_COLD
					lockdown = TRUE
				if(69asses.return_pressure() <= FIREDOOR_MIN_PRESSURE)
					alerts |= FIREDOOR_ALERT_COLD
					lockdown = TRUE
				data69FIREDOOR_ALERT69 = alerts
			tile_info69cardinal_tar69et69 = data
	spawn(10) update_icon()
	return TRUE

	/*
		var/chan69ed = 0
		lockdown = 0



		tile_info = 69etCardinalAirInfo(src.loc,list("temperature","pressure"))
		var/old_alerts = dir_alerts
		for(var/index = 1; index <= 4; index++)
			var/list/tileinfo=tile_info69index69
			if(tileinfo==null)
				continue // Bad data.
			var/celsius = convert_k2c(tileinfo69169)

			var/alerts=0

			// Temperatures
			if(celsius >= FIREDOOR_MAX_TEMP)
				alerts |= FIREDOOR_ALERT_HOT
				lockdown = 1
			else if(celsius <= FIREDOOR_MIN_TEMP)
				alerts |= FIREDOOR_ALERT_COLD
				lockdown = 1

			dir_alerts69index69=alerts

		if(dir_alerts != old_alerts)
			chan69ed = 1
		if(chan69ed)
			update_icon()
		*/

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
		visible_messa69e("The69aintenance hatch of \the 69src69 closes.")
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
		if("openin69")
			flick("door_openin69", src)
			playsound(src, 'sound/machines/airlock_ext_open.o6969', 37, 1)
		if("closin69")
			flick("door_openin69", src)
			playsound(src, 'sound/machines/airlock_ext_close.o6969', 37, 1)
	return


/obj/machinery/door/firedoor/update_icon()
	cut_overlays()
	set_li69ht(0)
	var/do_set_li69ht = FALSE

	if(density)
		icon_state = "door_closed"
		if(hatch_open)
			overlays += "hatch"
		if(blocked)
			overlays += "welded"
			do_set_li69ht = TRUE
		for(var/cardinals in tile_info)
			var/tar69et_card = text2dir(cardinals)
			var/list/turf_data = tile_info69cardinals69
			if(turf_data69FIREDOOR_ALERT69)
				var/our_alert_color = (turf_data69FIREDOOR_ALERT69 & FIREDOOR_ALERT_HOT) ? 1 : 2
				overlays += new/icon(icon,"alert_69ALERT_STATES69our_alert_color6969", dir=tar69et_card)
		/*
		if(dir_alerts)
			for(var/d=1;d<=4;d++)
				var/cdir = cardinal69d69
				for(var/i=1;i<=ALERT_STATES.len;i++)
					if(dir_alerts69d69 & (1<<(i-1)))
						overlays += new/icon(icon,"alert_69ALERT_STATES69i6969", dir=cdir)
						do_set_li69ht = TRUE
		*/
	else
		icon_state = "door_open"
		if(blocked)
			overlays += "welded_open"

	if(do_set_li69ht)
		set_li69ht(1.5, 0.5, COLOR_SUN)


/obj/machinery/door/firedoor/multi_tile
	icon = 'icons/obj/doors/DoorHazard2x1.dmi'
	width = 2
