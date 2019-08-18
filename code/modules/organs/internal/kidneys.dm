/obj/item/organ/internal/kidneys
	name = "kidneys"
	icon_state = "kidneys"
	gender = PLURAL
	organ_tag = BP_KIDNEYS
	parent_organ = BP_GROIN
	price_tag = 600

/obj/item/organ/internal/kidneys/Process()
	..()

	if(!owner)
		return
	var/datum/reagents/metabolism/BLOOD_MET = owner.getMetabolismHandler(CHEM_BLOOD)
	//If your kidneys aren't working, your body's going to have a hard time cleaning your blood.
	if(!owner.chem_effects[CE_ANTITOX])
		if(is_bruised())
			if(prob(5) && BLOOD_MET.get_reagent_amount("potassium") < 5)
				BLOOD_MET.add_reagent("potassium", REM*5)
		if(is_broken())
			if(BLOOD_MET.get_reagent_amount("potassium") < 15)
				BLOOD_MET.add_reagent("potassium", REM*2)
		if(status & ORGAN_DEAD)
			owner.adjustToxLoss(1)

			
