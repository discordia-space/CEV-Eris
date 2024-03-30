/obj/structure/barrier
	name = "bollards"
	desc = "A barrier that allows humans to pass, but blocks vehicles. Not very durable."
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
	var/is_damaged // Recieved enough damage for it to be visible on the sprite
	var/is_open // Some barricades have open and closed states
	var/is_animated // If sprite comes with opening and closing animations
	var/block_vehicles = TRUE // Prevent mechs and legacy vehicles from moving past, even if not dense


/obj/structure/barrier/CanPass(atom/movable/mover, turf/target, height, air_group)
	if(block_vehicles)
		if(istype(mover, /mob/living/exosuit) || istype(mover, /obj/vehicle))
			// Consider notifying the pilot (if any) that they can't move because of the barrier
			return FALSE

	if(is_open && !density) // If barrier is deployed, but meant to only block one direction
		if(get_dir(loc, target) == dir)
			return FALSE
		else if(istype(mover, /obj/item/projectile))
			// Achtung! This is fifth time the code below is being copypasted
			// TODO: Maybe do something about that
			// TODO: Also review the code itself, doesn't look great
			var/obj/item/projectile/P = mover
			if(config.z_level_shooting)
				if(P.height == HEIGHT_HIGH)
					return TRUE // Bullet is too high to hit
				P.height = (P.height == HEIGHT_LOW) ? HEIGHT_LOW : HEIGHT_CENTER

			if(get_dist(P.starting, loc) <= 1) // Cover won't help you if people are THIS close
				return TRUE
			if(get_dist(loc, P.trajectory.target) > 1 ) // Target turf must be adjacent for it to count as cover
				return TRUE
			if(!P.def_zone)
				return TRUE // Emitters, or anything with no targeted bodypart will always bypass the cover

			var/valid = FALSE
			var/targetzone = check_zone(P.def_zone)
			if(targetzone in list(BP_R_LEG, BP_L_LEG, BP_GROIN))
				valid = TRUE // Lower body is always concealed
			if(ismob(P.original))
				var/mob/M = P.original
				if(M.lying)
					valid = TRUE // Lying down covers your whole body
			// Bullet is low enough to hit
//			if(config.z_level_shooting && P.height == HEIGHT_LOW)
//				valid = TRUE
			if(valid)
				take_damage(P.get_structure_damage())
				return P.check_penetrate(src)
			return TRUE
	. = ..()


/obj/structure/barrier/bullet_act(obj/item/projectile/P, def_zone)
	if(prob(15))
		new /obj/effect/sparks(get_turf(P))
	P.on_hit(src)
	take_damage(P.get_structure_damage())
	return PROJECTILE_STOP


/obj/structure/barrier/take_damage(amount)
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
	if(is_animated)
		flick(new_icon_state + "_animation", src)


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
				return
	if(tool_type == QUALITY_BOLT_TURNING)
		if(!is_open && I.use_tool(user, src, WORKTIME_SLOW, tool_type, FAILCHANCE_NORMAL,  required_stat = STAT_MEC))
			for(var/material_name in matter)
				var/material/material_datum = get_material_by_name(material_name)
				material_datum.place_sheet(src, amount = matter[material_name])
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
	desc = "Retractable barrier. Could be climbed over."
	description_info = "Repaired by welding and dismantled with a tool capable of bolt turning.\nOnly retracted barrier could be dismantled. Alt-Click to set an ID for remote control."
	icon_state = "4-way"
	climbable = TRUE
	is_animated = TRUE
	block_vehicles = FALSE
	matter = list(MATERIAL_PLASTEEL = 15)
	health = 750
	maxHealth = 750
	var/_wifi_id
	var/datum/wifi/receiver/button/barrier/wifi_receiver


/obj/structure/barrier/four_way/Initialize()
	. = ..()
	if(_wifi_id)
		wifi_receiver = new(_wifi_id, src)


/obj/structure/barrier/four_way/Destroy()
	QDEL_NULL(wifi_receiver)
	wifi_receiver = null
	. = ..()


/obj/structure/barrier/four_way/AltClick(mob/user)
	if(!_wifi_id && can_touch(user))
		// PROMPT FOR _wifi_id HERE
		// var/new_wifi_id = input(user, "Enter an ID for remote activation:", name) as null|text
		// if(new_wifi_id)
		// 	_wifi_id = new_wifi_id
		// 	wifi_receiver = new(_wifi_id, src)

		// Don't use that shit, it's... well, shit

/obj/structure/barrier/four_way/proc/toggle_barrier()
	is_open = !is_open
	density = !density
	update_icon()


/obj/structure/barrier/hedgehog
	name = "Serb hedgehog"
	desc = "Static anti-mech barrier. Could be climbed over."
	description_info = "Repaired by welding and dismantled with a tool capable of bolt turning."
	icon_state = "hedgehog"
	density = TRUE
	climbable = TRUE
	matter = list(MATERIAL_STEEL = 15)
	health = 500
	maxHealth = 500


/obj/structure/barrier/barbed_wire
	name = "barbed wire"
	desc = "A mesh of metal strips with sharp edges, meant to prevent trespassing."
	description_info = "Repaired with pliers and dismantled with a wire cutting tool."
	icon_state = "barbed_wire"
	block_vehicles = FALSE
	matter = list(MATERIAL_STEEL = 10)
	var/tresspass_damage = 15 // How much brute is dealt when someone tries to cross or attack the wire


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
				return
	if(tool_type == QUALITY_WIRE_CUTTING)
		if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL,  required_stat = STAT_MEC))
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


/obj/structure/barrier/ballistic/AltClick(mob/user)
	// Can't fold the barrier from a distance, when standing on it, or when facing a deployed front panel
	// This is not what CanPass() meant to be used for, but otherwise it's a perfect tool for the job
	if((user.loc != loc) && CanPass(user, user.loc) && can_touch(user))
		toggle_barrier(user)


/obj/structure/barrier/ballistic/proc/toggle_barrier(mob/user)
	is_open = !is_open
	anchored = !anchored
	if(is_open)
		flags |= ON_BORDER
	else
		flags &= ~ON_BORDER
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
