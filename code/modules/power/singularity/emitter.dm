#define EMITTER_DAMAGE_POWER_TRANSFER 450 //used to transfer power to containment field generators

/obj/machinery/power/emitter
	name = "emitter"
	desc = "It is a heavy duty industrial laser."
	icon = 'icons/obj/singularity.dmi'
	icon_state = "emitter"
	anchored = FALSE
	density = TRUE
	req_access = list(access_engine_equip)
	var/id = null

	use_power = NO_POWER_USE	//uses powernet power, not APC power
	active_power_usage = 30000	//30 kW laser. I guess that means 30 kJ per shot.

	///Is the machine active?
	var/active = FALSE
	///Does the machine have power?
	var/powered = FALSE
	///Seconds before the next shot
	var/fire_delay = 10 SECONDS
	///Max delay before firing
	var/maximum_fire_delay = 10 SECONDS
	///Min delay before firing
	var/minimum_fire_delay = 2 SECONDS
	var/max_burst_delay = 100
	var/min_burst_delay = 20
	var/burst_shots = 3
	var/last_shot = 0
	var/shot_number = 0
	var/state = 0
	var/locked = 0
	///What's the projectile sound?
	var/projectile_sound = 'sound/weapons/emitter.ogg'
	///Sparks emitted with every shot
	var/datum/effect/effect/system/spark_spread/sparks
	// The following 3 vars are mostly for the prototype
	///manual shooting? (basically you hop onto the emitter and choose the shooting direction, is very janky since you can only shoot at the 8 directions and i don't think is ever used since you can't build those)
	var/manual = FALSE
	///Amount of power inside
	var/charge = 0

	var/_wifi_id
	var/datum/wifi/receiver/button/emitter/wifi_receiver

/obj/machinery/power/emitter/anchored
	anchored = TRUE
	state = 2

/obj/machinery/power/emitter/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in oview(1)

	if (src.anchored || usr:stat)
		to_chat(usr, "It is fastened to the floor!")
		return 0
	src.set_dir(turn(src.dir, 90))
	return 1

/obj/machinery/power/emitter/Initialize()
	. = ..()
	if(state == 2 && anchored)
		connect_to_network()
		if(_wifi_id)
			wifi_receiver = new(_wifi_id, src)

/obj/machinery/power/emitter/Destroy()
	if(SSticker.IsRoundInProgress())
		var/turf/T = get_turf(src)
		message_admins("Emitter deleted at [ADMIN_VERBOSEJMP(T)]")
		log_game("Emitter deleted at [AREACOORD(T)]")
		investigate_log("<font color='red'>deleted</font> at [AREACOORD(T)]", INVESTIGATE_SINGULO)
	QDEL_NULL(wifi_receiver)
	return ..()

/obj/machinery/power/emitter/on_update_icon()
	if (active && powernet && avail(active_power_usage))
		icon_state = "emitter_+a"
	else
		icon_state = "emitter"

/obj/machinery/power/emitter/attack_hand(mob/user as mob)
	src.add_fingerprint(user)
	activate(user)

/obj/machinery/power/emitter/proc/activate(mob/user as mob)
	if(state == 2)
		if(!powernet)
			to_chat(user, "\The [src] isn't connected to a wire.")
			return 1
		if(!src.locked)
			if(src.active==1)
				src.active = 0
				to_chat(user, "You turn off [src].")
				message_admins("Emitter turned off by [key_name(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
				log_game("Emitter turned off by [user.ckey]([user]) in ([x],[y],[z])")
				investigate_log("turned <font color='red'>off</font> by [user.key]","singulo")
			else
				src.active = 1
				to_chat(user, "You turn on [src].")
				src.shot_number = 0
				src.fire_delay = 100
				message_admins("Emitter turned on by [key_name(user, user.client)](<A HREF='?_src_=holder;adminmoreinfo=\ref[user]'>?</A>) in ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
				log_game("Emitter turned on by [user.ckey]([user]) in ([x],[y],[z])")
				investigate_log("turned <font color='green'>on</font> by [user.key]","singulo")
			playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
			update_icon()
		else
			to_chat(user, SPAN_WARNING("The controls are locked!"))
	else
		to_chat(user, SPAN_WARNING("\The [src] needs to be firmly secured to the floor first."))
		return 1


/obj/machinery/power/emitter/emp_act(var/severity)//Emitters are hardened but still might have issues
//	add_load(1000)
/*	if((severity == 1)&&prob(1)&&prob(1))
		if(src.active)
			src.active = 0
			src.use_power = IDLE_POWER_USE	*/
	return 1

/obj/machinery/power/emitter/process(delta_time)
	if(stat & (BROKEN))
		return
	if(state != 2 || (!powernet && active_power_usage))
		active = 0
		update_icon()
		return
	if(!active)
		return
	// dont actualy pull 30KW, calc it first
	if(active_power_usage && surplus() < active_power_usage)
		if(powered)
			powered = FALSE
			update_icon()
			investigate_log("lost power and turned <font color='red'>OFF</font> at [AREACOORD(src)]", INVESTIGATE_SINGULO)
			log_game("Emitter lost power in [AREACOORD(src)]")
		return

	// ok now we can draw power
	draw_power(active_power_usage)
	if(!powered)
		powered = TRUE
		update_icon()
		investigate_log("regained power and turned <font color='green'>ON</font> at [AREACOORD(src)]", INVESTIGATE_SINGULO)
	if(charge <= 80)
		charge += 2.5 * delta_time
	if(!check_delay() || manual == TRUE)
		return FALSE
	fire_beam()

/obj/machinery/power/emitter/proc/check_delay()
	if((last_shot + fire_delay) <= world.time)
		return TRUE
	return FALSE

/obj/machinery/power/emitter/proc/fire_beam(mob/user)
	var/obj/item/projectile/beam/projectile = new /obj/item/projectile/beam/emitter(get_turf(src))
	playsound(src, projectile_sound, 50, TRUE)
	if(prob(35))
		sparks.start()
	//need to calculate the power per shot as the emitter doesn't fire continuously.
	var/burst_time = (min_burst_delay + max_burst_delay)/2 + 2*(burst_shots-1)
	var/power_per_shot = active_power_usage * (burst_time/10) / burst_shots
	// projectile.firer = user ? user : src
	// projectile.fired_from = src
	// if(last_projectile_params)
	// 	projectile.p_x = last_projectile_params[2]
	// 	projectile.p_y = last_projectile_params[3]
	// 	projectile.fire(last_projectile_params[1])
	// else
	// 	projectile.fire(dir2angle(dir))
	projectile.damage_types[BURN] = round(power_per_shot/EMITTER_DAMAGE_POWER_TRANSFER)
	projectile.launch( get_step(src.loc, src.dir) )
	if(!manual)
		last_shot = world.time
		if(shot_number < 3)
			fire_delay = 20
			shot_number ++
		else
			fire_delay = rand(minimum_fire_delay,maximum_fire_delay)
			shot_number = 0
	return projectile

/obj/machinery/power/emitter/attackby(obj/item/I, mob/user)

	var/list/usable_qualities = list(QUALITY_BOLT_TURNING)
	if(state)
		usable_qualities.Add(QUALITY_WELDING)


	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)

		if(QUALITY_BOLT_TURNING)
			if(active)
				to_chat(user, SPAN_WARNING("Turn off [src] first."))
				return
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				state = !state
				anchored = !anchored
				user.visible_message("[user.name] [anchored? "un":""]secures [src] reinforcing bolts [anchored? "to":"from"] the floor.", \
					"You [anchored? "secure":"undo"] the external reinforcing bolts.", \
					"You hear a ratchet")
			return

		if(QUALITY_WELDING)
			if(active)
				to_chat(user, "Turn off [src] first.")
				return
			switch(state)
				if(0)
					to_chat(user, SPAN_WARNING("\The [src] needs to be wrenched to the floor."))
					return
				if(1)
					if (I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
						state = 2
						to_chat(user, SPAN_NOTICE("You weld [src] to the floor."))
						connect_to_network()
						return
				if(2)
					if (I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
						state = 1
						to_chat(user, SPAN_NOTICE("You cut [src] free from the floor."))
						disconnect_from_network()
						return
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/weapon/card/id) || istype(I, /obj/item/modular_computer))
		if(emagged)
			to_chat(user, SPAN_WARNING("The lock seems to be broken!"))
			return
		if(src.allowed(user))
			if(active)
				src.locked = !src.locked
				to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
			else
				src.locked = 0 //just in case it somehow gets locked
				to_chat(user, SPAN_WARNING("The controls can only be locked when [src] is online."))
		else
			to_chat(user, SPAN_WARNING("Access denied."))
		return
	..()
	return

/obj/machinery/power/emitter/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		locked = 0
		emagged = 1
		user.visible_message("[user.name] swipes an emag on [src]. It crackles and sparks violently.",SPAN_WARNING("You short out the lock. It crackles and sparks violently."))
		return 1
