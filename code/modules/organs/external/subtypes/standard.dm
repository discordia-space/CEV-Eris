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
			//owner.update_head_accessory()
			//owner.update_markings()
	..()

/*
//HEAD ACCESSORY OVERLAY
/mob/living/carbon/human/proc/update_head_accessory(var/update_icons=1)
	//Reset our head accessory
	remove_overlay(HEAD_ACCESSORY_LAYER)
	remove_overlay(HEAD_ACC_OVER_LAYER)

	var/obj/item/organ/external/head/head_organ = get_organ("head")
	if(!head_organ)
		return

	//masks and helmets can obscure our head accessory
	if((head && (head.flags & BLOCKHAIR)) || (wear_mask && (wear_mask.flags & BLOCKHAIR)))
		return

	//base icons
	var/icon/head_accessory_standing = new /icon('icons/mob/body_accessory.dmi',"accessory_none_s")
	if(head_organ.ha_style && (head_organ.dna.species.bodyflags & HAS_HEAD_ACCESSORY))
		var/datum/sprite_accessory/head_accessory/head_accessory_style = GLOB.head_accessory_styles_list[head_organ.ha_style]
		if(head_accessory_style && head_accessory_style.species_allowed)
			if(head_organ.dna.species.name in head_accessory_style.species_allowed)
				var/icon/head_accessory_s = new/icon("icon" = head_accessory_style.icon, "icon_state" = "[head_accessory_style.icon_state]_s")
				if(head_accessory_style.do_colouration)
					head_accessory_s.Blend(head_organ.headacc_colour, ICON_ADD)
				head_accessory_standing = head_accessory_s //head_accessory_standing.Blend(head_accessory_s, ICON_OVERLAY)
														   //Having it this way preserves animations. Useful for animated antennae.

				if(head_accessory_style.over_hair) //Select which layer to use based on the properties of the head accessory style.
					overlays_standing[HEAD_ACC_OVER_LAYER] = mutable_appearance(head_accessory_standing, layer = -HEAD_ACC_OVER_LAYER)
					apply_overlay(HEAD_ACC_OVER_LAYER)
				else
					overlays_standing[HEAD_ACCESSORY_LAYER] = mutable_appearance(head_accessory_standing, layer = -HEAD_ACCESSORY_LAYER)
					apply_overlay(HEAD_ACCESSORY_LAYER)
		else
*/			//warning("Invalid ha_style for [species.name]: [ha_style]")

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