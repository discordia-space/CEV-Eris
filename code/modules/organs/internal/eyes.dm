/obj/item/organ/internal/eyes
	name = "eyeballs"
	icon_state = "eyes"
	gender = PLURAL
	organ_tag = O_EYES
	parent_organ = BP_HEAD
	var/eye_color = ""
	var/robo_color = "#000000"
	var/icon/mob_icon = null
	var/body_build = null
	var/cache_key = "eyes"

/obj/item/organ/internal/eyes/proc/get_cache_key()
	return "[cache_key][robotic ? robo_color : eye_color]"

/obj/item/organ/internal/eyes/install(mob/living/carbon/human/H, redraw_mob = 1)
	if(..()) return 1
	// Apply our eye color to the target.
	if(eye_color)
		owner.eyes_color = eye_color
	sync_to_owner()
	if(redraw_mob)
		owner.update_body()

/obj/item/organ/internal/eyes/sync_to_owner()
	if(!owner)
		return
	species = owner.species
	body_build = owner.body_build.index
	eye_color = owner.eyes_color ? owner.eyes_color : "#000000"

/obj/item/organ/internal/eyes/get_icon()
	mob_icon = new/icon(species.icobase, "eyes[body_build]")
	if(robotic >= ORGAN_ROBOT)
		mob_icon.Blend(robo_color, ICON_ADD)
	else
		mob_icon.Blend(eye_color, ICON_ADD)
	return mob_icon

/obj/item/organ/internal/eyes/get_icon_key()
	return "eyes[eye_color]"

/obj/item/organ/internal/eyes/take_damage(amount, var/silent=0)
	var/oldbroken = is_broken()
	..()

	if(damage > 10)
		if(!silent)
			owner << "<span class='warning'>Your eyes are really starting to hurt. This can't be good for you!</span>"
	if(damage >= min_bruised_damage)
		if(!owner.disabilities & NEARSIGHTED)
			if(!silent)
				owner << "<span class='danger'>It's become harder to see!</span>"
			owner.disabilities |= NEARSIGHTED
			spawn(100)
				owner.disabilities &= ~NEARSIGHTED

	if(is_broken() && !oldbroken && owner && !owner.stat)
		owner << "<span class='danger'> You go blind!</span>"

/obj/item/organ/internal/eyes/process() //Eye damage replaces the old eye_stat var.
	..()
	if(!owner)
		return
	if(is_bruised())
		owner.eye_blurry = 20
	if(is_broken())
		owner.eye_blind = 20

/obj/item/organ/internal/eyes/proc/update_colour()
	if(!owner)
		return
	eye_color = owner.eyes_color

//// One eye ////

/obj/item/organ/internal/eyes/oneeye
	get_icon()
		mob_icon = icon(species.icobase, "left_eye[body_build]")
		mob_icon.Blend(eye_color, ICON_ADD)
		return mob_icon

/obj/item/organ/internal/eyes/oneeye/get_icon_key()
	return "eyes_left[eye_color]"

/obj/item/organ/internal/eyes/oneeye/right
	get_icon()
		mob_icon = icon(species.icobase, "right_eye[body_build]")
		mob_icon.Blend(eye_color, ICON_ADD)
		return mob_icon

/obj/item/organ/internal/eyes/oneeye/right/get_icon_key()
	return "eyes_right[eye_color]"

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
	return "eyes_hetero[eye_color]&[second_color]"
