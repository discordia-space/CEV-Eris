/obj/item/organ_module/muscle
	name = "mechanical muscles"
	desc = "A set of mechanical muscles designed to be implanted into legs, increasing the efficacy of your legs."
	allowed_organs = list(BP_R_LEG, BP_L_LEG)
	icon_state = "muscle"
	var/boosting = FALSE

/obj/item/organ_module/muscle/onInstall(obj/item/organ/external/E)
	if(E.owner)
		E.owner.tally -= 0.25
		boosting = TRUE

/obj/item/organ_module/muscle/onRemove(obj/item/organ/external/E)
	E.owner.tally += 0.25
	boosting = FALSE

/obj/item/organ_module/muscle/emp_act(severity)
	if(isorgan(loc))
		loc:owner:tally += 0.3
		// worst case scenario , 5  seconds of debuff
		boosting = FALSE
		addtimer(CALLBACK(src, PROC_REF(reboot), loc:owner, 5 SECONDS / severity ))


/obj/item/organ_module/muscle/proc/reboot(mob/living/carbon/human/the_debuffed)
	if(the_debuffed)
		the_debuffed.tally -= 0.3
		boosting = TRUE


