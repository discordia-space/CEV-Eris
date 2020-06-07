/****************************************************
			   ORGAN DEFINES
****************************************************/

/obj/item/organ/external/chest
	default_description = /datum/organ_description/chest

/obj/item/organ/external/groin
	default_description = /datum/organ_description/groin

/obj/item/organ/external/head
	default_description = /datum/organ_description/head

/obj/item/organ/external/head/removed_mob()
	name = "[owner.real_name]'s head"
	spawn(1)
		if(owner) // In case owner was destroyed already - gibbed, for example
			owner.update_hair()
	..()
	//hispania//
	//Head markings, duplicated (sadly) below.
	for(var/M in markings)
		var/datum/sprite_accessory/marking/mark_style = markings[M]["datum"]
		if (mark_style.draw_target == MARKING_TARGET_SKIN)
			var/icon/mark_s = new/icon("icon" = mark_style.icon, "icon_state" = "[mark_style.icon_state]-[organ_tag]")
			mark_s.Blend(markings[M]["color"], mark_style.blend)
			overlays |= mark_s //So when it's not on your body, it has icons
			mob_icon.Blend(mark_s, mark_style.layer_blend) //So when it's on your body, it has icons
	//fin hispania//

/obj/item/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list(), silent)
	. = ..()
	if(. && !disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/item/organ/external/head/get_conditions()
	var/list/conditions_list = ..()
	if(disfigured)
		var/list/condition = list(
			"name" = "Disfigured face",
			"fix_name" = "Restore",
			"step" = /datum/surgery_step/fix_face
		)
		conditions_list.Add(list(condition))

	return conditions_list