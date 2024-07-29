/obj/machinery/reagentgrinder/industrial/disgorger
	name = "disgorger"
	desc = "An abomination of meat and metal. Consumes organs and various reagent-filled objects."
	description_info = "Requires a retracting tool to open the panel and a clamping tool to disassemble.\n\n\
						Can be upgraded by re-assembling with organs of higher efficiency and using different organ types. Try using organs related to chewing, digestion, and filtration."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/disgorger.dmi'
	icon_state = "disgorger"
	reagent_flags = NO_REACT
	circuit = /obj/item/electronics/circuitboard/disgorger
	limit = 10
	nano_template = "disgorger.tmpl"
	sheet_reagents = list()
	var/biomatter_counter = 0				// We don't want this to actually produce biomatter
	var/research_counter = 0				// How many points towards the next unlock
	var/list/accepted_reagents = list(
		/datum/reagent/organic/nutriment = 1
	)
	var/list/accepted_objects = list(
		/obj/item/organ,
		/obj/item/modification/organ
	)
	var/spit_target
	var/spit_range = 2		// For var-edits
	var/has_brain = FALSE

	// Production
	var/grind_rate = 8				// How many ticks between each processed item
	var/current_tick = 0
	var/production_denominator = 2	// Affects the multiplier for converting reagents/biomatter into substrate

	// Placeholder research
	var/research_denominator = 2	// Affects the multiplier for researching new designs
	var/datum/research/knowledge
	var/list/designs_to_unlock = DISGORGER_RESEARCH_LIST

/obj/machinery/reagentgrinder/industrial/disgorger/Initialize()
	. = ..()
	spit_target = get_ranged_target_turf(src, dir, spit_range)
	knowledge = new /datum/research(src)
	knowledge.known_designs = list()

/obj/machinery/reagentgrinder/industrial/disgorger/InitCircuit()
	if(!circuit)
		return

	if(ispath(circuit))
		circuit = new circuit

	if(!component_parts)
		component_parts = list()
	if(circuit)
		component_parts += circuit

	component_parts += new /obj/item/organ/internal/vital/brain
	component_parts += new /obj/item/organ/internal/bone/head		// Doesn't do anything
	component_parts += new /obj/item/organ/internal/bone/chest		// Doesn't do anything
	component_parts += new /obj/item/organ/internal/bone/groin		// Doesn't do anything
	component_parts += new /obj/item/organ/internal/nerve			// Doesn't do anything
	component_parts += new /obj/item/organ/internal/nerve			// Doesn't do anything

	RefreshParts()

/obj/machinery/reagentgrinder/industrial/disgorger/examine(mob/user, extra_description = "")
	..()
	var/accepted

	if(accepted_objects?.len)
		for(var/object in accepted_objects)
			var/obj/O = object
			accepted += initial(O.name) + "s, "

	if(accepted)
		accepted += "and objects with the following reagents: "

	if(accepted_reagents?.len)
		for(var/reagent in accepted_reagents)
			var/datum/reagent/R = reagent
			accepted += initial(R.name) + ", "

	if(accepted)
		accepted = copytext(accepted, 1, length(accepted) - 1)
		extra_description += SPAN_NOTICE("\n<i>Accepts [accepted].</i>")

/obj/machinery/reagentgrinder/industrial/disgorger/proc/check_reagents(obj/item/I, mob/user)
	if(!I.reagents || !I.reagents.total_volume)
		return FALSE
	for(var/reagent in I.reagents.reagent_list)
		var/datum/reagent/R = reagent
		if(is_type_in_list(R, accepted_reagents))
			. = TRUE		// If the container has any amount of an accepted reagent, the proc will return true

/obj/machinery/reagentgrinder/industrial/disgorger/insert(obj/item/I, mob/user)
	if(!istype(I))
		return

	if(holdingitems && holdingitems.len >= limit)
		to_chat(user, "\The [src] cannot hold anymore items.")
		return TRUE

	if(!is_type_in_list(I, accepted_objects) && !check_reagents(I, user))
		to_chat(user, "\The [I] is not suitable for blending.")
		return TRUE

	flick("[initial(icon_state)]_chew", src)

	if(I.loc == user)
		user.remove_from_mob(I)
	else
		I.add_fingerprint(user)
	I.forceMove(src)
	holdingitems += I
	SSnano.update_uis(src)
	return FALSE

/obj/machinery/reagentgrinder/industrial/disgorger/grind_item(obj/item/I)
	// Check reagents first
	if(I.reagents)
		holdingitems -= I
		for(var/datum/reagent/R in I.reagents.reagent_list)
			for(var/reagent_path in accepted_reagents)
				if(!istype(R, reagent_path))
					continue
				biomatter_counter += round(R.volume * (accepted_reagents[reagent_path] / production_denominator), 0.01)
				research_counter += round(R.volume * (accepted_reagents[reagent_path] / research_denominator), 0.01)

	// Check biomatter content and contained objects (depth of 2, include self)
	for(var/path in accepted_objects)
		if(!istype(I, path))
			continue

		holdingitems -= I

		var/amount_to_take

		for(var/obj/item/O in I.GetAllContents(2, TRUE))
			amount_to_take += max(0, O.matter[MATERIAL_BIOMATTER])
			var/obj/item/organ/organ = O
			var/is_valid_organ = (organ && LAZYLEN(organ.transplant_data))
			qdel(O)
			if(amount_to_take)
				biomatter_counter += round(amount_to_take / production_denominator, 0.01)
				research_counter += is_valid_organ ? round(amount_to_take / research_denominator) : 0
				break

	// Make sure the object is qdel'd
	if(!QDELETED(I))
		qdel(I)

/obj/machinery/reagentgrinder/industrial/disgorger/grind()
	if(has_brain && prob(1))
		if(prob(1))									// If I did my calc right, this should happen once every 2 hours
			for(var/mob/O in hearers(src, null))
				O.show_message("\icon[src] <b>\The [src]</b> says, \"You s-s-saved me... w-why?\"", 2)
			flick("[initial(icon_state)]_spit", src)

	if(current_tick >= grind_rate)
		var/obj/item/I = locate() in holdingitems
		if(!I)
			return

		grind_item(I)
		current_tick = 0

	current_tick += 1

	while(biomatter_counter > 59)
		bottle()

	while(research_counter > 59)
		try_unlock_tech()

	SSnano.update_uis(src)

/obj/machinery/reagentgrinder/industrial/disgorger/bottle()
	biomatter_counter = max(biomatter_counter - 60, 0)		// Flesh cubes have 60 biomatter
	addtimer(CALLBACK(src, PROC_REF(spit)), 1 SECONDS, TIMER_STOPPABLE)

/obj/machinery/reagentgrinder/industrial/disgorger/proc/spit()
	flick("[initial(icon_state)]_spit", src)
	var/obj/item/fleshcube/new_cube = new(get_turf(src))
	new_cube.throw_at(spit_target, 3, 1)

/obj/machinery/reagentgrinder/industrial/disgorger/proc/try_unlock_tech()
	research_counter = max(research_counter - 60, 0)

	if(!LAZYLEN(designs_to_unlock))
		return

	var/datum/design/D = SSresearch.get_design(designs_to_unlock[1])
	designs_to_unlock.Remove(D.type)
	knowledge.AddDesign2Known(D)

	var/message = pickweight(list(
		"When you study and object from a distance, only its principle may be seen." = 1,									// Children of Dune
		"Knowledge is an unending adventure at the edge of uncertainty." = 1,												// 
		"To know a thing well, know its limits; Only when pushed beyond its tolerance will its true nature be seen." = 1,	//
		"You do not take from this universe. It grants what it will." = 1,							// Dune Messiah
		"Belief can be manipulated. Only knowledge is dangerous." = 1,								//
		"You can\'t stop a mental epidemic. It leaps from person to person across parsecs." = 1,	//
		"..." = 31,
		"...?" = 31,
		"...!" = 31
		))

	for(var/mob/O as anything in hearers(src, null))
		O.show_message("\icon[src] <b>\The [src]</b> says, \"[message]\"", 2)

	for(var/obj/machinery/autolathe/organ_fabricator/OF in get_area_all_atoms(get_area(src)))
		OF.files.AddDesign2Known(D)

/obj/machinery/reagentgrinder/industrial/disgorger/default_deconstruction(obj/item/I, mob/user)
	var/qualities = list(QUALITY_RETRACTING)

	if(panel_open && circuit)
		qualities += QUALITY_CLAMPING

	var/tool_type = I.get_tool_type(user, qualities, src)
	switch(tool_type)
		if(QUALITY_CLAMPING)
			if(I.use_tool(user, src, WORKTIME_NORMAL, tool_type, FAILCHANCE_HARD, required_stat = STAT_BIO))
				to_chat(user, SPAN_NOTICE("You remove the guts of \the [src] with [I]."))
				dismantle()
			return TRUE

		if(QUALITY_RETRACTING)
			var/used_sound = panel_open ? 'sound/machines/Custom_screwdriveropen.ogg' :  'sound/machines/Custom_screwdriverclose.ogg'
			if(I.use_tool(user, src, WORKTIME_NEAR_INSTANT, tool_type, FAILCHANCE_VERY_EASY, required_stat = STAT_BIO, instant_finish_tier = 30, forced_sound = used_sound))
				updateUsrDialog()
				panel_open = !panel_open
				to_chat(user, SPAN_NOTICE("You [panel_open ? "open" : "close"] the maw of \the [src] with [I]."))
				update_icon()
			return TRUE

		if(ABORT_CHECK)
			return TRUE

	return FALSE //If got no qualities - continue base attackby proc

/obj/machinery/reagentgrinder/industrial/disgorger/RefreshParts()
	var/liver_eff = 0
	var/kidney_eff = 0
	var/carrion_chem_eff = 0
	var/stomach_eff = 0
	var/muscle_eff = 0
	var/blood_vessel_eff = 0
	var/heart_eff = 0
	var/carrion_maw_eff = 0
	var/brain_eff = 0

	var/capacity_mod = 0
	var/tick_reduction = 0
	var/production_mod = 0
	var/research_mod = 0
	var/throughput_mult = 0

	has_brain = FALSE

	for(var/component in component_parts)
		if(istype(component, /obj/item/electronics/circuitboard/disgorger))
			var/obj/item/electronics/circuitboard/disgorger/C = component
			if(LAZYLEN(C.designs_to_unlock))
				designs_to_unlock = C.designs_to_unlock.Copy()
		if(!istype(component, /obj/item/organ/internal))
			continue
		var/obj/item/organ/internal/O = component
		for(var/eff in O.organ_efficiency)
			switch(eff)
				if(OP_LIVER)
					liver_eff += O.organ_efficiency[eff]
				if(OP_KIDNEYS)
					kidney_eff += O.organ_efficiency[eff]
				if(OP_CHEMICALS)		// Carrion vessel
					carrion_chem_eff += O.organ_efficiency[eff]
				if(OP_MAW)				// Carrion maw
					carrion_maw_eff += O.organ_efficiency[eff]
				if(OP_STOMACH)
					stomach_eff += O.organ_efficiency[eff]
				if(OP_MUSCLE)
					muscle_eff += O.organ_efficiency[eff]
				if(OP_BLOOD_VESSEL)
					blood_vessel_eff += O.organ_efficiency[eff]
				if(OP_HEART)
					heart_eff += O.organ_efficiency[eff]
				if(BP_BRAIN)
					has_brain = TRUE
					brain_eff += O.organ_efficiency[eff]

	if(liver_eff > 99)
		LAZYADD(accepted_reagents, list(
			/datum/reagent/toxin/diplopterum = 1.25,
			/datum/reagent/alcohol = 0.05
		))
	if(liver_eff > 149)
		LAZYADD(accepted_reagents, list(
			/datum/reagent/toxin/seligitillin = 2,
			/datum/reagent/toxin/starkellin = 2,
			/datum/reagent/toxin/gewaltine = 2,
			/datum/reagent/toxin/blattedin = 2
		))
	if(liver_eff > 199)
		LAZYADD(accepted_reagents, list(
			/datum/reagent/toxin/fuhrerole = 5,
			/datum/reagent/toxin/kaiseraurum = 10
		))

	if(kidney_eff > 49)
		LAZYADD(accepted_reagents, list(
			/datum/reagent/drug/nicotine = 0.1,
			/datum/reagent/drug/mindbreaker = 0.25
		))
	if(kidney_eff > 79)
		LAZYADD(accepted_reagents, list(
			/datum/reagent/stim = 0.5,
			/datum/reagent/drug/psilocybin = 2
		))
	if(kidney_eff > 199)
		LAZYADD(accepted_reagents, list(
			/datum/reagent/medicine/suppressital = 1,
			/datum/reagent/medicine/methylphenidate = 1,
			/datum/reagent/medicine/citalopram = 1,
			/datum/reagent/medicine/paroxetine = 1
		))

	if(carrion_chem_eff > 99)
		LAZYADD(accepted_reagents, list(
			/datum/reagent/toxin/pararein = 5,
			/datum/reagent/toxin/aranecolmin = 10
		))

	throughput_mult = (heart_eff > 79) ? round((heart_eff + blood_vessel_eff) / 650, 0.05) : 0.05

	capacity_mod = round((stomach_eff / 15) + carrion_chem_eff) 
	tick_reduction = round((muscle_eff / 20) + carrion_maw_eff) 
	production_mod = round(throughput_mult * ((stomach_eff / 2) + (liver_eff / 4) + (kidney_eff / 4) + (carrion_maw_eff)) / 100, 0.01)
	research_mod = round(throughput_mult * (brain_eff / 65), 0.01)

	limit = initial(limit) + capacity_mod
	grind_rate = initial(grind_rate) - tick_reduction
	production_denominator = max(initial(production_denominator) - production_mod, 0.5)
	research_denominator = max(initial(research_denominator) - research_mod, 0.5)

/obj/machinery/reagentgrinder/industrial/disgorger/on_deconstruction()
	..()
	var/obj/item/electronics/circuitboard/disgorger/C = locate(/obj/item/electronics/circuitboard/disgorger) in component_parts
	if(C)
		C.designs_to_unlock = designs_to_unlock.Copy()

/obj/machinery/reagentgrinder/industrial/disgorger/nano_ui_data()
	. = ..()

	.["biomatter_counter"] = biomatter_counter
	.["research_counter"] = research_counter
	.["research_rate"] = round(100 / research_denominator, 1)
	.["production_rate"] = round(100 / production_denominator, 1)

	var/current_thought = "none"
	if(has_brain && LAZYLEN(designs_to_unlock))
		var/datum/design/next_design = designs_to_unlock[1]
		var/atom/movable/next_path = initial(next_design.build_path)
		current_thought = initial(next_path.name)

	.["current_thought"] = current_thought

/obj/machinery/reagentgrinder/industrial/disgorger/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(!nano_template)
		return

	var/list/data = nano_ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, nano_template, name, 400, 300)
		ui.set_initial_data(data)
		ui.open()

/obj/item/electronics/circuitboard/disgorger
	name = T_BOARD("disgorger")
	spawn_blacklisted = TRUE
	board_type = "machine"
	build_path = /obj/machinery/reagentgrinder/industrial/disgorger
	origin_tech = list(TECH_BIO = 3)
	req_components = list(
		/obj/item/organ/internal = 6			// Build with any organ, but certain efficiencies will have different effects.
	)
	var/list/designs_to_unlock = list()

// Our resource item
/obj/item/fleshcube
	name = "flesh cube"
	desc = "A three-dimensional solid object bounded by six square faces, with three meeting at each vertex. This one is covered in several layers of ectodermal tissue."
	description_info = "Recycle this in the organ fabricator to add 60 biotic substrate, which is used in lieu of biomatter to print organs."
	icon = 'icons/obj/machines/disgorger.dmi'
	icon_state = "carne_cansada"
	w_class = ITEM_SIZE_SMALL
	matter = list(MATERIAL_BIOMATTER = 60)
	hitsound = 'sound/effects/squelch1.ogg'
	attack_verb = list("slapped")
	force = WEAPON_FORCE_HARMLESS
	structure_damage_factor = 0
	var/squelch_cooldown = 0.5 SECONDS
	var/last_used

/obj/item/fleshcube/proc/squelch()
	if((last_used + squelch_cooldown) < world.time)
		last_used = world.time
		playsound(src, hitsound, 50, 1)
		blood_splatter(src)
		return TRUE

/obj/item/fleshcube/attack_self(mob/user)
	squelch()
	user.visible_message(SPAN_NOTICE("<b>\The [user]</b> squeezes \the [src]. It squelches."), SPAN_NOTICE("You squeeze \the [src]. It squelches."))

/obj/item/fleshcube/throw_impact(atom/impact_atom)
	..()
	squelch()
	visible_message(SPAN_NOTICE("\The [src] squelches as it impacts with surface."))
