/obj/item/organ_module/muscule
	name = "mechanical muscules"
	allowed_organs = list(BP_R_LEG, BP_L_LEG)
	icon_state = "muscule"

/obj/item/organ_module/muscule/onInstall(obj/item/organ/external/E)
	E.tally -= 0.25

/obj/item/organ_module/muscule/onRemove(obj/item/organ/external/E)
	E.tally += 0.25