/obj/item/integrated_circuit/mining/ore_analyzer
	name = "ore analyzer"
	desc = "Analyzes a rock for its ore type."
	extended_desc = "Takes a reference for an object and checks if it is a rock first. If that is the case, it outputs the69ineral \
	inside the rock."
	category_text = "Mining"
	ext_cooldown = 1
	complexity = 20
	cooldown_per_use = 1 SECONDS
	inputs = list(
		"rock" = IC_PINTYPE_REF
		)
	outputs = list(
		"ore type" = IC_PINTYPE_STRING,
		"amount" = IC_PINTYPE_NUMBER
		)
	activators = list(
		"analyze" = IC_PINTYPE_PULSE_IN,
		"on analyzed" = IC_PINTYPE_PULSE_OUT,
		"on found" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 20
	var/ore/mineral

/obj/item/integrated_circuit/mining/ore_analyzer/do_work()
	var/turf/simulated/mineral/rock = get_pin_data(IC_INPUT, 1)
	if(!istype(rock,/turf/simulated/mineral))
		mineral = null
		set_pin_data(IC_OUTPUT, 1, null)
		set_pin_data(IC_OUTPUT, 2, null)

		push_data()
		activate_pin(2)
		return

	mineral = rock.mineral

	if(mineral)
		set_pin_data(IC_OUTPUT, 1,69ineral.display_name)
		set_pin_data(IC_OUTPUT, 2,69ineral.result_amount)
		push_data()

		activate_pin(2)
		activate_pin(3)


/obj/item/integrated_circuit/mining/mining_satchel
	name = "mining satchel"
	desc = "A69ining satchel that can collect ores from tile"
	extended_desc = "Takes a turf ref to take ores from it or accept69ining box to give collected ores to it."
	category_text = "Mining"
	ext_cooldown = 1
	complexity = 20
	cooldown_per_use = 1 SECONDS
	inputs = list(
		"target" = IC_PINTYPE_REF
		)
	outputs = list(
		"collected len" = IC_PINTYPE_NUMBER
	)
	activators = list(
		"collect ore" = IC_PINTYPE_PULSE_IN,
		"drop ore" = IC_PINTYPE_PULSE_IN,
		"pulse out" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 20
	var/obj/item/storage/bag/ore/box

/obj/item/integrated_circuit/mining/mining_satchel/Initialize()
	. = ..()
	box = new(src)

/obj/item/integrated_circuit/mining/mining_satchel/Destroy()
	. = ..()
	QDEL_NULL(box)

/obj/item/integrated_circuit/mining/mining_satchel/do_work(ord)
	switch(ord)
		if(1)
			var/atom/movable/AM = get_pin_data(IC_INPUT, 1)
			if(isturf(AM))
				var/turf/T = AM
				for(var/obj/item/ore/O in T.contents)
					if(!box.can_be_inserted(O))
						return
					box.handle_item_insertion(O)
			set_pin_data(IC_OUTPUT, 1, length(box.return_inv()))
			push_data()
			activate_pin(3)
		if(2)
			var/atom/movable/AM = get_pin_data(IC_INPUT, 1)
			if(istype(AM, /obj/structure/ore_box))
				var/obj/structure/ore_box/OB = AM
				OB.attackby(box, src)
			else if(isturf(AM))
				for(var/obj/item/ore/O in box.return_inv())
					box.remove_from_storage(O, AM)

/obj/item/integrated_circuit/mining/mining_drill
	name = "mining drill"
	desc = "A69ining drill that can drill through rocks."
	extended_desc = "A69ining drill that activates on sensing a69ineable rock. It takes some time to get the job done and \
	has to not be69oved during that time."
	category_text = "Mining"
	ext_cooldown = 1
	complexity = 20
	cooldown_per_use = 3 SECONDS
	inputs = list(
		"rock" = IC_PINTYPE_REF
		)
	outputs = list()
	activators = list(
		"mine" = IC_PINTYPE_PULSE_IN,
		"on success" = IC_PINTYPE_PULSE_OUT,
		"on failure" = IC_PINTYPE_PULSE_OUT
		)
	spawn_flags = IC_SPAWN_RESEARCH
	power_draw_per_use = 100

	var/busy = FALSE
	var/usedx
	var/usedy
	var/turf/simulated/mineral/mineral
	var/obj/structure/boulder/boulder

/obj/item/integrated_circuit/mining/mining_drill/do_work()
	var/atom/movable/AM = get_pin_data(IC_INPUT, 1)

	if(istype(AM, /turf/simulated/mineral))
		mineral = AM
		if(!istype(mineral) || !mineral.Adjacent(assembly))
			activate_pin(3)
			return
	else if(istype(AM, /obj/structure/boulder))
		boulder = AM
		if(!istype(boulder) || !boulder.Adjacent(assembly))
			activate_pin(3)
			return
	else
		activate_pin(3)
		return

	if(busy)
		activate_pin(3)
		return

	busy = TRUE
	usedx = assembly.loc.x
	usedy = assembly.loc.y
	playsound(src, 'sound/items/Ratchet.ogg',50,1)
	addtimer(CALLBACK(src, .proc/drill), 50)


/obj/item/integrated_circuit/mining/mining_drill/proc/drill()
	busy = FALSE
	// The assembly was69oved, hence stopping the69ining OR the rock was69ined before
	if(usedx != assembly.loc.x || usedy != assembly.loc.y || !(mineral || boulder))
		activate_pin(3)
		return FALSE

	if(mineral)
		mineral.GetDrilled()
	else
		boulder.Destroy()
	activate_pin(2)
	return TRUE
