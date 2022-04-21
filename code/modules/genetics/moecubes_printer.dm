/obj/machinery/dna/moeballs_printer
	name = "Gene regurgitator"
	desc = "A stationary computer."
	icon_state = "printer_base"
	circuit = /obj/item/electronics/circuitboard/moeballs_printer
	var/list/files[0]
	var/index = 0
	var/gene_cache = list(
		"name" = "\[NOT SELECTED\]",
		"desc" = "\[NOT FOUND\]",
		"type" = "",
		"content" = "")


/obj/machinery/dna/moeballs_printer/update_icon()
	..()
	overlays.Cut()
	if(!(stat & (NOPOWER|BROKEN)) && use_power)
		var/state = "printer_idle_[color_key]"
		overlays += state



//		flick("printer_error", src)


/obj/machinery/dna/moeballs_printer/try_eject_usb(mob/user)
	if(usb && eject_item(usb, user))
		usb = null
		files.Cut()
		index = 0


/obj/machinery/dna/moeballs_printer/proc/produce_cube(is_meatcube)
	flick("printer_on_[color_key]", src)
	sleep(1.5 SECONDS)
	var/obj/item/moecube/C = new(loc)

	if(is_meatcube)
		C.gene_type = gene_cache["type"]
		C.name = "cube of twitching meat"
		C.icon_state = "genecube"

	// gene_value here either mutation datum or null
	if(gene_cache["type"] == "mutation")
		var/datum/mutation/M = gene_cache["content"]
		C.gene_value = M
	else if(is_meatcube)
		C.gene_value = gene_cache["content"]


/obj/machinery/dna/moeballs_printer/Topic(href, href_list)
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
		produce_cube(FALSE)
		return TOPIC_REFRESH

	if(href_list["make_meat_cube"])
		produce_cube(TRUE)
		return TOPIC_REFRESH

	if(href_list["eject"])
		try_eject_usb(usr)
		return TOPIC_REFRESH


/obj/machinery/dna/moeballs_printer/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	var/list/data = ui_data()

	data["have_files"] = FALSE
	data["can_print"] = gene_cache["content"] ? TRUE : FALSE

	data["name"] = gene_cache["name"]
	data["desc"] = gene_cache["desc"]

	data["disc_inserted"] = usb ? TRUE : FALSE
	data["log"] = action_log

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
		ui = new(user, src, ui_key, "dna_printer.tmpl", "Gene regurgitator", 450, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
