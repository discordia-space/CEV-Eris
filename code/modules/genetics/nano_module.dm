/datum/computer_file/program/dna
	filename = "dnaapp"
	filedesc = "Genome decoder"
	program_icon_state = "generic"
	extended_desc = "Lorem Ipsum"
	size = 2
	available_on_ntnet = 1
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	nanomodule_path = /datum/nano_module/program/dna


/datum/nano_module/program/dna
	name = "Domino 2: Wraith of the Reere"


/datum/nano_module/program/dna/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	var/datum/computer_file/program/dna/P = program
	var/obj/item/modular_computer/C = P.computer
	var/obj/item/computer_hardware/hard_drive/portable/USB = C.portable_drive

	if(href_list["start_minigame"])
		if(USB)
			for(var/datum/computer_file/binary/animalgene/F in USB.stored_files)
				if(F.gene_value == href_list["start_minigame"])
					var/datum/mutation/M = F.gene_value
					M.is_active = TRUE
					F.gene_value = M
		return TOPIC_REFRESH


/datum/nano_module/program/dna/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	var/list/files[0]

	data["have_files"] = FALSE

	var/datum/computer_file/program/dna/P = program
	var/obj/item/modular_computer/C = P.computer
	var/obj/item/computer_hardware/hard_drive/HDD = C.hard_drive
	var/obj/item/computer_hardware/hard_drive/portable/USB = C.portable_drive

	// Accept only inactive mutations
	if(HDD)
		for(var/datum/computer_file/binary/animalgene/F in HDD.stored_files)
			if(F.gene_type == "mutation")
				var/datum/mutation/M = F.gene_value
				if(!M.is_active)
					files.Add(list(list(
					"name" = "[M.tier_string]_[M.hex]",
					"content" = "\ref[M]")))

	if(USB)
		for(var/datum/computer_file/binary/animalgene/F in USB.stored_files)
			if(F.gene_type == "mutation")
				var/datum/mutation/M = F.gene_value
				if(!M.is_active)
					files.Add(list(list(
					"name" = "[M.tier_string]_[M.hex]",
					"content" = "\ref[M]")))

	if(files.len)
		data["have_files"] = TRUE
		data["files"] = files

//	var/cell_size_x = 8
//	var/cell_size_y = 8

//	var/field_size_x = 8
//	var/field_size_y = 8
//	var/array[][]

//	if(!array)
//		array = new/list(field_size_x, field_size_y)
//
//		for(var/i in array)
//			i = FALSE

//	var/HUD_element/grid_cell = new
//	grid_cell.setName("")
//	grid_cell.setIcon(icon("icons/mob/screen1.dmi","block"))
//	grid_cell.setHideParentOnClick(TRUE)
//	grid_cell.setClickProc(.proc/closeButtonClick)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "domino_app.tmpl", "Domino 2: Wraith of the Reere", 450, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
