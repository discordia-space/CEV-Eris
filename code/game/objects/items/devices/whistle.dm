/obj/item/device/hailer
	name = "hailer"
	desc = "Used by obese officers to save their breath for running."
	icon_state = "voice0"
	item_state = "flashbang"	//looks exactly like a flash (and nothing like a flashbang)
	w_class = ITEM_SIZE_TINY
	matter = list(MATERIAL_PLASTIC = 2,69ATERIAL_GLASS = 1,69ATERIAL_STEEL = 2)
	flags = CONDUCT

	var/use_message = "Halt! Security!"
	var/spamcheck = 0
	var/insults

/obj/item/device/hailer/verb/set_message()
	set name = "Set Hailer69essage"
	set category = "Object"
	set desc = "Alter the69essage shouted by your hailer."

	if(!isnull(insults))
		to_chat(usr, "The hailer is fried. The tiny input screen just shows a waving ASCII penis.")
		return

	var/new_message = input(usr, "Please enter new69essage (leave blank to reset).") as text
	if(!new_message || new_message == "")
		use_message = "Halt! Security!"
	else
		use_message = capitalize(copytext(sanitize(new_message), 1,69AX_MESSAGE_LEN))

	to_chat(usr, "You configure the hailer to shout \"69use_message69\".")

/obj/item/device/hailer/attack_self(mob/living/carbon/user as69ob)
	if (spamcheck)
		return

	if(isnull(insults))
		playsound(get_turf(src), 'sound/voice/halt.ogg', 100, 1,69ary = 0)
		user.audible_message("<span class='warning'>69user69's 69name69 rasps, \"69use_message69\"</span>", SPAN_WARNING("\The 69user69 holds up \the 69name69."))
	else
		if(insults > 0)
			playsound(get_turf(src), 'sound/voice/binsult.ogg', 100, 1,69ary = 0)
			// Yes, it used to show the transcription of the sound clip. That was a) inaccurate b) immature as shit.
			user.audible_message(SPAN_WARNING("69user69's 69name69 gurgles something indecipherable and deeply offensive."), SPAN_WARNING("\The 69user69 holds up \the 69name69."))
			insults--
		else
			to_chat(user, SPAN_DANGER("*BZZZZZZZZT*"))

	spamcheck = 1
	spawn(20)
		spamcheck = 0

/obj/item/device/hailer/emag_act(var/remaining_charges,69ar/mob/user)
	if(isnull(insults))
		to_chat(user, SPAN_DANGER("You overload \the 69src69's69oice synthesizer."))
		insults = rand(1, 3)//to prevent dickflooding
		return 1
	else
		to_chat(user, "The hailer is fried. You can't even fit the se69uencer into the input slot.")
