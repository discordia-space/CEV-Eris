/obj/item/prosthesis
	name = "posthesis"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon = 'icons/obj/prosthesis.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	matter = list(MATERIAL_STEEL = 10)
	var/construction_time = 100
	var/list/construction_cost = list(MATERIAL_STEEL=15)
	var/list/part = null // Order of args is important for installing robolimbs.
	dir = SOUTH


//// Unbranded ////

/obj/item/prosthesis/l_arm
	name = "Unbranded left arm"
	icon_state = BP_L_ARM
	part = list(
		BP_L_ARM = /obj/item/organ/external/robotic/limb,
		BP_L_HAND= /obj/item/organ/external/robotic/tiny
	)

/obj/item/prosthesis/r_arm
	name = "Unbranded right arm"
	icon_state = "r_arm"
	part = list(
		BP_R_ARM = /obj/item/organ/external/robotic/limb,
		BP_R_HAND= /obj/item/organ/external/robotic/tiny
	)

/obj/item/prosthesis/l_leg
	name = "Unbranded left leg"
	icon_state = "l_leg"
	construction_cost = list(MATERIAL_STEEL=15)
	part = list(
		BP_L_LEG = /obj/item/organ/external/robotic/limb,
		BP_L_FOOT= /obj/item/organ/external/robotic/tiny
	)

/obj/item/prosthesis/r_leg
	name = "Unbranded right leg"
	icon_state = "r_leg"
	construction_cost = list(MATERIAL_STEEL=15)
	part = list(
		BP_R_LEG = /obj/item/organ/external/robotic/limb,
		BP_R_FOOT= /obj/item/organ/external/robotic/tiny
	)

