/datum/storyevent/blob
	id = "blob"
	name = "Blob"


	event_type = /datum/event/blob
	event_pools = list(EVENT_LEVEL_MAJOR = POOL_THRESHOLD_MAJOR)
	tags = list(TAG_COMBAT, TAG_DESTRUCTIVE, TAG_NEGATIVE)
//============================================

/datum/event/blob
	announceWhen	= 12

	var/obj/effect/blob/core/Blob

/datum/event/blob/announce()
	level_seven_announcement()

/datum/event/blob/start()
	var/area/A = random_ship_area(TRUE)
	var/turf/T = A.random_space()
	if(!T)
		log_and_message_admins("Blob failed to find a viable turf.")
		kill()
		return

	log_and_message_admins("Blob spawned at \the [get_area(T)]", location = T)
	Blob = new /obj/effect/blob/core(T)
	for(var/i = 1; i < rand(3, 4), i++)
		Blob.Process()

/datum/event/blob/tick()
	if(!Blob || !Blob.loc)
		Blob = null
		kill()
		return
	if(IsMultiple(activeFor, 3))
		Blob.Process()




//Code for how the blob functions

//I will need to recode parts of this but I am way too tired atm
/obj/effect/blob
	name = "blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob"
	light_range = 3
	desc = "Some blob creature thingy"
	density = 1
	opacity = 0
	anchored = 1
	mouse_opacity = 2

	var/maxHealth = 30
	var/health
	var/brute_resist = 4
	var/fire_resist = 0.75
	var/expandType = /obj/effect/blob

/obj/effect/blob/New(loc)
	health = maxHealth
	update_icon()
	return ..(loc)

/obj/effect/blob/CanPass(var/atom/movable/mover, vra/turf/target, var/height = 0, var/air_group = 0)
	if(air_group || height == 0)
		return 1
	return 0

/obj/effect/blob/ex_act(var/severity)
	switch(severity)
		if(1)
			take_damage(rand(100, 120) / brute_resist)
		if(2)
			take_damage(rand(60, 100) / brute_resist)
		if(3)
			take_damage(rand(20, 60) / brute_resist)


/obj/effect/blob/fire_act()
	take_damage(rand(20, 60) / fire_resist)

/obj/effect/blob/update_icon()
	if(health > maxHealth / 2)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/proc/take_damage(var/damage)
	if (damage > 0)
		health -= damage
		playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
		if(health < 0)
			playsound(loc, 'sound/effects/splat.ogg', 50, 1)
			qdel(src)
		else
			update_icon()

/obj/effect/blob/proc/regen()
	health = min(health + 1, maxHealth)
	update_icon()


//Changes by Nanako, 14th october 2018
//Blob now deals vastly reduced damage to walls and windows, but vastly increased damage to doors
//Also travels a much farther distance
/obj/effect/blob/proc/expand(var/turf/T)
	if(istype(T, /turf/unsimulated/) || istype(T, /turf/space) || (istype(T, /turf/simulated/mineral) && T.density))
		return
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/SW = T
		SW.take_damage(rand(5,10))
		return
	/* TODO: Uncomment this once Pull request #2229 is merged
	var/obj/structure/girder/G = locate() in T
	if(G)
		G.take_damage(5)
	*/
		//No return here because a girder is porous, we can expand past it
	var/obj/structure/window/W = locate() in T
	if(W)
		W.take_damage(3, TRUE)
		return
	var/obj/structure/grille/GR = locate() in T
	if(GR)
		qdel(GR)
		return
	for(var/obj/machinery/door/D in T)
		if(D.density)
			D.take_damage(100)
			//Blob eats through doors VERY quickly
			return
	var/obj/structure/foamedmetal/F = locate() in T
	if(F)
		qdel(F)
		return
	var/obj/structure/inflatable/I = locate() in T
	if(I)
		I.deflate(1)
		return

	var/obj/vehicle/V = locate() in T
	if(V)
		V.ex_act(2)
		return
	var/obj/machinery/bot/B = locate() in T
	if(B)
		B.ex_act(2)
		return
	var/obj/mecha/M = locate() in T
	if(M)
		M.visible_message(SPAN_DANGER("The blob attacks \the [M]!"))
		M.take_damage(40)
		return

	// Above things, we destroy completely and thus can use locate. Mobs are different.
	for(var/mob/living/L in T)
		if(L.stat == DEAD)
			continue
		L.visible_message(SPAN_DANGER("The blob attacks \the [L]!"), SPAN_DANGER("The blob attacks you!"))
		playsound(loc, 'sound/effects/attackblob.ogg', 50, 1)
		L.take_organ_damage(rand(30, 40))
		return
	new expandType(T, min(health, 30))

/obj/effect/blob/proc/pulse(var/forceLeft, var/list/dirs)
	regen()
	sleep(2)
	for (var/pushDir in dirs)
		var/turf/T = get_step(src, pushDir)
		var/obj/effect/blob/B = (locate() in T)
		if(!B)
			expand(T)
		else if(forceLeft)
			B.pulse(forceLeft - 1, dirs)

/obj/effect/blob/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj)
		return

	switch(Proj.damage_type)
		if(BRUTE)
			take_damage(Proj.damage / brute_resist)
		if(BURN)
			take_damage(Proj.damage / fire_resist)
	return 0

/obj/effect/blob/attackby(var/obj/item/weapon/W, var/mob/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(W.force && ! (W.flags & NOBLUDGEON))
		visible_message("<span class='danger'>\The [src] has been attacked with \the [W][(user ? " by [user]." : ".")]</span>")
		var/damage = 0
		switch(W.damtype)
			if("fire")
				damage = (W.force / fire_resist)
				if(istype(W, /obj/item/weapon/tool/weldingtool))
					playsound(loc, 'sound/items/Welder.ogg', 100, 1)
			if("brute")
				damage = (W.force / brute_resist)

		take_damage(damage)
		return 1
	return ..()

/obj/effect/blob/core
	name = "blob core"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_core"
	maxHealth = 200
	brute_resist = 4
	fire_resist = 2

	expandType = /obj/effect/blob/shield
	var/blob_may_process = 1

/obj/effect/blob/core/update_icon()
	return

/obj/effect/blob/core/New(loc)
	START_PROCESSING(SSobj, src)
	return ..(loc)

/obj/effect/blob/core/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()

/obj/effect/blob/core/Process()
	set waitfor = 0
	if(!blob_may_process)
		return
	blob_may_process = 0
	sleep(0)
	pulse(100, list(NORTH, EAST))
	pulse(100, list(NORTH, WEST))
	pulse(100, list(SOUTH, EAST))
	pulse(100, list(SOUTH, WEST))
	blob_may_process = 1

/obj/effect/blob/shield
	name = "strong blob"
	icon = 'icons/mob/blob.dmi'
	icon_state = "blob_idle"
	desc = "Some blob creature thingy"
	maxHealth = 60
	brute_resist = 2
	fire_resist = 1

/obj/effect/blob/shield/New()
	..()
	update_nearby_tiles()

/obj/effect/blob/shield/Destroy()
	density = 0
	update_nearby_tiles()
	. = ..()

/obj/effect/blob/shield/update_icon()
	if(health > maxHealth * 2 / 3)
		icon_state = "blob_idle"
	else if(health > maxHealth / 3)
		icon_state = "blob"
	else
		icon_state = "blob_damaged"

/obj/effect/blob/shield/CanPass(var/atom/movable/mover, var/turf/target, var/height = 0, var/air_group = 0)
	return !density
