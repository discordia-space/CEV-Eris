/obj/item/device/lighting/toggleable/flashlight
	action_button_name = "Toggle Flashlight"
	dir = WEST
	suitable_cell = /obj/item/cell/small
	rarity_value = 5
	var/tick_cost = 0.4

	var/obj/effect/effect/light/light_spot

	var/radiance_power = 0.8
	var/light_spot_power = 2
	var/light_spot_radius = 3

	var/light_spot_range = 3
	var/spot_locked = FALSE		//this flag needed for lightspot to stay in place when player clicked on turf, will reset when69oved or turned

	var/light_direction
	var/lightspot_hitObstacle = FALSE

/obj/item/device/lighting/toggleable/flashlight/Destroy()
	69DEL_NULL(light_spot)
	return ..()

/obj/item/device/lighting/toggleable/flashlight/proc/calculate_dir(turf/old_loc)
	if(istype(src.loc,/obj/item/storage) || istype(src.loc,/obj/structure/closet))
		return
	if(istype(src.loc,/mob/living))
		var/mob/living/L = src.loc
		set_dir(L.dir)
	else if(pulledby && old_loc)
		var/x_diff = src.x - old_loc.x
		var/y_diff = src.y - old_loc.y
		if(x_diff > 0)
			set_dir(EAST)
		else if(x_diff < 0)
			set_dir(WEST)
		else if(y_diff > 0)
			set_dir(NORTH)
		else if(y_diff < 0)
			set_dir(SOUTH)

/obj/item/device/lighting/toggleable/flashlight/set_dir(new_dir)
	var/turf/NT = get_turf(src)	//supposed location for lightspot
	var/turf/L = get_turf(src)	//current location of flashlight in world
	var/hitSomething = FALSE
	light_direction = new_dir

	if(istype(src.loc,/obj/item/storage) || istype(src.loc,/obj/structure/closet))	//no point in finding spot for light if flashlight is inside container
		place_lightspot(NT)
		return

	switch(light_direction)
		if(NORTH)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x,L.y + i,L.z)
				if(lightSpotPassable(T))
					if(T.is_space())
						break
					NT = T
				else
					hitSomething = TRUE
					break
		if(SOUTH)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x,L.y - i,L.z)
				if(lightSpotPassable(T))
					if(T.is_space())
						break
					NT = T
				else
					hitSomething = TRUE
					break
		if(EAST)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x + i,L.y,L.z)
				if(lightSpotPassable(T))
					if(T.is_space())
						break
					NT = T
				else
					hitSomething = TRUE
					break
		if(WEST)
			for(var/i = 1,i <= light_spot_range, i++)
				var/turf/T = locate(L.x - i,L.y,L.z)
				if(lightSpotPassable(T))
					if(T.is_space())
						break
					NT = T
				else
					hitSomething = TRUE
					break
	lightspot_hitObstacle = hitSomething
	place_lightspot(NT)

	if(!istype(src.loc,/mob/living))
		dir = new_dir

/obj/item/device/lighting/toggleable/flashlight/proc/place_lightspot(var/turf/T,69ar/angle = null)
	if(light_spot && on && !T.is_space())
		light_spot.forceMove(T)
		light_spot.icon_state = "nothing"
		light_spot.transform = initial(light_spot.transform)
		light_spot.set_light(light_spot_radius, light_spot_power)

		if(cell && cell.percent() <= 25)
			apply_power_deficiency()	//onhit brightness increased there
		else if(lightspot_hitObstacle)
			light_spot.set_light(light_spot_radius + 1, light_spot_power * 1.25)

		if(lightSpotPlaceable(T) && !lightspot_hitObstacle)
			var/distance = get_dist(get_turf(src),T)
			switch(distance)
				if(1)
					light_spot.icon_state = "lightspot_vclose"
				if(2)
					light_spot.icon_state = "lightspot_close"
				if(3)
					light_spot.icon_state = "lightspot_medium"
				if(4)
					light_spot.icon_state = "lightspot_far"
		if(angle)
			light_spot.transform = turn(light_spot.transform, angle)
		else
			switch(light_direction)	//icon pointing north by default
				if(SOUTH)
					light_spot.transform = turn(light_spot.transform, 180)
				if(EAST)
					light_spot.transform = turn(light_spot.transform, 90)
				if(WEST)
					light_spot.transform = turn(light_spot.transform, -90)

/obj/item/device/lighting/toggleable/flashlight/proc/lightSpotPassable(var/turf/T)
	if(is_opa69ue(T))
		return FALSE
	return TRUE

/obj/item/device/lighting/toggleable/flashlight/proc/lightSpotPlaceable(var/turf/T)	//check if we can place icon there, light will be still applied
	if(T == get_turf(src) || !isfloor(T))
		return FALSE
	for(var/obj/O in T)
		if(istype(O, /obj/structure/window))
			return FALSE
	return TRUE

/obj/item/device/lighting/toggleable/flashlight/moved(mob/user, old_loc)
	spot_locked = FALSE
	calculate_dir(old_loc)

/obj/item/device/lighting/toggleable/flashlight/entered_with_container()
	spot_locked = FALSE
	calculate_dir()

/obj/item/device/lighting/toggleable/flashlight/container_dir_changed(new_dir)
	spot_locked = FALSE
	set_dir(new_dir)

/obj/item/device/lighting/toggleable/flashlight/pre_pickup(mob/user)
	calculate_dir()
	dir = WEST
	return ..()

/obj/item/device/lighting/toggleable/flashlight/dropped(mob/user as69ob)
	if(light_direction)
		set_dir(light_direction)

/obj/item/device/lighting/toggleable/flashlight/afterattack(atom/A,69ob/user)
	var/turf/T = get_turf(A)
	if(can_see(user,T) && light_spot_range >= get_dist(get_turf(src),T))
		lightspot_hitObstacle = FALSE
		if(!lightSpotPassable(T))
			lightspot_hitObstacle = TRUE
			T = get_step_towards(T,get_turf(src))
			if(!lightSpotPassable(T))
				return
		spot_locked = TRUE
		light_direction = get_dir(src,T)
		place_lightspot(T,Get_Angle(get_turf(src),T))

/obj/item/device/lighting/toggleable/flashlight/turn_on(mob/user)
	if(!cell_check(tick_cost, user))
		playsound(loc, 'sound/machines/button.ogg', 50, 1)
		return FALSE
	. = ..()
	set_light(2,radiance_power)
	light_spot = new(get_turf(src),light_spot_radius, light_spot_power)
	light_spot.icon = 'icons/effects/64x64.dmi'
	light_spot.pixel_x = -16
	light_spot.pixel_y = -16
	light_spot.layer = ABOVE_OBJ_LAYER
	if(cell.percent() <= 25)
		apply_power_deficiency()
	calculate_dir()
	if(. && user)
		START_PROCESSING(SSobj, src)
		user.update_action_buttons()

/obj/item/device/lighting/toggleable/flashlight/turn_off(mob/user)
	. = ..()
	69del(light_spot)
	if(. && user)
		user.update_action_buttons()

/obj/item/device/lighting/toggleable/flashlight/proc/apply_power_deficiency()
	if(!cell || !light_spot)
		return
	var/hit_brightness_multiplier = 1
	var/hit_radius_addition = 0
	if(lightspot_hitObstacle)
		hit_brightness_multiplier = 1.25
		hit_radius_addition = 1

	switch(cell.percent())
		if(0 to 10)
			light_spot.set_light(max(2, round(light_spot_radius/100 * 15) + hit_radius_addition), light_spot_power/100 * 30 * hit_brightness_multiplier)
			set_light(l_power = radiance_power/100 * 15)
		if(10 to 15)
			light_spot.set_light(max(2, round(light_spot_radius/100 * 40) + hit_radius_addition), light_spot_power/100 * 50 * hit_brightness_multiplier)
			set_light(l_power = radiance_power/100 * 40)
		if(15 to 25)
			light_spot.set_light(max(2, round(light_spot_radius/100 * 70) + hit_radius_addition), light_spot_power/100 * 70 * hit_brightness_multiplier)
			set_light(l_power = radiance_power/100 * 70)

/obj/item/device/lighting/toggleable/flashlight/Process()
	if(on)
		if(!spot_locked)
			calculate_dir()
		if(!cell_use_check(tick_cost))
			if(ismob(src.loc))
				to_chat(src.loc, SPAN_WARNING("Your flashlight dies. You are alone now."))
			turn_off()
		else if(cell.percent() <= 25)
			apply_power_deficiency()

/obj/item/device/lighting/toggleable/flashlight/attack(mob/living/M,69ob/living/user)
	add_fingerprint(user)
	if(on && user.targeted_organ == BP_EYES)

		if((CLUMSY in user.mutations) && prob(50))	//too dumb to use flashlight properly
			return ..()	//just hit them in the head

		var/mob/living/carbon/human/H =69	//mob has protective eyewear
		if(istype(H))
			for(var/obj/item/clothing/C in list(H.head,H.wear_mask,H.glasses))
				if(istype(C) && (C.body_parts_covered & EYES))
					to_chat(user, SPAN_WARNING("You're going to need to remove 69C.name69 first."))
					return

			var/obj/item/organ/vision
			if(H.species.vision_organ)
				vision = H.random_organ_by_process(H.species.vision_organ)
			if(!vision)
				to_chat(user, "<span class='warning'>You can't find any 69H.species.vision_organ ? H.species.vision_organ : BP_EYES69 on 69H69!</span>")
				return

			user.visible_message(SPAN_NOTICE("\The 69user69 directs 69src69 to 69M69's eyes."), \
							 	 SPAN_NOTICE("You direct 69src69 to 69M69's eyes."))
			if(H == user)	//can't look into your own eyes buster
				if(M.stat == DEAD ||69.blinded)	//mob is dead or fully blind
					to_chat(user, SPAN_WARNING("\The 69M69's pupils do not react to the light!"))
					return
				if(XRAY in69.mutations)
					to_chat(user, SPAN_NOTICE("\The 69M69 pupils give an eerie glow!"))
				if(vision.damage)
					to_chat(user, SPAN_WARNING("There's69isible damage to 69M69's 69vision.name69!"))
				else if(M.eye_blurry)
					to_chat(user, SPAN_NOTICE("\The 69M69's pupils react slower than normally."))
				if(M.getBrainLoss() > 15)
					to_chat(user, SPAN_NOTICE("There's69isible lag between left and right pupils' reactions."))

				var/list/pinpoint = list("oxycodone"=1,"tramadol"=5)
				var/list/dilating = list("space_drugs"=5,"mindbreaker"=1)
				if(M.reagents.has_any_reagent(pinpoint) || H.ingested.has_any_reagent(pinpoint))
					to_chat(user, SPAN_NOTICE("\The 69M69's pupils are already pinpoint and cannot narrow any69ore."))
				else if(M.reagents.has_any_reagent(dilating) || H.ingested.has_any_reagent(dilating))
					to_chat(user, SPAN_NOTICE("\The 69M69's pupils narrow slightly, but are still69ery dilated."))
				else
					to_chat(user, SPAN_NOTICE("\The 69M69's pupils narrow."))

			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) //can be used offensively
			if(M.HUDtech.Find("flash"))
				flick("flash",69.HUDtech69"flash"69)
	else
		return ..()

/obj/item/device/lighting/toggleable/flashlight/pen
	name = "penlight"
	desc = "A pen-sized light, used by69edical staff."
	icon_state = "penlight"
	item_state = ""
	slot_flags = SLOT_EARS
	radiance_power = 0.4
	light_spot_radius = 2
	light_spot_power = 2
	light_spot_range = 1
	w_class = ITEM_SIZE_TINY

/obj/item/device/lighting/toggleable/flashlight/heavy
	name = "heavy duty flashlight"
	desc = "A hand-held heavy-duty light."
	icon_state = "heavyduty"
	item_state = "heavyduty"
	radiance_power = 1
	light_spot_radius = 4
	light_spot_power = 3
	light_spot_range = 4
	tick_cost = 0.8
	suitable_cell = /obj/item/cell/medium

/obj/item/device/lighting/toggleable/flashlight/seclite
	name = "Ironhammer flashlight"
	desc = "A hand-held security flashlight."
	icon_state = "seclite"
	item_state = "seclite"
	light_spot_radius = 3
	light_spot_power = 2.5

/obj/item/device/lighting/toggleable/flashlight/seclite/update_icon()
	. = ..()

	if(on)
		item_state = "69initial(icon_state)69-on"
		update_wear_icon()
	else
		item_state = "69initial(icon_state)69"
		update_wear_icon()
