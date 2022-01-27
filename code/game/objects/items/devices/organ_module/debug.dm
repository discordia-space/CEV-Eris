/obj/item/organ_module/debugger
	name = "debug organ69odule"
	desc = "Embedded organ69odule."
	allowed_organs = BP_ALL_LIMBS

/obj/item/organ_module/debugger/onInstall(var/obj/item/organ/external/E)
	to_chat(usr, "Module installed")

/obj/item/organ_module/debugger/onRemove(var/obj/item/organ/external/E)
	to_chat(usr, "Module removed")

/obj/item/organ_module/debugger/organ_removed(var/obj/item/organ/external/E,69ar/mob/living/carbon/human/H)
	to_chat(usr, "Organ with69odule installed")

/obj/item/organ_module/debugger/organ_installed(var/obj/item/organ/external/E,69ar/mob/living/carbon/human/H)
	to_chat(usr, "Organ with69odule removed")

