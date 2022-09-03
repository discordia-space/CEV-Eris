/obj/machinery/reagentgrinder/industrial/regurgitator
	name = "regurgitator"
	desc = "An abomination of meat and metal. Consumes organs and various reagents."
	description_info = "Requires a retracting tool to open the panel and a clamping tool to disassemble.\n\n\
						Can be upgraded by re-assembling with organs of higher efficiency and using different organ types. Try using organs related to chewing, digestion, and filtration."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/regurgitator.dmi'
	icon_state = "regurgitator"
	reagent_flags = NO_REACT
	circuit = /obj/item/electronics/circuitboard/regurgitator
	limit = 10
	nano_template = "regurgitator.tmpl"
	sheet_reagents = list()
	var/biomatter_counter = 0				// We don't want this to actually produce biomatter
	var/list/accepted_reagents = list(
		/datum/reagent/drink/milk = 0.13,				// Internet said milk is 13% solids, 87% water
		/datum/reagent/organic/nutriment/protein = 1
	)
	var/list/blacklisted_reagents = list(
		/datum/reagent/drink/milk/soymilk
	)
	var/list/accepted_objects = list(
		/obj/item/organ,
		/obj/item/modification/organ
	)
	var/spit_target
	var/spit_range = 2		// For var-edits
	var/has_brain = FALSE
	var/grind_rate = 8	//ticks
	var/current_tick = 0

/obj/machinery/reagentgrinder/industrial/regurgitator/Initialize()
	. = ..()
	spit_target = get_ranged_target_turf(src, dir, spit_range)

/obj/machinery/reagentgrinder/industrial/regurgitator/InitCircuit()
	if(!circuit)
		return

	if(ispath(circuit))
		circuit = new circuit

	if(!component_parts)
		component_parts = list()
	if(circuit)
		component_parts += circuit

	component_parts += new /obj/item/organ/internal/brain
	component_parts += new /obj/item/organ/internal/bone/head		// Doesn't do anything
	component_parts += new /obj/item/organ/internal/nerve			// Doesn't do anything
	component_parts += new /obj/item/organ/internal/blood_vessel	// Doesn't do anything

	RefreshParts()

/obj/machinery/reagentgrinder/industrial/regurgitator/examine(mob/user)
	..()
	var/accepted
	var/blacklisted

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

	if(blacklisted_reagents?.len)
		for(var/reagent in blacklisted_reagents)
			var/datum/reagent/R = reagent
			blacklisted += initial(R.name) + ", "

	if(accepted)
		accepted = copytext(accepted, 1, length(accepted) - 1)
		to_chat(user, SPAN_NOTICE("<i>Accepts [accepted].</i>"))

	if(blacklisted)
		blacklisted = copytext(blacklisted, 1, length(blacklisted) - 1)
		to_chat(user, SPAN_WARNING("Rejects [blacklisted]."))

/obj/machinery/reagentgrinder/industrial/regurgitator/proc/check_reagents(obj/item/I, mob/user)
	if(!I.reagents || !I.reagents.total_volume)
		return FALSE
	for(var/reagent in I.reagents.reagent_list)
		var/datum/reagent/R = reagent
		if(is_type_in_list(R, accepted_reagents))
			. = TRUE		// If the container has any amount of an accepted reagent, the proc will return true
		if(is_type_in_list(R, blacklisted_reagents))
			return FALSE	// If the container has any amount of a blacklisted reagent, the proc will immediately return false
	
/obj/machinery/reagentgrinder/industrial/regurgitator/insert(obj/item/I, mob/user)
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

/obj/machinery/reagentgrinder/industrial/regurgitator/grind_item(obj/item/I)
	for(var/path in accepted_objects)
		if(!istype(I, path))
			continue

		holdingitems -= I

		var/amount_to_take

		for(var/object in I.GetAllContents(includeSelf = TRUE))
			var/obj/item/O = object
			if(O.matter.Find(MATERIAL_BIOMATTER))
				amount_to_take += max(0, O.matter[MATERIAL_BIOMATTER])
			qdel(O)
		if(amount_to_take)
			biomatter_counter += amount_to_take
			return
		break

	if(I.reagents)
		holdingitems -= I
		for(var/reagent in I.reagents.reagent_list)
			var/datum/reagent/R = reagent
			if(!is_type_in_list(R, blacklisted_reagents) && is_type_in_list(R, accepted_reagents))
				biomatter_counter += round(R.volume * accepted_reagents[R.type], 0.01)
		qdel(I)

/obj/machinery/reagentgrinder/industrial/regurgitator/grind()
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

	while(biomatter_counter > 59.99)
		bottle()

	SSnano.update_uis(src)

/obj/machinery/reagentgrinder/industrial/regurgitator/bottle()
	biomatter_counter -= 60		// Flesh cubes have 60 biomatter
	addtimer(CALLBACK(src, .proc/spit), 1 SECONDS, TIMER_STOPPABLE)

/obj/machinery/reagentgrinder/industrial/regurgitator/proc/spit()
	flick("[initial(icon_state)]_spit", src)
	var/obj/item/fleshcube/new_cube = new(get_turf(src))
	new_cube.throw_at(spit_target, 3, 1)
	

/obj/machinery/reagentgrinder/industrial/regurgitator/default_deconstruction(obj/item/I, mob/user)
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

/obj/machinery/reagentgrinder/industrial/regurgitator/RefreshParts()
	var/liver_eff = 0
	var/kidney_eff = 0
	var/carrion_chem_eff = 0

	var/muscle_eff = 0
	var/tick_reduction = 0

	var/stomach_eff = 0
	var/capacity_mod = 0

	has_brain = FALSE

	for(var/component in component_parts)
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
				if(OP_MUSCLE)
					muscle_eff += O.organ_efficiency[eff]
				if(OP_STOMACH)
					stomach_eff += O.organ_efficiency[eff]
				if(BP_BRAIN)
					has_brain = TRUE

	if(liver_eff > 99)
		accepted_reagents |= list(
			/datum/reagent/toxin/diplopterum = 0.25
		)
	if(liver_eff > 124)
		accepted_reagents |= list(
			/datum/reagent/toxin/seligitillin = 0.75,
			/datum/reagent/toxin/starkellin = 0.75,
			/datum/reagent/toxin/gewaltine = 0.75,
			/datum/reagent/toxin/blattedin = 0.5
		)
	if(liver_eff > 149)
		accepted_reagents = list(
			/datum/reagent/toxin/fuhrerole = 1,
			/datum/reagent/toxin/kaiseraurum = 10
		)

	if(kidney_eff > 49)
		accepted_reagents |= list(
			/datum/reagent/organic/blood = 0.1		// Internet says blood plasma is 10% solids, 90% water
		)

	if(carrion_chem_eff > 99)
		accepted_reagents |= list(
			/datum/reagent/toxin/pararein = 1,
			/datum/reagent/toxin/aranecolmin = 2
		)

	if(stomach_eff > 99)
		capacity_mod += 5
	if(stomach_eff > 124)
		capacity_mod += 5

	if(muscle_eff > 99)
		tick_reduction += 1
	if(muscle_eff > 124)
		tick_reduction += 1
	if(muscle_eff > 149)
		tick_reduction += 2

	limit = initial(limit) + capacity_mod
	grind_rate = initial(grind_rate) - tick_reduction

/obj/machinery/reagentgrinder/industrial/regurgitator/ui_data()
	. = ..()

	.["biomatter_counter"] = biomatter_counter

/obj/machinery/reagentgrinder/industrial/regurgitator/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS)
	if(!nano_template)
		return

	var/list/data = ui_data()

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, nano_template, name, 400, 250)
		ui.set_initial_data(data)
		ui.open()

/obj/item/electronics/circuitboard/regurgitator
	name = T_BOARD("regurgitator")
	board_type = "machine"
	build_path = /obj/machinery/reagentgrinder/industrial/regurgitator
	origin_tech = list(TECH_BIO = 3)
	rarity_value = 20
	req_components = list(
		/obj/item/organ/internal = 4			// Build with any organ, but certain efficiencies will have different effects.
	)

// Our resource item
/obj/item/fleshcube
	name = "flesh cube"
	desc = "A three-dimensional solid object bounded by six square faces, with three meeting at each vertex. This one is covered in several layers of ectodermal tissue."
	description_info = "Recycle this in the organ fabricator to add 60 biotic substrate, which is used in lieu of biomatter to print organs."
	// Source: https://en.wikipedia.org/wiki/Cube and https://en.wikipedia.org/wiki/Ectoderm
	description_fluff = "Its shape is that of a regular hexahedron and is one of the five Platonic solids. It has 6 faces, 12 edges, and 8 vertices. \
						It is also a square parallelepiped, an equilateral cuboid and a right rhombohedron a 3-zonohedron. \
						It is a regular square prism in three orientations, and a trigonal trapezohedron in four orientations. \
						It is dual to the octahedron. It has cubical or octahedral symmetry. \
						It is the only convex polyhedron whose faces are all squares.\n\n\
						The ectoderm is one of the three primary germ layers formed in early embryonic development. \
						It is the outermost layer, and is superficial to the mesoderm (the middle layer) and endoderm (the innermost layer). \
						It emerges and originates from the outer layer of germ cells. \
						The word ectoderm comes from the Greek ektos meaning \"outside\", and derma meaning \"skin\". \
						Generally speaking, the ectoderm differentiates to form epithelial and neural tissues (spinal cord, peripheral nerves and brain). \
						This includes the skin, linings of the mouth, anus, nostrils, sweat glands, hair and nails, and tooth enamel. \
						Other types of epithelium are derived from the endoderm."
	icon = 'icons/obj/machines/regurgitator.dmi'
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
