/obj/machinery/power/port_gen/os_generator
	name = "fusion microgenerator"
	icon = 'icons/obj/machines/one_star/machines.dmi'
	icon_state = "generator"
	circuit = /obj/item/electronics/circuitboard/os_generator
	power_gen = 0						// Watts output per power_output level
	var/can_generate_power = FALSE
	var/is_circuit_fried = FALSE		// Doesn't actually fry anything, maybe it should
	var/power_gen_gain_per_tick = 100	// How fast this thing ramps up
	var/max_power_gen = 30000
	var/max_power_output = 10			// The maximum power setting without emagging.

/obj/machinery/power/port_gen/os_generator/Initialize()
	. = ..()
	if(anchored)
		connect_to_network()

/obj/machinery/power/port_gen/os_generator/RefreshParts()
	can_generate_power = FALSE

	var/micro_laser_rating = 0
	var/capacitor_rating = 0

	for(var/obj/item/stock_parts/SP in component_parts)
		if(istype(SP, /obj/item/stock_parts/micro_laser))
			micro_laser_rating += SP.rating
		if(istype(SP, /obj/item/stock_parts/capacitor))
			capacitor_rating += SP.rating

	if(micro_laser_rating > 4 && capacitor_rating > 4)
		can_generate_power = TRUE

	var/total_rating = micro_laser_rating + capacitor_rating
	power_gen = round(initial(power_gen) * (max(2, total_rating) / 2))

/obj/machinery/power/port_gen/os_generator/update_icon()
	if(IsBroken() || is_circuit_fried)
		icon_state = initial(icon_state) + "_broken"
	else
		icon_state = initial(icon_state) + (active ? "_on" : null)

/obj/machinery/power/port_gen/os_generator/examine(mob/living/user)
	..(user)
	if(!istype(user))
		return

	var/mec_or_cog = max(user.stats.getStat(STAT_MEC), user.stats.getStat(STAT_COG))
	if(mec_or_cog >= STAT_LEVEL_PROF)
		if(can_generate_power)
			to_chat(user, "\The [src] appears to be producing [power_gen*power_output] W.")
		else
			to_chat(user, SPAN_NOTICE("\The [src] wasn\'t built correctly. One or more of its components are incompatible with the circuitry."))
		if(IsBroken())
			to_chat(user, SPAN_WARNING("\The [src] seems to have broken down."))
	else
		to_chat(user, SPAN_WARNING("You lack the knowledge or skill to comprehend \the [src]\'s functions."))

/obj/machinery/power/port_gen/os_generator/handleInactive()
	if(power_gen > 0)
		power_gen -= power_gen_gain_per_tick
		power_gen = max(power_gen, 0)

/obj/machinery/power/port_gen/os_generator/UseFuel()
	if(!can_generate_power)
		if(!is_circuit_fried)
			var/datum/effect/effect/system/smoke_spread/smoke = new
			smoke.set_up(1, 0, loc, 0)
			smoke.start()
			do_sparks(2, 0, loc)
			is_circuit_fried = TRUE
			active = FALSE
		return

	if(power_gen < max_power_gen)
		power_gen += power_gen_gain_per_tick
		power_gen = min(power_gen, max_power_gen)

/obj/machinery/power/port_gen/os_generator/attackby(obj/item/I, mob/user)
	var/mec_or_cog = max(user.stats.getStat(STAT_MEC), user.stats.getStat(STAT_COG))
	if(mec_or_cog < STAT_LEVEL_EXPERT)
		to_chat(user, SPAN_WARNING("You lack the knowledge or skill to perform work on \the [src]."))
		return

	if(active)
		to_chat(user, SPAN_NOTICE("You can't work with [src] while its running!"))
		return

	if(default_deconstruction(I,user))
		return

	if(default_part_replacement(I,user))
		return

	var/list/usable_qualities = list(QUALITY_BOLT_TURNING)

	var/tool_type = I.get_tool_type(user, usable_qualities, src)
	switch(tool_type)
		if(QUALITY_BOLT_TURNING)
			if(istype(get_turf(src), /turf/space) && !anchored)
				to_chat(user, SPAN_NOTICE("You can't anchor something to empty space. Idiot."))
				return
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_EASY, required_stat = STAT_MEC))
				to_chat(user, SPAN_NOTICE("You [anchored ? "un" : ""]anchor the brace with [I]."))
				anchored = !anchored
				if(anchored)
					connect_to_network()
				else
					disconnect_from_network()
		if(ABORT_CHECK)
			return

/obj/machinery/power/port_gen/os_generator/attack_hand(mob/user)
	..()
	if(!anchored)
		to_chat(user, SPAN_NOTICE("\The [src] needs to be anchored to the floor before you can use it."))
		return
	nano_ui_interact(user)

/obj/machinery/power/port_gen/os_generator/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(IsBroken() || is_circuit_fried)
		to_chat(user, SPAN_WARNING("You can\'t operate \the [src] while it is broken."))
		return

	var/data[0]
	data["active"] = active

	if(isAI(user))
		data["is_ai"] = 1
	else if(isrobot(user) && !Adjacent(user))
		data["is_ai"] = 1
	else
		data["is_ai"] = 0

	data["output_set"] = power_output
	data["output_max"] = max_power_output
	data["output_gain_rate"] = power_gen_gain_per_tick
	data["output_watts"] = (power_output * power_gen) ? (power_output * power_gen) : "0"
	data["output_watts_max"] = power_output * max_power_gen
	data["power_gen"] = power_gen
	data["power_gen_max"] = max_power_gen
	data["is_maxed"] = (power_gen == max_power_gen) ? TRUE : FALSE

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "os_generator.tmpl", src.name, 500, 560)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/power/port_gen/os_generator/Topic(href, href_list)
	if(..())
		return

	if(href_list["action"])
		if(href_list["action"] == "enable")
			if(!active && HasFuel() && !IsBroken())
				active = 1
				update_icon()
		if(href_list["action"] == "disable")
			if(active)
				active = 0
				update_icon()
		if(href_list["action"] == "lower_power")
			if(power_output > 1)
				power_output--
		if(href_list["action"] == "higher_power")
			if(power_output < max_power_output || (emagged && power_output < round(max_power_output*2.5)))
				power_output++

/obj/item/electronics/circuitboard/os_generator
	name = T_BOARD("fusion microgenerator")
	build_path = /obj/machinery/power/port_gen/os_generator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 3, TECH_POWER = 5, TECH_ENGINEERING = 5)
	spawn_blacklisted = TRUE
	req_components = list(
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/micro_laser = 1,		// If not OS, no output
		/obj/item/stack/cable_coil = 2,
		/obj/item/stock_parts/capacitor = 1			// If not OS, no output
	)
