/obj/item/device/lighting/toggleable/flashlight
	action_button_name = "Toggle Flashlight"
	var/tick_cost = 0.4
	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small
	brightness_on = 2
	dir = WEST

	var/obj/effect/effect/light/light_spot
	var/light_spot_brightness = 3
	var/light_spot_range = 3
	var/spot_locked = 0		//this flag needed for lightspot to stay in place when player clicked on turf, will reset when moved or turned

	var/light_direction
	//var/list/lightSpotBlacklist = list(/obj/machinery/door/airlock)	//list of items that stops lightspot despite that they are not opaque
	
/obj/item/device/lighting/toggleable/flashlight/New()
	..()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

/obj/item/device/lighting/toggleable/flashlight/Destroy()
	..()
	qdel(light_spot)

/obj/item/device/lighting/toggleable/flashlight/proc/calculate_dir(var/turf/old_loc)
	if (istype(src.loc,/obj/item/weapon/storage) || istype(src.loc,/obj/structure/closet))
		return
	if (istype(src.loc,/mob/living))
		var/mob/living/L = src.loc 
		set_dir(L.dir)
	else if (pulledby && old_loc)
		var/x_diff = src.x - old_loc.x
		var/y_diff = src.y - old_loc.y
		if (x_diff > 0)
			set_dir(EAST)
		else if (x_diff < 0)
			set_dir(WEST)
		else if (y_diff > 0)
			set_dir(NORTH)
		else if (y_diff < 0)
			set_dir(SOUTH)

/obj/item/device/lighting/toggleable/flashlight/set_dir(new_dir)
	var/turf/NT = get_turf(src)	//supposed location for lightspot
	var/turf/L = get_turf(src)	//current location of flashlight in world

	light_direction = new_dir

	if (istype(src.loc,/obj/item/weapon/storage) || istype(src.loc,/obj/structure/closet))	//no point in finding spot for light if flashlight is inside container
		place_lightspot(NT,light_direction)
		return

	switch(light_direction)
		if(NORTH)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x,L.y + i,L.z)
				if (lightSpotPassable(T))
					NT = T
				else 
					break
		if(SOUTH)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x,L.y - i,L.z)
				if (lightSpotPassable(T))
					NT = T
				else 
					break
		if(EAST)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x + i,L.y,L.z)
				if (lightSpotPassable(T))
					NT = T
				else 
					break
		if(WEST)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x - i,L.y,L.z)
				if (lightSpotPassable(T))
					NT = T
				else 
					break

	place_lightspot(NT,light_direction)

	if (!istype(src.loc,/mob/living))
		dir = new_dir

/obj/item/device/lighting/toggleable/flashlight/proc/place_lightspot(var/turf/T, var/direction)
	if (light_spot && on && !T.is_space())
		light_spot.forceMove(T)
		light_spot.icon_state = "nothing"
		if (lightSpotPlaceable(T))
			light_spot.icon_state = "light_spot"
		light_spot.set_dir(direction)

/obj/item/device/lighting/toggleable/flashlight/proc/lightSpotPassable(var/turf/T)
	if (is_opaque(T) || is_blocked_turf(T))
		return 0
	/*for(var/obj/O in T)
		if(O.type in lightSpotBlacklist)
			return 0*/
	return 1

/obj/item/device/lighting/toggleable/flashlight/proc/lightSpotPlaceable(var/turf/T)	//check if we can place icon there, light will be still applied
	if(T == get_turf(src) || !isfloor(T))
		return 0
	for(var/obj/O in T)
		if(istype(O, /obj/structure/window))
			return 0
	return 1

/obj/item/device/lighting/toggleable/flashlight/moved(mob/user, old_loc)
	spot_locked = 0
	calculate_dir(old_loc)

/obj/item/device/lighting/toggleable/flashlight/entered_with_container()
	spot_locked = 0
	calculate_dir()

/obj/item/device/lighting/toggleable/flashlight/container_dir_changed(new_dir)
	spot_locked = 0
	set_dir(new_dir)

/obj/item/device/lighting/toggleable/flashlight/pickup(mob/user)
	..()
	calculate_dir()
	dir = WEST

/obj/item/device/lighting/toggleable/flashlight/dropped(mob/user as mob)
	if(light_direction)
		set_dir(light_direction)

/obj/item/device/lighting/toggleable/flashlight/afterattack(atom/A, mob/user)
	var/turf/T = get_turf(A)
	if(can_see(user,T) && lightSpotPassable(T) && light_spot_range >= get_dist(get_turf(src),T))
		spot_locked = 1
		light_direction = get_dir(src,T)
		place_lightspot(T, light_direction)

/obj/item/device/lighting/toggleable/flashlight/turn_on(mob/user)
	if(!cell || !cell.check_charge(tick_cost))
		playsound(loc, 'sound/machines/button.ogg', 50, 1)
		user << SPAN_WARNING("[src] battery is dead or missing.")
		return FALSE
	. = ..()
	light_spot = new(get_turf(src),light_spot_brightness)
	light_spot.icon_state = "light_spot"
	calculate_dir()
	if(. && user)
		START_PROCESSING(SSobj, src)
		user.update_action_buttons()

/obj/item/device/lighting/toggleable/flashlight/turn_off(mob/user)
	. = ..()
	qdel(light_spot)
	if(. && user)
		user.update_action_buttons()

/obj/item/device/lighting/toggleable/flashlight/Process()
	if(on)
		if(!spot_locked)
			calculate_dir()
		if(!cell || !cell.checked_use(tick_cost))
			if(ismob(src.loc))
				src.loc << SPAN_WARNING("Your flashlight dies. You are alone now.")
			turn_off()

/obj/item/device/lighting/toggleable/flashlight/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null
	else
		return ..()

/obj/item/device/lighting/toggleable/flashlight/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C

/obj/item/device/lighting/toggleable/flashlight/attack(mob/living/M, mob/living/user)
	add_fingerprint(user)
	if(on && user.targeted_organ == O_EYES)

		if((CLUMSY in user.mutations) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H = M	//mob has protective eyewear
		if(istype(H))
			for(var/obj/item/clothing/C in list(H.head,H.wear_mask,H.glasses))
				if(istype(C) && (C.body_parts_covered & EYES))
					user << SPAN_WARNING("You're going to need to remove [C.name] first.")
					return

			var/obj/item/organ/vision
			if(H.species.vision_organ)
				vision = H.internal_organs_by_name[H.species.vision_organ]
			if(!vision)
				user << "<span class='warning'>You can't find any [H.species.vision_organ ? H.species.vision_organ : O_EYES] on [H]!</span>"
				return

			user.visible_message(SPAN_NOTICE("\The [user] directs [src] to [M]'s eyes."), \
							 	 SPAN_NOTICE("You direct [src] to [M]'s eyes."))
			if(H == user)	//can't look into your own eyes buster
				if(M.stat == DEAD || M.blinded)	//mob is dead or fully blind
					user << SPAN_WARNING("\The [M]'s pupils do not react to the light!")
					return
				if(XRAY in M.mutations)
					user << SPAN_NOTICE("\The [M] pupils give an eerie glow!")
				if(vision.damage)
					user << SPAN_WARNING("There's visible damage to [M]'s [vision.name]!")
				else if(M.eye_blurry)
					user << SPAN_NOTICE("\The [M]'s pupils react slower than normally.")
				if(M.getBrainLoss() > 15)
					user << SPAN_NOTICE("There's visible lag between left and right pupils' reactions.")

				var/list/pinpoint = list("oxycodone"=1,"tramadol"=5)
				var/list/dilating = list("space_drugs"=5,"mindbreaker"=1)
				if(M.reagents.has_any_reagent(pinpoint) || H.ingested.has_any_reagent(pinpoint))
					user << SPAN_NOTICE("\The [M]'s pupils are already pinpoint and cannot narrow any more.")
				else if(M.reagents.has_any_reagent(dilating) || H.ingested.has_any_reagent(dilating))
					user << SPAN_NOTICE("\The [M]'s pupils narrow slightly, but are still very dilated.")
				else
					user << SPAN_NOTICE("\The [M]'s pupils narrow.")

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //can be used offensively
			if(M.HUDtech.Find("flash"))
				flick("flash", M.HUDtech["flash"])
	else
		return ..()

/obj/item/device/lighting/toggleable/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by medical staff."
	icon_state = "penlight"
	item_state = ""
	slot_flags = SLOT_EARS
	brightness_on = 2
	light_spot_brightness = 2
	light_spot_range = 1
	w_class = ITEM_SIZE_TINY

/obj/item/device/lighting/toggleable/flashlight/heavy
	name = "heavy duty flashlight"
	desc = "A hand-held heavy-duty light."
	icon_state = "heavyduty"
	item_state = "heavyduty"
	brightness_on = 3
	light_spot_brightness = 4
	light_spot_range = 4
	tick_cost = 0.8
	suitable_cell = /obj/item/weapon/cell/medium

/obj/item/device/lighting/toggleable/flashlight/seclite
	name = "Ironhammer flashlight"
	desc = "A hand-held security flashlight."
	icon_state = "seclite"
	item_state = "seclite"
