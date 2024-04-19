/obj/structure/girder
	name = "wall girder"
	icon_state = "girder"
	anchored = TRUE
	density = TRUE
	layer = BELOW_OBJ_LAYER
	explosion_coverage = 0.4 // Not a lot of explosion blocking but still there
	var/resistance = RESISTANCE_TOUGH
	var/is_reinforced = FALSE // If girder have been reinforced with metal rods, finishing construction will produce a reinforced wall
	var/is_low = TRUE // If girder should produce a low wall, mutually exclusive with reinforcing

	var/static/rods_amount_to_reinforce = 2
	var/static/metal_amount_to_complete = 5

/obj/structure/girder/get_matter()
	if(is_reinforced)
		return list(MATERIAL_STEEL = 6) // Including the 2 metal rods, each is 0.5 steel
	else
		return list(MATERIAL_STEEL = 5)

/obj/structure/girder/attack_generic(mob/M, damage, attack_message = "smashes apart")
	if(damage)
		M.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		M.do_attack_animation(src)
		M.visible_message(SPAN_DANGER("\The [M] [attack_message] \the [src]!"))
		playsound(loc, 'sound/effects/metalhit2.ogg', 50, 1)
		take_damage(damage)
	else
		attack_hand(M)

/obj/structure/girder/attackby(obj/item/I, mob/user)
	ASSERT(I)
	ASSERT(user)
	if(!user.Adjacent(src))
		return
	if(user.a_intent == I_HURT)
		return ..() // Attempting to damage girder supercedes all other actions. So change your intent if you don't want to smack it

	var/list/usable_qualities = list(
		QUALITY_BOLT_TURNING, // Toggling 'anchored' var, always available
		QUALITY_WELDING) // Both repairing and deconstructing
	if(is_reinforced)
		usable_qualities.Add(QUALITY_WIRE_CUTTING) // Cutting the support beams
	else
		usable_qualities.Add(QUALITY_PRYING) // Adjusting the girder height, can't be done when reinforced

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		if(QUALITY_BOLT_TURNING)
			to_chat(user, SPAN_NOTICE("You start [anchored ? "unsecuring" : "securing"] the girder..."))
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				anchored = !anchored
				to_chat(user, SPAN_NOTICE("You've [anchored ? "unsecured" : "secured"] the girder!"))
			return
		if(QUALITY_PRYING)
			to_chat(user, SPAN_NOTICE("You start adjusting the girder height..."))
			if(I.use_tool(user, src, WORKTIME_FAST, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				is_low = !is_low
				to_chat(user, SPAN_NOTICE("You've changed the girder size. It will create a [is_low ? "low" : "regular"] wall when finished!"))
			return
		if(QUALITY_WIRE_CUTTING)
			to_chat(user, SPAN_NOTICE("You start cutting the support beams..."))
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				is_reinforced = FALSE
				new /obj/item/stack/rods(drop_location(), rods_amount_to_reinforce)
				to_chat(user, SPAN_NOTICE("You've removed metal rods from the girder. It will create a regular wall when finished!"))
			return
		if(QUALITY_WELDING)
			var/is_repairing = (health < maxHealth) ? TRUE : FALSE // Repair always comes before deconstruction with walls
			to_chat(user, SPAN_NOTICE("You start [is_repairing ? "repairing" : "dismantling"] the girder..."))
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_NORMAL, required_stat = STAT_MEC))
				if(is_repairing)
					health = maxHealth
					to_chat(user, SPAN_NOTICE("You've repaired the girder!"))
				else
					dismantle(user)
					to_chat(user, SPAN_NOTICE("You've dismantled the girder!"))
			return
		if(ABORT_CHECK)
			return

	if(istype(I, /obj/item/stack/rods))
		if(is_low)
			to_chat(user, SPAN_NOTICE("Girder is too low to be reinforced!\
			\nAdjust the girder height with prying tool first, if you want to make regular or reinforced wall.\
			\nAlternatively, you can add [metal_amount_to_complete] steel sheets to create a low wall."))
			return
		if(is_reinforced)
			to_chat(user, SPAN_NOTICE("The girder is already reinforced!\
			\nAdd [metal_amount_to_complete] plasteel to make a reinforced wall, or remove the support beams with wire cutting tool."))
			return
		else
			var/obj/item/stack/rods/rods = I
			if(rods.get_amount() < rods_amount_to_reinforce)
				to_chat(user, SPAN_NOTICE("There isn't enough rods to reinforce the girder, you need at least [rods_amount_to_reinforce]."))
				return
			to_chat(user, SPAN_NOTICE("You start reinforcing the girder..."))
			if(do_after(user, 40, src) && rods.use(rods_amount_to_reinforce))
				is_reinforced = TRUE
				to_chat(user, SPAN_NOTICE("You've reinforced the girder!\
				\nAdd [metal_amount_to_complete] plasteel to complete a reinforced wall, or use wire cutting tool to get the metal rods back."))
			else
				to_chat(user, SPAN_NOTICE("You've failed to reinforce the girder!"))

	else if(istype(I, /obj/item/stack/material))
		if(!anchored)
			to_chat(user, SPAN_NOTICE("The girder must be anchored first! Use a bolt turning tool for this."))
		else if(is_reinforced)
			if(istype(I, /obj/item/stack/material/plasteel))
				var/obj/item/stack/material/plasteel/plasteel = I
				if(do_after(user, 40, src) && plasteel.use(metal_amount_to_complete))
					construct_wall(user)
					to_chat(user, SPAN_NOTICE("You've built a reinforced wall!"))
			else
				to_chat(user, SPAN_NOTICE("You need plasteel to finish the reinforced wall!"))
		else
			if(istype(I, /obj/item/stack/material/steel))
				var/obj/item/stack/material/steel/steel = I
				if(do_after(user, 40, src) && steel.use(metal_amount_to_complete))
					construct_wall(user)
					to_chat(user, SPAN_NOTICE("You've built a [is_low ? "low " : ""]wall!"))
				else
					to_chat(user, SPAN_NOTICE("You've built a [is_low ? "low " : ""]wall!"))
			else
				to_chat(user, SPAN_NOTICE("You need steel to finish the [is_low ? "low " : ""]wall!"))
	else
		. = ..()

/obj/structure/girder/proc/construct_wall(mob/user)
	var/wall_type_to_make = /turf/wall
	if(is_low)
		wall_type_to_make = /turf/wall/low
	else if(is_reinforced)
		wall_type_to_make = /turf/wall/reinforced
	var/turf/turf_to_change = get_turf(src)
	turf_to_change.ChangeTurf(wall_type_to_make)
	var/turf/wall/created_wall = get_turf(src)
	created_wall.add_hiddenprint(user)
	qdel(src)

/obj/structure/girder/proc/dismantle(mob/living/user)
	drop_materials(drop_location(), user)
	qdel(src)

/obj/structure/girder/take_damage(damage, damage_type = BRUTE, ignore_resistance = FALSE)
	if(!ignore_resistance)
		damage -= resistance
	if(!damage || damage <= 0)
		return
	health -= damage
	if(health <= 0)
		. = health // Return value '.' in this context is damage dealth to the girder, can't be more than the current health
		dismantle()
	else
		. = damage
	. *= explosion_coverage

/obj/structure/girder/explosion_act(target_power, explosion_handler/handler)
	var/absorbed = take_damage(target_power)
	return absorbed

/obj/structure/girder/bullet_act(obj/item/projectile/P, def_zone)
	// Girders only provide partial cover. There's a chance that the projectiles will just pass through, unless you are trying to shoot the girder
	var/prop_of_blocking = is_low ? 25 : 50
	if(P.original != src && !prob(prop_of_blocking))
		return PROJECTILE_CONTINUE
	take_damage(P.get_structure_damage())

/obj/structure/girder/get_fall_damage(turf/from, turf/dest)
	. = health * 0.4 * get_health_ratio()
	if(from && dest)
		. *= abs(from.z - dest.z)
