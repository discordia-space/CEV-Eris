/obj/item/organ_module/muscle
	name = "mechanical muscles"
	desc = "A set of mechanical muscles designed to be implanted into legs, increasing the efficacy of your legs."
	allowed_organs = list(BP_R_LEG, BP_L_LEG)
	icon_state = "muscle"
	var/boosting = FALSE

/obj/item/organ_module/muscle/onInstall(obj/item/organ/external/E)
	E.tally -= 0.25
	boosting = TRUE

/obj/item/organ_module/muscle/onRemove(obj/item/organ/external/E)
	E.tally += 0.25
	boosting = FALSE

/obj/item/organ_module/muscle/emp_act(severity)
	if(boosting)
		E.tally += 0.3
		// worst case scenario , 5  seconds of debuff
		boosting = FALSE
		addtimer(CALLBACK(src, PROC_REF(reboot), 5 SECONDS / severity ))


/obj/item/organ_module/muscle/proc/reboot()
	E.tally -= 0.3
	boosting = TRUE


