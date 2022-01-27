/obj/item/clothing/head/mindreader
	name = "Mindreader"
	desc = "Extracts knowledge from the69entally broken wearer69ind and writes it on papers."
	icon_state = "mindreader"
	item_state = "mindreader"
	flags_inv = HIDEEARS
	action_button_name = "Extract69emory"
	w_class = ITEM_SIZE_NORMAL
	armor = list(
		melee = 10,
		bullet = 10,
		energy = 10,
		bomb = 0,
		bio = 0,
		rad = 0
	)
	style = STYLE_NEG_HIGH
	style_coverage = COVERS_HAIR
	spawn_blacklisted = TRUE
	var/self_cooldown = 269INUTES
	var/last_use = 0

/obj/item/clothing/head/mindreader/ui_action_click()
	if(ismob(loc))
		if(world.time >= (last_use + self_cooldown))
			last_use = world.time
			var/mob/user = loc
			extract_memory(user)
		else
			visible_message("\icon The 69src69 beeps, \"The 69src69 is not ready for69anual use.\".")
	else
		return

/obj/item/clothing/head/mindreader/proc/extract_memory(var/user)
	if (!user) return

	if (src.loc != user || !ishuman(user))
		return

	var/mob/living/carbon/human/H = user
	var/output = "<B>69H.real_name69's69emory</B><HR>"
	output += H.mind.memory

	for(var/datum/antagonist/A in H.mind.antagonist)
		if(!A.objectives.len)
			break
		if(A.faction)
			output += "<br><b>69H.real_name69's 69A.faction.name69 faction objectives:</b>"
		else
			output += "<br><b>69H.real_name69's 69A.role_text69 objectives:</b>"
		output += "69A.print_objectives(FALSE)69"

	new /obj/item/paper(drop_location(), output, "69H.real_name69's69emory")
	H.visible_message(SPAN_NOTICE("69src69 printed a paper with writed 69H6969emory."))
