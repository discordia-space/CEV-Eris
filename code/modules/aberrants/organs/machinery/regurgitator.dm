/obj/machinery/reagentgrinder/industrial/regurgitator
	name = "regurgitator"
	desc = "An abomination of meat and metal. Consumes organs, milk, and protein."
	density = TRUE
	anchored = TRUE
	icon = 'icons/obj/machines/regurgitator.dmi'
	icon_state = "regurgitator"
	reagent_flags = NO_REACT
	circuit = /obj/item/electronics/circuitboard/regurgitator
	limit = 25
	nano_template = "regurgitator.tmpl"
	sheet_reagents = list()
	var/biomatter_counter = 0		// We don't want this to actually produce biomatter
	var/accepted_reagents = list(
		/datum/reagent/drink/milk,
		/datum/reagent/organic/nutriment/protein	// should be able to take eggs since it's a child type
	)
	var/blacklisted_reagents = list(
		/datum/reagent/drink/milk/soymilk
	)
	var/accepted_objects = list(
		/obj/item/organ,
		/obj/item/modification/organ,
		/obj/item/reagent_containers/food/snacks/meat
	)
	var/spit_target
	var/spit_range = 2		// For var-edits

/obj/machinery/reagentgrinder/industrial/regurgitator/Initialize()
	. = ..()
	spit_target = get_ranged_target_turf(src, dir, spit_range)

/obj/machinery/reagentgrinder/industrial/regurgitator/proc/check_reagents(obj/item/I, mob/user)
	if(!I.reagents || !I.reagents.total_volume)
		return FALSE
	for(var/reagent in I.reagents.reagent_list)
		var/datum/reagent/R = reagent
		if(is_type_in_list(R, accepted_reagents))
			if(!is_type_in_list(R, blacklisted_reagents))
				. = TRUE	// If the container has only accepted reagents, the proc should return true
		else
			return FALSE	// If there is anything that can't be accepted in the container, refuse the whole thing

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
		for(var/reagent in I.reagents.reagent_list)
			var/datum/reagent/R = reagent
			if(istype(R, /datum/reagent/drink/milk))
				biomatter_counter += R.volume * 0.13	// Internet said milk is 13% solids, 87% water
			if(istype(R, /datum/reagent/organic/nutriment/protein))
				biomatter_counter += R.volume
			R.remove_self(R.volume)
		if(I.reagents.total_volume == 0)
			holdingitems -= I
			qdel(I)

/obj/machinery/reagentgrinder/industrial/regurgitator/grind()
	if(prob(1))
		if(prob(1))
			speak("You s-s-saved me... w-why?")	// If I did my calc right, this should happen once every 3 rounds
			flick("[initial(icon_state)]_spit", src)

	var/obj/item/I = locate() in holdingitems
	if(!I)
		return

	grind_item(I)

	while(biomatter_counter >= 60)
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
		/obj/item/stock_parts/manipulator = 1,
		/obj/item/organ/internal/stomach = 1,
		/obj/item/organ/internal/brain = 1
	)

// Our resource item
/obj/item/fleshcube
	name = "flesh cube"
	desc = "A three-dimensional solid object bounded by six square faces, with three meeting at each vertex. This one is covered in several layers of ectodermal tissue."
	description_info = "Recycle this in the organ fabricator to add 60 biotic substrate, which is used in lieu of biomatter to print organs."
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
