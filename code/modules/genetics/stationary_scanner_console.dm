/obj/machinery/dna_console
	name = "Chrysalis controller"
	desc = "A stationary computer."
	icon = 'icons/obj/eris_genetics.dmi'
	icon_state = "console_base"
	density = TRUE
	anchored = TRUE
	circuit = /obj/item/electronics/circuitboard/dna_console
	use_power = IDLE_POWER_USE
	idle_power_usage = 60
	active_power_usage = 10000
	req_access = list(access_research_equipment)
	var/color_key = "yellow"
	var/error = FALSE
	var/obj/machinery/cryo_slab/linked
	var/linked_direction
	var/obj/item/computer_hardware/hard_drive/portable/usb


/obj/machinery/dna_console/initalize_statverbs()
	if(req_access.len)
		add_statverb(/datum/statverb/hack_console)


/obj/machinery/dna_console/Initialize(mapload, d=0)
	. = ..()
	color_key = default_dna_machinery_style
	establish_connection()
	update_icon()


/obj/machinery/dna_console/New()
	..()
	color_key = default_dna_machinery_style
	establish_connection()
	update_icon()


/obj/machinery/dna_console/proc/establish_connection()
	if(linked)
		return TRUE

	linked = locate(/obj/machinery/cryo_slab) in get_step(src, WEST)
	if(linked)
		linked_direction = "left"
		return TRUE

	linked = locate(/obj/machinery/cryo_slab) in get_step(src, EAST)
	if(linked)
		linked_direction = "right"
		return TRUE

	return FALSE


/obj/machinery/dna_console/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	hacked = TRUE


/obj/machinery/dna_console/update_icon()
	if(error)
		return

	..()
	overlays.Cut()
	var/screen_state = "console"
	var/wires_state = "console_wires"

	if(!(stat & (NOPOWER|BROKEN)) && use_power)
		if(SSnano.open_uis["\ref[src]"])
			screen_state += "_on"
			spawn(1.5 SECONDS)
			.() // If UI is open - run check every 1.5 seconds until it's closed
		else
			screen_state += "_idle"
		screen_state += "_[color_key]"
		overlays += screen_state

	if(linked && linked_direction)
		wires_state += "_[linked_direction]"
		wires_state += "_[color_key]"
		overlays += wires_state


/obj/machinery/dna_console/proc/error_popup()
	if(error)
		return

	error = TRUE
	overlays += "console_error"
	sleep(1.5 SECONDS)
	error = FALSE
	update_icon()


/obj/machinery/dna_console/proc/save_pe()
	if(!usb)
		audible_message(SPAN_WARNING("[src] beeps: 'No data storage found.'"))
		error_popup()
		return

	var/mob/living/carbon/human/H = linked.han_solo
	if(!H || !istype(H))
		return

	var/stored_count = 0

	// Race // SPECIES_HUMAN, SPECIES_SLIME, SPECIES_MONKEY, SPECIES_GOLEM
	var/datum/computer_file/binary/animalgene/F = new
	F.filename = "AN_GENE_SPECIES_[uppertext(H.species.name)]"
	F.gene_type = "species"
	F.gene_value = H.species
	if(usb.store_file(F))
		stored_count++
	else if(!(F in usb.stored_files)) // If it's just a duplicated file - no error needed
		audible_message(SPAN_WARNING("[src] beeps: 'Sequencing failed.'"))
		error_popup()
		return

	// Blood type // GLOB.blood_types = list("A-", "A+", "B-", "B+", "AB-", "AB+", "O-", "O+")
	F = new // Gotta do that each time or magic won't happen
	var/blood_type = H.b_type
	blood_type = replacetext(blood_type, "+", "_POSITIVE")
	blood_type = replacetext(blood_type, "-", "_NEGATIVE")
	F.filename = "AN_GENE_BLOOD_[blood_type]"
	F.gene_type = "b_type"
	F.gene_value = H.b_type
	if(usb.store_file(F))
		stored_count++
	else if(!(F in usb.stored_files)) // If it's just a duplicated file - no error needed
		audible_message(SPAN_WARNING("[src] beeps: 'Sequencing failed.'"))
		error_popup()
		return

	// Unique identity // Fingerprints is md5() of real_name, while dna trace is sha1() of it
	F = new
	F.filename = "AN_GENE_APPEARANCE_[uppertext(copytext(sha1(H.real_name), 1, 12))]"
	F.gene_type = "real_name"
	F.gene_value = H.real_name
	if(usb.store_file(F))
		stored_count++
	else if(!(F in usb.stored_files)) // If it's just a duplicated file - no error needed
		audible_message(SPAN_WARNING("[src] beeps: 'Sequencing failed.'"))
		error_popup()
		return

	if(stored_count)
		audible_message(SPAN_WARNING("[src] beeps: 'Sequencing complete, [stored_count] unique patterns recorded.'"))


/obj/machinery/dna_console/proc/save_ue()
	if(!usb)
		audible_message(SPAN_WARNING("[src] beeps: 'No data storage found.'"))
		error_popup()
		return

	var/mob/living/carbon/human/H = linked.han_solo
	if(!H || !istype(H))
		return

	var/stored_count = 0

	for(var/i in H.dormant_mutations)
		var/datum/mutation/M = i
		var/datum/computer_file/binary/animalgene/F = new
		// Show mutation name instead of a tier_string if it have been activated previously
		var/mut_name = M.is_active ? replacetext("[M.name]", " ", "_") : "[M.tier_string]"
		F.filename = "AN_GENE_MUT_[M.hex]_[uppertext(mut_name)]"
		F.gene_type = "mutation"
		F.gene_value = M.clone()
		if(usb.store_file(F))
			stored_count++
		else if(!(F in usb.stored_files))
			audible_message(SPAN_WARNING("[src] beeps: 'Sequencing failed.'"))
			error_popup()
			break

	for(var/i in H.active_mutations)
		var/datum/mutation/M = i
		var/datum/computer_file/binary/animalgene/F = new
		F.filename = "AN_GENE_MUT_[M.hex]_[uppertext(replacetext("[M.name]", " ", "_"))]"
		F.gene_type = "mutation"
		F.gene_value = M.clone()
		if(usb.store_file(F))
			stored_count++
		else if(!(F in usb.stored_files))
			audible_message(SPAN_WARNING("[src] beeps: 'Sequencing failed.'"))
			error_popup()
			break

	if(stored_count)
		audible_message(SPAN_WARNING("[src] beeps: 'Sequencing complete, [stored_count] unique patterns recorded.'"))


/obj/machinery/dna_console/attack_hand(mob/user)
	if(!linked)
		establish_connection()
		update_icon()

	if(hacked || allowed(user))
		ui_interact(user)
		update_icon()
	else
		to_chat(user, SPAN_WARNING("Unauthorized access."))


/obj/machinery/dna_console/attackby(obj/item/I, mob/living/user)
	if(default_part_replacement(I, user))
		return

	if(default_deconstruction(I, user))
		return

	if(istype(I, /obj/item/computer_hardware/hard_drive/portable) && !usb && insert_item(I, user))
		usb = I

	else if(QUALITY_PULSING in I.tool_qualities)
		var/input_color = input(user, "Available colors", "Configuration") in GLOB.dna_machinery_styles
		if(input_color)
			color_key = input_color
			update_icon()
	else
		..()


/obj/machinery/dna_console/AltClick(mob/user)
	try_eject_usb(user)


/obj/machinery/dna_console/verb/eject_usb()
	set name = "Eject Portable Storage"
	set category = "Object"
	set src in view(1)
	try_eject_usb(usr)


/obj/machinery/dna_console/proc/try_eject_usb(mob/user)
	if(eject_item(usb, user))
		usb = null


/obj/machinery/dna_console/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["save_pe"])
		save_pe()
		return TOPIC_REFRESH

	if(href_list["save_ue"])
		save_ue()
		return TOPIC_REFRESH


/obj/machinery/dna_console/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	if(isghost(user))
		return

	var/no_data = "\[REDACTED\]"
	var/list/data = list()
	var/list/occupant_mutations = list()

	data["linked"] = linked
	data["occupied"] = FALSE
	data["species"] = no_data
//	data["gender"] = no_data
	data["b_type"] = no_data
	data["age"] = no_data
	data["dna_trace"] = no_data
	data["fingers_trace"] = no_data
	data["occupant_mutations"] = no_data
	data["have_mutations"] = FALSE

	if(linked && linked.han_solo)
		var/mob/living/carbon/human/H = linked.han_solo // For convenience sake

		data["occupied"] = TRUE
		data["species"] = H.species ? H.species : no_data
//		data["gender"] = H.gender ? H.gender : no_data
		data["b_type"] = H.b_type ? H.b_type : no_data
		data["age"] = H.age ? H.age : no_data
		data["dna_trace"] = H.dna_trace ? H.dna_trace : no_data
		data["fingers_trace"] = H.fingers_trace ? H.fingers_trace : no_data

		if(H.dormant_mutations && H.dormant_mutations)
			for(var/i in H.dormant_mutations)
				var/datum/mutation/M = i
				var/mut_name = M.is_active ? replacetext("[M.name]", " ", "_") : ("[M.tier_string]")
				occupant_mutations.Add(list(list(
				"name" = "AN_GENE_MUT_[M.hex]_[uppertext(mut_name)]",
				"is_active" = M.is_active ? "ACTIVE" : "DORMANT")))

			for(var/i in H.active_mutations)
				var/datum/mutation/M = i
				occupant_mutations.Add(list(list(
				"name" = "AN_GENE_MUT_[M.hex]_[uppertext(M.tier_string)]",
				"is_active" = "ACTIVE")))
			
			if(occupant_mutations.len)
				data["have_mutations"] = TRUE
				data["occupant_mutations"] = occupant_mutations

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "dna_console.tmpl", "Chrysalis controller", 450, 600, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
