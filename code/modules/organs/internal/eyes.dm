/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	organ_efficiency = list(OP_EYES = 100)
	parent_organ_base = BP_HEAD
	price_tag = 100
	blood_req = 2
	max_blood_storage = 10
	oxygen_req = 1
	nutriment_req = 1
	min_bruised_damage = IORGAN_STANDARD_BRUISE + 1
	min_broken_damage = IORGAN_STANDARD_BREAK + 1
	var/eyes_color = "#000000"
	var/robo_color = "#000000"
	var/cache_key = BP_EYES
	var/list/colourmatrix = null
	var/list/colourblind_matrix = MATRIX_GREYSCALE //Special colourblindness parameters. By default, it's black-and-white.

/obj/item/organ/internal/eyes/proc/get_icon()
	var/icon/eyes_icon = new/icon('icons/mob/human_face.dmi', "eye_l")
	eyes_icon.Blend(icon('icons/mob/human_face.dmi', "eye_r"), ICON_OVERLAY)
	eyes_icon.Blend(BP_IS_ROBOTIC(src) ? robo_color : eyes_color, ICON_ADD)
	return eyes_icon

/obj/item/organ/internal/eyes/proc/get_cache_key()
	return "[cache_key][BP_IS_ROBOTIC(src) ? robo_color : eyes_color]"

/obj/item/organ/internal/eyes/replaced_mob(mob/living/carbon/human/target)
	..()
	// Apply our eye colour to the target.
	if(eyes_color)
		owner.eyes_color = eyes_color
		owner.update_eyes()
	owner.update_client_colour()

/obj/item/organ/internal/eyes/proc/update_colour()
	if(!owner)
		return
	eyes_color = owner.eyes_color

/obj/item/organ/internal/eyes/take_damage(amount, damage_type = BRUTE, wounding_multiplier = 1, silent = FALSE, sharp = FALSE, edge = FALSE)
	var/oldbroken = is_broken()
	..()
	if(is_broken() && !oldbroken && owner && !owner.stat)
		to_chat(owner, SPAN_DANGER("You go blind!"))

/obj/item/organ/internal/eyes/proc/get_colourmatrix() //Returns a special colour matrix if the mob is colourblind, otherwise it uses the current one.
	if(owner.stats.getPerk(PERK_OBORIN_SYNDROME) && !owner.is_dead())
		return colourblind_matrix
	else
		return colourmatrix

/obj/item/organ/internal/eyes/get_possible_wounds(damage_type, sharp, edge)
	var/list/possible_wounds = list()

	// Determine possible wounds based on nature and damage type
	var/is_robotic = BP_IS_ROBOTIC(src)
	var/is_organic = BP_IS_ORGANIC(src) || BP_IS_ASSISTED(src)

	switch(damage_type)
		if(BRUTE)
			if(!edge)
				if(sharp)
					if(is_organic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/eyes_sharp))
					if(is_robotic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/eyes_sharp))
				else
					if(is_organic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/eyes_blunt))
					if(is_robotic)
						LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/eyes_blunt))
			else
				if(is_organic)
					LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/eyes_edge))
				if(is_robotic)
					LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/eyes_edge))
		if(BURN)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/eyes_burn))
			if(is_robotic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/eyes_emp_burn))
		if(TOX)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/eyes_poisoning))
			//if(is_robotic)
			//	LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/eyes_build_up))
		if(CLONE)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/radiation))
		if(PSY)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/organic/sanity))
			if(is_robotic)
				LAZYADD(possible_wounds, subtypesof(/datum/component/internal_wound/robotic/sanity))

	return possible_wounds

//Subtypes
/obj/item/organ/internal/eyes/oneeye
	icon_state = "eye_l"
	cache_key = "left_eye"

/obj/item/organ/internal/eyes/oneeye/get_icon()
	var/icon/eyes_icon
	eyes_icon = icon('icons/mob/human_face.dmi', "[icon_state]")
	eyes_icon.Blend(BP_IS_ROBOTIC(src) ? robo_color : eyes_color, ICON_ADD)
	return eyes_icon

/obj/item/organ/internal/eyes/oneeye/right
	icon_state = "eye_r"
	cache_key = "right_eye"

/obj/item/organ/internal/eyes/heterohromia
	var/second_color = "#000000"
	cache_key = "heterohromia"

/obj/item/organ/internal/eyes/heterohromia/get_cache_key()
	return "[cache_key][BP_IS_ROBOTIC(src) ? robo_color : eyes_color]&[second_color]"

/obj/item/organ/internal/eyes/heterohromia/get_icon()
	var/icon/eyes_icon = icon('icons/mob/human_face.dmi', "eye_l")
	eyes_icon.Blend(BP_IS_ROBOTIC(src) ? robo_color : eyes_color, ICON_ADD)

	var/icon/right_eye = icon('icons/mob/human_face.dmi', "eye_r")
	right_eye.Blend(second_color, ICON_ADD)
	eyes_icon.Blend(right_eye)

	return eyes_icon
