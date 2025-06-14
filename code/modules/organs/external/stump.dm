/obj/item/organ/external/stump
	name = "limb stump"
	nerve_struck = -1

/obj/item/organ/external/stump/New(var/mob/living/carbon/holder, var/OD, var/obj/item/organ/external/limb)
	if(istype(limb))
		organ_tag = limb.organ_tag
		body_part = limb.body_part
		amputation_point = limb.amputation_point
		joint = limb.joint
		parent_organ_base = limb.parent_organ_base
		wounds = limb.wounds.Copy()
	..(holder, null)
	if(istype(limb))
		max_damage = limb.max_damage
		if(BP_IS_ROBOTIC(limb) && (!parent || BP_IS_ROBOTIC(parent)))
			nature = MODIFICATION_SILICON


/obj/item/organ/external/stump/get_tally()
	return 4

/obj/item/organ/external/stump/get_cache_key()
	return "Stump"

/obj/item/organ/external/stump/is_stump()
	return TRUE

/obj/item/organ/external/stump/update_icon()
	return

/obj/item/organ/external/stump/removed()
	..()
	if(owner)
		qdel(src)
	owner = null //To stop infinate deletion loop.

/obj/item/organ/external/stump/is_usable()
	return FALSE
