/datum/computer_file/program/dna
	filename = "dnaapp"
	filedesc = "Genome decoder"
	program_icon_state = "generic"
	extended_desc = "Copyright © 2563, Moebius Laboratories. All rights reserved."
	size = 2
	available_on_ntnet = 1
	usage_flags = PROGRAM_CONSOLE | PROGRAM_LAPTOP
	nanomodule_path = /datum/nano_module/program/dna


/datum/computer_file/program/dna/process_tick()
	. = ..()
	var/datum/nano_module/program/dna/D = NM
	if(D.current_progress)
		D.tick()


/datum/nano_module/program/dna
	name = "Genome Decoder"
	var/list/files[0]
	var/index = 0
	var/target_hex
	var/message = ""
	var/current_progress = 0
	var/target_progress = 50


/datum/nano_module/program/dna/proc/tick()
	var/datum/computer_file/program/dna/P = program
	var/obj/item/modular_computer/C = P.computer

	var/processing_power = C.processor_unit.max_programs - C.all_threads.len

	if(!processing_power) // Too many programs running in the background
		message = "ERROR: Insufficient processing power."
		current_progress = 0
		return

	current_progress += processing_power

	if(current_progress >= target_progress)
		message = "Genome isolation complete." // Whatever that is supposed to mean
		current_progress = 0

		var/obj/item/computer_hardware/hard_drive/HDD = C.hard_drive
		var/obj/item/computer_hardware/hard_drive/portable/USB = C.portable_drive

		// Look for the right datum and make it "active" so /moeballs_printer would recognize it
		if(USB)
			for(var/datum/computer_file/binary/animalgene/F in USB.stored_files)
				if(F.gene_type == "mutation")
					var/datum/mutation/MF = F.gene_value
					if(MF.hex == target_hex)
						MF.is_active = TRUE
						F.filename = "AN_GENE_MUT_[MF.hex]_[uppertext(replacetext("[MF.name]", " ", "_"))]"

		if(HDD)
			for(var/datum/computer_file/binary/animalgene/F in HDD.stored_files)
				if(F.gene_type == "mutation")
					var/datum/mutation/MF = F.gene_value
					if(MF.hex == target_hex)
						MF.is_active = TRUE
						F.filename = "AN_GENE_MUT_[MF.hex]_[uppertext(replacetext("[MF.name]", " ", "_"))]"


/datum/nano_module/program/dna/Topic(href, href_list)
	if(..())
		return TOPIC_HANDLED

	if(href_list["reset"])
		message = ""
		current_progress = 0
		return TOPIC_REFRESH

	if(href_list["decode"])
		var/hex

		for(var/entry in files)
			if(entry["index"] == href_list["decode"])
				var/datum/mutation/M = entry["content"]
				hex = M.hex
				break

		if(!hex)
			message = "ERROR: Data cache corrupted."
			return TOPIC_REFRESH

		target_hex = hex
		current_progress++
		return TOPIC_REFRESH


/datum/nano_module/program/dna/nano_ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = NANOUI_FOCUS, datum/nano_topic_state/state = GLOB.default_state)
	var/list/data = host.initial_data()
	if(!current_progress)
		files.Cut()
		index = 0

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
						"name" = F.filename,
						"content" = F.gene_value,
						"index" = "[++index]")))
		if(USB)
			for(var/datum/computer_file/binary/animalgene/F in USB.stored_files)
				if(F.gene_type == "mutation")
					var/datum/mutation/M = F.gene_value
					if(!M.is_active)
						files.Add(list(list(
						"name" = F.filename,
						"content" = F.gene_value,
						"index" = "[++index]")))

	data["message"] = message
	data["files"] = files
	// Can't just check for files.len in template, nope
	data["have_files"] = files.len ? TRUE : FALSE
	data["target_progress"] = target_progress
	data["current_progress"] = current_progress

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "dna_software.tmpl", "Genome Decoder", 450, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
