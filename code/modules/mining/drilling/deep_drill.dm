#define DRILL_REPAIR_AMOUNT 500

//these are defined because a few of them are used in multiple places and this makes it easier to work with them all at once
#define DRILL_SHUTDOWN_TEXT_BROKEN "ERROR HP00: CRITICAL DAMAGE"
#define DRILL_SHUTDOWN_TEXT_OBSTACLE "ERROR W411: OBSTACLE DETECTED"

#define DRILL_SHUTDOWN_LOG_BROKEN "A cave system was collapsed because its associated drill was destroyed."
#define DRILL_SHUTDOWN_LOG_OBSTACLE "A cave system was collapsed because its associated drill was too close to an obstacle."
#define DRILL_SHUTDOWN_LOG_MANUAL "[key_name(user)] has collapsed an active cave system."

/obj/machinery/mining
	icon = 'icons/obj/mining_drill.dmi'
	anchored = FALSE
	use_power = NO_POWER_USE //The drill doesn't need power
	density = TRUE
	layer = MOB_LAYER+0.1 //So it draws over mobs in the tile north of it.

/obj/machinery/mining/deep_drill
	name = "deep mining drill head"
	desc = "An enormous drill to dig out deep ores."
	description_info = "Can be used to open caves on asteroid surfaces, with difficulty and ore level depending on the seismic level of the tile it's activated on.\nThe seismic level of a tile can be found with a subsurface ore detector."
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

/obj/machinery/mining/deep_drill/Initialize()
	. = ..()
	cave_gen = locate(/obj/cave_generator)
	update_icon()

/obj/machinery/mining/deep_drill/Destroy()
	if(cave_connected)
		// In case the drill gets destroyed with an active cave system
		shutdown_drill(DRILL_SHUTDOWN_TEXT_BROKEN,DRILL_SHUTDOWN_LOG_OBSTACLE)
	if(cave_gen)
		cave_gen = null
	. = ..()

/obj/machinery/mining/deep_drill/Process()
	if(!cave_connected)
		return

	if(check_surroundings())
		shutdown_drill(DRILL_SHUTDOWN_TEXT_OBSTACLE,DRILL_SHUTDOWN_LOG_OBSTACLE)
		return

	if(health == 0)
		shutdown_drill(DRILL_SHUTDOWN_TEXT_BROKEN,DRILL_SHUTDOWN_LOG_OBSTACLE)

	//Drill through the flooring, if any.
	if(istype(get_turf(src), /turf/floor/asteroid))
		var/turf/floor/asteroid/T = get_turf(src)
		if(!T.dug)
			T.gets_dug()
	else if(istype(get_turf(src), /turf/floor))
		var/turf/floor/T = get_turf(src)
		visible_message(SPAN_NOTICE("\The [src] drills straight through the [T], exposing the asteroid underneath!"))
		T.ChangeTurf(/turf/floor/asteroid) //turn it back into an asteroid, otherwise things like platings become underplatings which makes no sense


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
	if(user.a_intent == I_HURT && user.Adjacent(src))
		if(!(I.flags & NOBLUDGEON))
			user.do_attack_animation(src)
			var/damage = I.force * I.structure_damage_factor
			var/volume =  min(damage * 3.5, 15)
			if(I.hitsound)
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
		else if(!anchored && check_surroundings()) // we only care about the terrain when anchoring, not the other way around, otherwise the drill gets stuck if the terrain under it changes (like if someone RCDs the asteroid tile under it)
			to_chat(user, SPAN_WARNING("The space around \the [src] has to be clear of obstacles!"))
			return

		anchored = !anchored
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
		return

	// Repair the drill if it is damaged
	if((health < maxHealth) && (QUALITY_WELDING in I.tool_qualities))
		if(cave_connected)
			to_chat(user, SPAN_WARNING("Turn \the [src] off first!"))
			return

		to_chat(user, "<span class='notice'>You start repairing the damage to [src].</span>")
		if(I.use_tool(user, src, WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_ROB))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You finish repairing the damage to [src].</span>")
			health = min(maxHealth, health + DRILL_REPAIR_AMOUNT)

		return

	if(!panel_open || cave_connected)
		return ..()

	..()

/obj/machinery/mining/deep_drill/attack_hand(mob/user as mob)

	if(!panel_open)
		if(cave_connected) //there are no restrictions on turning off the drill besides the panel being shut.
			shutdown_drill(null,DRILL_SHUTDOWN_LOG_MANUAL)
			to_chat(user, SPAN_NOTICE("You turn off \the [src], collapsing the attached cave system."))
		else
			if(health == 0)
				to_chat(user, SPAN_NOTICE("\The [src] is too damaged to turn on!"))
			else if(!anchored)
				to_chat(user, SPAN_NOTICE("\The [src] needs to be anchored to be turned on."))
			else if(check_surroundings())
				to_chat(user, SPAN_WARNING("The space around \the [src] has to be clear of obstacles!"))
			else if(cave_gen.is_generating())
				to_chat(user, SPAN_WARNING("A cave system is already being dug."))
			else if(cave_gen.is_opened())
				to_chat(user, SPAN_WARNING("A cave system is already being explored."))
			else if(cave_gen.is_collapsing() || cave_gen.is_cleaning())
				to_chat(user, SPAN_WARNING("The cave system is being collapsed!"))
			else if(!cave_gen.check_cooldown())
				to_chat(user, SPAN_WARNING("The asteroid structure is too unstable for now to open a new cave system. Best to take your current haul to the ship, miner!\nYou have to wait [cave_gen.remaining_cooldown()] minutes."))
			else //if we've gotten this far all the checks have succeeded so we can turn it on and gen a cave
				var/turf/T = get_turf(loc)
				cave_connected = cave_gen.place_ladders(loc.x, loc.y, loc.z, T.seismic_activity)
	else
		to_chat(user, SPAN_NOTICE("Operating a piece of industrial machinery with wires exposed seems like a bad idea."))

	update_icon()

/obj/machinery/mining/deep_drill/update_icon()
	if(anchored && (check_surroundings() || !istype(get_turf(src), /turf/floor/asteroid)))
		icon_state = "mining_drill_error"
	else if(cave_connected)
		icon_state = "mining_drill_active"
	else
		icon_state = "mining_drill"
	return

/obj/machinery/mining/deep_drill/proc/shutdown_drill(displaytext,log)

	if(cave_gen.is_closed()) //easy sanity check
		return

	if(displaytext)
		visible_message(SPAN_NOTICE("\The [src] flashes with '[displaytext]' and shuts down!"))
		log_and_message_admins(log)
	cave_gen.initiate_collapse()
	cave_connected = FALSE
	update_icon()

/obj/machinery/mining/deep_drill/proc/check_surroundings()
	// Check if there are no walls around the drill
	for(var/turf/F in block(locate(x - 1, y - 1, z), locate(x + 1, y + 1, z)))
		if(!istype(F,/turf/floor) && !istype(F,/turf/space)) //if it's not a floor and not space it's probably an obstacle.
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
		shutdown_drill("critical damage")
		if(prob(10)) // Some chance that the drill completely blows up
			var/turf/O = get_turf(src)
			if(!O) return
			explosion(get_turf(src), 800, 50)
			qdel(src)

/obj/machinery/mining/deep_drill/examine(mob/user, extra_description = "")
	if(cave_connected)
		switch(cave_gen.orecount)
			if(-INFINITY to 3)
				extra_description += SPAN_NOTICE("\nThe integrated ore scanner can't detect any ore in the attached cave.")
			if(3 to 10)
				extra_description += SPAN_NOTICE("\nThe integrated ore scanner barely detects any ore in the attached cave.")
			if(10 to 50)
				extra_description += SPAN_NOTICE("\nThe integrated ore scanner still detects plenty of ore in the attached cave.")
			if(50 to INFINITY)
				extra_description += SPAN_NOTICE("\nThe integrated ore scanner detects an abundance of ore in the attached cave.")
			else //something has gone wrong
				extra_description += SPAN_WARNING("\nThe integrated ore scanner seems to be malfunctioning.")
	if(health < maxHealth)
		switch(health)
			if(-INFINITY to 0)
				extra_description += "\n\The [src] is wrecked."
			if(0 to 600)
				extra_description += SPAN_DANGER("\n\The [src] looks like it's about to break!")
			if(600 to 1200)
				extra_description += SPAN_DANGER("\n\The [src] looks seriously damaged!")
			else
				extra_description += "\n\The [src] shows signs of damage!"
	else
		extra_description += "\n\The [src] is in pristine condition."

	..(user, extra_description)

#undef DRILL_REPAIR_AMOUNT

#undef DRILL_SHUTDOWN_TEXT_BROKEN
#undef DRILL_SHUTDOWN_TEXT_OBSTACLE

#undef DRILL_SHUTDOWN_LOG_BROKEN
#undef DRILL_SHUTDOWN_LOG_OBSTACLE
#undef DRILL_SHUTDOWN_LOG_MANUAL

