/obj/item/device/scanner
	name = "scanner"
	desc = "basic scanner unit"
	icon_state = "multitool"
	item_state = null
	flags = CONDUCT
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 3
	throw_range = 7

	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1)
	origin_tech = list(TECH_BIO = 1)
	bad_type = /obj/item/device/scanner

	suitable_cell = /obj/item/cell/small

	var/scan_title
	var/scan_data

	var/use_delay = 5
	var/scan_sound = 'sound/machines/twobeep.ogg'

	//For displaying scans
	var/window_width = 450
	var/window_height = 600

	var/charge_per_use = 0

	var/is_virtual = FALSE // for non-physical scanner to avoid displaying action69essages


/obj/item/device/scanner/attack_self(mob/user)
	if(!scan_data)
		to_chat(user, SPAN_NOTICE("69src69\'s data buffer is empty."))
		return
	show_results(user)

/obj/item/device/scanner/proc/show_results(mob/user)
	var/datum/browser/popup = new(user, "scanner", scan_title, window_width, window_height)
	popup.set_content("69get_header()69<hr>69scan_data69")
	popup.open()

/obj/item/device/scanner/proc/get_header()
	return "<a href='?src=\ref69src69;print=1'>Print Report</a><a href='?src=\ref69src69;clear=1'>Clear data</a>"

/obj/item/device/scanner/proc/can_use(mob/user)
	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return
	if(!cell_use_check(charge_per_use, user))
		return
	return TRUE

/obj/item/device/scanner/proc/is_valid_scan_target(atom/O)
	return FALSE

/obj/item/device/scanner/proc/scan(atom/A,69ob/user)

/obj/item/device/scanner/afterattack(atom/A,69ob/user, proximity)
	if(!proximity)
		return
	if(!can_use(user))
		return

	if(is_valid_scan_target(A) && A.simulated)
		if(!is_virtual)
			user.visible_message(SPAN_NOTICE("69user69 runs \the 69src69 over \the 69A69."), range = 2)
			if(scan_sound)
				playsound(src, scan_sound, 30)
		else
			user.visible_message(SPAN_NOTICE("69user69 focuses on \the 69A69 for a69oment."), range = 2)
		if(use_delay && !do_after(user, use_delay, A))
			if(!is_virtual)
				to_chat(user, "You stop scanning \the 69A69 with \the 69src69.")
			else
				to_chat(user, "You stop focusing on \the 69A69.")
			return
		scan(A, user)
		if(!scan_title)
			scan_title = "69capitalize(name)69 scan - 69A69"

/obj/item/device/scanner/proc/print_report_verb()
	set name = "Print Report"
	set category = "Object"
	set src = usr

	var/mob/user = usr
	if(!istype(user))
		return
	if (user.incapacitated())
		return
	print_report(user)

/obj/item/device/scanner/OnTopic(var/user,69ar/list/href_list)
	if(href_list69"print"69)
		print_report(user)
		return 1
	if(href_list69"clear"69)
		to_chat(user, "You clear data buffer on 69src69.")
		scan_data = null
		scan_title = null
		user << browse(null, "window=scanner")
		return 1

/obj/item/device/scanner/proc/print_report(mob/living/user)
	if(!scan_data)
		to_chat(user, "There is no scan data to print.")
		return
	var/obj/item/paper/P = new(get_turf(src), scan_data, "paper - 69scan_title69")
	user.put_in_hands(P)
	user.visible_message("\The 69src69 spits out a piece of paper.")

/obj/item/device/scanner/examine(mob/user)
	if(..(user, 2) && scan_data)
		show_results(user)
