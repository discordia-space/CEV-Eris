//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define DOOR_REPAIR_AMOUNT 50	//amount of health regained per stack amount used
#define DOOR_AI_ACTIVATION_RANGE 12 // Range in which this door activates AI when opened

/obj/machinery/door
	name = "Door"
	desc = "It opens and closes."
	icon = 'icons/obj/doors/Doorint.dmi'
	icon_state = "door1"
	anchored = TRUE
	opacity = 1
	density = TRUE
	layer = OPEN_DOOR_LAYER
	var/open_layer = OPEN_DOOR_LAYER
	var/closed_layer = CLOSED_DOOR_LAYER
	var/visible = 1
	var/p_open = 0
	var/operating = 0
	var/autoclose = 0
	var/glass = 0
	var/normalspeed = 1
	var/heat_proof = 0 // For glass airlocks/opacity firedoors
	var/air_properties_vary_with_direction = 0
	maxHealth = 250
	health = 250
	var/destroy_hits = 10 //How many strong hits it takes to destroy the door
	var/resistance = RESISTANCE_TOUGH //minimum amount of force needed to damage the door with a melee weapon
	var/bullet_resistance = RESISTANCE_FRAGILE
	var/open_on_break = TRUE
	var/hitsound = 'sound/weapons/smash.ogg' //sound door makes when hit with a weapon
	var/obj/item/stack/material/repairing
	var/block_air_zones = 1 //If set, air zones cannot merge across the door even when it is opened.
	var/obj/machinery/filler_object/f5
	var/obj/machinery/filler_object/f6
	var/welded //Placed here for simplicity, only airlocks can be welded tho
	//Multi-tile doors
	dir = EAST
	var/width = 1

	var/damage_smoke = FALSE
	var/tryingToLock = FALSE // for autoclosing

	atmos_canpass = CANPASS_PROC

	// turf animation
	var/atom/movable/overlay/c_animation

/obj/machinery/door/New()
	GLOB.all_doors += src
	..()

/obj/machinery/door/Destroy()
	GLOB.all_doors -= src
	..()

/obj/machinery/door/can_prevent_fall()
	return density

/obj/machinery/door/attack_generic(mob/user, var/damage)
	if(damage >= resistance)
		visible_message(SPAN_DANGER("\The [user] smashes into \the [src]!"))
		take_damage(damage)
	else
		visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly."))
		playsound(src, 'sound/weapons/Genhit.ogg', 15, 1,-1)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*1.5)
	attack_animation(user)

/obj/machinery/door/New()
	. = ..()
	if(density)
		layer = closed_layer
		explosion_resistance = initial(explosion_resistance)
		update_heat_protection(get_turf(src))
	else
		layer = open_layer
		explosion_resistance = 0


	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	health = maxHealth

	update_nearby_tiles(need_rebuild=1)
	return

/obj/machinery/door/Destroy()
	density = FALSE
	update_nearby_tiles()

	return ..()

/obj/machinery/door/Process()
	return PROCESS_KILL

/obj/machinery/door/proc/can_open()
	if(!density || operating)
		return 0
	return 1

/obj/machinery/door/proc/can_close()
	if(density || operating)
		return 0
	return 1

/obj/machinery/door/Bumped(atom/AM)
	if(operating) return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time - M.last_bumped <= 10) return	//Can bump-open one airlock per second. This is to prevent shock spam.
		M.last_bumped = world.time
		if(!M.restrained() && (!issmall(M) || ishuman(M)))
			bumpopen(M)
		return

	if(istype(AM, /obj/machinery/bot))
		var/obj/machinery/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /mob/living/bot))
		var/mob/living/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /mob/living/exosuit))
		var/mob/living/exosuit/exosuit = AM
		if(density)
			if(exosuit.pilots.len && (allowed(exosuit.pilots[1]) || check_access_list(exosuit.saved_access)))
				open()
			else
				do_animate("deny")
		return
	if(istype(AM, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pulling && (src.allowed(wheel.pulling)))
				open()
			else
				do_animate("deny")
		return
	return


/obj/machinery/door/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group) return !block_air_zones
	if(istype(mover) && mover.checkpass(PASSGLASS))
		return !opacity
	return !density


/obj/machinery/door/proc/bumpopen(mob/user)
	if(operating)
		return FALSE
	if(user.last_airflow > world.time - vsc.airflow_delay) //Fakkit
		return FALSE
	add_fingerprint(user)
	if(density)
		if(allowed(user))
			if(open())
				tryingToLock = TRUE
		else
			do_animate("deny")
	return TRUE

/obj/machinery/door/bullet_act(var/obj/item/projectile/Proj)
	..()

	var/damage = Proj.get_structure_damage()
	if(Proj.damage_types[BRUTE])
		damage -= bullet_resistance

	// Emitter Blasts - these will eventually completely destroy the door, given enough time.
	if (damage > 90)
		destroy_hits--
		if (destroy_hits <= 0)
			visible_message(SPAN_DANGER("\The [src.name] disintegrates!"))
			if(Proj.damage_types[BRUTE] > Proj.damage_types[BURN])
				new /obj/item/stack/material/steel(src.loc, 2)
				new /obj/item/stack/rods(loc, 3)
			else
				new /obj/effect/decal/cleanable/ash(src.loc) // Turn it to ashes!
			qdel(src)

	if(damage)
		if(Proj.nocap_structures)
			take_damage(damage)
		else
		//cap projectile damage so that there's still a minimum number of hits required to break the door
			take_damage(min(damage, 100))



/obj/machinery/door/proc/hit_by_living(var/mob/living/M)
	var/body_part = pick(BP_HEAD, BP_CHEST, BP_GROIN)
	visible_message(SPAN_DANGER("[M] slams against \the [src]!"))
	if(prob(30))
		M.Weaken(1)
	M.damage_through_armor(rand(5,8), BRUTE, body_part, ARMOR_MELEE)
	take_damage(M.mob_size)

/obj/machinery/door/hitby(AM as mob|obj, var/speed=5)

	..()
	var/damage = 5
	if (istype(AM, /obj/item))
		var/obj/item/O = AM
		damage = O.throwforce
	else if (isliving(AM))
		var/mob/living/M = AM
		hit_by_living(M)
		return
	take_damage(damage)
	return

/obj/machinery/door/attack_hand(mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(allowed(user) && operable())
		if(density)
			open()
		else
			close()
	else
		do_animate("deny")

/obj/machinery/door/attack_tk(mob/user)
	if(requiresID() && !allowed(null))
		return
	..()

/obj/machinery/door/attackby(obj/item/I, mob/user)
	src.add_fingerprint(user)

	//Harm intent overrides other actions
	if(src.density && user.a_intent == I_HURT && !I.GetIdCard())
		hit(user, I)
		return

	if(density && I.GetIdCard())
		if(allowed(user))	open()
		else				do_animate("deny")
		return

	if(repairing)
		var/tool_type = I.get_tool_type(user, list(QUALITY_PRYING, QUALITY_WELDING), src)
		switch(tool_type)

			if(QUALITY_WELDING)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You finish repairing the damage to \the [src]."))
					health = between(health, health + repairing.amount*DOOR_REPAIR_AMOUNT, maxHealth)
					update_icon()
					qdel(repairing)
					repairing = null
					return
				return

			if(QUALITY_PRYING)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  required_stat = STAT_ROB))
					to_chat(user, SPAN_NOTICE("You remove \the [repairing]."))
					repairing.loc = user.loc
					repairing = null
					return
				return

			if(ABORT_CHECK)
				return

	if(istype(I, /obj/item/stack/material) && I.get_material_name() == src.get_material_name())
		if(stat & BROKEN)
			to_chat(user, SPAN_NOTICE("It looks like \the [src] is pretty busted. It's going to need more than just patching up now."))
			return
		if(health >= maxHealth)
			to_chat(user, SPAN_NOTICE("Nothing to fix!"))
			return
		if(!density)
			to_chat(user, SPAN_WARNING("\The [src] must be closed before you can repair it."))
			return

		//figure out how much metal we need
		var/amount_needed = (maxHealth - health) / DOOR_REPAIR_AMOUNT
		amount_needed = CEILING(amount_needed, 1)

		var/obj/item/stack/stack = I
		var/transfer
		if (repairing)
			transfer = stack.transfer_to(repairing, amount_needed - repairing.amount)
			if (!transfer)
				to_chat(user, SPAN_WARNING("You must weld or remove \the [repairing] from \the [src] before you can add anything else."))
		else
			repairing = stack.split(amount_needed)
			if (repairing)
				repairing.loc = src
				transfer = repairing.amount

		if (transfer)
			to_chat(user, SPAN_NOTICE("You fit [transfer] [stack.singular_name]\s to damaged and broken parts on \the [src]."))

		return



	if(src.operating > 0 || isrobot(user))	return //borgs can't attack doors open because it conflicts with their AI-like interaction with them.

	if(src.operating) return

	if(src.density)
		do_animate("deny")
	return

/obj/machinery/door/emag_act(var/remaining_charges)
	if(density && operable())
		do_animate("spark")
		sleep(6)
		open()
		operating = -1
		return 1



/obj/machinery/door/proc/hit(var/mob/user, var/obj/item/I, var/thrown = FALSE)
	var/obj/item/W = I
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*1.5)
	var/calc_damage
	if (thrown)
		calc_damage= W.throwforce*W.structure_damage_factor
	else
		calc_damage= W.force*W.structure_damage_factor
		if (user)user.do_attack_animation(src)

	calc_damage -= resistance

	if(calc_damage <= 0)
		if (user)user.visible_message(SPAN_DANGER("\The [user] hits \the [src] with \the [W] with no visible effect."))
		playsound(src.loc, hitsound, 20, 1)
	else
		if (user)user.visible_message(SPAN_DANGER("\The [user] forcefully strikes \the [src] with \the [W]!"))
		playsound(src.loc, hitsound, calc_damage*2.5, 1, 3,3)
		take_damage(W.force)

/obj/machinery/door/take_damage(damage)
	if (!isnum(damage))
		return
	var/initialhealth = health
	. = health - damage < 0 ? damage - (damage - health) : damage
	// Not closed , not protected.
	. *= density
	health -= damage
	var/smoke_amount
	if(health < 0)
		qdel(src)
		return
	else if(health < maxHealth / 5 && initialhealth > maxHealth / 5)
		set_broken()
		smoke_amount = 4
	else if(health < maxHealth / 4 && initialhealth >= maxHealth / 4)
		visible_message("\The [src] looks like it's about to break!" )
		smoke_amount = 3
	else if(health < maxHealth / 2 && initialhealth >= maxHealth / 2)
		visible_message("\The [src] looks seriously damaged!" )
		smoke_amount = 2
	else if(health < maxHealth * 3/4 && initialhealth >= maxHealth * 3/4)
		visible_message("\The [src] shows signs of damage!" )
		smoke_amount = 1
	update_icon()
	if(damage_smoke && smoke_amount)
		var/datum/effect/effect/system/smoke_spread/S = new
		S.set_up(smoke_amount, 0, src)
		S.start()


/obj/machinery/door/examine(mob/user)
	. = ..()
	if(src.health < src.maxHealth / 4)
		to_chat(user, "\The [src] looks like it's about to break!")
	else if(src.health < src.maxHealth / 2)
		to_chat(user, "\The [src] looks seriously damaged!")
	else if(src.health < src.maxHealth * 3/4)
		to_chat(user, "\The [src] shows signs of damage!")


/obj/machinery/door/proc/set_broken()
	stat |= BROKEN

	if (health <= 0 && open_on_break)
		visible_message(SPAN_WARNING("\The [src.name] breaks open!"))
		open(TRUE)
	else
		visible_message(SPAN_WARNING("\The [src.name] breaks!"))
	update_icon()

/obj/machinery/door/explosion_act(target_power, explosion_handler/handler)
	var/absorbed = take_damage(target_power)
	//message_admins("Door block absorbed [absorbed] damage , whilst having a health pool of [health] out of a maximum of [maxHealth]")
	return absorbed

/obj/machinery/door/update_icon()
	icon_state = "door[density]"
	update_openspace()


/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("opening")
			if(p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closing")
			if(p_open)
				flick("o_doorc1", src)
			else
				flick("doorc1", src)
		if("spark")
			if(density)
				flick("door_spark", src)
		if("deny")
			if(density && !(stat & (NOPOWER|BROKEN)))
				flick("door_deny", src)
				playsound(src.loc, 'sound/machines/Custom_deny.ogg', 50, 0)
	return


/obj/machinery/door/proc/open(var/forced = 0)
	if(!can_open(forced))
		return FALSE
	operating = TRUE
	activate_mobs_in_range(src, 10)
	set_opacity(0)
	if(istype(src, /obj/machinery/door/airlock/multi_tile/metal))
		f5?.set_opacity(0)
		f6?.set_opacity(0)

	do_animate("opening")
	icon_state = "door0"
	//sleep(3)
	src.density = FALSE
	update_nearby_tiles()
	//sleep(7)
	src.layer = open_layer
	explosion_resistance = 0
	update_icon()
	update_nearby_tiles()
	operating = FALSE
	if(autoclose)
		var/wait = normalspeed ? 150 : 5
		addtimer(CALLBACK(src, PROC_REF(close)), wait)
	return TRUE

/obj/machinery/door/proc/close(var/forced = 0)
	set waitfor = FALSE
	if(!can_close(forced))
		return
	operating = TRUE

	do_animate("closing")
	//sleep(3)
	src.density = TRUE
	update_nearby_tiles()
	//sleep(7)
	src.layer = closed_layer
	explosion_resistance = initial(explosion_resistance)
	update_icon()
	update_nearby_tiles()

	if(visible && !glass)
		set_opacity(1)	//caaaaarn!
	if(istype(src, /obj/machinery/door/airlock/multi_tile/metal))
		f5?.set_opacity(1)
		f6?.set_opacity(1)

	operating = FALSE

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	if(fire)
		qdel(fire)
	return

/obj/machinery/door/proc/requiresID()
	return 1

/obj/machinery/door/allowed(mob/M)
	if(!requiresID())
		return ..(null) //don't care who they are or what they have, act as if they're NOTHING
	return ..(M)

/obj/machinery/door/update_nearby_tiles(need_rebuild)
	for(var/turf/simulated/turf in locs)
		update_heat_protection(turf)
		SSair.mark_for_update(turf)

	return 1

/obj/machinery/door/proc/update_heat_protection(var/turf/simulated/source)
	if(istype(source))
		if(src.density && (src.opacity || src.heat_proof))
			source.thermal_conductivity = DOOR_HEAT_TRANSFER_COEFFICIENT
		else
			source.thermal_conductivity = initial(source.thermal_conductivity)

/obj/machinery/door/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0, var/glide_size_override = 0)
	//update_nearby_tiles()
	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_height = world.icon_size
		else
			bound_width = world.icon_size
			bound_height = width * world.icon_size

	update_nearby_tiles()

/obj/machinery/door/morgue
	icon = 'icons/obj/doors/doormorgue.dmi'

