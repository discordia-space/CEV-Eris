/obj/machinery/moeballs_printer
	name = "moeballs printer"
	desc = "Lorem Ipsum"
	icon = 'icons/obj/eris_genetics.dmi'
	icon_state = "printer_base"
	density = TRUE
	anchored = TRUE
//	circuit = /obj/item/electronics/circuitboard/moeballs_printer
	use_power = IDLE_POWER_USE
	idle_power_usage = 60
	active_power_usage = 10000
	req_access = list(access_research_equipment)
	var/color_key = "yellow"
	var/hacked = FALSE
	var/obj/item/computer_hardware/hard_drive/portable/usb
	var/list/files[0]
	var/index = 0 // Maybe use files.len or something
	var/gene_cache = list(
		"name" = "\[NOT SELECTED\]",
		"desc" = "\[NOT FOUND\]",
		"type" = "b_type",
		"content" = "O-")


/obj/machinery/moeballs_printer/initalize_statverbs()
	if(req_access.len)
		add_statverb(/datum/statverb/hack_console)


/obj/machinery/moeballs_printer/LateInitialize()
	color_key = default_dna_machinery_style
	update_icon()


/obj/machinery/moeballs_printer/New()
	..()
	color_key = default_dna_machinery_style
	update_icon()


//obj/machinery/moeballs_printer/attackby(obj/item/I, mob/living/user)
// Reaction to multitool here, for changing color_key


//obj/machinery/moeballs_printer/emag_act(remaining_charges, mob/user, emag_source)
//	. = ..()
//	hacked = TRUE


/obj/machinery/moeballs_printer/update_icon()
	..()
	overlays.Cut()
	if(!(stat & (NOPOWER|BROKEN)) && use_power)
		var/state = "printer_idle_[color_key]"
		overlays += state


/obj/machinery/moeballs_printer/proc/do_flick(is_error)
	if(is_error)
		flick("printer_error", src)
	else
		flick("printer_on_[color_key]", src)


/obj/machinery/moeballs_printer/AltClick(mob/user)
	try_eject_usb(user)


/obj/machinery/moeballs_printer/verb/eject_usb()
	set name = "Eject Portable Storage"
	set category = "Object"
	set src in view(1)
	try_eject_usb(usr)


/obj/machinery/moeballs_printer/proc/try_eject_usb(mob/user)
	if(!usb || user.incapacitated() || !Adjacent(user) || !isliving(user))
		return

	eject_item(usb, user)
	usb = null
	files.Cut()
	index = 0


/obj/machinery/moeballs_printer/attack_hand(mob/user)
	ui_interact(user)


/obj/machinery/moeballs_printer/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/computer_hardware/hard_drive/portable) && !usb)
		insert_item(I, user)
		usb = I
	else
		..()


/obj/machinery/moeballs_printer/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["cache"])
		for(var/entry in files)
			if(entry["index"] == href_list["cache"])
				gene_cache["name"] = entry["name"]
				gene_cache["type"] = entry["type"]
				gene_cache["content"] = entry["content"]

				switch(entry["type"])
					if("mutation")
						var/datum/mutation/M = entry["content"]
						gene_cache["desc"] = M.desc

					if("b_type")
						gene_cache["desc"] = "Permanently changes blood type to [entry["content"]]."

					if("real_name")
						gene_cache["desc"] = "Alters person\'s appearance, voice and fingerprints to match those of [entry["content"]]."

					if("species")
						gene_cache["desc"] = "Significantly alters body structure. Resulting creature would clasify as [entry["content"]]"
		return TOPIC_REFRESH

	if(href_list["make_worm_cube"])
		do_flick(FALSE)
		sleep(1.5 SECONDS)
		var/obj/item/wormcube/C = new(src.loc)
		if(gene_cache["type"] == "mutation")
			var/datum/mutation/M = gene_cache["content"]
			C.gene_value = M
		else
			C.gene_value = gene_cache["content"]
		return TOPIC_REFRESH

	if(href_list["make_meat_cube"])
		do_flick(FALSE)
		sleep(1.5 SECONDS)
		var/obj/item/moecube/C = new(src.loc)
		C.gene_type = gene_cache["type"]
		if(gene_cache["type"] == "mutation")
			var/datum/mutation/M = gene_cache["content"]
			C.gene_value = M
		else
			C.gene_value = gene_cache["content"]
		return TOPIC_REFRESH


/obj/machinery/moeballs_printer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = ui_data()

	data["have_files"] = FALSE
	data["can_print"] = TRUE //TODO: Add conditions when it's false. Like nutriment requirement or some such.

	data["name"] = gene_cache["name"]
	data["desc"] = gene_cache["desc"]

	// Accept everything but inactive mutation
	if(usb && !index)
		for(var/datum/computer_file/binary/animalgene/F in usb.stored_files)
			if(F.gene_type == "mutation")
				var/datum/mutation/M = F.gene_value
				if(M.is_active)
					files.Add(list(list(
					"name" = "AN_GENE_MUT_[M.hex]_[uppertext(replacetext("[M.name]", " ", "_"))]",
					"type" = "mutation",
					"content" = M,
					"index" = "[++index]")))
			else
				files.Add(list(list(
				"name" = F.filename,
				"type" = F.gene_type,
				"content" = F.gene_value,
				"index" = "[++index]")))

	if(files.len)
		data["have_files"] = TRUE
		data["files"] = files

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "dna_printer.tmpl", "Dna 3: Rework of the rework", 450, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
