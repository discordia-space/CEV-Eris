// Waist-height object with traits from both walls and tables
// It goes over a turf, can have items and a full tile window on it, blocks movement, can be climbed over, and provides cover
/turf/wall/low
	name = "low wall"
	desc = "A waist-height wall, provides decent enough cover."
	icon = 'icons/walls.dmi'
	icon_state = "eris_low"
	opacity = FALSE
	layer = LOW_WALL_LAYER
	throwpass = TRUE
	max_health = 500
	health = 500
	is_low_wall = TRUE
	blocks_air = FALSE
	wall_type = "eris_low"

/turf/wall/low/onestar // Standard dungeon low wall, only comes in one flavor
	name = "One Star low wall"
	icon_state = "onestar_low_smart"
	wall_style = "minimalistic" // No overlays at all
	wall_type = "onestar_low"
	window_prespawned_material = "smart"

/turf/wall/low/frontier // Fancy downstream low wall, does not spawn in the wild yet
	icon_state = "frontier_low_smart"
	wall_style = "fancy" // Fancy overlays on every wall
	wall_type = "frontier_low"
	window_prespawned_material = "smart"

/turf/wall/low/with_glass
	icon_state = "eris_low_glass"
	wall_type = "eris_low"
	window_prespawned_material = MATERIAL_GLASS

/turf/wall/low/with_glass/reinforced
	icon_state = "eris_low_reinf_glass"
	window_prespawned_material = MATERIAL_RGLASS

/turf/wall/low/with_glass/smart
	icon_state = "eris_low_smart"
	window_prespawned_material = "smart" // MATERIAL_RGLASS if near space, MATERIAL_GLASS otherwise

/turf/wall/low/with_glass/plasma
	icon_state = "eris_low_plasma_glass"
	window_prespawned_material = MATERIAL_PLASMAGLASS

/turf/wall/low/with_glass/plasma_reinforced
	icon_state = "eris_low_plasma_reinf_glass"
	window_prespawned_material = MATERIAL_RPLASMAGLASS

/turf/wall/low/with_glass/smart_plasma
	icon_state = "eris_low_smart_plasma"
	window_prespawned_material = "smart_plasma" // MATERIAL_RPLASMAGLASS if near space, MATERIAL_PLASMAGLASS otherwise

/turf/wall/low/dismantle_wall(mob/user)
	if(window_type)
		shatter_window()
	..() // Call /turf/wall/proc/dismantle_wall()

/turf/wall/low/proc/shatter_window()
	playsound(src, "shatter", 70, 1)
	visible_message("Window shatters!")
	var/list/adjacent_turfs = RANGE_TURFS(1, src) - src
	if(findtext(window_type, "reinf")) // Not worth it's own variable
		new /obj/item/stack/rods(src)
	var/material/glass/window_material = get_material_by_name(window_type)
	if(istype(window_material))
		for(var/i in 1 to 6)
			var/obj/item/material/shard/shard = window_material.place_shard(src)
			if(LAZYLEN(adjacent_turfs))
				var/turf/target_turf = pick(adjacent_turfs)
				shard.throw_at(target = target_turf, range = 40, speed = 3)
	window_type = null
	window_health = null
	window_max_health = null
	window_heat_resistance = null
	window_damage_resistance = null
	blocks_air = FALSE
	update_icon()
	SSair.mark_for_update(src)

/turf/wall/low/create_window(material)
	ASSERT(material)
	if(material == "smart")
		material = is_turf_near_space(src) ? MATERIAL_RGLASS : MATERIAL_GLASS
	else if(material == "smart_plasma")
		material = is_turf_near_space(src) ? MATERIAL_RPLASMAGLASS : MATERIAL_PLASMAGLASS
	switch(material)
		if(MATERIAL_GLASS)
			window_type = MATERIAL_GLASS
			window_health = 40
			window_max_health = 40
			window_heat_resistance = T0C + 200
			window_damage_resistance = RESISTANCE_FLIMSY
		if(MATERIAL_RGLASS)
			window_type = MATERIAL_RGLASS
			window_health = 80
			window_max_health = 80
			window_heat_resistance = T0C + 750
			window_damage_resistance = RESISTANCE_FRAGILE
		if(MATERIAL_PLASMAGLASS)
			window_type = MATERIAL_PLASMAGLASS
			window_health = 200
			window_max_health = 200
			window_heat_resistance = T0C + 5227 // 5500 kelvin
			window_damage_resistance = RESISTANCE_AVERAGE
		if(MATERIAL_RPLASMAGLASS)
			window_type = MATERIAL_RPLASMAGLASS
			window_health = 250
			window_max_health = 250
			window_heat_resistance = T0C + 5453 // 6000 kelvin
			window_damage_resistance = RESISTANCE_IMPROVED
	blocks_air = TRUE
	update_icon()
	SSair.mark_for_update(src)


/turf/wall/low/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(isnull(mover)) // Air, fire, and flamethorower spread
		if(window_type || blocks_air || (target && target.blocks_air))
			return FALSE
		return TRUE
	if(window_type) // Full-tile glass blocks everything
		if(mover.checkpass(PASSGLASS)) // Except for when it doesn't
			return TRUE
		return FALSE
	if(istype(mover.loc, /turf/wall/low)) // Mover is located on a connected low wall
		return TRUE
	if(istype(mover, /obj/item/projectile))
		return check_cover(mover, target)
	if(istype(mover))
		// Its debateable whether its correct to use layer in a logic check like this
		// The main intent is to prevent creatures from walking under the wall in hide mode, there is no "under" the wall
		// This is necessary because low walls can't be placed below the hide layer due to shutters
		if(mover.checkpass(PASSTABLE) && mover.layer > layer)
			return TRUE
		return FALSE

	if(blocks_air || (target && target.blocks_air))
		return FALSE
	for(var/obj/obstacle in src)
		if(!obstacle.CanPass(mover, target, height, air_group))
			return FALSE
	if(target != src)
		for(var/obj/obstacle in target)
			if(!obstacle.CanPass(mover, src, height, air_group))
				return FALSE
	if(target != src)
		for(var/obj/obstacle in target)
			if(!obstacle.CanPass(mover, src, height, air_group))
				return FALSE
	return TRUE

//checks if projectile 'P' from turf 'from' can hit whatever is behind the table. Returns 1 if it can, 0 if bullet stops.
/turf/wall/low/proc/check_cover(obj/item/projectile/P, turf/from)
	if(config.z_level_shooting)
		if(P.height == HEIGHT_HIGH)
			return TRUE // Bullet is too high to hit
		P.height = (P.height == HEIGHT_LOW) ? HEIGHT_LOW : HEIGHT_CENTER

	if (get_dist(P.starting, loc) <= 1) //Tables won't help you if people are THIS close
		return 1
	if(get_dist(loc, P.trajectory.target) > 1 ) // Target turf must be adjacent for it to count as cover
		return TRUE
	var/valid = FALSE

	if(!P.def_zone)
		return 1 // Emitters, or anything with no targeted bodypart will always bypass the cover
	var/targetzone = check_zone(P.def_zone)
	if (targetzone in list(BP_R_LEG, BP_L_LEG, BP_GROIN))
		valid = TRUE //The lower body is always concealed
	if (ismob(P.original))
		var/mob/M = P.original
		if (M.lying)
			valid = TRUE			//Lying down covers your whole body

	// Bullet is low enough to hit the wall
	if(config.z_level_shooting && P.height == HEIGHT_LOW)
		valid = TRUE

	if(valid)
		var/pierce = P.check_penetrate(src)
		take_damage(P.get_structure_damage()/2)
		if (health > 0)
			visible_message(SPAN_WARNING("[P] hits \the [src]!"))
			return pierce
		else
			visible_message(SPAN_WARNING("[src] breaks down!"))
			qdel(src)
			return 1
	return 1

//Drag and drop onto low walls. Copied from tables
/turf/wall/low/MouseDrop_T(atom/A, mob/user, src_location, over_location, src_control, over_control, params)
	if(!CanMouseDrop(A, user)) // isghost(), incapacitated(), and Adjacent() checks
		return

	if(ismob(A.loc))
		user.unEquip(A, src)
		set_pixel_click_offset(A, params)
		return

	if(istype(A, /obj/item) && istype(A.loc, /turf) && (A.Adjacent(src) || user.Adjacent(src)))
		var/obj/item/O = A
		//Mice can push around pens and paper, but not heavy tools
		if(O.w_class <= user.can_pull_size)
			O.forceMove(src)
			set_pixel_click_offset(O, params, animate=TRUE)
			return
		else
			to_chat(user, SPAN_WARNING("[O] is too heavy for you to move!"))
			return
	// Climbing
	if(A == user)
		if(window_type)
			to_chat(user, SPAN_WARNING("A window is in the way!"))
			return
		add_fingerprint(user)
		if(user.stats.getPerk(PERK_PARKOUR))
			user.forceMove(src)
			user.visible_message(SPAN_WARNING("[user] hops onto \the [src]!"))
		else
			user.visible_message(SPAN_WARNING("[user] starts climbing onto \the [src]!"))
			if(do_after(user = user, delay = 3 SECONDS, target = src))
				user.forceMove(src)
				user.visible_message(SPAN_WARNING("[user] climbs onto \the [src]!"))


/turf/wall/low/adjacent_fire_act(turf/floor/adj_turf, datum/gas_mixture/adj_air, adj_temp, adj_volume)
	if(window_type)
		if(adj_temp > window_heat_resistance)
			take_damage(damage = 2) // Number here is average of damage_per_fire_tick variable on widows
	else
		..() // Calls /turf/wall/adjacent_fire_act()


/turf/wall/low/bullet_act(obj/item/projectile/Proj)
	Proj.on_hit(src)
	var/projectile_structure_damage = Proj.get_structure_damage()
	if(Proj.nocap_structures)
		projectile_structure_damage *= 4
	take_damage(projectile_structure_damage)


/turf/wall/low/take_damage(damage)
	if(window_health)
		var/damage_to_window = damage// - window_damage_resistance
		if(damage_to_window < 1)
			playsound(src, 'sound/effects/Glasshit.ogg', 25, 1)
			return
		var/remaining_damage = damage_to_window - health
		window_health -= damage_to_window
		if(window_health < 1)
			shatter_window()
			if(remaining_damage > 1)
				. = ..(remaining_damage) // Calls /turf/wall/take_damage(), but passes along reduced damage
		else
			playsound(src, 'sound/effects/Glasshit.ogg', 50, 1)
	else
		. = ..() // Calls /turf/wall/take_damage()


/turf/wall/low/proc/affect_grab(mob/living/user, mob/living/target, state)
	if(window_type)
		to_chat(user, SPAN_DANGER("There's a window in the way."))
		return
	if(state < GRAB_AGGRESSIVE || target.loc == loc)
		if(user.a_intent == I_HURT)
			if(prob(15))
				target.Weaken(5)
			target.damage_through_armor(12, BRUTE, BP_HEAD, ARMOR_MELEE)
			visible_message(SPAN_DANGER("[user] slams [target]'s face against \the [src]!"))
			playsound(loc, 'sound/weapons/tablehit1.ogg', 50, 1)
		else
			to_chat(user, SPAN_DANGER("You need a better grip to do that!"))
			return
	else
		target.forceMove(src)
		target.Weaken(5)
		visible_message(SPAN_DANGER("[user] puts [target] on \the [src]."))
		target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been put on \the [src] by [user.name] ([user.ckey] )</font>"
		user.attack_log += "\[[time_stamp()]\] <font color='red'>Puts [target.name] ([target.ckey] on \the [src])</font>"
		msg_admin_attack("[user] puts a [target] on \the [src].")
	return TRUE
