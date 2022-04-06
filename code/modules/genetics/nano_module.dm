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
	var/list/domino_pool[0]
	var/list/domino_row_1[0]
	var/list/domino_row_2[0]
	var/index = 0


/datum/nano_module/program/dna/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED
/*
	var/datum/computer_file/program/dna/P = program
	var/obj/item/modular_computer/C = P.computer
	var/obj/item/computer_hardware/hard_drive/HDD = C.hard_drive
	var/obj/item/computer_hardware/hard_drive/portable/USB = C.portable_drive

	if(href_list["start_minigame"])
		var/hex

		for(var/entry in domino_pool)
			if(entry["index"] == href_list["start_minigame"])
				var/datum/mutation/M = entry["content"]
				hex = M.hex
				break

		if(!hex)
			return TOPIC_REFRESH

		if(USB)
			for(var/datum/computer_file/binary/animalgene/F in USB.stored_files)
				if(F.gene_type == "mutation")
					var/datum/mutation/MF = F.gene_value
					if(MF.hex == hex)
						MF.is_active = TRUE
						F.filename = "AN_GENE_MUT_[MF.hex]_[uppertext(replacetext("[MF.name]", " ", "_"))]"
		if(HDD)
			for(var/datum/computer_file/binary/animalgene/F in HDD.stored_files)
				if(F.gene_type == "mutation")
					var/datum/mutation/MF = F.gene_value
					if(MF.hex == hex)
						MF.is_active = TRUE
						F.filename = "AN_GENE_MUT_[MF.hex]_[uppertext(replacetext("[MF.name]", " ", "_"))]"
		
*/

	if(href_list["draw_from_pool"])
		for(var/entry in domino_pool)
			if(entry["index"] == href_list["draw_from_pool"])
				if(!domino_row_1.len)
					domino_row_1 += entry
					domino_pool -= entry

				else if(domino_row_1.len != DOMINO_ROW_LENGTH)
					var/last_entry = domino_row_1.len
					if(entry["domino_r"] == last_entry["domino_l"])
						domino_row_1 += entry
						domino_pool -= entry

				else if(!domino_row_2.len)
					domino_row_2 += entry
					domino_pool -= entry

				else if(domino_row_2.len != DOMINO_ROW_LENGTH)
					var/last_entry = domino_row_2.len
					if(entry["domino_r"] == last_entry["domino_l"])
						domino_row_2 += entry
						domino_pool -= entry
				break
		return TOPIC_REFRESH


	if(href_list["discard_to_pool"])
		var/target_row = domino_row_1

		if(domino_row_2.len)
			target_row = domino_row_2

		for(var/entry in target_row)
			if(entry["index"] == href_list["discard_to_pool"])
				domino_pool += entry
				target_row -= entry
				break
		return TOPIC_REFRESH


/datum/nano_module/program/dna/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
//	domino_pool.Cut()
//	index = 0

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
					domino_pool.Add(list(list(
					"name" = F.filename,
					"content" = F.gene_value,
					"hex" = M.hex,
					"domino_l" = M.domino_l,
					"domino_r" = M.domino_r,
					"index" = "[++index]")))
	if(USB)
		for(var/datum/computer_file/binary/animalgene/F in USB.stored_files)
			if(F.gene_type == "mutation")
				var/datum/mutation/M = F.gene_value
				if(!M.is_active)
					domino_pool.Add(list(list(
					"name" = F.filename,
					"content" = F.gene_value,
					"index" = "[++index]")))

	data["domino_pool"] = domino_pool
	data["domino_row_1"] = domino_row_1
	data["domino_row_2"] = domino_row_2

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "domino_app.tmpl", "Domino 2: Wraith of the Reere", 450, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)



// {{:value.name}} {{:helper.link('Do the thing', null, {'start_minigame' : value.index})}}
// {{:value.hex}}{{:value.domino_l}}{{:value.domino_r}}
