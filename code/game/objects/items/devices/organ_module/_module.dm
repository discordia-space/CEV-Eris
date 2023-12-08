/obj/item/organ_module
	name = "embedded organ module"
	desc = "A mechanical augment designed for implantation into a human's flesh or prosthetics."
	icon = 'icons/obj/surgery.dmi'
	matter = list(MATERIAL_STEEL = 12)
	var/list/allowed_organs = list() // Surgery. list of organ_tags. BP_R_ARM, BP_L_ARM, BP_HEAD, etc.
	var/mod_overlay //For cybernetic-specific applicator sprite calls.

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

/obj/item/organ_module/attackby(obj/item/I, mob/user)
	..()
	if(istype(I, /obj/item/implanter/installer/disposable))
		to_chat(user, SPAN_NOTICE("You cannot refill a single-use applicator."))
		return

	if(istype(I, /obj/item/implanter/installer))
		var/obj/item/implanter/installer/M = I
		if(!M.mod && user.unEquip(src, M))
			M.mod = src
			M.update_icon()
		return TRUE

	if(istype(I, /obj/item/implanter))
		to_chat(user, SPAN_NOTICE("You cannot insert cybernetics into an implant applicator."))
		return
