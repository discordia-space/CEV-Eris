/obj/item/device/scanner
	name = "scanner"
	desc = "basic scanner unit"
	icon_state = "multitool"
	item_state = null
	flags = CONDUCT
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	throwforce = WEAPON_FORCE_HARMLESS
	throw_speed = 4
	throw_range = 20

	origin_tech = null

	var/obj/item/weapon/cell/cell = null
	var/suitable_cell = /obj/item/weapon/cell/small

	var/scan_title
	var/scan_data

	var/use_delay = 5
	var/scan_sound = 'sound/machines/twobeep.ogg'

	//For displaying scans
	var/window_width = 450
	var/window_height = 600

	var/charge_per_use = 0

	throw_speed = 3
	throw_range = 7

	matter = list(MATERIAL_PLASTIC = 2, MATERIAL_GLASS = 1)
	origin_tech = list(TECH_BIO = 1)

/obj/item/device/scanner/attack_self(mob/user)
	if(!scan_data)
		to_chat(user, SPAN_NOTICE("[src]\'s data buffer is empty."))
		return
	show_results(user)

/obj/item/device/scanner/proc/show_results(mob/user)
	var/datum/browser/popup = new(user, "scanner", scan_title, window_width, window_height)
	popup.set_content("[get_header()]<hr>[scan_data]")
	popup.open()

/obj/item/device/scanner/proc/get_header()
	return "<a href='?src=\ref[src];print=1'>Print Report</a><a href='?src=\ref[src];clear=1'>Clear data</a>"

/obj/item/device/scanner/proc/can_use(mob/user)
	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return
	if(!cell_use_check(charge_per_use))
		to_chat(user, SPAN_WARNING("[src] battery is dead or missing."))
		return
	return TRUE

/obj/item/device/scanner/proc/is_valid_scan_target(atom/O)
	return FALSE

/obj/item/device/scanner/proc/scan(atom/A, mob/user)

/obj/item/device/scanner/afterattack(atom/A, mob/user, proximity)
	if(!proximity)
		return
	if(!can_use(user))
		return

	if(is_valid_scan_target(A) && A.simulated)
		user.visible_message(SPAN_NOTICE("[user] runs \the [src] over \the [A]."), range = 2)
		if(scan_sound)
			playsound(src, scan_sound, 30)
		if(use_delay && !do_after(user, use_delay, A))
			to_chat(user, "You stop scanning \the [A] with \the [src].")
			return
		scan(A, user)
		if(!scan_title)
			scan_title = "[capitalize(name)] scan - [A]"

/obj/item/device/scanner/proc/cell_check()
	if(!cell && suitable_cell)
		cell = new suitable_cell(src)

//all user was replased on usr
/obj/item/device/scanner/proc/cell_use_check(charge)
	. = TRUE
	if(!cell || !cell.checked_use(charge))
		to_chat(usr, SPAN_WARNING("[src] battery is dead or missing."))
		. = FALSE

/obj/item/device/scanner/Initialize()
	. = ..()
	cell_check()

/obj/item/device/scanner/get_cell()
	return cell

/obj/item/device/scanner/handle_atom_del(atom/A)
	..()
	if(A == cell)
		cell = null
		update_icon()

/obj/item/device/scanner/MouseDrop(over_object)
	if((src.loc == usr) && istype(over_object, /obj/screen/inventory/hand) && eject_item(cell, usr))
		cell = null

/obj/item/device/scanner/attackby(obj/item/C, mob/living/user)
	if(istype(C, suitable_cell) && !cell && insert_item(C, user))
		src.cell = C


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

/obj/item/device/scanner/OnTopic(var/user, var/list/href_list)
	if(href_list["print"])
		print_report(user)
		return 1
	if(href_list["clear"])
		to_chat(user, "You clear data buffer on [src].")
		scan_data = null
		scan_title = null
		user << browse(null, "window=scanner")
		return 1

/obj/item/device/scanner/proc/print_report(var/mob/living/user)
	if(!scan_data)
		to_chat(user, "There is no scan data to print.")
		return
	var/obj/item/weapon/paper/P = new(get_turf(src), scan_data, "paper - [scan_title]")
	user.put_in_hands(P)
	user.visible_message("\The [src] spits out a piece of paper.")

/obj/item/device/scanner/examine(mob/user)
	if(..(user, 2) && scan_data)
		show_results(user)