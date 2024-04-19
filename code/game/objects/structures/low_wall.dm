#define OVERLAY_NONE		1 // No overlays beyond the base low wall
#define OVERLAY_WALL_ONLY	2 // Only add extra overlays when connected to the wall
#define OVERLAY_FULL		3 // Always add extra overlays

// Waist-height object with some traits from both walls and tables
// It goes over a turf, can have items and a full tile window on it, blocks movement, can be climbed over, and provides cover
/turf/wall/low
	name = "low wall"
	desc = ""
	icon = 'icons/test_walls_best_walls.dmi'
	icon_state = "frontier_low" // eris_low
	density = TRUE
	opacity = FALSE
	layer = LOW_WALL_LAYER
	throwpass = TRUE
	maxHealth = 450
	health = 450
	is_low_wall = TRUE
	var/overlay_type = OVERLAY_FULL // OVERLAY_WALL_ONLY

	var/window
	var/window_health
	var/window_maxHealth

// Remember /obj/effect/window_lwall_spawn

/turf/wall/low/onestar
	name = "One Star low wall"
	icon_state = "onestar_low"
	overlay_type = OVERLAY_NONE

/turf/wall/low/frontier
	name = "low wall"
	icon_state = "frontier_low"
	overlay_type = OVERLAY_FULL

/turf/wall/low/update_icon()
	// We'll be using 4 overlays for each corner instead of an icon_state, which will be empty
	// It is, however, set to a preview image initially, so mappers see a wall instead of a purple square
	icon_state = ""
	cut_overlays()
	var/initial_icon_state = initial(icon_state)
	for(var/overlay_direction in cardinal)
		var/connection_type = get_overlay_connection_type(overlay_direction, any_wall_connections)
		var/image/image = image(icon, icon_state = "[initial_icon_state]_[connection_type]", dir = overlay_direction)
		add_overlay(image.appearance)

		var/overlay_icon_state = "[initial_icon_state]_over_[connection_type]"
		var/add_extra_overlay
		if(overlay_type == OVERLAY_FULL)
			add_extra_overlay = TRUE
			if(connection_type == "horizontal") // Use an alternative sprite when connecting to a corner
				if((overlay_direction == SOUTH) && any_wall_connections[SOUTHWEST])
					overlay_icon_state = "[initial_icon_state]_over_[connection_type]_right_angle"
				if((overlay_direction == WEST) && any_wall_connections[SOUTHEAST])
					overlay_icon_state = "[initial_icon_state]_over_[connection_type]_right_angle"

		if(overlay_type == OVERLAY_WALL_ONLY)
			add_extra_overlay = full_wall_connections[overlay_direction]

		if(add_extra_overlay)
			image = image(icon, icon_state = overlay_icon_state, dir = overlay_direction, layer = ABOVE_WINDOW_LAYER)
			add_overlay(image.appearance)

	var/obj/structure/window/window = locate() in loc
	if(window)
		window.update_icon()

#undef OVERLAY_NONE
#undef OVERLAY_WALL_ONLY
#undef OVERLAY_FULL

/turf/wall/low/Initialize(mapload, ...)
	..()
	if(mapload)
		return INITIALIZE_HINT_LATELOAD
	update_connections()
	update_icon()

/turf/wall/low/LateInitialize()
	update_connections()
	update_icon()

/turf/wall/low/dismantle_wall(mob/user)
	if(window)
		shatter_window()
	..() // Call /turf/wall/proc/dismantle_wall()


/turf/wall/low/proc/shatter_window()
	return

/turf/wall/low/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(istype(mover,/obj/item/projectile))
		return (check_cover(mover,target))

	//Its debateable whether its correct to use layer in a logic check like this.
	//The main intent is to prevent creatures from walking under the wall in hide mode, there is no "under" the wall.
	//This is necessary because low walls can't be placed below the hide layer due to shutters
	if(istype(mover) && mover.checkpass(PASSTABLE) && mover.layer > layer)
		return TRUE
	if(locate(/turf/wall/low) in get_turf(mover))
		return TRUE
	if(isliving(mover))
		var/mob/living/L = mover
		if(L.weakened)
			return TRUE
	return ..()

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
	if(!CanMouseDrop(A, user))
		return

	if(ismob(A.loc))
		user.unEquip(A, loc)
		set_pixel_click_offset(A, params)
		return

	if(istype(A, /obj/item) && istype(A.loc, /turf) && (A.Adjacent(src) || user.Adjacent(src)))
		var/obj/item/O = A
		//Mice can push around pens and paper, but not heavy tools
		if(O.w_class <= user.can_pull_size)
			O.forceMove(loc)
			set_pixel_click_offset(O, params, animate=TRUE)
			return
		else
			to_chat(user, SPAN_WARNING("[O] is too heavy for you to move!"))
			return

	// CLIMBING CODE GOES HERE, DON'T FORGET --KIROV

/turf/wall/low/attack_generic(mob/M, damage, attack_message)
	if(damage)
		playsound(loc, 'sound/effects/metalhit2.ogg', 50, 1)
		M.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		M.do_attack_animation(src)
		M.visible_message(SPAN_DANGER("\The [M] [attack_message] \the [src]!"))
		take_damage(damage*2)
	else
		attack_hand(M)

/turf/wall/attack_generic(mob/user, damage, attack_message)
	if(!is_simulated)
		return
	ASSERT(user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!damage)
		attack_hand(user)
	else if(damage >= hardness)
		to_chat(user, SPAN_DANGER("You smash through the wall!"))
		user.do_attack_animation(src)
		dismantle_wall(user)
	else
		playsound(src, pick(WALLHIT_SOUNDS), 50, 1)
		to_chat(user, SPAN_DANGER("You smash against the wall!"))
		user.do_attack_animation(src)
		take_damage(rand(15,45))







/turf/wall/low/take_damage(damage)
	. = health - damage < 0 ? damage - (damage - health) : damage
	if(locate(/obj/effect/overlay/wallrot) in src)
		damage *= 10
	health -= damage
	if(health < 0)
		dismantle_wall()
	else
		update_icon()
/*
/turf/wall/low/affect_grab(mob/living/user, mob/living/target, state)
	if(window)
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
		target.forceMove(loc)
		target.Weaken(5)
		visible_message(SPAN_DANGER("[user] puts [target] on \the [src]."))
		target.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been put on \the [src] by [user.name] ([user.ckey] )</font>"
		user.attack_log += "\[[time_stamp()]\] <font color='red'>Puts [target.name] ([target.ckey] on \the [src])</font>"
		msg_admin_attack("[user] puts a [target] on \the [src].")
	return TRUE
*/

