/obj/item/organ_module
	name = "embedded organ module"
	desc = "Embedded organ module."
	icon = 'icons/obj/surgery.dmi'
	var/list/allowed_organs = list() // Surgery. list of organ_tags. BP_R_ARM, BP_L_ARM, BP_HEAD, etc.

/obj/item/organ_module/proc/install(var/obj/item/organ/external/E)

/obj/item/organ_module/proc/remove(var/obj/item/organ/external/E)

/obj/item/organ_module/proc/organ_removed(var/obj/item/organ/external/E, var/mob/living/carbon/human/H)

/obj/item/organ_module/proc/organ_installed(var/obj/item/organ/external/E, var/mob/living/carbon/human/H)

