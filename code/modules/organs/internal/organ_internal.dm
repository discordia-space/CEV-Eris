/obj/item/organ/internal

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

	var/datum/reagent/blood/transplant_blood = locate(/datum/reagent/blood) in reagents.reagent_list
	transplant_data = list()
	if(!transplant_blood)
		transplant_data["species"] =    owner.species.name
		transplant_data["blood_type"] = owner.dna.b_type
		transplant_data["blood_DNA"] =  owner.dna.unique_enzymes
	else
		transplant_data["species"] =    transplant_blood.data["species"]
		transplant_data["blood_type"] = transplant_blood.data["blood_type"]
		transplant_data["blood_DNA"] =  transplant_blood.data["blood_DNA"]

	..()
