var/image/contamination_overlay = image('icons/effects/contamination.dmi')

/pl_control
	var/PLASMA_DMG = 3
	var/PLASMA_DMG_NAME = "Plasma Damage Amount"
	var/PLASMA_DMG_DESC = "Self Descriptive"

	var/PLASMAGUARD_ONLY = 0
	var/PLASMAGUARD_ONLY_NAME = "\"PlasmaGuard Only\""
	var/PLASMAGUARD_ONLY_DESC = "If this is on, only biosuits and spacesuits protect against ill effects."

	var/GENETIC_CORRUPTION = 0
	var/GENETIC_CORRUPTION_NAME = "Genetic Corruption Chance"
	var/GENETIC_CORRUPTION_DESC = "Chance of genetic corruption as well as toxic damage, X in 10,000."

	var/SKIN_BURNS = 0
	var/SKIN_BURNS_DESC = "Plasma has an effect similar to mustard gas on the un-suited."
	var/SKIN_BURNS_NAME = "Skin Burns"

	var/EYE_BURNS = 1
	var/EYE_BURNS_NAME = "Eye Burns"
	var/EYE_BURNS_DESC = "Plasma burns the eyes of anyone not wearing eye protection."

	var/PLASMA_HALLUCINATION = 0
	var/PLASMA_HALLUCINATION_NAME = "Plasma Hallucination"
	var/PLASMA_HALLUCINATION_DESC = "Does being in plasma cause you to hallucinate?"

	var/N2O_HALLUCINATION = 1
	var/N2O_HALLUCINATION_NAME = "N2O Hallucination"
	var/N2O_HALLUCINATION_DESC = "Does being in sleeping gas cause you to hallucinate?"


/mob/proc/pl_effects()

/mob/living/carbon/human/pl_effects()
	//Handles all the bad things plasma can do.
	if(stat >= DEAD)
		return

	//Burn skin if exposed.
	if(vsc.plc.SKIN_BURNS)
		if(!pl_head_protected() || !pl_suit_protected())
			burn_skin(0.75)
			if(prob(20)) to_chat(src, SPAN_DANGER("Your skin burns!"))
			updatehealth()

	//Burn eyes if exposed.
	if(vsc.plc.EYE_BURNS)
		if(!head)
			if(!wear_mask)
				burn_eyes()
			else
				if(!(wear_mask.body_parts_covered & EYES))
					burn_eyes()
		else
			if(!(head.body_parts_covered & EYES))
				if(!wear_mask)
					burn_eyes()
				else
					if(!(wear_mask.body_parts_covered & EYES))
						burn_eyes()

/mob/living/carbon/human/proc/burn_eyes()
	//The proc that handles eye burning.
	if(!species.has_process[OP_EYES])
		return

	var/obj/item/organ/internal/eyes/E = random_organ_by_process(OP_EYES)
	if(E)
		if(prob(20)) to_chat(src, SPAN_DANGER("Your eyes burn!"))
		E.damage += 2.5
		eye_blurry = min(eye_blurry+1.5,50)
		if(prob(max(0,E.damage - 15) + 1) &&!eye_blind)
			to_chat(src, SPAN_DANGER("You are blinded!"))
			eye_blind += 20

/mob/living/carbon/human/proc/pl_head_protected()
	//Checks if the head is adequately sealed.
	if(head && (head.body_parts_covered & EYES))
		return 1
	return 0

/mob/living/carbon/human/proc/pl_suit_protected()
	//Checks if the suit is adequately sealed.
	var/coverage = 0
	for(var/obj/item/protection in list(wear_suit, gloves, shoes))
		if(!protection)
			continue
		coverage |= protection.body_parts_covered

	if(vsc.plc.PLASMAGUARD_ONLY)
		return 1

	return BIT_TEST_ALL(coverage, UPPER_TORSO|LOWER_TORSO|LEGS|ARMS)
