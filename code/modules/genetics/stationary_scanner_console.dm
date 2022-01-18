/obj/machinery/dna_console
	name = "moebius dna console"
	desc = "Lorem Ipsum"
	icon = 'icons/obj/machines/excelsior/autodoc.dmi'
	icon_state = "base"
	density = TRUE
	anchored = TRUE
//	circuit = /obj/item/electronics/circuitboard/dna_console
	use_power = IDLE_POWER_USE
	idle_power_usage = 60
	active_power_usage = 10000
	req_access = list(access_research_equipment)
	var/hacked = 0 // If this console has had its access requirements hacked or not.
	var/obj/machinery/cryo_slab/linked
	var/obj/item/computer_hardware/hard_drive/portable/usb


/obj/machinery/dna_console/initalize_statverbs()
	if(req_access.len)
		add_statverb(/datum/statverb/hack_console)


/obj/machinery/dna_console/proc/establish_connection()
	for(var/D in cardinal)
		var/step = get_step(src, D)
		linked = locate(/obj/machinery/cryo_slab) in step


/obj/machinery/dna_console/proc/save_ue()
	if(!usb)
		// to_chat(user, "nowhere to copy yo dumbass")
		return

	var/mob/living/carbon/human/H = linked.han_solo
	if(!H || !istype(H))
		return

	var/datum/computer_file/binary/animalgene/F = new

	// Race // SPECIES_HUMAN, SPECIES_SLIME, SPECIES_MONKEY, SPECIES_GOLEM
	F.filename = "Primus sequence \"[H.species]\""
	F.gene_type = "species"
	F.gene_value = H.species
	if(!usb.store_file(F))
		// to_chat(user, "oopsie woopsie can't copy sry(((")
		return

	// Blood type // GLOB.blood_types = list("A-", "A+", "B-", "B+", "AB-", "AB+", "O-", "O+")
	F.filename = "Sanguinis sequence \"[H.b_type]\""
	F.gene_type = "b_type"
	F.gene_value = H.b_type
	if(!usb.store_file(F))
		// to_chat(user, "oopsie woopsie can't copy sry(((")
		return

	// Unique identity // Fingerprints is md5() of real_name, while dna trace is sha1() of it
	F.filename = "Aspectus sequence \"[sha1(H.real_name)]\""
	F.gene_type = "real_name"
	F.gene_value = H.real_name
	if(!usb.store_file(F))
		// to_chat(user, "oopsie woopsie can't copy sry(((")
		return
/*
	// Not sure if we need that one
	F.filename = "Genus sequence \"[H.gender]\""
	F.gene_type = "gender"
	F.gene_value = H.gender
	if(!usb.store_file(F))
		// to_chat(user, "oopsie woopsie can't copy sry(((")
		return
*/
	// to_chat(user, "beep boop all copied")


/obj/machinery/dna_console/proc/save_pe()
	if(!usb)
		// to_chat(user, "nowhere to copy yo dumbass")
		return

	var/mob/living/carbon/human/H = linked.han_solo
	if(!H || !istype(H))
		return

	var/datum/computer_file/binary/animalgene/F = new

	for(var/datum/mutation/M in H.active_mutations)
		F.filename = "Sequence \"[M.tier_string]_[M.hex]\""
		F.gene_type = "mutation"
		F.gene_value = M
		if(!usb.store_file(F))
			// to_chat(user, "oopsie woopsie can't copy sry(((")
			return

	for(var/datum/mutation/M in H.dormant_mutations)
		F.filename = "Sequence \"[M.tier_string]_[M.hex]\""
		F.gene_type = "mutation"
		F.gene_value = M
		if(!usb.store_file(F))
			// to_chat(user, "oopsie woopsie can't copy sry(((")
			return

	// to_chat(user, "beep boop all copied")


/obj/machinery/dna_console/attack_hand(mob/user)
	if(!linked)
		establish_connection()

	ui_interact(user)


/obj/machinery/dna_console/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/computer_hardware/hard_drive/portable) && !usb)
		insert_item(I, user)
		usb = I
	else
		..()


/obj/machinery/dna_console/MouseDrop(over_object)
	..()
	if(usb && istype(over_object, /obj/screen/inventory/hand))
		eject_item(usb, usr)
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


	










