/obj/item/organ/internal
	var/dead_icon // Icon to use when the organ has died.

/obj/item/organ/internal/die()
	..()
	if((status & ORGAN_DEAD) && dead_icon)
		icon_state = dead_icon

/obj/item/organ/internal/install(mob/living/carbon/human/H)
	if(..()) return 1
	H.internal_organs |= src
	var/obj/item/organ/internal/outdated = H.internal_organs_by_name[organ_tag]
	if(outdated && (outdated != src))
		outdated.removed()
	H.internal_organs_by_name[organ_tag] = src
	if(parent)
		parent.internal_organs |= src

/obj/item/organ/internal/Destroy()
	if(owner)
		owner.internal_organs.Remove(src)
		owner.internal_organs_by_name[organ_tag] = null
	if(parent)
		parent.internal_organs -= src
	return ..()

/obj/item/organ/internal/removed(mob/living/user)
	if(!istype(owner)) return

	owner.internal_organs_by_name[organ_tag] = null
	owner.internal_organs -= src

	parent.internal_organs -= src


	..()
