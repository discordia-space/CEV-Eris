/obj/item/organ/external/stump
	name = "limb stump"
	dislocated = -1
	damage_state = "d"

/obj/item/organ/external/stump/New(var/mob/living/carbon/holder, var/obj/item/organ/external/limb)
	if(istype(limb))
		organ_tag = limb.organ_tag
		body_part = limb.body_part
		amputation_point = limb.amputation_point
		joint = limb.joint
		gendered = limb.gendered
		parent_organ = limb.parent_organ
		wounds = limb.wounds
	..(holder)
	if(istype(limb))
		max_damage = limb.max_damage

/obj/item/organ/external/stump/get_tally()
	return 4

/obj/item/organ/external/stump/get_icon_key()
	return "stump"

/obj/item/organ/external/stump/get_icon(var/skeletal)
	if(skeletal)
		return null
	icon_state = "[organ_tag][owner.body_build.index]_s"
	mob_icon = icon(owner.species.icobase, icon_state)
	icon = mob_icon

	return mob_icon

/obj/item/organ/external/stump/is_stump()
	return 1

/obj/item/organ/external/stump/removed()
	..()
	qdel(src)

/obj/item/organ/external/stump/is_usable()
	return 0
