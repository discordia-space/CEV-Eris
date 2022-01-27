/obj/item/hand_labeler
	name = "hand labeler"
	desc = "Device that could be used to label just about anything, including ammo69agazines."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	matter = list(MATERIAL_PLASTIC = 2)
	var/label =69ull
	var/labels_left = 30
	var/mode = 0	//off or on.

/obj/item/hand_labeler/attack()
	return

/obj/item/hand_labeler/afterattack(atom/A,69ob/user as69ob, proximity)
	if(!proximity)
		return

	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label

	if(istype(A, /obj/item/ammo_magazine) && !istype(A, /obj/item/ammo_magazine/ammobox))
		var/obj/item/ammo_magazine/M = A
		// Flip ammo_names dictionary so player see, for example, "high69elocity" instead of "hv" in input() popup
		var/list/choices69069
		for(var/i in69.ammo_names)
			choices69M.ammo_names69i6969 = i

		choices69"automatic"69 = "l"
		var/choice = input(user, "Available color schemes", "Label configuration") in choices

		if(!choice || choice == "automatic")
			M.get_label()
		else
			M.get_label(choices69choice69)
		M.update_icon()
		return

	if(!mode)	//if it's off, give up.
		return

	if(!labels_left)
		to_chat(user, SPAN_NOTICE("No labels left."))
		return
	if(!label || !length(label))
		to_chat(user, SPAN_NOTICE("No text set."))
		return
	if(length(A.name) + length(label) > 64)
		to_chat(user, SPAN_NOTICE("Label too big."))
		return
	if(ishuman(A))
		to_chat(user, SPAN_NOTICE("The label refuses to stick to 69A.name69."))
		return
	if(issilicon(A))
		to_chat(user, SPAN_NOTICE("The label refuses to stick to 69A.name69."))
		return
	if(isobserver(A))
		to_chat(user, SPAN_NOTICE("69src69 passes through 69A.name69."))
		return
	if(istype(A, /obj/item/reagent_containers/glass))
		to_chat(user, SPAN_NOTICE("The label can't stick to the 69A.name69.  (Try using a pen)"))
		return
	if(istype(A, /obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/tray = A
		if(!tray.mechanical)
			to_chat(user, SPAN_NOTICE("How are you going to label that?"))
			return
		tray.labelled = label
		spawn(1)
			tray.update_icon()
	playsound(src,'sound/effects/FOLEY_Gaffer_Tape_Tear_mono.ogg',100,1)
	user.visible_message(SPAN_NOTICE("69user69 labels 69A69 as 69label69."), \
						 SPAN_NOTICE("You label 69A69 as 69label69."))
	A.name = "69A.name69 (69label69)"

/obj/item/hand_labeler/attack_self(mob/user as69ob)
	mode = !mode
	icon_state = "labeler69mode69"
	if(mode)
		to_chat(user, SPAN_NOTICE("You turn on \the 69src69."))
		//Now let them chose the text.
		var/str = sanitizeName(input(user,"Label text?","Set label",""),69AX_NAME_LEN) //Only A-Z, 1-9 and `-`
		if(!str || !length(str))
			to_chat(user, SPAN_NOTICE("Invalid text."))
			return
		label = str
		to_chat(user, SPAN_NOTICE("You set the text to '69str69'."))
	else
		to_chat(user, SPAN_NOTICE("You turn off \the 69src69."))
