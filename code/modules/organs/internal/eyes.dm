/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	organ_tag = "eyes"
	parent_organ = "head"
	var/eyes_color = "#000000"
	var/robo_color = "#000000"
	var/icon/mob_icon = null
	var/body_build = null

/obj/item/organ/internal/eyes/install(mob/living/carbon/human/H, redraw_mob = 1)
	if(..()) return 1
	// Apply our eye color to the target.
	if(eyes_color)
		owner.eyes_color = eyes_color
	sync_to_owner()
	if(redraw_mob)
		owner.update_body()

/obj/item/organ/internal/eyes/sync_to_owner()
	if(!owner)
		return
	species = owner.species
	body_build = owner.body_build.index
	eyes_color = owner.eyes_color ? owner.eyes_color : "#000000"

/obj/item/organ/internal/eyes/get_icon()
	mob_icon = new/icon(species.icobase, "eye_right[body_build]")
	mob_icon.Blend(icon(species.icobase, "eye_left[body_build]"))
	if(robotic >= ORGAN_ROBOT)
		mob_icon.Blend(robo_color, ICON_ADD)
	else
		mob_icon.Blend(eyes_color, ICON_ADD)
	return mob_icon

/obj/item/organ/internal/eyes/get_icon_key()
	return (robotic >= ORGAN_ROBOT) ? robo_color : eyes_color

/obj/item/organ/internal/eyes/take_damage(amount, var/silent=0)
	var/oldbroken = is_broken()
	..()
	if(is_broken() && !oldbroken && owner && !owner.stat)
		owner << "<span class='danger'>You go blind!</span>"

/obj/item/organ/internal/eyes/process() //Eye damage replaces the old eye_stat var.
	..()
	if(!owner)
		return
	if(is_bruised())
		owner.eye_blurry = 20
	if(is_broken())
		owner.eye_blind = 20


//// One eye ////

/obj/item/organ/internal/eyes/oneeye
	icon_state = "left_eye"

/obj/item/organ/internal/eyes/oneeye/right
	icon_state = "right_eye"

/obj/item/organ/internal/eyes/oneeye/get_icon()
	mob_icon = icon(species.icobase, "[icon_state][body_build]")
	mob_icon.Blend(eyes_color, ICON_ADD)
	return mob_icon

/obj/item/organ/internal/eyes/oneeye/get_icon_key()
	return "[icon_state][eyes_color]"

//// Heterohromia ////

/obj/item/organ/internal/eyes/heterohromia
	var/second_color = "#000000"
	get_icon()
		..()
		var/icon/one_eye = icon(species.icobase, "left_eye[body_build]")
		one_eye.Blend(second_color, ICON_ADD)
		mob_icon.Blend(one_eye, ICON_OVERLAY)
		return mob_icon

/obj/item/organ/internal/eyes/heterohromia/get_icon_key()
	return "hetero[eyes_color]&[second_color]"

