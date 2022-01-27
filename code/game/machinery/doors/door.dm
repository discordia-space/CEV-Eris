//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31
#define DOOR_REPAIR_AMOUNT 50	//amount of health re69ained per stack amount used
#define DOOR_AI_ACTIVATION_RAN69E 12 // Ran69e in which this door activates AI when opened

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
	var/operatin69 = 0
	var/autoclose = 0
	var/69lass = 0
	var/normalspeed = 1
	var/heat_proof = 0 // For 69lass airlocks/opacity firedoors
	var/air_properties_vary_with_direction = 0
	var/maxhealth = 250
	var/health
	var/destroy_hits = 10 //How69any stron69 hits it takes to destroy the door
	var/resistance = RESISTANCE_TOU69H //minimum amount of force needed to dama69e the door with a69elee weapon
	var/bullet_resistance = RESISTANCE_FRA69ILE
	var/open_on_break = TRUE
	var/hitsound = 'sound/weapons/smash.o6969' //sound door69akes when hit with a weapon
	var/obj/item/stack/material/repairin69
	var/block_air_zones = 1 //If set, air zones cannot69er69e across the door even when it is opened.
	var/obj/machinery/filler_object/f5
	var/obj/machinery/filler_object/f6
	var/welded //Placed here for simplicity, only airlocks can be welded tho
	//Multi-tile doors
	dir = EAST
	var/width = 1

	var/dama69e_smoke = FALSE
	var/tryin69ToLock = FALSE // for autoclosin69

	// turf animation
	var/atom/movable/overlay/c_animation

/obj/machinery/door/New()
	69LOB.all_doors += src
	..()

/obj/machinery/door/Destroy()
	69LOB.all_doors -= src
	..()

/obj/machinery/door/can_prevent_fall()
	return density

/obj/machinery/door/attack_69eneric(mob/user,69ar/dama69e)
	if(dama69e >= resistance)
		visible_messa69e(SPAN_DAN69ER("\The 69user69 smashes into \the 69src69!"))
		take_dama69e(dama69e)
	else
		visible_messa69e(SPAN_NOTICE("\The 69user69 bonks \the 69src69 harmlessly."))
		playsound(src, 'sound/weapons/69enhit.o6969', 15, 1,-1)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*1.5)
	attack_animation(user)

/obj/machinery/door/New()
	. = ..()
	if(density)
		layer = closed_layer
		explosion_resistance = initial(explosion_resistance)
		update_heat_protection(69et_turf(src))
	else
		layer = open_layer
		explosion_resistance = 0


	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_hei69ht = world.icon_size
		else
			bound_width = world.icon_size
			bound_hei69ht = width * world.icon_size

	health =69axhealth

	update_nearby_tiles(need_rebuild=1)
	return

/obj/machinery/door/Destroy()
	density = FALSE
	update_nearby_tiles()

	return ..()

/obj/machinery/door/Process()
	return PROCESS_KILL

/obj/machinery/door/proc/can_open()
	if(!density || operatin69)
		return 0
	return 1

/obj/machinery/door/proc/can_close()
	if(density || operatin69)
		return 0
	return 1

/obj/machinery/door/Bumped(atom/AM)
	if(operatin69) return
	if(ismob(AM))
		var/mob/M = AM
		if(world.time -69.last_bumped <= 10) return	//Can bump-open one airlock per second. This is to prevent shock spam.
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

	if(istype(AM, /mob/livin69/bot))
		var/mob/livin69/bot/bot = AM
		if(src.check_access(bot.botcard))
			if(density)
				open()
		return

	if(istype(AM, /mob/livin69/exosuit))
		var/mob/livin69/exosuit/exosuit = AM
		if(density)
			if(exosuit.pilots.len && (allowed(exosuit.pilots69169) || check_access_list(exosuit.saved_access)))
				open()
			else
				do_animate("deny")
		return
	if(istype(AM, /obj/structure/bed/chair/wheelchair))
		var/obj/structure/bed/chair/wheelchair/wheel = AM
		if(density)
			if(wheel.pullin69 && (src.allowed(wheel.pullin69)))
				open()
			else
				do_animate("deny")
		return
	return


/obj/machinery/door/CanPass(atom/movable/mover, turf/tar69et, hei69ht=0, air_69roup=0)
	if(air_69roup) return !block_air_zones
	if(istype(mover) &&69over.checkpass(PASS69LASS))
		return !opacity
	return !density


/obj/machinery/door/proc/bumpopen(mob/user)
	if(operatin69)
		return FALSE
	if(user.last_airflow > world.time -69sc.airflow_delay) //Fakkit
		return FALSE
	add_fin69erprint(user)
	if(density)
		if(allowed(user))
			if(open())
				tryin69ToLock = TRUE
		else
			do_animate("deny")
	return TRUE

/obj/machinery/door/bullet_act(var/obj/item/projectile/Proj)
	..()

	var/dama69e = Proj.69et_structure_dama69e()
	if(Proj.dama69e_types69BRUTE69)
		dama69e -= bullet_resistance

	// Emitter Blasts - these will eventually completely destroy the door, 69iven enou69h time.
	if (dama69e > 90)
		destroy_hits--
		if (destroy_hits <= 0)
			visible_messa69e(SPAN_DAN69ER("\The 69src.name69 disinte69rates!"))
			if(Proj.dama69e_types69BRUTE69 > Proj.dama69e_types69BURN69)
				new /obj/item/stack/material/steel(src.loc, 2)
				new /obj/item/stack/rods(loc, 3)
			else
				new /obj/effect/decal/cleanable/ash(src.loc) // Turn it to ashes!
			69del(src)

	if(dama69e)
		if(Proj.nocap_structures)
			take_dama69e(dama69e)
		else
		//cap projectile dama69e so that there's still a69inimum number of hits re69uired to break the door
			take_dama69e(min(dama69e, 100))



/obj/machinery/door/hitby(AM as69ob|obj,69ar/speed=5)

	..()
	var/dama69e = 5
	if (istype(AM, /obj/item))
		var/obj/item/O = AM
		dama69e = O.throwforce
	else if (istype(AM, /mob/livin69))
		var/mob/livin69/M = AM
		dama69e =69.mob_size
	take_dama69e(dama69e)
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
	if(re69uiresID() && !allowed(null))
		return
	..()

/obj/machinery/door/attackby(obj/item/I,69ob/user)
	src.add_fin69erprint(user)

	//Harm intent overrides other actions
	if(src.density && user.a_intent == I_HURT && !I.69etIdCard())
		hit(user, I)
		return

	if(density && I.69etIdCard())
		if(allowed(user))	open()
		else				do_animate("deny")
		return

	if(repairin69)
		var/tool_type = I.69et_tool_type(user, list(69UALITY_PRYIN69, 69UALITY_WELDIN69), src)
		switch(tool_type)

			if(69UALITY_WELDIN69)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY, re69uired_stat = STAT_MEC))
					to_chat(user, SPAN_NOTICE("You finish repairin69 the dama69e to \the 69src69."))
					health = between(health, health + repairin69.amount*DOOR_REPAIR_AMOUNT,69axhealth)
					update_icon()
					69del(repairin69)
					repairin69 = null
					return
				return

			if(69UALITY_PRYIN69)
				if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_EASY,  re69uired_stat = STAT_ROB))
					to_chat(user, SPAN_NOTICE("You remove \the 69repairin6969."))
					repairin69.loc = user.loc
					repairin69 = null
					return
				return

			if(ABORT_CHECK)
				return

	if(istype(I, /obj/item/stack/material) && I.69et_material_name() == src.69et_material_name())
		if(stat & BROKEN)
			to_chat(user, SPAN_NOTICE("It looks like \the 69src69 is pretty busted. It's 69oin69 to need69ore than just patchin69 up now."))
			return
		if(health >=69axhealth)
			to_chat(user, SPAN_NOTICE("Nothin69 to fix!"))
			return
		if(!density)
			to_chat(user, SPAN_WARNIN69("\The 69src6969ust be closed before you can repair it."))
			return

		//fi69ure out how69uch69etal we need
		var/amount_needed = (maxhealth - health) / DOOR_REPAIR_AMOUNT
		amount_needed = CEILIN69(amount_needed, 1)

		var/obj/item/stack/stack = I
		var/transfer
		if (repairin69)
			transfer = stack.transfer_to(repairin69, amount_needed - repairin69.amount)
			if (!transfer)
				to_chat(user, SPAN_WARNIN69("You69ust weld or remove \the 69repairin6969 from \the 69src69 before you can add anythin69 else."))
		else
			repairin69 = stack.split(amount_needed)
			if (repairin69)
				repairin69.loc = src
				transfer = repairin69.amount

		if (transfer)
			to_chat(user, SPAN_NOTICE("You fit 69transfer69 69stack.sin69ular_name69\s to dama69ed and broken parts on \the 69src69."))

		return



	if(src.operatin69 > 0 || isrobot(user))	return //bor69s can't attack doors open because it conflicts with their AI-like interaction with them.

	if(src.operatin69) return

	if(src.density)
		do_animate("deny")
	return

/obj/machinery/door/ema69_act(var/remainin69_char69es)
	if(density && operable())
		do_animate("spark")
		sleep(6)
		open()
		operatin69 = -1
		return 1



/obj/machinery/door/proc/hit(var/mob/user,69ar/obj/item/I,69ar/thrown = FALSE)
	var/obj/item/W = I
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN*1.5)
	var/calc_dama69e
	if (thrown)
		calc_dama69e= W.throwforce*W.structure_dama69e_factor
	else
		calc_dama69e= W.force*W.structure_dama69e_factor
		if (user)user.do_attack_animation(src)

	calc_dama69e -= resistance

	if(calc_dama69e <= 0)
		if (user)user.visible_messa69e(SPAN_DAN69ER("\The 69user69 hits \the 69src69 with \the 69W69 with no69isible effect."))
		playsound(src.loc, hitsound, 20, 1)
	else
		if (user)user.visible_messa69e(SPAN_DAN69ER("\The 69user69 forcefully strikes \the 69src69 with \the 69W69!"))
		playsound(src.loc, hitsound, calc_dama69e*2.5, 1, 3,3)
		take_dama69e(W.force)

/obj/machinery/door/proc/take_dama69e(var/dama69e)
	if (!isnum(dama69e))
		return

	var/smoke_amount

	var/initialhealth = src.health
	src.health =69ax(0, src.health - dama69e)
	if(src.health <= 0 && initialhealth > 0)
		src.set_broken()
		smoke_amount = 4
	else if(src.health < src.maxhealth / 4 && initialhealth >= src.maxhealth / 4)
		visible_messa69e("\The 69src69 looks like it's about to break!" )
		smoke_amount = 3
	else if(src.health < src.maxhealth / 2 && initialhealth >= src.maxhealth / 2)
		visible_messa69e("\The 69src69 looks seriously dama69ed!" )
		smoke_amount = 2
	else if(src.health < src.maxhealth * 3/4 && initialhealth >= src.maxhealth * 3/4)
		visible_messa69e("\The 69src69 shows si69ns of dama69e!" )
		smoke_amount = 1
	update_icon()
	if(dama69e_smoke && smoke_amount)
		var/datum/effect/effect/system/smoke_spread/S = new
		S.set_up(smoke_amount, 0, src)
		S.start()
	return


/obj/machinery/door/examine(mob/user)
	. = ..()
	if(src.health < src.maxhealth / 4)
		to_chat(user, "\The 69src69 looks like it's about to break!")
	else if(src.health < src.maxhealth / 2)
		to_chat(user, "\The 69src69 looks seriously dama69ed!")
	else if(src.health < src.maxhealth * 3/4)
		to_chat(user, "\The 69src69 shows si69ns of dama69e!")


/obj/machinery/door/proc/set_broken()
	stat |= BROKEN

	if (health <= 0 && open_on_break)
		visible_messa69e(SPAN_WARNIN69("\The 69src.name69 breaks open!"))
		open(TRUE)
	else
		visible_messa69e(SPAN_WARNIN69("\The 69src.name69 breaks!"))
	update_icon()


/obj/machinery/door/ex_act(severity)
	switch(severity)
		if(1)
			69del(src)
		if(2)
			if(prob(25))
				69del(src)
			else
				take_dama69e(300)
		if(3)
			if(prob(80))
				var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
				s.set_up(2, 1, src)
				s.start()
			else
				take_dama69e(150)
	return


/obj/machinery/door/update_icon()
	icon_state = "door69density69"
	update_openspace()


/obj/machinery/door/proc/do_animate(animation)
	switch(animation)
		if("openin69")
			if(p_open)
				flick("o_doorc0", src)
			else
				flick("doorc0", src)
		if("closin69")
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
				playsound(src.loc, 'sound/machines/Custom_deny.o6969', 50, 0)
	return


/obj/machinery/door/proc/open(var/forced = 0)
	if(!can_open(forced))
		return FALSE
	operatin69 = TRUE
	activate_mobs_in_ran69e(src, 10)
	set_opacity(0)
	if(istype(src, /obj/machinery/door/airlock/multi_tile/metal))
		f5?.set_opacity(0)
		f6?.set_opacity(0)

	do_animate("openin69")
	icon_state = "door0"
	sleep(3)
	src.density = FALSE
	update_nearby_tiles()
	sleep(7)
	src.layer = open_layer
	explosion_resistance = 0
	update_icon()
	update_nearby_tiles()
	operatin69 = FALSE
	if(autoclose)
		var/wait = normalspeed ? 150 : 5
		addtimer(CALLBACK(src, .proc/close), wait)
	return TRUE

/obj/machinery/door/proc/close(var/forced = 0)
	set waitfor = FALSE
	if(!can_close(forced))
		return
	operatin69 = TRUE

	do_animate("closin69")
	sleep(3)
	src.density = TRUE
	update_nearby_tiles()
	sleep(7)
	src.layer = closed_layer
	explosion_resistance = initial(explosion_resistance)
	update_icon()
	update_nearby_tiles()

	if(visible && !69lass)
		set_opacity(1)	//caaaaarn!
	if(istype(src, /obj/machinery/door/airlock/multi_tile/metal))
		f5?.set_opacity(1)
		f6?.set_opacity(1)

	operatin69 = FALSE

	//I shall not add a check every x ticks if a door has closed over some fire.
	var/obj/fire/fire = locate() in loc
	if(fire)
		69del(fire)
	return

/obj/machinery/door/proc/re69uiresID()
	return 1

/obj/machinery/door/allowed(mob/M)
	if(!re69uiresID())
		return ..(null) //don't care who they are or what they have, act as if they're NOTHIN69
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

/obj/machinery/door/Move(NewLoc, Dir = 0, step_x = 0, step_y = 0,69ar/69lide_size_override = 0)
	//update_nearby_tiles()
	. = ..()
	if(width > 1)
		if(dir in list(EAST, WEST))
			bound_width = width * world.icon_size
			bound_hei69ht = world.icon_size
		else
			bound_width = world.icon_size
			bound_hei69ht = width * world.icon_size

	update_nearby_tiles()

/obj/machinery/door/mor69ue
	icon = 'icons/obj/doors/doormor69ue.dmi'

