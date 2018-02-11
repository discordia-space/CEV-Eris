/obj/item/organ_module/debugger
	name = "debug organ module"
	desc = "Embedded organ module."
	allowed_organs = BP_ALL

/obj/item/organ_module/debugger/onInstall(var/obj/item/organ/external/E)
	usr << "Module installed"

/obj/item/organ_module/debugger/onRemove(var/obj/item/organ/external/E)
	usr << "Module removed"

/obj/item/organ_module/debugger/organ_removed(var/obj/item/organ/external/E, var/mob/living/carbon/human/H)
	usr << "Organ with module installed"

/obj/item/organ_module/debugger/organ_installed(var/obj/item/organ/external/E, var/mob/living/carbon/human/H)
	usr << "Organ with module removed"

