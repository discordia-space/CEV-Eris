/obj/item/gun_safety_module
	name = "gun's safety module"
	desc = "A classic way to make gun not able to shoot."
	var/safety_state = TRUE // TRUE means what gun currently restructed to shoot due safety is on.
	var/decline_message  = "bebop, something goes wrong."

/obj/item/gun_safety_module/proc/verification(user)
	return TRUE

/obj/item/gun_safety_module/regular
	name = "regular gun safety module"

/obj/item/gun_safety_module/access
	name = "access gun safety module"
	desc = "For weapons that should not fall into the wrong hands. Uses access from id card."
	var/required_access

/obj/item/gun_safety_module/access/verification(user)
	if(!required_access)
		return TRUE // No access, no problems
	else
		if(ishuman(user))
			var/mob/living/carbon/human/H = user
			for(
			if(src.check_access(bot.botcard))

	return FALSE
