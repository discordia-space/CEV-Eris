//// Runner ////

/obj/item/prosthesis/runner
	desc = "Full limb runner prosthesis module."
	matter = list(DEFAULT_WALL_MATERIAL = 9000)
	construction_cost = list(DEFAULT_WALL_MATERIAL=15000)

/obj/item/prosthesis/runner/l_leg
	name = "R.U.N.N.E.R. left leg"
	icon_state = "l_leg"
	part = list(BP_L_LEG = /obj/item/organ/external/robotic/limb/runner)

/obj/item/prosthesis/runner/r_leg
	name = "R.U.N.N.E.R. right leg"
	icon_state = "r_leg"
	part = list(BP_R_LEG = /obj/item/organ/external/robotic/limb/runner)


/obj/item/organ/external/robotic/limb/runner
	icon = 'icons/mob/human_races/cyberlimbs/runner.dmi'
	max_damage = 45
	min_broken_damage = 30
	w_class = 3
	tally = -0.25
	forced_children = list(
		BP_L_LEG = list(BP_L_FOOT = /obj/item/organ/external/robotic/limb/runner/tiny),
		BP_R_LEG = list(BP_R_FOOT = /obj/item/organ/external/robotic/limb/runner/tiny)
		)

/obj/item/organ/external/robotic/limb/runner/tiny
	tally = 0
	min_broken_damage = 15
	w_class = 2
