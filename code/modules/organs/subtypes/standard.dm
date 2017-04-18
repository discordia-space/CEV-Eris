/****************************************************
			   ORGAN DEFINES
****************************************************/

/obj/item/organ/external/organic

/obj/item/organ/external/organic/set_description(var/datum/organ_description/desc)
	..()
	switch(organ_tag)
		if(BP_CHEST)
			encased = "ribcage"
			dislocated = -1
			gendered = 1
		if(BP_HEAD)
			encased = "skull"
			dislocated = -1
			gendered = 1
		if(BP_GROIN)
			dislocated = -1
			gendered = 1

/obj/item/organ/external/head
	vital = 1
	gendered = 1
	encased = "skull"
	var/hairstyle
	var/real_name
	var/can_intake_reagents = 1

/obj/item/organ/external/head/removed(user, delete_children)
	if(owner)
		var/mob/living/carbon/human/last_owner = owner
		name = "[owner.name]'s head"
		hairstyle = owner.h_style
		real_name = owner.real_name
		spawn(1)
			if(last_owner)
				last_owner.update_hair()
	return ..()

/obj/item/organ/external/head/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list())
	..(brute, burn, sharp, edge, used_weapon, forbidden_limbs)
	if (!disfigured)
		if (brute_dam > 40)
			if (prob(50))
				disfigure("brute")
		if (burn_dam > 40)
			disfigure("burn")

/obj/item/organ/external/head/install(mob/living/carbon/human/H, redraw_mob = 1)
	if(..(H, 0)) return 1

	name = "head"
	if(hairstyle)
		owner.h_style = hairstyle
	if(real_name)
		owner.real_name = real_name
	owner.update_hair(redraw_mob)
