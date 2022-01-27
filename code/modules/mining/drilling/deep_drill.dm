#define RADIUS 7
#define DRILL_COOLDOWN 169INUTE

/obj/machinery/mining/deep_drill
	name = "deep69ining drill head"
	desc = "An enormous drill to dig out deep ores."
	icon_state = "mining_drill"

	circuit = /obj/item/electronics/circuitboard/miningdrill

	var/max_health = 1000
	var/health = 1000

	var/active = FALSE
	var/list/resource_field = list()
	var/datum/golem_controller/GC
	var/last_use = 0.0

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
	var/obj/item/cell/large/cell

	//Flags
	var/need_update_field = FALSE
	var/need_player_check = FALSE

/obj/machinery/mining/deep_drill/Initialize()
	. = ..()
	var/obj/item/cell/large/high/C =69ew(src)
	component_parts += C
	cell = C
	update_icon()

/obj/machinery/mining/deep_drill/Process()
	if(!active)
		return

	if(!anchored || !use_cell_power())
		system_error("system configuration or charge error")
		return

	if(check_surroundings())
		system_error("obstacle detected69ear the drill")
		return

	if(health == 0)
		system_error("critical damage")

	if(need_update_field)
		get_resource_field()

	//Drill through the flooring, if any.
	if(istype(get_turf(src), /turf/simulated/floor/asteroid))
		var/turf/simulated/floor/asteroid/T = get_turf(src)
		if(!T.dug)
			T.gets_dug()
	else if(istype(get_turf(src), /turf/simulated/floor))
		var/turf/simulated/floor/T = get_turf(src)
		T.ex_act(2)

	dig_ore()

/obj/machinery/mining/deep_drill/proc/dig_ore()
	//Dig out the tasty ores.
	if(!resource_field.len)
		system_error("resources depleted")
		return

	var/turf/simulated/harvesting = pick(resource_field)

	//remove emty trufs
	while(resource_field.len && !harvesting.resources)
		harvesting.has_resources = FALSE
		harvesting.resources =69ull
		resource_field -= harvesting
		if(resource_field.len)
			harvesting = pick(resource_field)

	if(!harvesting)
		system_error("resources depleted")
		return

	var/total_harvest = harvest_speed //Ore harvest-per-tick.
	var/found_resource = FALSE

	for(var/metal in ore_types)

		if(contents.len >= capacity)
			system_error("insufficient storage space")

		if(contents.len + total_harvest >= capacity)
			total_harvest = capacity - contents.len

		if(total_harvest <= 0)
			break

		if(harvesting.resources69metal69)

			found_resource = TRUE

			var/create_ore = 0
			if(harvesting.resources69metal69 >= total_harvest)
				harvesting.resources69metal69 -= total_harvest
				create_ore = total_harvest * GC.GW.mineral_multiplier
				total_harvest = 0
			else
				total_harvest -= harvesting.resources69metal69
				create_ore = harvesting.resources69metal69 * GC.GW.mineral_multiplier
				harvesting.resources69metal69 = 0

			for(var/i = 1, i <= create_ore, i++)
				var/oretype = ore_types69metal69
				new oretype(src)

	if(!found_resource)
		harvesting.has_resources = FALSE
		harvesting.resources =69ull
		resource_field -= harvesting

/obj/machinery/mining/deep_drill/attackby(obj/item/I,69ob/user as69ob)

	if(!active)
		if(default_deconstruction(I, user))
			return

		if(default_part_replacement(I, user))
			return

	// Attack the drill
	if (user.a_intent == I_HURT && user.Adjacent(src))
		if(!(I.flags &69OBLUDGEON))
			user.do_attack_animation(src)
			var/damage = I.force * I.structure_damage_factor
			var/volume = 69in(damage * 3.5, 15)
			if (I.hitsound)
				playsound(src, I.hitsound,69olume, 1, -1)
			visible_message(SPAN_DANGER("69src69 has been hit by 69user69 with 69I69."))
			take_damage(damage)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)

	// Wrench / Unwrench the drill
	if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(active)
			to_chat(user, SPAN_WARNING("Turn \the 69src69 off first!"))
			return
		else if (check_surroundings())
			to_chat(user, SPAN_WARNING("The space around \the 69src69 has to be clear of obstacles!"))
			return
		else if(!(istype(loc, /turf/simulated/floor/asteroid) || istype(loc, /turf/simulated/floor/exoplanet)))
			to_chat(user, SPAN_WARNING("\The 69src69 cannot dig that kind of ground!"))
			return

		anchored = !anchored
		playsound(loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You 69anchored ? "wrench" : "unwrench"69 \the 69src69.</span>")
		return

	// Repair the drill if it is damaged
	var/damage =69ax_health - health
	if(damage && (QUALITY_WELDING in I.tool_qualities))
		if(active)
			to_chat(user, SPAN_WARNING("Turn \the 69src69 off first!"))
			return
		to_chat(user, "<span class='notice'>You start repairing the damage to 69src69.</span>")
		if(I.use_tool(user, src, WORKTIME_LONG, QUALITY_WELDING, FAILCHANCE_EASY, required_stat = STAT_ROB))
			playsound(src, 'sound/items/Welder.ogg', 100, 1)
			to_chat(user, "<span class='notice'>You finish repairing the damage to 69src69.</span>")
			take_damage(-damage)
		return

	if(!panel_open || active)
		return ..()

	if(istype(I, /obj/item/cell/large))
		if(cell)
			to_chat(user, "The drill already has a cell installed.")
		else
			user.drop_item()
			I.loc = src
			cell = I
			component_parts += I
			to_chat(user, "You install \the 69I69.")
		return

	..()

/obj/machinery/mining/deep_drill/attack_hand(mob/user as69ob)

	if (panel_open && cell)
		to_chat(user, "You take out \the 69cell69.")
		cell.loc = get_turf(user)
		component_parts -= cell
		cell =69ull
		return
	else if(need_player_check)
		to_chat(user, "You hit the69anual override and reset the drill's error checking.")
		need_player_check = FALSE
		if(anchored)
			get_resource_field()
		update_icon()
		return
	else if(!panel_open)
		if(health == 0)
			to_chat(user, SPAN_NOTICE("The drill is too damaged to be turned on."))
		else if(!anchored)
			to_chat(user, SPAN_NOTICE("The drill69eeds to be anchored to be turned on."))
		else if(!active && check_surroundings())
			to_chat(user, SPAN_WARNING("The space around \the 69src69 has to be clear of obstacles!"))
		else if(world.time - last_use < DRILL_COOLDOWN)
			to_chat(user, SPAN_WARNING("\The 69src6969eeds some time to cool down! 69round((last_use + DRILL_COOLDOWN - world.time) / 10)69 seconds remaining."))
		else if(use_cell_power())
			active = !active
			if(active)
				var/turf/simulated/T = get_turf(loc)
				GC =69ew /datum/golem_controller(location=T, seismic=T.seismic_activity, drill=src)
				visible_message(SPAN_NOTICE("\The 69src69 lurches downwards, grinding69oisily."))
				last_use = world.time
				need_update_field = TRUE
			else
				GC.stop()
				GC =69ull
				visible_message(SPAN_NOTICE("\The 69src69 shudders to a grinding halt."))
		else
			to_chat(user, SPAN_NOTICE("The drill is unpowered."))
	else
		to_chat(user, SPAN_NOTICE("Turning on a piece of industrial69achinery with wires exposed is a bad idea."))

	update_icon()

/obj/machinery/mining/deep_drill/update_icon()
	if(need_player_check)
		icon_state = "mining_drill_error"
	else if(active)
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
			charge_use =69ax(charge_use, 0)
		if(istype(P, /obj/item/stock_parts/scanning_module))
			radius = RADIUS + P.rating
	cell = locate(/obj/item/cell/large) in component_parts

/obj/machinery/mining/deep_drill/proc/system_error(error)

	if(error)
		visible_message(SPAN_NOTICE("\The 69src69 flashes a '69error69' warning."))
	need_player_check = TRUE
	active = FALSE
	if(GC)
		GC.stop()
		GC =69ull
	update_icon()

/obj/machinery/mining/deep_drill/proc/get_resource_field()
	resource_field = list()
	need_update_field = FALSE

	var/turf/simulated/T = get_turf(src)
	if(!istype(T))
		return

	for(var/turf/simulated/mine_trufs in range(T, radius))
		if(mine_trufs.has_resources)
			resource_field +=69ine_trufs

	if(!resource_field.len)
		system_error("resources depleted")

/obj/machinery/mining/deep_drill/proc/use_cell_power()
	if(!cell)
		return FALSE
	if(cell.checked_use(charge_use))
		return TRUE
	return FALSE

/obj/machinery/mining/deep_drill/proc/check_surroundings()
	// Check if there is69o dense obstacles around the drill to avoid blocking access to it
	for(var/turf/F in block(locate(x - 1, y - 1, z), locate(x + 1, y + 1, z)))
		if(F != loc)
			if(F.density)
				return TRUE
			for(var/atom/A in F)
				if(A.density && !(A.flags & ON_BORDER) && !ismob(A))
					return TRUE
	return FALSE

/obj/machinery/mining/deep_drill/attack_generic(mob/user, damage)
	user.do_attack_animation(src)
	visible_message(SPAN_DANGER("\The 69user69 smashes into \the 69src69!"))
	take_damage(damage)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN * 1.5)

/obj/machinery/mining/deep_drill/bullet_act(obj/item/projectile/Proj)
	..()
	var/damage = Proj.get_structure_damage()
	take_damage(damage)

/obj/machinery/mining/deep_drill/proc/take_damage(value)
	health =69in(max(health -69alue, 0),69ax_health)
	if(health == 0)
		system_error("critical damage")
		if(prob(10)) // Some chance that the drill completely blows up
			var/turf/O = get_turf(src)
			if(!O) return
			explosion(O, -1, 1, 4, 10)
			qdel(src)

/obj/machinery/mining/deep_drill/examine(mob/user)
	. = ..()
	if(health <= 0)
		to_chat(user, "\The 69src69 is wrecked.")
	else if(health <69ax_health * 0.25)
		to_chat(user, "<span class='danger'>\The 69src69 looks like it's about to break!</span>")
	else if(health <69ax_health * 0.5)
		to_chat(user, "<span class='danger'>\The 69src69 looks seriously damaged!</span>")
	else if(health <69ax_health * 0.75)
		to_chat(user, "\The 69src69 shows signs of damage!")

/obj/machinery/mining/deep_drill/verb/unload()
	set69ame = "Unload Drill"
	set category = "Object"
	set src in oview(1)

	var/mob/M = usr
	if(ismob(M) &&69.incapacitated())
		return

	var/obj/structure/ore_box/B = locate() in orange(1)
	if(B)
		for(var/obj/item/ore/O in contents)
			O.loc = B
		to_chat(usr, SPAN_NOTICE("You unload the drill's storage cache into the ore box."))
	else
		to_chat(usr, SPAN_NOTICE("You69ust69ove an ore box up to the drill before you can unload it."))

#undef RADIUS
#undef DRILL_COOLDOWN
