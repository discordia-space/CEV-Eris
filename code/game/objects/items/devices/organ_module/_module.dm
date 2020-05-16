/obj/item/organ_module
	name = "embedded organ module"
	desc = "A mechanical augment designed for implantation into a human's flesh or prosthetics."
	icon = 'icons/obj/surgery.dmi'
	matter = list(MATERIAL_STEEL = 12)
	var/list/allowed_organs = list() // Surgery. list of organ_tags. BP_R_ARM, BP_L_ARM, BP_HEAD, etc.

/obj/item/organ_module/proc/install(obj/item/organ/external/E)
	E.module = src
	E.implants += src
	src.forceMove(E)
	onInstall(E)

/obj/item/organ_module/proc/onInstall(obj/item/organ/external/E)

/obj/item/organ_module/proc/remove(obj/item/organ/external/E)
	E.module = null
	E.implants -= src
	src.forceMove(E.drop_location())
	onRemove(E)

/obj/item/organ_module/proc/onRemove(obj/item/organ/external/E)

/obj/item/organ_module/proc/organ_removed(obj/item/organ/external/E, mob/living/carbon/human/H)

/obj/item/organ_module/proc/organ_installed(obj/item/organ/external/E, mob/living/carbon/human/H)
