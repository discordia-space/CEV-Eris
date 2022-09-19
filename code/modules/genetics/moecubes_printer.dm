/obj/machinery/dna/moeballs_printer
	name = "Gene regurgitator"
	desc = "A stationary computer."
	icon_state = "printer_base"
	circuit = /obj/item/electronics/circuitboard/moeballs_printer
	description_info = "Prints cubes of genetics-modifying worms. They deal toxins upon ingestion"
	description_antag = "Can be used to give people bad genetics. They have no way of knowing what you're giving them unless its effects are obvious."
	var/obj/item/reagent_containers/glass/beaker
	var/index = 0
	var/is_busy = FALSE
	var/list/files[0]
	var/list/gene_cache = list(
		"name" = "\[NOT SELECTED\]",
		"desc" = "\[NOT FOUND\]",
		"type" = "",
		"content" = "")
	var/list/valid_reagents = list(
		"nutriment",
		"protein",
		"glucose",
		"egg")


/obj/machinery/dna/moeballs_printer/update_icon()
	..()
	overlays.Cut()
	if(!(stat & (NOPOWER|BROKEN)) && use_power)
		var/state = "printer_idle_[color_key]"
		overlays += state


/obj/machinery/dna/moeballs_printer/proc/do_flick(is_error)
	if(!is_busy)
		is_busy = TRUE
		overlays.Cut()
		if(is_error)
			flick("printer_error", src)
		else
			flick("printer_on_[color_key]", src)
		spawn(1.5 SECONDS)
			overlays += "printer_idle_[color_key]"
			is_busy = FALSE


/obj/machinery/dna/moeballs_printer/try_eject_usb(mob/user)
	if(usb && eject_item(usb, user))
		usb = null
		files.Cut()
		index = 0
		gene_cache = list(
		"name" = "\[NOT SELECTED\]",
		"desc" = "\[NOT FOUND\]",
		"type" = "",
		"content" = "")


/obj/machinery/dna/moeballs_printer/proc/produce_cube(is_meatcube)
	if(stat & (NOPOWER|BROKEN) || is_busy)
		return

	if(!beaker)
		do_flick(TRUE)
		log_add("Nutriment source missing.")
		return

	if(beaker.reagents.get_reagents_amount(valid_reagents) < 15)
		do_flick(TRUE)
		log_add("Insufficient nutriment amount.")
		return

	beaker.reagents.remove_reagents(valid_reagents, 15)
	do_flick(FALSE)
	sleep(1.5 SECONDS)

	if(is_meatcube)
		var/obj/item/reagent_containers/food/snacks/moecube/C = new(loc)
		C.gene_type = gene_cache["type"]
		C.gene_value = gene_cache["content"]
		log_add("Created genome imprinter for [gene_cache["name"]]")
		if(gene_cache["type"] == "mutation")
			var/datum/mutation/M = gene_cache["content"]
			C.gene_value = M
		C.set_genes()
	else
		var/obj/item/reagent_containers/food/snacks/moecube/worm/C = new(loc)
		if(gene_cache["type"] == "mutation")
			var/datum/mutation/M = gene_cache["content"]
			C.gene_value = M
			log_add("Created cleansing substrate for [gene_cache["name"]]")
		else
			log_add("Created universal cleansing substrate.")
		C.set_genes()

/obj/machinery/dna/moeballs_printer/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/reagent_containers/glass/beaker) && !beaker && insert_item(I, user))
		beaker = I
	..()


/obj/machinery/dna/moeballs_printer/verb/eject_beaker()
	set name = "Eject Reagent Container"
	set category = "Object"
	set src in view(1)
	try_eject_beaker(usr)


/obj/machinery/dna/moeballs_printer/proc/try_eject_beaker(mob/user)
	if(eject_item(beaker, user))
		beaker.update_icon()
		beaker = null


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

	if(href_list["eject_usb"])
		try_eject_usb(usr)
		return TOPIC_REFRESH

	if(href_list["eject_beaker"])
		try_eject_beaker(usr)
		return TOPIC_REFRESH


/obj/machinery/dna/moeballs_printer/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/nano_topic_state/state = GLOB.default_state)
	var/list/data = nano_ui_data()

	data["log"] = action_log
	data["have_files"] = FALSE
	data["name"] = gene_cache["name"]
	data["desc"] = gene_cache["desc"]
	data["can_print"] = gene_cache["content"] ? TRUE : FALSE
	data["disc_inserted"] = usb ? TRUE : FALSE
	data["beaker_inserted"] = beaker ? TRUE : FALSE
	data["beaker_volume"] = beaker ? beaker.reagents.get_reagents_amount(valid_reagents) : 0
	data["beaker_max"] = beaker ? beaker.reagents.maximum_volume : 60

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
		ui = new(user, src, ui_key, "dna_printer.tmpl", "Gene regurgitator", 450, 650, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
