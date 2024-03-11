/obj/item/implanter/installer/disposable/muscle
	name = "disposable cybernetic installer (muscle)"
	desc = "A set of mechanical muscles designed to be implanted into legs, increasing the efficacy of your legs."
	mod = /obj/item/organ_module/muscle
	spawn_tags = null

/obj/item/organ_module/muscle
	name = "mechanical muscles"
	desc = "A set of mechanical muscles designed to be implanted into legs, increasing the efficacy of your legs."
	allowed_organs = list(BP_R_LEG, BP_L_LEG)
	icon_state = "muscle"
	mod_overlay = "installer_muscle"

/obj/item/organ_module/muscule/onInstall(obj/item/organ/external/E)
	E.tally -= 0.25

/obj/item/organ_module/muscule/onRemove(obj/item/organ/external/E)
	E.tally += 0.25