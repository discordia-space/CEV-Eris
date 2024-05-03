/obj/structure/barrier
	name = "bollards"
	desc = "A barrier that allows humans to pass, but blocks mechs. Not very durable."
	description_info = "Repaired by welding and dismantled with a tool capable of bolt turning."
	icon = 'icons/obj/structures/eris_barricades.dmi'
	icon_state = "bollards"
	w_class = ITEM_SIZE_GARGANTUAN
	spawn_frequency = 0
	rarity_value = 1
	throwpass = TRUE
	anchored = TRUE
	matter = list(MATERIAL_STEEL = 10)
	health = 100
	maxHealth = 100
	var/resistance = RESISTANCE_AVERAGE // Flat reduction on incoming damage. Some day it will be moved to /obj, but not today...
	var/is_damaged // Recieved enough damage for it to be visible on the sprite
	var/is_open // Some barricades have open and closed states
	var/block_vehicles = TRUE // Prevent mechs and legacy vehicles from moving past, even if not dense


/obj/structure/barrier/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(block_vehicles)
		if(istype(mover, /mob/living/exosuit) || istype(mover, /obj/vehicle))
			// Consider notifying the pilot (if any) that they can't move because of the barrier
			return FALSE

/* // TODO: This is exclusive to ballistic barrier, should be entirely rewritten with no regard to what tables and low walls do --KIROV
	if(is_open && !density) // If barrier is deployed, but meant to only block one direction
		if(istype(mover, /obj/item/projectile))
			var/obj/item/projectile/projectile = mover
			if(projectile.original && (projectile.original == src))
				return FALSE // Specifically targeting the barricade, hit

			if(get_dir(loc, target) in list(dir, turn(dir, 45), turn(dir, -45))) // Front plate is in the way
				// Projectile targets a mob that is hiding behind the barricade
				if(projectile.original && isliving(projectile.original) && (projectile.original.loc == loc))
					var/mob/living/living = projectile.original
					if(living.lying)
						return FALSE // Aiming at a mob that's lying behind the barricade, so hit the barricade
					else if(projectile.def_zone in list(BP_R_LEG, BP_L_LEG, BP_GROIN))
						return FALSE // Targeting body part covered by the barricade, hit

				// Looking at this code some time after writing it, I think that bullets, which
				// do not directly target a mob, should be stopped anyway in some cases
				// Perhaps try to 'locate()' a mob on our tile and roll a 'prob()'?
				// TODO: See if this could be improved after player feedback comes --KIROV

			return TRUE // Good enough angle, won't be stopped by the front panel

			// Note: return FALSE for a projectile will call 'bullet_act()', in which the barricade will take damage
			// and most likely stop the projectile from moving past, see 'check_penetrate()' for details

		else if(get_dir(loc, target) == dir)
			return FALSE // Facing the open front plate, can't pass
		return TRUE
*/
	. = ..()


/obj/structure/barrier/bullet_act(obj/item/projectile/P, def_zone)
	if(prob(20))
		new /obj/effect/sparks(get_turf(P))
	P.on_hit(src)
	take_damage(P.get_structure_damage())
	return PROJECTILE_STOP


/obj/structure/barrier/take_damage(amount)
	amount -= resistance
	if(amount < 1)
		return
	health -= amount
	if(health <= 0)
		visible_message(SPAN_WARNING("\The [src] breaks apart!"))
		var/turf/turf = get_turf(src)
		var/obj/item/trash/material/metal/slug = new(turf)
		slug.matter = matter
		slug.throw_at(turf, 0, 1)
		qdel(src)
	else if(health < (maxHealth * 0.75))
		if(!is_damaged)
			is_damaged = TRUE
			update_icon()


/obj/structure/barrier/update_icon()
	var/new_icon_state = initial(icon_state)
	if(is_damaged)
		new_icon_state = "[new_icon_state]_damaged"
	if(is_open)
		new_icon_state = "[new_icon_state]_open"
	icon_state = new_icon_state


/obj/structure/barrier/attackby(obj/item/I, mob/user)
	var/list/usable_qualities = list(QUALITY_BOLT_TURNING)
	if(health < maxHealth)
		usable_qualities.Add(QUALITY_WELDING)

	var/tool_type = I.get_tool_type(user, usable_qualities)

	if(tool_type == QUALITY_WELDING)
		if(health < maxHealth)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL,  required_stat = STAT_MEC))
				user.visible_message(SPAN_NOTICE("\The [user] repairs \the [src]."), SPAN_NOTICE("You repair \the [src]."))
				health = maxHealth
				is_damaged = FALSE
				update_icon()
				return
	if(tool_type == QUALITY_BOLT_TURNING)
		if(!is_open && I.use_tool(user, src, WORKTIME_SLOW, tool_type, FAILCHANCE_NORMAL,  required_stat = STAT_MEC))
			for(var/material_name in matter)
				var/material/material_datum = get_material_by_name(material_name)
				material_datum.place_sheet(loc, amount = matter[material_name])
			user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."), SPAN_NOTICE("You dismantle \the [src]."))
			qdel(src)
			return

	user.do_attack_animation(src)
	if(I.hitsound)
		playsound(loc, I.hitsound, 50, 1, -1)
	visible_message(SPAN_DANGER("[src] has been hit by [user] with [I]."))
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	take_damage(I.force * I.structure_damage_factor)


/obj/structure/barrier/four_way
	name = "4-way barrier"
	desc = "Retractable barrier. Can be climbed over."
	description_info = "Repaired by welding, dismantled by bolt turning, toggled by prying and hacked by pulsing.\nOnly retracted barrier could be dismantled. Use a signaler on the barrier to link them, use again to break the link."
	icon_state = "4-way"
	climbable = TRUE
	block_vehicles = FALSE
	matter = list(MATERIAL_PLASTEEL = 15)
	health = 750
	maxHealth = 750
	resistance = RESISTANCE_TOUGH

	// Remote control galore
	var/code // A number from 1 to 100
	var/frequency // A number from 1200 to 1600
	var/roundstart_barrier_id // Text. Links a group of pre-mapped barriers with a signaller that has matching ID


/obj/structure/barrier/four_way/Initialize()
	. = ..()
	if(roundstart_barrier_id)
		var/list/code_and_frequency_list = GLOB.roundstart_barrier_groups[roundstart_barrier_id]
		if(!code_and_frequency_list)
			code_and_frequency_list = list(	rand(1,100), // var/code used by src and /obj/item/device/assembly/signaler
											rand(1200, 1600)) // var/frequency, just like above
			GLOB.roundstart_barrier_groups[roundstart_barrier_id] = code_and_frequency_list

		update_wifi_password(code_and_frequency_list[1], code_and_frequency_list[2])


/obj/structure/barrier/four_way/Destroy()
	if(frequency)
		SSradio.remove_object(src, frequency)
	. = ..()


/obj/structure/barrier/four_way/proc/update_wifi_password(new_code, new_frequency)
	if(frequency)
		SSradio.remove_object(src, frequency)
	code = new_code
	frequency = new_frequency
	if(frequency)
		SSradio.add_object(src, frequency)


/obj/structure/barrier/four_way/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/device/assembly/signaler))
		var/obj/item/device/assembly/signaler/signaler = I
		if((signaler.code == code) && (signaler.frequency == frequency)) // Linked signaler is used, break the link
			update_wifi_password()
			signaler.audible_message("\icon[signaler] *beep*")
		else if(!frequency || !code) // There is no link, establish one
			update_wifi_password(signaler.code, signaler.frequency)
			signaler.audible_message("\icon[signaler] *beep* *beep*")
		else // Access denied
			signaler.audible_message("\icon[signaler] *beep* *beep* *beep*") // Silly and cryptic, yet authentic signaler feedback
		return

	var/list/usable_qualities = list(QUALITY_BOLT_TURNING)
	if(health < maxHealth)
		usable_qualities.Add(QUALITY_WELDING)
	if(code || frequency)
		usable_qualities.Add(QUALITY_PULSING)

	var/tool_type = I.get_tool_type(user, usable_qualities)

	switch(tool_type)
		if(QUALITY_WELDING)
			if(health < maxHealth)
				if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL,  required_stat = STAT_MEC))
					user.visible_message(SPAN_NOTICE("\The [user] repairs \the [src]."), SPAN_NOTICE("You repair \the [src]."))
					health = maxHealth
					is_damaged = FALSE
					update_icon()
					return
		if(QUALITY_BOLT_TURNING) // Deconstruction and hacking be harder when barrier is deployed
			if(I.use_tool(user, src, (is_open ? WORKTIME_LONG : WORKTIME_NORMAL), tool_type, (is_open ? FAILCHANCE_CHALLENGING : FAILCHANCE_NORMAL),  required_stat = STAT_MEC))
				for(var/material_name in matter)
					var/material/material_datum = get_material_by_name(material_name)
					material_datum.place_sheet(loc, amount = matter[material_name])
				user.visible_message(SPAN_NOTICE("\The [user] dismantles \the [src]."), SPAN_NOTICE("You dismantle \the [src]."))
				qdel(src)
				return
		if(QUALITY_PULSING)
			if(I.use_tool(user, src, (is_open ? WORKTIME_LONG : WORKTIME_NORMAL), tool_type, (is_open ? FAILCHANCE_CHALLENGING : FAILCHANCE_NORMAL),  required_stat = STAT_MEC))
				update_wifi_password()
				return

	user.do_attack_animation(src)
	if(I.hitsound)
		playsound(loc, I.hitsound, 50, 1, -1)
	visible_message(SPAN_DANGER("[src] has been hit by [user] with [I]."))
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	take_damage(I.force * I.structure_damage_factor)


/obj/structure/barrier/four_way/receive_signal(datum/signal/signal, receive_method, receive_param)
	ASSERT(signal)
	if(signal.encryption == code)
		toggle_barrier()


/obj/structure/barrier/four_way/proc/toggle_barrier()
	is_open = !is_open
	density = !density
	playsound(loc, 'sound/machines/Custom_bolts.ogg', 20)
	update_icon()
	flick(icon_state + "_animation", src)


/obj/structure/barrier/hedgehog
	name = "serbian hedgehog"
	desc = "Static anti-mech barrier. Can be climbed over."
	description_info = "Repaired by welding and dismantled with a tool capable of bolt turning."
	icon_state = "hedgehog"
	density = TRUE
	climbable = TRUE
	matter = list(MATERIAL_STEEL = 15)
	health = 500
	maxHealth = 500
	resistance = RESISTANCE_TOUGH


/obj/structure/barrier/barbed_wire
	name = "barbed wire"
	desc = "A mesh of metal strips with sharp edges, meant to prevent trespassing."
	description_info = "Repaired with pliers and dismantled with a wire cutting tool."
	icon_state = "barbed_wire"
	block_vehicles = FALSE
	matter = list(MATERIAL_STEEL = 10)
	var/tresspass_damage = 20 // How much brute is dealt when someone tries to cross or attack the wire


/obj/structure/barrier/barbed_wire/attackby(obj/item/I, mob/user)
	var/list/usable_qualities = list(QUALITY_WIRE_CUTTING)
	if(health < maxHealth)
		usable_qualities.Add(QUALITY_CLAMPING)

	var/tool_type = I.get_tool_type(user, usable_qualities)

	if(tool_type == QUALITY_CLAMPING) // Pliers
		if(health < maxHealth)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL,  required_stat = STAT_MEC))
				user.visible_message(SPAN_NOTICE("\The [user] repairs \the [src]."), SPAN_NOTICE("You repair \the [src]."))
				health = maxHealth
				is_damaged = FALSE
				update_icon()
				return
	if(tool_type == QUALITY_WIRE_CUTTING)
		if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL,  required_stat = STAT_MEC))
			for(var/material_name in matter)
				var/material/material_datum = get_material_by_name(material_name)
				material_datum.place_sheet(loc, amount = matter[material_name])
			user.visible_message(SPAN_NOTICE("\The [user] cuts \the [src]."), SPAN_NOTICE("You cut \the [src]."))
			qdel(src)
			return

	user.do_attack_animation(src)
	if(I.hitsound)
		playsound(loc, I.hitsound, 50, 1, -1)
	visible_message(SPAN_DANGER("[src] has been hit by [user] with [I]."))
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	take_damage(I.force * I.structure_damage_factor)
	get_barb_wired(user)


/obj/structure/barrier/barbed_wire/Crossed(O)
	if(isliving(O))
		var/mob/living/user = O
		user.slowdown += 10
		if(!istype(user, /mob/living/exosuit))
			get_barb_wired(user)


/obj/structure/barrier/barbed_wire/proc/get_barb_wired(mob/user)
	if(ishuman(user))
		var/mob/living/carbon/human/human = user
		var/static/list/zones_1
		var/static/list/zones_2
		if(!zones_1)
			zones_1 = list(BP_GROIN, BP_L_LEG, BP_R_LEG)
			zones_2 = list(BP_GROIN, BP_L_LEG, BP_R_LEG, BP_L_ARM, BP_R_ARM)
		var/damage_zone = prob(50) ? pick(zones_1) : pick(zones_2) // More likely to damage legs and groin
		var/obj/item/organ/external/affecting = human.get_organ(damage_zone)
		if(affecting)
			var/damage_dealt = human.damage_through_armor(tresspass_damage, BRUTE, damage_zone, ARMOR_MELEE, sharp = TRUE, edge = TRUE, wounding_multiplier = 1)
			human.updatehealth()
			if(damage_dealt > 5) // If damage is even noticeable after armor reduced it
				to_chat(human, SPAN_DANGER("You have been cut by the barbed wire!"))
	else if(issuperioranimal(user))
		var/mob/living/carbon/superior_animal/superior_animal = user
		// Only damage roaches and such when they're pursuing someone, not when they just walk around
		if(superior_animal.target_mob)
			superior_animal.damage_through_armor(tresspass_damage, BRUTE, BP_CHEST, ARMOR_MELEE)
			superior_animal.updatehealth()

/* // TODO: Review the cover mechanic later --KIROV
/obj/structure/barrier/ballistic
	name = "ballistic barrier"
	desc = "Portable and robust directional cover."
	description_info = "Repaired by welding and dismantled with a tool capable of bolt turning.\nOnly folded barrier could be dismantled. Alt-Click to fold or unfold."
	icon_state = "ballistic"
	anchored = FALSE
	block_vehicles = FALSE
	matter = list(MATERIAL_PLASTEEL = 20)
	health = 600
	maxHealth = 600
	climbable = TRUE
	resistance = RESISTANCE_ARMOURED


/obj/structure/barrier/ballistic/AltClick(mob/user)
	// Can't fold the barrier from a distance, when standing on it, or when facing a deployed front panel
	// This is not what CanPass() meant to be used for, but otherwise it's a perfect tool for the job
	if((user.loc != loc) && CanPass(user, user.loc) && can_touch(user))
		toggle_barrier(user)


/obj/structure/barrier/ballistic/proc/toggle_barrier(mob/user)
	for(var/obj/structure/barrier/ballistic/barrier in get_turf(src))
		if(barrier.is_open && (barrier != src))
			return // Current sprites are great, but do not overlap well, corners are especially meh
	is_open = !is_open
	anchored = !anchored
	if(is_open)
		flags |= ON_BORDER
	else
		flags &= ~ON_BORDER
	playsound(loc, 'sound/machines/click.ogg', 20)
	update_icon()


/obj/structure/barrier/ballistic/update_icon()
	cut_overlays()
	var/new_icon_state = initial(icon_state)
	if(is_damaged)
		new_icon_state = "[new_icon_state]_damaged"
	if(is_open)
		new_icon_state = "[new_icon_state]_open"
		var/static/ballistic_overlay
		var/static/ballistic_overlay_damaged
		if(!ballistic_overlay)
			var/image/image = image(icon = icon, icon_state = "ballistic_overlay", layer = ABOVE_MOB_LAYER)
			ballistic_overlay = image.appearance
			image = image(icon = icon, icon_state = "ballistic_overlay_damaged", layer = ABOVE_MOB_LAYER)
			ballistic_overlay_damaged = image.appearance
		add_overlay(is_damaged ? ballistic_overlay_damaged : ballistic_overlay)
	icon_state = new_icon_state

/obj/structure/barrier/ballistic/CheckExit(atom/movable/mover, turf/target)
	if(is_open && (get_dir(loc, target) == dir))
		return FALSE // Can't step through the open front panel
	return TRUE

/obj/structure/barrier/ballistic/verb/rotate()
	set name = "Rotate"
	set category = "Object"
	set src in view(1)

	if(!anchored && can_touch(usr))
		set_dir(turn(dir, -90))
*/
