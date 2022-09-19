/obj/machinery/dna
	icon = 'icons/obj/eris_genetics.dmi'
	use_power = IDLE_POWER_USE
	idle_power_usage = 60
	active_power_usage = 10000
	req_access = list(access_genetics)
	density = TRUE
	anchored = TRUE
	var/color_key = "yellow"
	var/last_log = ""
	var/action_log = ""
	var/obj/item/computer_hardware/hard_drive/portable/usb


/obj/machinery/dna/Initialize(mapload, d=0)
	. = ..()
	color_key = default_dna_machinery_style
	update_icon()
	log_add("Initialization complete.")


/obj/machinery/dna/New()
	..()
	color_key = default_dna_machinery_style
	update_icon()


/obj/machinery/dna/initalize_statverbs()
	if(req_access.len)
		add_statverb(/datum/statverb/hack_console)


/obj/machinery/dna/proc/log_add(entry, do_check)
	entry = "\[[stationtime2text()]\] [entry] <br>"
	// Prevents stacking of "log in" messages when player clicks on console many times
	// But log all other messages, even if matching
	if(do_check)
		if(entry != last_log)
			last_log = entry
			action_log = last_log + action_log
	else
		action_log = entry + action_log


/obj/machinery/dna/AltClick(mob/user)
	try_eject_usb(user)


/obj/machinery/dna/verb/eject_usb()
	set name = "Eject Portable Storage"
	set category = "Object"
	set src in view(1)
	try_eject_usb(usr)


/obj/machinery/dna/proc/try_eject_usb(mob/user)
	if(eject_item(usb, user))
		usb = null


/obj/machinery/dna/emag_act(remaining_charges, mob/user, emag_source)
	. = ..()
	on_hacked()


/obj/machinery/dna/proc/on_hacked()
	if(!hacked)
		hacked = pick("Rache Bartmoss", "Doctor Braun", "Overseer Koster", "admin")
		log_add("Security protocols compromised.")
		log_add("Access granted to [hacked]", TRUE)


/obj/machinery/dna/attack_hand(mob/living/carbon/human/user)
	if(!istype(user))
		to_chat(user, SPAN_WARNING("You don't have the dexterity to do this!"))
		return

	if(hacked)
		nano_ui_interact(user)
		update_icon()
		log_add("Access granted to [hacked].", TRUE)

	else if(allowed(user))
		nano_ui_interact(user)
		update_icon()
		log_add("Access granted to [user.rank_prefix_name(FindNameFromID(user))].", TRUE)

	else
		log_add("Unauthorized access attempt by [user.rank_prefix_name(FindNameFromID(user))].", TRUE)
		to_chat(user, SPAN_WARNING("Unauthorized access."))


/obj/machinery/dna/attackby(obj/item/I, mob/living/user)
	if(default_part_replacement(I, user))
		return

	if(default_deconstruction(I, user))
		return

	if(istype(I, /obj/item/computer_hardware/hard_drive/portable) && !usb && insert_item(I, user))
		usb = I

	else if(QUALITY_PULSING in I.tool_qualities)
		var/input_color = input(user, "Available colors", "Configuration") in GLOB.dna_machinery_styles
		if(input_color)
			color_key = input_color
			update_icon()
	else
		..()
