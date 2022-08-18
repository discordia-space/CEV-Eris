/obj/machinery/dna/console
	name = "Chrysalis controller"
	desc = "A stationary computer."
	icon_state = "console_base"
	circuit = /obj/item/electronics/circuitboard/dna_console
	var/error = FALSE
	var/obj/machinery/cryo_slab/linked
	var/linked_direction


/obj/machinery/dna/console/Initialize(mapload, d=0)
	establish_connection()
	. = ..()


/obj/machinery/dna/console/New()
	establish_connection()
	..()


/obj/machinery/dna/console/proc/establish_connection()
	if(linked)
		return TRUE

	linked = locate(/obj/machinery/cryo_slab) in get_step(src, WEST)
	if(linked)
		linked_direction = "left"
		log_add("Chrysalis Pod v3.1 link established.")
		return TRUE

	linked = locate(/obj/machinery/cryo_slab) in get_step(src, EAST)
	if(linked)
		linked_direction = "right"
		log_add("Chrysalis Pod v3.1 link established.")
		return TRUE

	return FALSE


/obj/machinery/dna/console/update_icon()
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


/obj/machinery/dna/console/attack_hand(mob/living/carbon/human/user)
	..()
	if(!linked)
		establish_connection()
		update_icon()


/obj/machinery/dna/console/proc/error_popup()
	if(error)
		return

	error = TRUE
	overlays += "console_error"
	sleep(1.5 SECONDS)
	error = FALSE
	update_icon()


/obj/machinery/dna/console/proc/save_pe()
	if(!usb)
		log_add("ERROR: No data storage found. Sequiencing aborted.")
		error_popup()
		return

	var/mob/living/carbon/human/H = linked.han_solo
	if(!H || !istype(H))
		return

	var/stored_count = 0
/* Temporary disabled due to species change currently duplicatiing organs in mob
	// Race // SPECIES_HUMAN, SPECIES_SLIME, SPECIES_MONKEY, SPECIES_GOLEM
	var/datum/computer_file/binary/animalgene/F = new
	F.filename = "AN_GENE_SPECIES_[uppertext(H.species.name)]"
	F.gene_type = "species"
	F.gene_value = H.species
	if(usb.store_file(F))
		stored_count++
	else if(!(F in usb.stored_files)) // If it's just a duplicated file - no error needed
		log_add("ERROR: Insufficient storage space. Sequiencing aborted.")
		error_popup()
		return
*/
	// Blood type // GLOB.blood_types = list("A-", "A+", "B-", "B+", "AB-", "AB+", "O-", "O+")
	var/datum/computer_file/binary/animalgene/F = new // Gotta do that each time or magic won't happen
	var/blood_type = H.b_type
	blood_type = replacetext(blood_type, "+", "_POSITIVE")
	blood_type = replacetext(blood_type, "-", "_NEGATIVE")
	F.filename = "AN_GENE_BLOOD_[blood_type]"
	F.gene_type = "b_type"
	F.gene_value = H.b_type
	if(usb.store_file(F))
		stored_count++
	else if(!(F in usb.stored_files)) // If it's just a duplicated file - no error needed
		log_add("ERROR: Insufficient storage space. Sequiencing aborted.")
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
		log_add("ERROR: Insufficient storage space. Sequiencing aborted.")
		error_popup()
		return

	if(stored_count)
		log_add("Sequencing complete, [stored_count] unique patterns recorded.")


/obj/machinery/dna/console/proc/save_ue(target_hex)
	if(!usb)
		log_add("ERROR: No data storage found. Sequiencing aborted.")
		error_popup()
		return

	var/mob/living/carbon/human/H = linked.han_solo
	if(!H || !istype(H))
		return

	var/stored_count = 0

	for(var/list/L in list(H.dormant_mutations, H.active_mutations))
		for(var/i in L)
			var/datum/mutation/M = i
			if(!target_hex || target_hex == M.hex)
				var/datum/computer_file/binary/animalgene/F = new
				// Show mutation name instead of a tier_string if it have been activated previously
				var/mut_name = M.is_active ? replacetext("[M.name]", " ", "_") : "[M.tier_string]"
				F.filename = "AN_GENE_MUT_[M.hex]_[uppertext(mut_name)]"
				F.gene_type = "mutation"
				F.gene_value = M.clone()
				if(usb.store_file(F))
					stored_count++
				else if(!(F in usb.stored_files))
					log_add("ERROR: Insufficient storage space. Sequiencing aborted.")
					error_popup()
					break

	if(stored_count)
		log_add("Sequencing complete, [stored_count] unique pattern[stored_count == 1 ? "" : "s"] recorded.")


/obj/machinery/dna/console/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["save_pe"])
		save_pe()
		return TOPIC_REFRESH

	if(href_list["save_ue"])
		save_ue()
		return TOPIC_REFRESH

	if(href_list["save_mut"])
		save_ue(href_list["save_mut"])
		return TOPIC_REFRESH


	if(href_list["eject"])
		try_eject_usb(usr)
		return TOPIC_REFRESH


/obj/machinery/dna/console/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/nano_topic_state/state = GLOB.default_state)
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
	data["disc_inserted"] = usb ? TRUE : FALSE
	data["log"] = action_log

	if(linked && linked.han_solo)
		var/mob/living/carbon/human/H = linked.han_solo // For convenience sake

		data["occupied"] = TRUE
		data["species"] = H.species ? H.species : no_data
//		data["gender"] = H.gender ? H.gender : no_data
		data["b_type"] = H.b_type ? H.b_type : no_data
		data["age"] = H.age ? H.age : no_data
		data["dna_trace"] = H.dna_trace ? H.dna_trace : no_data
		data["fingers_trace"] = get_active_mutation(H, MUTATION_NOPRINTS) ? "None" : (H.fingers_trace ? H.fingers_trace : no_data)

		if(H.dormant_mutations && H.dormant_mutations)
			for(var/i in H.dormant_mutations)
				var/datum/mutation/M = i
				var/mut_name = M.is_active ? replacetext("[M.name]", " ", "_") : ("[M.tier_string]")
				occupant_mutations.Add(list(list(
				"name" = "AN_GENE_MUT_[M.hex]_[uppertext(mut_name)]",
				"hex" = M.hex,
				"is_active" = M.is_active ? "ACTIVE" : "DORMANT")))

			for(var/i in H.active_mutations)
				var/datum/mutation/M = i
				occupant_mutations.Add(list(list(
				"name" = "AN_GENE_MUT_[M.hex]_[uppertext(M.tier_string)]",
				"hex" = M.hex,
				"is_active" = "ACTIVE")))

			if(occupant_mutations.len)
				data["have_mutations"] = TRUE
				data["occupant_mutations"] = occupant_mutations

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "dna_console.tmpl", "Chrysalis controller", 450, 650, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
