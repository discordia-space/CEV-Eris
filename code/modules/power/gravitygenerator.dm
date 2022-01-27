//
// Gravity Generator
//
GLOBAL_DATUM(active_gravity_generator, /obj/machinery/gravity_generator/main)
var/const/POWER_IDLE = 0
var/const/POWER_UP = 1
var/const/POWER_DOWN = 2
var/const/PULSE_FREQ = 9 SECONDS

var/const/GRAV_NEEDS_SCREWDRIVER = 0
var/const/GRAV_NEEDS_WELDING = 1
var/const/GRAV_NEEDS_PLASTEEL = 2
var/const/GRAV_NEEDS_WRENCH = 3

//
// Abstract Generator
//

/obj/machinery/gravity_generator
	name = "gravitational generator"
	desc = "A device which produces a gravaton field when set up."
	icon = 'icons/obj/machines/gravity_generator.dmi'
	anchored = TRUE
	density = TRUE
	use_power =69O_POWER_USE
	unacidable = 1
	var/sprite_number = 0

/obj/machinery/gravity_generator/ex_act(severity, target)
	if(severity == 1) //69ery sturdy.
		set_broken()

/obj/machinery/gravity_generator/update_icon()
	..()

/obj/machinery/gravity_generator/proc/get_status()
	return "off"

// You aren't allowed to69ove.
/obj/machinery/gravity_generator/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/glide_size_override = 0)
	. = ..()
	qdel(src)

/obj/machinery/gravity_generator/proc/set_broken()
	stat |= BROKEN

/obj/machinery/gravity_generator/proc/set_fix()
	stat &= ~BROKEN

/obj/machinery/gravity_generator/part/Destroy()
	set_broken()
	if(main_part)
		qdel(main_part)
	. = ..()

//
// Part generator which is69ostly there for looks
//

/obj/machinery/gravity_generator/part
	var/obj/machinery/gravity_generator/main/main_part =69ull

/obj/machinery/gravity_generator/part/attackby(obj/item/I as obj,69ob/user as69ob, params)
	return69ain_part.attackby(I, user)

/obj/machinery/gravity_generator/part/get_status()
	return69ain_part.get_status()

/obj/machinery/gravity_generator/part/attack_hand(mob/user as69ob)
	return69ain_part.attack_hand(user)

/obj/machinery/gravity_generator/part/set_broken()
	..()
	if(main_part && !(main_part.stat & BROKEN))
		main_part.set_broken()

//
// Generator which spawns with the station.
//

/obj/machinery/gravity_generator/main/station/Initialize()
	. = ..()
	//Set ourselves in the global69ar
	if (!GLOB.active_gravity_generator)
		GLOB.active_gravity_generator = src

//
// Generator an admin can spawn
//

/obj/machinery/gravity_generator/main/station/admin/Initialize()
	. = ..()
	grav_on()

//
//69ain Generator with the69ain code
//

/obj/machinery/gravity_generator/main
	icon_state = "main"
	pixel_x = -16
	pixel_y = -16
	idle_power_usage = 0
	active_power_usage = 3000
	power_channel = STATIC_ENVIRON
	sprite_number = 8
	use_power = IDLE_POWER_USE
	interact_offline = 1
	var/on = TRUE
	var/breaker = 1
	var/obj/middle =69ull
	var/charging_state = POWER_IDLE
	var/charge_count = 100
	var/current_overlay =69ull
	var/broken_state = 0

/obj/machinery/gravity_generator/main/Destroy() // If we somehow get deleted, remove all of our other parts.
	investigate_log("was destroyed!", "gravity")
	on = FALSE
	grav_off()
	. = ..()

/obj/machinery/gravity_generator/main/set_broken()
	..()
	middle.cut_overlays()
	charge_count = 0
	breaker = 0
	grav_off()
	set_power()
	set_state(0)
	investigate_log("has broken down.", "gravity")

/obj/machinery/gravity_generator/main/set_fix()
	..()
	broken_state = 0
	update_icon()
	set_power()

// Interaction

// Fixing the gravity generator.
/obj/machinery/gravity_generator/main/attackby(obj/item/I,69ob/user, params)
	var/old_broken_state = broken_state

	var/list/usable_qualities = list()
	if(GRAV_NEEDS_WRENCH)
		usable_qualities.Add(QUALITY_BOLT_TURNING)
	if(GRAV_NEEDS_WELDING)
		usable_qualities.Add(QUALITY_WELDING)
	if(GRAV_NEEDS_SCREWDRIVER)
		usable_qualities.Add(QUALITY_SCREW_DRIVING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)

		if(QUALITY_BOLT_TURNING)
			if(GRAV_NEEDS_WRENCH)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You secure the plating to the framework."))
					set_fix()
					return
			return

		if(QUALITY_WELDING)
			if(GRAV_NEEDS_WELDING)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You69end the damaged framework."))
					broken_state++
					return
			return

		if(QUALITY_SCREW_DRIVING)
			if(GRAV_NEEDS_SCREWDRIVER)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You secure the screws of the framework."))
					broken_state++
					return
			return

		if(ABORT_CHECK)
			return

	if(GRAV_NEEDS_PLASTEEL)
		if(istype(I, /obj/item/stack/material/plasteel))
			var/obj/item/stack/material/plasteel/PS = I
			if(PS.amount >= 10)
				PS.use(10)
				to_chat(user, SPAN_NOTICE("You add the plating to the framework."))
				playsound(src.loc, 'sound/machines/click.ogg', 75, 1)
				broken_state++
			else
				to_chat(user, SPAN_WARNING("You69eed 10 sheets of plasteel!"))
	if(old_broken_state != broken_state)
		update_icon()
	else
		..()

/obj/machinery/gravity_generator/main/attack_hand(mob/user as69ob)
	if(!..())
		return interact(user)

/obj/machinery/gravity_generator/main/interact(mob/user as69ob)
	if(stat & BROKEN)
		return
	var/dat = "Gravity Generator Breaker: "
	if(breaker)
		dat += "<span class='linkOn'>ON</span> <A href='?src=\ref69src69;gentoggle=1'>OFF</A>"
	else
		dat += "<A href='?src=\ref69src69;gentoggle=1'>ON</A> <span class='linkOn'>OFF</span> "

	dat += "<br>Generator Status:<br><div class='statusDisplay'>"
	if(charging_state != POWER_IDLE)
		dat += "<font class='bad'>WARNING</font> Radiation Detected. <br>69charging_state == POWER_UP ? "Charging..." : "Discharging..."69"
	else if(on)
		dat += "Powered."
	else
		dat += "Unpowered."

	dat += "<br>Gravity Charge: 69charge_count69%</div>"

	var/datum/browser/popup =69ew(user, "gravgen",69ame)
	popup.set_content(dat)
	popup.open()


/obj/machinery/gravity_generator/main/Topic(href, href_list)

	if(..())
		return

	if(href_list69"gentoggle"69)
		breaker = !breaker
		investigate_log("was toggled 69breaker ? "<font color='green'>ON</font>" : "<font color='red'>OFF</font>"69 by 69usr.key69.", "gravity")
		set_power()
		src.updateUsrDialog()

// Power and Icon States

/obj/machinery/gravity_generator/main/power_change()
	..()
	investigate_log("has 69stat &69OPOWER ? "lost" : "regained"69 power.", "gravity")
	set_power()

/obj/machinery/gravity_generator/main/get_status()
	if(stat & BROKEN)
		return "fix69min(broken_state, 3)69"
	return on || charging_state != POWER_IDLE ? "on" : "off"

/obj/machinery/gravity_generator/main/update_icon()
	..()

// Set the charging state based on power/breaker.
/obj/machinery/gravity_generator/main/proc/set_power()
	var/new_state = 0
	if(stat & (NOPOWER|BROKEN) || !breaker)
		new_state = 0
	else if(breaker)
		new_state = 1

	charging_state =69ew_state ? POWER_UP : POWER_DOWN // Startup sequence animation.
	investigate_log("is69ow 69charging_state == POWER_UP ? "charging" : "discharging"69.", "gravity")
	update_icon()

// Set the state of the gravity.
/obj/machinery/gravity_generator/main/proc/set_state(var/new_state)
	if(new_state == on)
		var/pulse = 0.5 * sin(2 *69_PI * PULSE_FREQ * world.time) + 0.5
		set_light(3+pulse, 3+pulse, "#8AD55D")
		return
	on =69ew_state
	charging_state = POWER_IDLE
	use_power = on ? 2 : 1
	if(new_state) // If we turned on
		grav_on()
	else
		grav_off()
		set_light(0)
	update_icon()
	src.updateUsrDialog()

/obj/machinery/gravity_generator/main/proc/grav_on()
	if(!GLOB.maps_data.station_levels.len)
		message_admins("GLOB.maps_data.station_levels is blank. Gravgen isn't properly established.")
		return

	gravity_is_on = 1
	update_gravity(gravity_is_on)
	priority_announcement.Announce("The gravity generator was brought fully operational.")
	investigate_log("was brought full online and is69ow producing gravity.", "gravity")
	var/area/area = get_area(src)
	message_admins("The gravity generator was brought fully online. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69x69;Y=69y69;Z=69z69'>69area.name69</a>)")

/obj/machinery/gravity_generator/main/proc/grav_off()
	if(!GLOB.maps_data.station_levels.len)
		message_admins("GLOB.maps_data.station_levels is blank. Gravgen isn't properly established.")
		return

	gravity_is_on = 0
	update_gravity(gravity_is_on)
	priority_announcement.Announce("The gravity generator was brought offline.")
	investigate_log("was brought offline and there is69ow69o gravity.", "gravity")
	var/area/area = get_area(src)
	message_admins("The gravity generator was brought offline with69o backup generator. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=69x69;Y=69y69;Z=69z69'>69area.name69</a>)")
	shake_everyone()

/obj/machinery/gravity_generator/main/proc/update_gravity(var/is_on)
	for(var/area/A in world)
		if(isStationLevel(A.z))
			A.update_gravity()

// Charge/Discharge and turn on/off gravity when you reach 0/100 percent.
// Also emit radiation and handle the overlays.
/obj/machinery/gravity_generator/main/Process()
	if(stat & BROKEN)
		return
	if(charging_state != POWER_IDLE)
		if(charging_state == POWER_UP && charge_count >= 100)
			set_state(1)
		else if(charging_state == POWER_DOWN && charge_count <= 0)
			set_state(0)
		else
			if(charging_state == POWER_UP)
				charge_count += 2

			else if(charging_state == POWER_DOWN)
				charge_count -= 2

			if(charge_count % 4 == 0 && prob(75)) // Let them know it is charging/discharging.
				playsound(src.loc, 'sound/effects/EMPulse.ogg', 100, 1)

			updateDialog()
			if(prob(25)) // To help stop "Your clothes feel warm." spam.
				pulse_radiation()


/obj/machinery/gravity_generator/main/proc/pulse_radiation()
	for(var/mob/living/L in69iew(7, src))
		L.apply_effect(20, IRRADIATE)

// Shake everyone to let them know that gravity was enagaged/disenagaged.
/obj/machinery/gravity_generator/main/proc/shake_everyone()
	for(var/mob/M in SSmobs.mob_list)
		var/turf/our_turf = get_turf(src.loc)
		if(M.client)
			shake_camera(M, 15, 1)
			M.playsound_local(our_turf, 'sound/effects/alert.ogg', 100, 1, 0.5)

//69isc
/obj/item/paper/gravity_gen
	name = "paper- 'Generate your own gravity!'"
	info = {"<h1>Gravity Generator Instructions For Dummies</h1>
	<p>Surprisingly, gravity isn't that hard to69ake! All you have to do is inject deadly radioactive69inerals into a ball of
	energy and you have yourself gravity! You can turn the69achine on or off when required but you69ust remember that the generator
	will EMIT RADIATION when charging or discharging, you can tell it is charging or discharging by the69oise it69akes, so please WEAR PROTECTIVE CLOTHING.</p>
	<br>
	<h3>It blew up!</h3>
	<p>Don't panic! The gravity generator was designed to be easily repaired. If, somehow, the sturdy framework did69ot survive then
	please proceed to panic; otherwise follow these steps.</p><ol>
	<li>Secure the screws of the framework with a screwdriver.</li>
	<li>Mend the damaged framework with a welding tool.</li>
	<li>Add additional plasteel plating.</li>
	<li>Secure the additional plating with a wrench.</li></ol>"}
