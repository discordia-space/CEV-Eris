
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
	var/health = max_health //The shield can only take so much beating (prevents perma-prisons)
	var/shield_generate_power = 7500	//how much power we use when regenerating
	var/shield_idle_power = 1500		//how much power we use when just being sustained.

/obj/machinery/shield/malfai
	name = "emergency forcefield"
	desc = "A powerful forcefield which seems to be projected by the vessel's emergency atmosphere containment field."
	health = 400

/obj/machinery/shield/proc/check_failure()
	if (health <= 0)
		visible_message(SPAN_NOTICE("\The [src] dissipates!"))
		qdel(src)
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

/obj/machinery/shield/attackby(obj/item/weapon/W as obj, mob/user as mob)
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
				qdel(src)
		if(2)
			if (prob(50))
				qdel(src)
		if(3)
			if (prob(25))
				qdel(src)
	return

/obj/machinery/shield/emp_act(severity)
	switch(severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(50))
				qdel(src)


/obj/machinery/shield/hitby(AM as mob|obj)
	//Let everyone know we've been hit!
	visible_message(SPAN_NOTICE("<B>The\ [src] was hit by [AM].</B>"))

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
	desc = "Used to seal minor hull breaches."
	icon = 'icons/obj/objects.dmi'
	icon_state = "shieldoff"
	density = TRUE
	opacity = FALSE
	anchored = FALSE
	req_access = list(access_engine)
	use_power = NO_POWER_USE
	idle_power_usage = 0
	var/const/max_health = 100
	var/health = max_health
	var/active = FALSE
	var/list/deployed_shields
	var/locked = FALSE
	var/malfunction = 0 //Malfunction causes parts of the shield to slowly dissapate
	var/list/regenerating = list()
	var/is_open = 0 //Whether or not the wires are exposed
	var/check_delay = 60	//periodically recheck if we need to rebuild a shield

/obj/machinery/shieldgen/Initialize(mapload)
	. = ..()
	deployed_shields = list()
	if(mapload && active && anchored)
		shields_up()

/obj/machinery/shieldgen/Destroy()
	QDEL_LIST(deployed_shields)
	return ..()

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
	active = TRUE
	update_icon()

	for(var/turf/target_tile as anything in RANGE_TURFS(2, src))
		if(istype(target_tile,/turf/space) && !(locate(/obj/machinery/shield) in target_tile))
			if(!(stat & BROKEN) || prob(33))
				var/obj/machinery/shield/S = new /obj/machinery/shield(target_tile)
				deployed_shields += S
				use_power(S.shield_generate_power)

/obj/machinery/shieldgen/proc/collapse_shields()
	active = FALSE
	update_icon()
	QDEL_LIST(deployed_shields)

/obj/machinery/shieldgen/process(delta_time)
	if(((stat & BROKEN) || malfunction) && active)
		if(deployed_shields.len && DT_PROB(2.5, delta_time))
			qdel(pick(deployed_shields))

/obj/machinery/shieldgen/proc/checkhp()
	if(health <= 30)
		src.malfunction = 1
	if(health <= 0)
		spawn(0)
			explosion(get_turf(src.loc), 0, 0, 1, 0, 0, 0)
		qdel(src)
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

/obj/machinery/shieldgen/interact(mob/user)
	. = ..()
	if(.)
		return
	if(locked)
		to_chat(user, "<span class='warning'>The machine is locked, you are unable to use it!</span>")
		return
	if(is_open)
		to_chat(user, "<span class='warning'>The panel must be closed before operating this machine!</span>")
		return

	if (active)
		user.visible_message("<span class='notice'>[user] deactivated \the [src].</span>", \
			"<span class='notice'>You deactivate \the [src].</span>", \
			"<span class='hear'>You hear heavy droning fade out.</span>")
		shields_down()
	else
		if(anchored)
			user.visible_message("<span class='notice'>[user] activated \the [src].</span>", \
				"<span class='notice'>You activate \the [src].</span>", \
				"<span class='hear'>You hear heavy droning.</span>")
			shields_up()
		else
			to_chat(user, "<span class='warning'>The device must first be secured to the floor!</span>")
	return

/obj/machinery/shieldgen/emag_act(var/remaining_charges, var/mob/user)
	if(!malfunction)
		malfunction = 1
		update_icon()
		return TRUE

/obj/machinery/shieldgen/attackby(obj/item/I, mob/user)

	var/tool_type = I.get_tool_type(user, list(QUALITY_BOLT_TURNING, QUALITY_SCREW_DRIVING), src)
	switch(tool_type)

		if(QUALITY_BOLT_TURNING)
			if(locked)
				to_chat(user, "<span class='warning'>The bolts are covered! Unlocking this would retract the covers.</span>")
				return
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC))
				if(anchored)
					to_chat(user, "<span class='notice'>You unsecure \the [src] from the floor!</span>")
					if(active)
						to_chat(user, SPAN_NOTICE("The [src] shuts off!"))
						src.shields_down()
					anchored = FALSE
				else
					if(istype(get_turf(src), /turf/space)) return //No wrenching these in space!
					to_chat(user, SPAN_NOTICE("You secure the [src] to the floor!"))
					anchored = TRUE
			return

		if(QUALITY_SCREW_DRIVING)
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_EASY,  required_stat = STAT_MEC, instant_finish_tier = 30))
				is_open = !is_open
				to_chat(user, SPAN_NOTICE("You [is_open ? "open" : "close"] the panel of \the [src] with [I]."))
			return

		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/cable_coil) && malfunction && is_open)
		var/obj/item/stack/cable_coil/coil = I
		to_chat(user, SPAN_NOTICE("You begin to replace the wires."))
		if(do_after(user, 30,src))
			if (coil.use(1))
				health = max_health
				malfunction = 0
				to_chat(user, SPAN_NOTICE("You repair the [src]!"))
				update_icon()

	else if(istype(I, /obj/item/weapon/card/id) || istype(I, /obj/item/modular_computer))
		if(src.allowed(user))
			src.locked = !src.locked
			to_chat(user, "The controls are now [src.locked ? "locked." : "unlocked."]")
		else
			to_chat(user, SPAN_WARNING("Access denied."))

	else
		..()


/obj/machinery/shieldgen/on_update_icon()
	if(active && !(stat & NOPOWER))
		src.SetIconState(malfunction ? "shieldonbr":"shieldon")
	else
		src.SetIconState(malfunction ? "shieldoffbr":"shieldoff")
	return
