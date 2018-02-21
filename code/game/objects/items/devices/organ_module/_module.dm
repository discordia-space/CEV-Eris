/obj/item/organ_module
	name = "embedded organ module"
	desc = "Embedded organ module."
	icon = 'icons/obj/surgery.dmi'
	var/list/allowed_organs = list() // Surgery. list of organ_tags. BP_R_ARM, BP_L_ARM, BP_HEAD, etc.

/obj/item/organ_module/proc/install(var/obj/item/organ/external/E)
	E.module = src
	src.forceMove(E)
	onInstall(E)

/obj/item/organ_module/proc/onInstall(var/obj/item/organ/external/E)

/obj/item/organ_module/proc/remove(var/obj/item/organ/external/E)
	E.module = null
	src.forceMove(get_turf(E))
	onRemove(E)

/obj/item/organ_module/proc/onRemove(var/obj/item/organ/external/E)

/obj/item/organ_module/proc/organ_removed(var/obj/item/organ/external/E, var/mob/living/carbon/human/H)

/obj/item/organ_module/proc/organ_installed(var/obj/item/organ/external/E, var/mob/living/carbon/human/H)

