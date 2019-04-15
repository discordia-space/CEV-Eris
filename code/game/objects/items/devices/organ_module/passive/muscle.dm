/obj/item/organ_module/muscle
	name = "mechanical muscles"
	desc = "A set of mechanical muscles designed to be implanted into legs, increasing speed beyond what human muscles are capable of."
	allowed_organs = list(BP_R_LEG, BP_L_LEG)
	icon_state = "muscle"

/obj/item/organ_module/muscule/onInstall(obj/item/organ/external/E)
	E.tally -= 0.25

/obj/item/organ_module/muscule/onRemove(obj/item/organ/external/E)
	E.tally += 0.25