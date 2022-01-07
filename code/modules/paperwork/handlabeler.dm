/obj/item/hand_labeler
	name = "hand labeler"
	desc = "Device that could be used to label just about anything, including ammo magazines."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "labeler0"
	item_state = "flight"
	matter = list(MATERIAL_PLASTIC = 2)
	var/label = null
	var/labels_left = 30
	var/mode = 0	//off or on.

/obj/item/hand_labeler/attack()
	return

/obj/item/hand_labeler/afterattack(atom/A, mob/user as mob, proximity)
	if(!proximity)
		return

	if(A == loc)	// if placing the labeller into something (e.g. backpack)
		return		// don't set a label

	if(istype(A, /obj/item/ammo_magazine) && !istype(A, /obj/item/ammo_magazine/ammobox))
		var/obj/item/ammo_magazine/M = A
		// Flip ammo_names dictionary so player see, for example, "high velocity" instead of "hv" in input() popup
		var/list/choices[0]
		for(var/i in M.ammo_names)
			choices[M.ammo_names[i]] = i

		choices["automatic"] = "l"
		var/choice = input(user, "Available color schemes", "Label configuration") in choices

		if(!choice || choice == "automatic")
			M.get_label()
		else
			M.get_label(choices[choice])
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
		to_chat(user, SPAN_NOTICE("The label refuses to stick to [A.name]."))
		return
	if(issilicon(A))
		to_chat(user, SPAN_NOTICE("The label refuses to stick to [A.name]."))
		return
	if(isobserver(A))
		to_chat(user, SPAN_NOTICE("[src] passes through [A.name]."))
		return
	if(istype(A, /obj/item/reagent_containers/glass))
		to_chat(user, SPAN_NOTICE("The label can't stick to the [A.name].  (Try using a pen)"))
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
	user.visible_message(SPAN_NOTICE("[user] labels [A] as [label]."), \
						 SPAN_NOTICE("You label [A] as [label]."))
	A.name = "[A.name] ([label])"

/obj/item/hand_labeler/attack_self(mob/user as mob)
	mode = !mode
	icon_state = "labeler[mode]"
	if(mode)
		to_chat(user, SPAN_NOTICE("You turn on \the [src]."))
		//Now let them chose the text.
		var/str = sanitizeName(input(user,"Label text?","Set label",""), MAX_NAME_LEN) //Only A-Z, 1-9 and `-`
		if(!str || !length(str))
			to_chat(user, SPAN_NOTICE("Invalid text."))
			return
		label = str
		to_chat(user, SPAN_NOTICE("You set the text to '[str]'."))
	else
		to_chat(user, SPAN_NOTICE("You turn off \the [src]."))
