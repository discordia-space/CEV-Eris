/obj/machinery/mining/deep_drill
	name = "mining drill head"
	desc = "An enormous drill."
	icon_state = "mining_drill"

	circuit = /obj/item/electronics/circuitboard/miningdrill

	var/braces_needed = 2
	var/list/supports = list()
	var/active = FALSE
	var/list/resource_field = list()

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

/obj/machinery/mining/deep_drill/Destroy()

	for(var/obj/machinery/mining/brace/b in supports)
		b.disconnect()
	return ..()

/obj/machinery/mining/deep_drill/Initialize()
	. = ..()
	var/obj/item/cell/large/high/C = new(src)
	component_parts += C
	cell = C
	update_icon()

/obj/machinery/mining/deep_drill/Process()
	if(!active)
		return

	if(!anchored || !use_cell_power())
		system_error("system configuration or charge error")
		return

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
		harvesting.resources = null
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

		if(harvesting.resources[metal])

			found_resource = TRUE

			var/create_ore = 0
			if(harvesting.resources[metal] >= total_harvest)
				harvesting.resources[metal] -= total_harvest
				create_ore = total_harvest
				total_harvest = 0
			else
				total_harvest -= harvesting.resources[metal]
				create_ore = harvesting.resources[metal]
				harvesting.resources[metal] = 0

			for(var/i = 1, i <= create_ore, i++)
				var/oretype = ore_types[metal]
				new oretype(src)

	if(!found_resource)
		harvesting.has_resources = FALSE
		harvesting.resources = null
		resource_field -= harvesting

/obj/machinery/mining/deep_drill/attackby(obj/item/I, mob/user as mob)

	if(!active)
		if(default_deconstruction(I, user))
			return

		if(default_part_replacement(I, user))
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
			to_chat(user, "You install \the [I].")
		return

    if(QUALITY_BOLT_TURNING in I.tool_qualities)
		if(active)
			to_chat(user, SPAN_WARNING("Turn \the [src] off first!"))
			return

		anchored = !anchored
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		to_chat(user, "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>")
		return

	..()

/obj/machinery/mining/deep_drill/attack_hand(mob/user as mob)

	if (panel_open && cell)
		to_chat(user, "You take out \the [cell].")
		cell.loc = get_turf(user)
		component_parts -= cell
		cell = null
		return
	else if(need_player_check)
		to_chat(user, "You hit the manual override and reset the drill's error checking.")
		need_player_check = 0
		if(anchored)
			get_resource_field()
		update_icon()
		return
	else if(!panel_open)
		if(use_cell_power())
			active = !active
			if(active)
				visible_message(SPAN_NOTICE("\The [src] lurches downwards, grinding noisily."))
				need_update_field = 1
			else
				visible_message(SPAN_NOTICE("\The [src] shudders to a grinding halt."))
		else
			to_chat(user, SPAN_NOTICE("The drill is unpowered."))
	else
		to_chat(user, SPAN_NOTICE("Turning on a piece of industrial machinery with wires exposed is a bad idea."))

	update_icon()

/obj/machinery/mining/deep_drill/on_update_icon()
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
	radius = 0

	for(var/obj/item/stock_parts/P in component_parts)
		if(istype(P, /obj/item/stock_parts/micro_laser))
			harvest_speed = P.rating
		if(istype(P, /obj/item/stock_parts/matter_bin))
			capacity = 200 * P.rating
		if(istype(P, /obj/item/stock_parts/capacitor))
			charge_use -= 8 * (P.rating - harvest_speed)
			charge_use = max(charge_use, 0)
		if(istype(P, /obj/item/stock_parts/scanning_module))
			radius = 1 + P.rating
	cell = locate(/obj/item/cell/large) in component_parts

/obj/machinery/mining/deep_drill/proc/system_error(var/error)

	if(error)
		visible_message(SPAN_NOTICE("\The [src] flashes a '[error]' warning."))
	need_player_check = TRUE
	active = FALSE
	update_icon()

/obj/machinery/mining/deep_drill/proc/get_resource_field()
	resource_field = list()
	need_update_field = FALSE

	var/turf/T = get_turf(src)
	if(!istype(T))
		return

	for(var/turf/simulated/mine_trufs in range(T, radius))
		if(mine_trufs.has_resources)
			resource_field += mine_trufs

	if(!resource_field.len)
		system_error("resources depleted")

/obj/machinery/mining/deep_drill/proc/use_cell_power()
	if(!cell)
		return FALSE
	if(cell.checked_use(charge_use))
		return TRUE
	return FALSE

/obj/machinery/mining/deep_drill/verb/unload()
	set name = "Unload Drill"
	set category = "Object"
	set src in oview(1)

	if(usr.stat)
		return

	var/obj/structure/ore_box/B = locate() in orange(1)
	if(B)
		for(var/obj/item/ore/O in contents)
			O.loc = B
		to_chat(usr, SPAN_NOTICE("You unload the drill's storage cache into the ore box."))
	else
		to_chat(usr, SPAN_NOTICE("You must move an ore box up to the drill before you can unload it."))
