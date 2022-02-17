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

	if(href_list["placeholder"])
		for(var/entry in files)
			if(entry["index"] == href_list["placeholder"])
				do_flick(FALSE)
				sleep(1.5 SECONDS)
				var/obj/item/moecube/C = new(src.loc)
				C.gene_type = entry["type"]
				if(entry["type"] == "mutation")
					var/datum/mutation/M = entry["content"]
					C.gene_value = M
				else
					C.gene_value = entry["content"]
		return TOPIC_REFRESH


/obj/machinery/moeballs_printer/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = NANOUI_FOCUS, var/datum/topic_state/state = GLOB.default_state)
	var/list/data = ui_data()

	data["have_files"] = FALSE

	// Accept everything othen than inactive mutation
	if(usb && !index)
		for(var/datum/computer_file/binary/animalgene/F in usb.stored_files)
			if(F.gene_type == "mutation")
				var/datum/mutation/M = F.gene_value
				if(M.is_active)
					files.Add(list(list(
					"name" = M.name,
					"type" = "mutation",
					"content" = "\ref[M]",
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
		ui = new(user, src, ui_key, "moeballs_printer.tmpl", "Dna 3: Rework of the rework", 450, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(TRUE)
