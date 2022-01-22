/obj/machinery/dna_console
	name = "moebius dna console"
	desc = "Lorem Ipsum"
	icon = 'icons/obj/eris_genetics.dmi'
	icon_state = "console_base"
	density = TRUE
	anchored = TRUE
//	circuit = /obj/item/electronics/circuitboard/dna_console
	use_power = IDLE_POWER_USE
	idle_power_usage = 60
	active_power_usage = 10000
	req_access = list(access_research_equipment)
	var/color_key = "yellow"
	var/error = FALSE
	var/hacked = FALSE
	var/obj/machinery/cryo_slab/linked
	var/linked_direction
	var/obj/item/computer_hardware/hard_drive/portable/usb
	var/tmp/obj/effect/flicker_overlay/flicker_overlay


/obj/machinery/dna_console/initalize_statverbs()
	if(req_access.len)
		add_statverb(/datum/statverb/hack_console)


/obj/machinery/dna_console/LateInitialize()
	color_key = default_dna_machinery_style
	establish_connection()
	update_icon()
	flicker_overlay = new(src)

/obj/machinery/dna_console/New()
	..()
	color_key = default_dna_machinery_style
	establish_connection()
	update_icon()
	flicker_overlay = new(src)

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


//obj/machinery/dna_console/attackby(obj/item/I, mob/living/user)
// Reaction to multitool here, for changing color_key


//obj/machinery/dna_console/emag_act(remaining_charges, mob/user, emag_source)
//	. = ..()
//	hacked = TRUE


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
	flick("console_error", flicker_overlay)
	sleep(3 SECONDS)
	error = FALSE


/obj/machinery/dna_console/proc/save_pe()
	if(!usb)
		error_popup()
		return

	var/mob/living/carbon/human/H = linked.han_solo
	if(!H || !istype(H))
		return

	// Race // SPECIES_HUMAN, SPECIES_SLIME, SPECIES_MONKEY, SPECIES_GOLEM
	var/datum/computer_file/binary/animalgene/F = new
	F.filename = "AN_GENE_SPECIES_[uppertext(H.species.name)]"
	F.gene_type = "species"
	F.gene_value = H.species
	if(!usb.store_file(F))
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
	if(!usb.store_file(F))
		error_popup()
		return

	// Unique identity // Fingerprints is md5() of real_name, while dna trace is sha1() of it
	F = new
	F.filename = "AN_GENE_APPEARANCE_[uppertext(sha1(H.real_name))]"
	F.gene_type = "real_name"
	F.gene_value = H.real_name
	if(!usb.store_file(F))
		error_popup()
		return
/*
	// Not sure if we need that one
	F = new
	F.filename = "Genus sequence '[H.gender]'"
	F.gene_type = "gender"
	F.gene_value = H.gender
	if(!usb.store_file(F))
		error_popup()
		return
*/
	// to_chat(user, "beep boop all copied")


/obj/machinery/dna_console/proc/save_ue()
	if(!usb)
		error_popup()
		return

	var/mob/living/carbon/human/H = linked.han_solo
	if(!H || !istype(H))
		return


	for(var/i in H.dormant_mutations)
		var/datum/computer_file/binary/animalgene/F = new
		var/datum/mutation/M = i
		if(!istype(M))
			log_and_message_admins("PIZDETS NAHUI BLYAT! Mutation is not a type!")
		var/mut_name = replacetext("[M.name]", " ", "_")
		F.filename = "AN_GENE_MUT_[uppertext(mut_name)]"
		F.gene_type = "mutation"
		F.gene_value = M
		if(!usb.store_file(F))
			error_popup()
			return

	for(var/i in H.active_mutations)
		var/datum/computer_file/binary/animalgene/F = new
		var/datum/mutation/M = i
		F.filename = "AN_GENE_MUT_[uppertext(M.tier_string)]"//"AN_GENE_MUT_[uppertext(M.tier_string)]_[M.hex]"
		F.gene_type = "mutation"
		F.gene_value = M
		if(!usb.store_file(F))
			error_popup()
			return

	// to_chat(user, "beep boop all copied")


/obj/machinery/dna_console/attack_hand(mob/user)
	if(!linked)
		establish_connection()

	ui_interact(user)
	update_icon()


/obj/machinery/dna_console/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/computer_hardware/hard_drive/portable) && !usb)
		insert_item(I, user)
		usb = I
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
	if(!usb)
		return

	if(user.incapacitated() || !Adjacent(user) || !isliving(user))
		return

	eject_item(usb, user)
	usb = null


/obj/machinery/dna_console/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["save_all"])
		save_pe()
		save_ue()
		return TOPIC_REFRESH

	if(href_list["save_pe"])
		save_pe()
		return TOPIC_REFRESH

	if(href_list["save_ue"])
		save_ue()
		return TOPIC_REFRESH


/obj/machinery/dna_console/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS, var/datum/topic_state/state = GLOB.default_state)
	if(isghost(user))
		return

	var/list/data = list()
	var/no_data = "\[REDACTED\]"

	data["linked"] = linked
	data["occupied"] = FALSE
	data["species"] = no_data
//	data["gender"] = no_data
	data["b_type"] = no_data
	data["age"] = no_data
	data["dna_trace"] = no_data
	data["fingers_trace"] = no_data
	data["active_mutations"] = no_data
	data["dormant_mutations"] = no_data

	if(linked && linked.han_solo)
		var/mob/living/carbon/human/H = linked.han_solo // For convenience sake

		data["occupied"] = TRUE
		data["species"] = H.species ? H.species : no_data
//		data["gender"] = H.gender ? H.gender : no_data
		data["b_type"] = H.b_type ? H.b_type : no_data
		data["age"] = H.age ? H.age : no_data
		data["dna_trace"] = H.dna_trace ? H.dna_trace : no_data
		data["fingers_trace"] = H.fingers_trace ? H.fingers_trace : no_data
		data["active_mutations"] = H.active_mutations ? H.active_mutations.len : no_data
		data["dormant_mutations"] = H.dormant_mutations ? H.dormant_mutations.len : no_data

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "dna_console.tmpl", "PLACEHOLDER", 450, 600, state = state)
		ui.auto_update_layout = TRUE
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
