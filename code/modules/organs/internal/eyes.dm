/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	organ_tag = BP_EYES
	parent_organ = BP_HEAD
	price_tag = 100
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

/obj/item/organ/internal/eyes/take_damage(amount, silent=0)
	var/oldbroken = is_broken()
	..()
	if(is_broken() && !oldbroken && owner && !owner.stat)
		to_chat(owner, SPAN_DANGER("You go blind!"))

/obj/item/organ/internal/eyes/Process() //Eye damage replaces the old eye_stat var.
	..()
	if(!owner)
		return
	if(is_bruised())
		owner.eye_blurry = 1
	if(is_broken())
		owner.eye_blind = 1
	owner.update_client_colour()

/obj/item/organ/internal/eyes/proc/get_colourmatrix() //Returns a special colour matrix if the eyes are organic and the mob is colourblind, otherwise it uses the current one.
	if(!(BP_IS_ROBOTIC(src)) && owner.stats.getPerk(PERK_OBORIN_SYNDROME) && !owner.is_dead())
		return colourblind_matrix
	else
		return colourmatrix

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
