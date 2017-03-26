/obj/item/prosthesis
	name = "posthesis"
	desc = "A skeletal limb wrapped in pseudomuscles, with a low-conductivity case."
	icon = 'icons/obj/prosthesis.dmi'
	item_state = "buildpipe"
	icon_state = "blank"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	matter = list(DEFAULT_WALL_MATERIAL = 10000)
	var/construction_time = 100
	var/list/construction_cost = list(DEFAULT_WALL_MATERIAL=18000)
	var/list/part = null // Order of args is important for installing robolimbs.
	var/allow_slim_body = 1
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
	construction_cost = list(DEFAULT_WALL_MATERIAL=15000)
	part = list(
		BP_L_LEG = /obj/item/organ/external/robotic/limb,
		BP_L_FOOT= /obj/item/organ/external/robotic/tiny
	)

/obj/item/prosthesis/r_leg
	name = "Unbranded right leg"
	icon_state = "r_leg"
	construction_cost = list(DEFAULT_WALL_MATERIAL=15000)
	part = list(
		BP_R_LEG = /obj/item/organ/external/robotic/limb,
		BP_R_FOOT= /obj/item/organ/external/robotic/tiny
	)



//// Enforcer ////

/obj/item/prosthesis/enforcer
	desc = "Full limb combat prosthesis module."
	matter = list(DEFAULT_WALL_MATERIAL = 15000)
	construction_cost = list(DEFAULT_WALL_MATERIAL=25000)
	allow_slim_body = 0 // No sprites folks.

/obj/item/prosthesis/enforcer/l_arm
	name = "Enforcer Charge left arm"
	icon_state = "l_arm"
	part = list(BP_L_ARM = /obj/item/organ/external/robotic/enforcer/limb)

/obj/item/prosthesis/enforcer/r_arm
	name = "Enforcer Charge right arm"
	icon_state = "r_arm"
	part = list(BP_R_ARM = /obj/item/organ/external/robotic/enforcer/limb)

/obj/item/prosthesis/enforcer/l_leg
	name = "Enforcer Charge left leg"
	icon_state = "l_leg"
	part = list(BP_L_LEG = /obj/item/organ/external/robotic/enforcer/limb/leg)

/obj/item/prosthesis/enforcer/r_leg
	name = "Enforcer Charge right leg"
	icon_state = "r_leg"
	part = list(BP_R_LEG = /obj/item/organ/external/robotic/enforcer/limb/leg)


