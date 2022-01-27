
/obj/machinery/shield
	name = "Emergency energy shield"
	desc = "An energy shield used to contain hull breaches."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shield-old"
	density = TRUE
	opacity = 0
	anchored = TRUE
	unacidable = 1
	var/const/max_health = 200
	var/health =69ax_health //The shield can only take so69uch beating (prevents perma-prisons)
	var/shield_generate_power = 7500	//how69uch power we use when regenerating
	var/shield_idle_power = 1500		//how69uch power we use when just being sustained.

/obj/machinery/shield/malfai
	name = "emergency forcefield"
	desc = "A powerful forcefield which seems to be projected by the69essel's emergency atmosphere containment field."
	health = 400

/obj/machinery/shield/proc/check_failure()
	if (health <= 0)
		visible_message(SPAN_NOTICE("\The 69src69 dissipates!"))
		69del(src)
		return

/obj/machinery/shield/New()
	set_dir(pick(1,2,3,4))
	..()
	update_nearby_tiles(need_rebuild=1)

/obj/machinery/shield/Destroy()
	update_nearby_tiles()
	. = ..()

/obj/machinery/shield/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(!height || air_group) return 0
	else return ..()

/obj/machinery/shield/attackby(obj/item/W as obj,69ob/user as69ob)
	if(!istype(W)) return

	//Calculate damage
	var/aforce = W.force
	if(W.damtype == BRUTE || W.damtype == BURN)
		src.health -= aforce

	//Play a fitting sound
	playsound(src.loc, 'sound/effects/EMPulse.ogg', 75, 1)

	check_failure()
	set_opacity(TRUE)
	spawn(20)
		if(src)
			set_opacity(FALSE)

	..()

/obj/machinery/shield/bullet_act(var/obj/item/projectile/Proj)
	health -= Proj.get_structure_damage()
	..()
	check_failure()
	set_opacity(TRUE)
	spawn(20)
		if(src)
			set_opacity(FALSE)

/obj/machinery/shield/ex_act(severity)
	switch(severity)
		if(1)
			if (prob(75))
				69del(src)
		if(2)
			if (prob(50))
				69del(src)
		if(3)
			if (prob(25))
				69del(src)
	return

/obj/machinery/shield/emp_act(severity)
	switch(severity)
		if(1)
			69del(src)
		if(2)
			if(prob(50))
				69del(src)
		if(3)
			if(prob(25))
				69del(src)


/obj/machinery/shield/hitby(AM as69ob|obj)
	//Let everyone know we've been hit!
	visible_message(SPAN_NOTICE("<B>The\ 69src69 was hit by 69AM69.</B>"))

	//Super realistic, resource-intensive, real-time damage calculations.
	var/tforce = 0
	if(ismob(AM))
		tforce = 40
	else
		tforce = AM:throwforce

	health -= tforce

	//This seemed to be the best sound for hitting a force field.
	playsound(loc, 'sound/effects/EMPulse.ogg', 100, 1)

	check_failure()

	//The shield becomes dense to absorb the blow.. purely asthetic.
	set_opacity(TRUE)
	spawn(20)
		if(src)
			set_opacity(FALSE)

	..()
	return
/obj/machinery/shieldgen
	name = "Emergency shield projector"
	desc = "Used to seal69inor hull breaches."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	density = TRUE
	opacity = 0
	anchored = FALSE
	re69_access = list(access_engine)
	var/const/max_health = 100
	var/health =69ax_health
	var/active = 0
	var/malfunction = 0 //Malfunction causes parts of the shield to slowly dissapate
	var/list/deployed_shields = list()
	var/list/regenerating = list()
	var/is_open = 0 //Whether or69ot the wires are exposed
	var/locked = 0
	var/check_delay = 60	//periodically recheck if we69eed to rebuild a shield
	use_power =69O_POWER_USE
	idle_power_usage = 0

/obj/machinery/shieldgen/Destroy()
	collapse_shields()
	. = ..()

/obj/machinery/shieldgen/proc/shields_up()
	if(active) return 0 //If it's already turned on, how did this get called?

	src.active = 1
	update_icon()

	create_shields()

	idle_power_usage = 0
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		idle_power_usage += shield_tile.shield_idle_power
	update_use_power(1)

/obj/machinery/shieldgen/proc/shields_down()
	if(!active) return 0 //If it's already off, how did this get called?

	src.active = 0
	update_icon()

	collapse_shields()

	update_use_power(0)

/obj/machinery/shieldgen/proc/create_shields()
	for(var/turf/target_tile in range(2, src))
		if (istype(target_tile,/turf/space) && !(locate(/obj/machinery/shield) in target_tile))
			if (malfunction && prob(33) || !malfunction)
				var/obj/machinery/shield/S =69ew/obj/machinery/shield(target_tile)
				deployed_shields += S
				use_power(S.shield_generate_power)

/obj/machinery/shieldgen/proc/collapse_shields()
	for(var/obj/machinery/shield/shield_tile in deployed_shields)
		69del(shield_tile)

/obj/machinery/shieldgen/power_change()
	..()
	if(!active) return
	if (stat &69OPOWER)
		collapse_shields()
	else
		create_shields()
	update_icon()

/obj/machinery/shieldgen/Process()
	if (!active || (stat &69OPOWER))
		return

	if(malfunction)
		if(deployed_shields.len && prob(5))
			69del(pick(deployed_shields))
	else
		if (check_delay <= 0)
			create_shields()

			var/new_power_usage = 0
			for(var/obj/machinery/shield/shield_tile in deployed_shields)
				new_power_usage += shield_tile.shield_idle_power

			if (new_power_usage != idle_power_usage)
				idle_power_usage =69ew_power_usage
				use_power(0)

			check_delay = 60
		else
			check_delay--

/obj/machinery/shieldgen/proc/checkhp()
	if(health <= 30)
		src.malfunction = 1
	if(health <= 0)
		spawn(0)
			explosion(get_turf(src.loc), 0, 0, 1, 0, 0, 0)
		69del(src)
	update_icon()
	return

/obj/machinery/shieldgen/ex_act(severity)
	switch(severity)
		if(1)
			src.health -= 75
			src.checkhp()
		if(2)
			src.health -= 30
			if (prob(15))
				src.malfunction = 1
			src.checkhp()
		if(3)
			src.health -= 10
			src.checkhp()
	return

/obj/machinery/shieldgen/emp_act(severity)
	switch(severity)
		if(1)
			src.health /= 2 //cut health in half
			malfunction = 1
			locked = pick(0,1)
		if(2)
			if(prob(50))
				src.health *= 0.3 //chop off a third of the health
				malfunction = 1
	checkhp()

/obj/machinery/shieldgen/attack_hand(mob/user as69ob)
	if(locked)
		to_chat(user, "The69achine is locked, you are unable to use it.")
		return
	if(is_open)
		to_chat(user, "The panel69ust be closed before operating this69achine.")
		return

	if (src.active)
		user.visible_message("\blue \icon69src69 69user69 deactivated the shield generator.", \
			"\blue \icon69src69 You deactivate the shield generator.", \
			"You hear heavy droning fade out.")
		src.shields_down()
	else
		if(anchored)
			user.visible_message("\blue \icon69src69 69user69 activated the shield generator.", \
				"\blue \icon69src69 You activate the shield generator.", \
				"You hear heavy droning.")
			src.shields_up()
		else
			to_chat(user, "The device69ust first be secured to the floor.")
	return

/obj/machinery/shieldgen/emag_act(var/remaining_charges,69ar/mob/user)
	if(!malfunction)
		malfunction = 1
		update_icon()
		return TRUE

/obj/machinery/shieldgen/attackby(obj/item/I,69ob/user)

	var/tool_type = I.get_tool_type(user, list(69UALITY_BOLT_TURNING, 69UALITY_SCREW_DRIVING), src)
	switch(tool_type)

		if(69UALITY_BOLT_TURNING)
			if(locked)
				to_chat(user, SPAN_NOTICE("The bolts are covered, unlocking this would retract the covers."))
				return
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC))
				if(anchored)
					to_chat(user, SPAN_NOTICE("You unsecure the 69src69 from the floor!"))
					if(active)
						to_chat(user, SPAN_NOTICE("The 69src69 shuts off!"))
						src.shields_down()
					anchored = FALSE
				else
					if(istype(get_turf(src), /turf/space)) return //No wrenching these in space!
					to_chat(user, SPAN_NOTICE("You secure the 69src69 to the floor!"))
					anchored = TRUE
			return

		if(69UALITY_SCREW_DRIVING)
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_MEC, instant_finish_tier = 30))
				is_open = !is_open
				to_chat(user, SPAN_NOTICE("You 69is_open ? "open" : "close"69 the panel of \the 69src69 with 69I69."))
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/cable_coil) &&69alfunction && is_open)
		var/obj/item/stack/cable_coil/coil = I
		to_chat(user, SPAN_NOTICE("You begin to replace the wires."))
		if(do_after(user, 30,src))
			if (coil.use(1))
				health =69ax_health
				malfunction = 0
				to_chat(user, SPAN_NOTICE("You repair the 69src69!"))
				update_icon()

	else if(istype(I, /obj/item/card/id) || istype(I, /obj/item/modular_computer))
		if(src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "The controls are69ow 69src.locked ? "locked." : "unlocked."69")
		else
			to_chat(user, SPAN_WARNING("Access denied."))

	else
		..()


/obj/machinery/shieldgen/update_icon()
	if(active && !(stat &69OPOWER))
		src.icon_state =69alfunction ? "shieldonbr":"shieldon"
	else
		src.icon_state =69alfunction ? "shieldoffbr":"shieldoff"
	return
