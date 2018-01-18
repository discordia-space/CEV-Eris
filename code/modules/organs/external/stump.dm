/obj/item/organ/external/stump
	name = "limb stump"
	icon_name = ""
	dislocated = -1

/obj/item/organ/external/stump/New(var/mob/living/carbon/holder, var/OD, var/obj/item/organ/external/limb)
	if(istype(limb))
		organ_tag = limb.organ_tag
		body_part = limb.body_part
		amputation_point = limb.amputation_point
		joint = limb.joint
		parent_organ = limb.parent_organ
		wounds = limb.wounds
	..(holder, null)
	if(istype(limb))
		max_damage = limb.max_damage
		if((limb.robotic >= ORGAN_ROBOT) && (!parent || (parent.robotic >= ORGAN_ROBOT)))
			robotic = ORGAN_ROBOT

/obj/item/organ/external/stump/get_tally()
	return 4

/obj/item/organ/external/stump/get_cache_key()
	return "Stump"

/obj/item/organ/external/stump/is_stump()
	return TRUE

/obj/item/organ/external/stump/removed()
	..()
	qdel(src)

/obj/item/organ/external/stump/is_usable()
	return FALSE
