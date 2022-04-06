/obj/item/dna_scanner
	name = "ML \"Sensillum\""
	desc = "Dna est? A esli naidu?"
	icon = 'icons/obj/eris_genetics.dmi'
	icon_state = "dnascanner"
	var/color_key = "yellow"
	var/current_state = "standby" // opening, closing, working, no
	var/obj/item/computer_hardware/hard_drive/portable/usb


/obj/item/dna_scanner/Initialize(mapload, d=0)
	. = ..()
	color_key = default_dna_machinery_style
	update_icon()


/obj/item/dna_scanner/update_icon()
	icon_state = "[initial(icon_state)]_[current_state]_[color_key]"


/obj/item/dna_scanner/AltClick(mob/user)
	try_eject_usb(user)


/obj/item/dna_scanner/verb/eject_usb()
	set name = "Eject Portable Storage"
	set category = "Object"
	set src in view(1)
	try_eject_usb(usr)


/obj/item/dna_scanner/proc/try_eject_usb(mob/user)
	if(!usb || user.incapacitated() || !Adjacent(user) || !isliving(user))
		return

	eject_item(usb, user)
	usb = null


/obj/item/dna_scanner/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/computer_hardware/hard_drive/portable) && !usb)
		insert_item(I, user)
		usb = I
	else if(QUALITY_PULSING in I.tool_qualities)
		var/input_color = input(user, "Available colors", "Configuration") in GLOB.dna_machinery_styles
		if(input_color)
			color_key = input_color
			update_icon()
	else
		..()


/obj/item/dna_scanner/attack(mob/living/L, mob/living/user, target_zone)
	if(user.a_intent != I_HURT && ishuman(L))
		var/mob/living/carbon/human/H = L

		if(!usb)
			audible_message(SPAN_WARNING("[src] beeps: 'No data storage found.'"))
			return

		if(!H.reagents.has_reagent("kognim"))
			audible_message(SPAN_WARNING("[src] beeps: 'No catalyst reagent detected in test subject's bloodstream.'"))
			return

		var/stored_count = 0

		for(var/i in H.dormant_mutations)
			var/datum/mutation/M = i
			var/datum/computer_file/binary/animalgene/F = new
			// Show mutation name instead of a hex value if it have been activated previously
			var/mut_name = M.is_active ? replacetext("[M.name]", " ", "_") : "[M.tier_string]"
			F.filename = "AN_GENE_MUT_[M.hex]_[uppertext(mut_name)]"
			F.gene_type = "mutation"
			F.gene_value = M.clone()
			if(usb.store_file(F))
				stored_count++
			else if(!(F in usb.stored_files)) // If it's just a duplicated file - no error needed
				audible_message(SPAN_WARNING("[src] beeps: 'Sequencing failed.'"))
				break

		for(var/i in H.active_mutations)
			var/datum/mutation/M = i
			var/datum/computer_file/binary/animalgene/F = new
			F.filename = "AN_GENE_MUT_[M.hex]_[uppertext(replacetext("[M.name]", " ", "_"))]"
			F.gene_type = "mutation"
			F.gene_value = M.clone()
			if(usb.store_file(F))
				stored_count++
			else if(!(F in usb.stored_files))
				audible_message(SPAN_WARNING("[src] beeps: 'Sequencing failed.'"))
				break

		if(stored_count)
			audible_message(SPAN_WARNING("[src] beeps: 'Sequencing complete, [stored_count] unique patterns recorded.'"))

	else
		..()

