////FIELD GEN START //shameless copypasta from fieldgen, powersink, and grille
/obj/machinery/shieldwallgen
		name = "shield generator"
		desc = "A shield generator."
		icon = 'icons/obj/stationobjs.dmi'
		icon_state = "Shield_Gen"
		anchored = FALSE
		density = TRUE
		re69_access = list(access_engine_e69uip)
		circuit = /obj/item/electronics/circuitboard/shieldwallgen
		var/shield_type = /obj/machinery/shieldwall //Overridden by excelsior69ariant
		var/active = 0
		var/power = 0
		var/state = 0
		var/steps = 0
		var/last_check = 0
		var/check_delay = 10
		var/recalc = 0
		var/locked = 1
		var/destroyed = 0
		var/directwired = 1
//		var/maxshieldload = 200
		var/obj/structure/cable/attached		// the attached cable
		var/storedpower = 0
		flags = CONDUCT
		//There have to be at least two posts, so these are effectively doubled
		var/power_draw = 30000 //30 kW. How69uch power is drawn from powernet. Increase this to allow the generator to sustain longer shields, at the cost of69ore power draw.
		var/max_stored_power = 50000 //50 kW
		use_power =69O_POWER_USE	//Draws directly from power69et. Does69ot use APC power.
		var/max_field_dist = 8
		var/stunmode = FALSE
		var/stun_chance = 1

/obj/machinery/shieldwallgen/attack_hand(mob/user as69ob)
	if(state != 1)
		to_chat(user, "\red \The 69src6969eeds to be firmly secured to the floor first.")
		return 1
	if(src.locked && !issilicon(user))
		to_chat(user, "\red The controls are locked!")
		return 1
	if(power != 1)
		to_chat(user, "\red \The 69src6969eeds to be powered by wire underneath.")
		return 1

	if(src.active >= 1)
		src.active = 0

		user.visible_message("69user69 turned \the 69src69 off.", \
			"You turn off \the 69src69.", \
			"You hear heavy droning fade out.")
		for(var/dir in list(1,2,4,8)) src.cleanup(dir)
	else
		src.active = 1
		user.visible_message("69user69 turned \the 69src69 on.", \
			"You turn on \the 69src69.", \
			"You hear heavy droning.")
	src.add_fingerprint(user)
	playsound(loc, 'sound/machines/machine_switch.ogg', 100, 1)
	update_icon()

/obj/machinery/shieldwallgen/proc/power()
	if(!anchored)
		power = 0
		return 0
	var/turf/T = src.loc

	var/obj/structure/cable/C = T.get_cable_node()
	var/datum/powernet/PN
	if(C)
		PN = C.powernet		// find the powernet of the connected cable

	if(!PN)
		power = 0
		return 0

	var/shieldload = between(500,69ax_stored_power - storedpower, power_draw)	//what we try to draw
	shieldload = PN.draw_power(shieldload) //what we actually get
	storedpower += shieldload

	//If we're still in the red, then there69ust69ot be enough available power to cover our load.
	if(storedpower <= 0)
		power = 0
		return 0

	power = 1	// IVE GOT THE POWER!
	return 1

/obj/machinery/shieldwallgen/update_icon()
	icon_state = "Shield_Gen"
	if(active)
		icon_state = "Shield_Gen_active"
		if(stunmode)
			icon_state = "Shield_Gen_emagged"

	overlays.Cut()
	if(panel_open)
		overlays.Add(image(icon,"Shield_Gen_panel"))

/obj/machinery/shieldwallgen/Process()
	power()

	if(power)
		storedpower -= 2500 //the generator post itself uses some power

	if(storedpower >=69ax_stored_power)
		storedpower =69ax_stored_power
	if(storedpower <= 0)
		storedpower = 0

	if(active)
		if(!state)
			active = FALSE
			for(var/fdir in cardinal)
				cleanup(fdir)
			return

		if(!stunmode)
			for(var/fdir in cardinal)
				setup_field(fdir)
		else
			stun()


		if(!power)
			visible_message("\red The 69src.name69 shuts down due to lack of power!", \
				"You hear heavy droning fade out")
			active = FALSE
			for(var/fdir in cardinal)
				cleanup(fdir)

			update_icon()

/obj/machinery/shieldwallgen/proc/stun()
	for(var/mob/M in range(src,max_field_dist))
		if(can_stun(M) && prob(stun_chance))
			var/obj/item/projectile/beam/stun/P =69ew(src.loc)
			P.shot_from = src
			P.launch(M)

/obj/machinery/shieldwallgen/proc/can_stun(var/mob/M)
	return TRUE


/obj/machinery/shieldwallgen/proc/setup_field(var/f_dir = 0)
	if(!f_dir)//Make sure its ran right
		return

	var/field_found = 0
	var/turf/T = src.loc
	var/obj/machinery/shieldwallgen/G =69ull
	for(var/dist = 1, dist <=69ax_field_dist, dist += 1) // checks out to 69max_field_dist69 tiles away for another generator
		T = get_step(T, f_dir)

		var/obj/machinery/shieldwall/F = locate(/obj/machinery/shieldwall) in T
		if(F && (F.dir == f_dir || F.dir == reverse_dir69f_dir69))
			field_found++

		G = (locate(/obj/machinery/shieldwallgen) in T)

		if(G && G.active && !G.stunmode)
			break
		else
			G =69ull

	if(isnull(G))
		return

	if(field_found > 0)	//if we already have the field
		if(field_found < get_dist(src, G)-1)	//but it breached
			cleanup(f_dir)
		else
			return

	T = src.loc
	for(var/dist = 1, dist <= get_dist(src, G)-1, dist += 1) // creates each field tile
		T = get_step(T, f_dir)
		var/obj/machinery/shieldwall/CF =69ew shield_type(src, G) //(ref to this gen, ref to connected gen)
		CF.loc = T
		CF.set_dir(f_dir)


/obj/machinery/shieldwallgen/proc/cleanup(var/c_dir)

	var/turf/T = src.loc

	for(var/dist = 1, dist <=69ax_field_dist, dist += 1) // checks out to 8 tiles away for fields
		T = get_step(T, c_dir)

		var/obj/machinery/shieldwall/F = locate(/obj/machinery/shieldwall) in T
		if(F && (F.dir == c_dir || F.dir == reverse_dir69c_dir69))
			69del(F)

		var/obj/machinery/shieldwallgen/G = (locate(/obj/machinery/shieldwallgen) in T)
		if(G && G.active && !G.stunmode)
			break


/obj/machinery/shieldwallgen/attackby(obj/item/I,69ob/user)

	if(default_deconstruction(I, user))
		return

	if(default_part_replacement(I, user))
		return


	if(69UALITY_BOLT_TURNING in I.tool_69ualities)
		if(I.use_tool(user, src, WORKTIME_FAST, 69UALITY_BOLT_TURNING, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
			if(active)
				to_chat(user, "Turn off the field generator first.")
				return

			else if(!state)
				state = TRUE
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				to_chat(user, "You secure the external reinforcing bolts to the floor.")
				src.anchored = TRUE
				return

			else
				state = FALSE
				playsound(src.loc, 'sound/items/Ratchet.ogg', 75, 1)
				to_chat(user, "You undo the external reinforcing bolts.")
				src.anchored = FALSE
				return

	if(istype(I, /obj/item/card/id) || istype(I, /obj/item/modular_computer))
		if (src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "Controls are69ow 69src.locked ? "locked." : "unlocked."69")
		else
			to_chat(user, "\red Access denied.")

	else
		src.add_fingerprint(user)
		visible_message("\red The 69src.name69 has been hit with \the 69I.name69 by 69user.name69!")


/obj/machinery/shieldwallgen/emag_act()
	stunmode = TRUE

/obj/machinery/shieldwallgen/Destroy()
	src.cleanup(NORTH)
	src.cleanup(SOUTH)
	src.cleanup(WEST)
	src.cleanup(EAST)
	. = ..()

/obj/machinery/shieldwallgen/bullet_act(var/obj/item/projectile/Proj)
	storedpower -= 400 * Proj.get_structure_damage()
	..()
	return

/obj/machinery/shieldwallgen/emag_act()
	stunmode = TRUE
	return

//////////////Containment Field START
/obj/machinery/shieldwall
		name = "Shield"
		desc = "An energy shield."
		icon = 'icons/effects/effects.dmi'
		icon_state = "shieldwall"
		anchored = TRUE
		density = TRUE
		unacidable = 1
		light_range = 3
		var/needs_power = 0
		var/active = 1
//		var/power = 10
		var/delay = 5
		var/last_active
		var/mob/U
		var/obj/machinery/shieldwallgen/gen_primary
		var/obj/machinery/shieldwallgen/gen_secondary
		var/power_usage = 2500	//how69uch power it takes to sustain the shield
		var/generate_power_usage = 7500	//how69uch power it takes to start up the shield

/obj/machinery/shieldwall/New(var/obj/machinery/shieldwallgen/A,69ar/obj/machinery/shieldwallgen/B)
	..()
	update_nearby_tiles()
	src.gen_primary = A
	src.gen_secondary = B
	if(A && B && A.active && B.active)
		needs_power = 1
		if(prob(50))
			A.storedpower -= generate_power_usage
		else
			B.storedpower -= generate_power_usage
	else
		69del(src) //need at least two generator posts

/obj/machinery/shieldwall/Destroy()
	update_nearby_tiles()
	. = ..()

/obj/machinery/shieldwall/attack_hand(mob/user as69ob)
	return


/obj/machinery/shieldwall/Process()
	if(needs_power)
		if(isnull(gen_primary)||isnull(gen_secondary))
			69del(src)
			return

		if(!(gen_primary.active) || !(gen_secondary.active) || (gen_primary.stunmode) || (gen_secondary.stunmode))
			69del(src)
			return

		if(prob(50))
			gen_primary.storedpower -= power_usage
		else
			gen_secondary.storedpower -= power_usage


/obj/machinery/shieldwall/bullet_act(var/obj/item/projectile/Proj)
	if(needs_power)
		var/obj/machinery/shieldwallgen/G
		if(prob(50))
			G = gen_primary
		else
			G = gen_secondary
		G.storedpower -= 400 * Proj.get_structure_damage()
	..()
	return


/obj/machinery/shieldwall/ex_act(severity)
	if(needs_power)
		var/obj/machinery/shieldwallgen/G
		switch(severity)
			if(1) //big boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= 120000

			if(2) //medium boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= 30000

			if(3) //lil boom
				if(prob(50))
					G = gen_primary
				else
					G = gen_secondary
				G.storedpower -= 12000
	return


/obj/machinery/shieldwall/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0)) return 1

	if(istype(mover) &&69over.checkpass(PASSGLASS))
		return prob(20)
	else
		if (istype(mover, /obj/item/projectile))
			return prob(10)
		else
			return !src.density
