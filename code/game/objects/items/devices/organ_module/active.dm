//Toggleable embedded module
/obj/item/organ_module/active
	var/verb_name = "Activate"
	var/verb_desc = "activate embedded module"

/obj/item/organ_module/active/onInstall(var/obj/item/organ/external/E)
	new /obj/item/organ/external/proc/activate_module(E, verb_name, verb_desc)

/obj/item/organ_module/active/onRemove(var/obj/item/organ/external/E)
	E.verbs -= /obj/item/organ/external/proc/activate_module

/obj/item/organ_module/active/organ_removed(obj/item/organ/external/E, mob/living/carbon/human/H)
	onRemove(E)

/obj/item/organ_module/active/organ_installed(obj/item/organ/external/E, mob/living/carbon/human/H)
	onInstall(E)

/obj/item/organ_module/active/proc/can_activate(var/mob/living/carbon/human/H, var/obj/item/organ/external/E)
	if(H.incapacitated())
		H << SPAN_WARNING("You can't do that now!")
		return
/*
	for(var/obj/item/weapon/implant/prosthesis_inhibition/I in H)
		if(I.malfunction)
			continue
		H << SPAN_WARNING("[I] in your [I.part] prevent [src] activation!")
		return FALSE
*/
	return TRUE

/obj/item/organ_module/active/proc/activate(var/mob/living/carbon/human/H, var/obj/item/organ/external/E)
/obj/item/organ_module/active/proc/deactivate(var/mob/living/carbon/human/H, var/obj/item/organ/external/E)


