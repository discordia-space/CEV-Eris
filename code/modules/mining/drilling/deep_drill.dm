#define RADIUS 4
#define DRILL_COOLDOWN 1 MINUTE

/obj/machinery/mining
	icon = 'icons/obj/mining_drill.dmi'
	anchored = FALSE
	use_power = NO_POWER_USE //The drill doesn't need power
	density = TRUE
	layer = MOB_LAYER+0.1 //So it draws over mobs in the tile north of it.

/obj/machinery/mining/deep_drill
	name = "deep mining drill head"
	desc = "An enormous drill to dig out deep ores."
	icon_state = "mining_drill"
	pixel_x = -16

	circuit = /obj/item/electronics/circuitboard/miningdrill

	maxHealth = 2000
	health = 2000

	var/obj/cave_generator/cave_gen
	var/cave_connected = FALSE

	var/ore_types = list(
		MATERIAL_IRON = /obj/item/ore/iron,
		MATERIAL_URANIUM = /obj/item/ore/uranium,
		MATERIAL_GOLD = /obj/item/ore/gold,
		MATERIAL_SILVER = /obj/item/ore/silver,
		MATERIAL_DIAMOND = /obj/item/ore/diamond,
		MATERIAL_PLASMA = /obj/item/ore/plasma,
		MATERIAL_OSMIUM = /obj/item/ore/osmium,
		MATERIAL_TRITIUM = /obj/item/ore/hydrogen,
		MATERIAL_GLASS = /obj/item/ore/glass,
		MATERIAL_PLASTIC = /obj/item/ore/coal
		)

	//Upgrades
	var/harvest_speed
	var/capacity
	var/charge_use
	var/radius

/obj/machinery/mining/deep_drill/Initialize()
	. = ..()
	cave_gen = locate(/obj/cave_generator)
	update_icon()

/obj/machinery/mining/deep_drill/Destroy()
	if(cave_connected)
		// In case the drill gets destroyed with an active cave system
		log_and_message_admins("Collapsing active cave system as its associated drill got destroyed.")
		cave_gen.initiate_collapse()
		cave_connected = FALSE
	if(cave_gen)
		cave_gen = null
	. = ..()

/obj/machinery/mining/deep_drill/Process()
	if(!cave_connected)
		return

	if(check_surroundings())
		system_error("ERROR W411: OBSTACLE DETECTED")
		return

	if(health == 0)
		system_error("ERROR HP00: CRITICAL DAMAGE")

	//Drill through the flooring, if any.
	if(istype(get_turf(src), /turf/floor/asteroid))
		var/turf/floor/asteroid/T = get_turf(src)
		if(!T.dug)
			T.gets_dug()
	else if(istype(get_turf(src), /turf/floor))
		var/turf/floor/T = get_turf(src)
		T.explosion_act(200, null)

/obj/machinery/mining/deep_drill/attackby(obj/item/I, mob/user as mob)

	if(!cave_connected)
		var/tool_type = I.get_tool_type(user, list(QUALITY_SCREW_DRIVING), src)
		if(tool_type == QUALITY_SCREW_DRIVING)
			var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.ogg' :  'sound/machines/Custom_screwdriverclose.ogg'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_MEC, instant_finish_tier = 30, forced_sound = used_sound))
				updateUsrDialog()
				panel_open = !panel_open
				to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maintenance hatch of \the [src] with [I]."))
				update_icon()
			return

		if(default_part_replacement(I, user))
			return

	// Attack the drill
	if (user.a_intent == I_HURT && user.Adjacent(src))
		if(!(I.flags & NOBLUDGEON))
			user.do_attack_animation(src)
			var/damage = I.force * I.structure_damage_factor
			var/volume =  min(damage * 3.5, 15)
			if (I.hitsound)
				playsound(src, I.hitsound, volume, 1, -1)
			visible_message(SPAN_DANGER("[src] has been hit by [user] with [I]."))
			take_damage(damage)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)

	// Wrench / Unwrench the drill
	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(cave_connected)
			to_chat(user, SPAN_WARNING("You have to collapse the cave first!"))
			return
		else if(cave_gen.is_collapsing() || cave_gen.is_cleaning())
			to_chat(user, SPAN_WARNING("The cave system is being collapsed!"))
			return
		else if (check_surroundings())
			to_chat(user, SPAN_WARNING("The space around \the [src] has to be clear of obstacles!"))
			return
		else if(!(istype(loc, /turf/floor/asteroid) || istype(loc, /turf/floor/exoplanet)))
			to_chat(user, SPAN_WARNING("\The [src] cannot dig that kind of ground!"))
			return

		anchored = !anchored
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
		return

	// Repair the drill if it is damaged
	var/damage = maxHealth - health
	if(damage && (QUALITY_WELDING in I.tool_qualities))
		if(cave_connected)
			to_chat(user, SPAN_WARNING("Turn \the [src] off first!"))
			return
		to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
		if(I.use_tool(user, src, WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_ROB))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
			if(damage < 0.33 * maxHealth)
				take_damage(-damage)  // Completely repair the drill
			else if(damage < 0.66 * maxHealth)
				take_damage(-(0.66 * maxHealth - health))  // Repair the drill to 66 percents
			else
				take_damage(-(0.33 * maxHealth - health))  // Repair the drill to 33 percents
		return

	if(!panel_open || cave_connected)
		return ..()

	..()

/obj/machinery/mining/deep_drill/attack_hand(mob/user as mob)

	if(!panel_open)
		if(health == 0)
			to_chat(user, SPAN_NOTICE("The drill is too damaged to be turned on."))
		else if(!anchored)
			to_chat(user, SPAN_NOTICE("The drill needs to be anchored to be turned on."))
		else if(!cave_connected && check_surroundings())
			to_chat(user, SPAN_WARNING("The space around \the [src] has to be clear of obstacles!"))

		if(!cave_connected)
			if(cave_gen.is_generating())
				to_chat(user, SPAN_WARNING("A cave system is already being dug."))
			else if(cave_gen.is_opened())
				to_chat(user, SPAN_WARNING("A cave system is already being explored."))
			else if(cave_gen.is_collapsing() || cave_gen.is_cleaning())
				to_chat(user, SPAN_WARNING("The cave system is being collapsed!"))
			else if(!cave_gen.check_cooldown())
				to_chat(user, SPAN_WARNING("The asteroid structure is too unstable for now to open a new cave system. Best to take your current haul to the ship, miner!\nYou have to wait [cave_gen.remaining_cooldown()] minutes."))
			else
				var/turf/T = get_turf(loc)
				cave_connected = cave_gen.place_ladders(loc.x, loc.y, loc.z, T.seismic_activity)
				update_icon()
		else
			if(!cave_gen.is_closed())  // If cave is already closed, something went wrong
				log_and_message_admins("[key_name(user)] has collapsed an active cave system.")
				cave_gen.initiate_collapse()
			cave_connected = FALSE
			update_icon()

		/* // Only if on mother load
		active = !active
		if(active)
			var/turf/T = get_turf(loc)
			GC = new /datum/golem_controller(location=T, seismic=T.seismic_activity, drill=src)
			visible_message(SPAN_NOTICE("\The [src] lurches downwards, grinding noisily."))
			last_use = world.time
			need_update_field = TRUE
		else
			GC.stop()
			GC = null
			visible_message(SPAN_NOTICE("\The [src] shudders to a grinding halt."))
		*/
	else
		to_chat(user, SPAN_NOTICE("Turning on a piece of industrial machinery with wires exposed is a bad idea."))

	update_icon()

/obj/machinery/mining/deep_drill/update_icon()
	if(anchored && check_surroundings())
		icon_state = "mining_drill_error"
	else if(cave_connected)
		icon_state = "mining_drill_active"
	else
		icon_state = "mining_drill"
	return


/obj/machinery/mining/deep_drill/RefreshParts()
	..()
	harvest_speed = 0
	capacity = 0
	charge_use = 37
	radius = RADIUS

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/micro_laser))
			harvest_speed = P.rating
		if(istype(P, /obj/item/stock_parts/matter_bin))
			capacity = 200 * P.rating
		if(istype(P, /obj/item/stock_parts/capacitor))
			charge_use -= 8 * (P.rating - harvest_speed)
			charge_use = max(charge_use, 0)
		if(istype(P, /obj/item/stock_parts/scanning_module))
			radius = RADIUS + P.rating

/obj/machinery/mining/deep_drill/proc/system_error(error)

	if(error)
		visible_message(SPAN_NOTICE("\The [src] flashes with '[error]' and shuts down!"))
	log_and_message_admins("An active cave system was collapsed.")
	cave_gen.initiate_collapse()
	cave_connected = FALSE
	update_icon()

/obj/machinery/mining/deep_drill/proc/check_surroundings()
	// Check if there are no walls around the drill
	for(var/turf/F in block(locate(x - 1, y - 1, z), locate(x + 1, y + 1, z)))
		if(!istype(F,/turf/floor))
			return TRUE
	return FALSE

/obj/machinery/mining/deep_drill/attack_generic(mob/user, damage)
	user.do_attack_animation(src)
	visible_message(SPAN_DANGER("\The [user] smashes into \the [src]!"))
	take_damage(damage)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)

/obj/machinery/mining/deep_drill/bullet_act(obj/item/projectile/Proj)
	..()
	var/damage = Proj.get_structure_damage()
	take_damage(damage)

/obj/machinery/mining/deep_drill/take_damage(value)
	health = min(max(health - value, 0), maxHealth)
	if(health == 0)
		system_error("critical damage")
		if(prob(10)) // Some chance that the drill completely blows up
			var/turf/O = get_turf(src)
			if(!O) return
			explosion(get_turf(src), 800, 50)
			qdel(src)

/obj/machinery/mining/deep_drill/examine(mob/user, extra_description = "")
	if(health <= 0)
		extra_description += "\n\The [src] is wrecked."
	else if(health < maxHealth * 0.33)
		extra_description += SPAN_DANGER("\n\The [src] looks like it's about to break!")
	else if(health < maxHealth * 0.66)
		extra_description += SPAN_DANGER("\n\The [src] looks seriously damaged!")
	else if(health < maxHealth)
		extra_description += "\n\The [src] shows signs of damage!"
	else
		extra_description += "\n\The [src] is in pristine condition."

	..(user, extra_description)

#undef RADIUS
#undef DRILL_COOLDOWN
