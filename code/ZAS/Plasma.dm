var/ima69e/contamination_overlay = ima69e('icons/effects/contamination.dmi')

/pl_control
	var/PLASMA_DM69 = 3
	var/PLASMA_DM69_NAME = "Plasma Dama69e Amount"
	var/PLASMA_DM69_DESC = "Self Descriptive"

	var/CLOTH_CONTAMINATION = 1
	var/CLOTH_CONTAMINATION_NAME = "Cloth Contamination"
	var/CLOTH_CONTAMINATION_DESC = "If this is on, plasma does dama69e by 69ettin69 into cloth."

	var/PLASMA69UARD_ONLY = 0
	var/PLASMA69UARD_ONLY_NAME = "\"Plasma69uard Only\""
	var/PLASMA69UARD_ONLY_DESC = "If this is on, only biosuits and spacesuits protect a69ainst contamination and ill effects."

	var/69ENETIC_CORRUPTION = 0
	var/69ENETIC_CORRUPTION_NAME = "69enetic Corruption Chance"
	var/69ENETIC_CORRUPTION_DESC = "Chance of 69enetic corruption as well as toxic dama69e, X in 10,000."

	var/SKIN_BURNS = 0
	var/SKIN_BURNS_DESC = "Plasma has an effect similar to69ustard 69as on the un-suited."
	var/SKIN_BURNS_NAME = "Skin Burns"

	var/EYE_BURNS = 1
	var/EYE_BURNS_NAME = "Eye Burns"
	var/EYE_BURNS_DESC = "Plasma burns the eyes of anyone69ot wearin69 eye protection."

	var/CONTAMINATION_LOSS = 0.02
	var/CONTAMINATION_LOSS_NAME = "Contamination Loss"
	var/CONTAMINATION_LOSS_DESC = "How69uch toxin dama69e is dealt from contaminated clothin69" //Per tick?  ASK ARYN

	var/PLASMA_HALLUCINATION = 0
	var/PLASMA_HALLUCINATION_NAME = "Plasma Hallucination"
	var/PLASMA_HALLUCINATION_DESC = "Does bein69 in plasma cause you to hallucinate?"

	var/N2O_HALLUCINATION = 1
	var/N2O_HALLUCINATION_NAME = "N2O Hallucination"
	var/N2O_HALLUCINATION_DESC = "Does bein69 in sleepin69 69as cause you to hallucinate?"


obj/var/contaminated = 0


/obj/item/proc/can_contaminate()
	//Clothin69 and backpacks can be contaminated.
	if(fla69s & PLASMA69UARD) return 0
	else if(istype(src,/obj/item/stora69e/backpack)) return 0 //Cannot be washed :(
	else if(istype(src,/obj/item/clothin69)) return 1

/obj/item/proc/contaminate()
	//Do a contamination overlay? Temporary69easure to keep contamination less deadly than it was.
	if(!contaminated)
		contaminated = 1
		overlays += contamination_overlay

/obj/item/proc/decontaminate()
	contaminated = 0
	overlays -= contamination_overlay

/mob/proc/contaminate()

/mob/livin69/carbon/human/contaminate()
	//See if anythin69 can be contaminated.

	if(!pl_suit_protected())
		suit_contamination()

	if(!pl_head_protected())
		if(prob(1)) suit_contamination() //Plasma can sometimes 69et throu69h such an open suit.

//Cannot wash backpacks currently.
//	if(istype(back,/obj/item/stora69e/backpack))
//		back.contaminate()

/mob/proc/pl_effects()

/mob/livin69/carbon/human/pl_effects()
	//Handles all the bad thin69s plasma can do.

	//Contamination
	if(vsc.plc.CLOTH_CONTAMINATION) contaminate()

	//Anythin69 else re69uires them to69ot be dead.
	if(stat >= 2)
		return

	//Burn skin if exposed.
	if(vsc.plc.SKIN_BURNS)
		if(!pl_head_protected() || !pl_suit_protected())
			burn_skin(0.75)
			if(prob(20)) to_chat(src, SPAN_DAN69ER("Your skin burns!"))
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

	//69enetic Corruption
	if(vsc.plc.69ENETIC_CORRUPTION)
		if(rand(1,10000) <69sc.plc.69ENETIC_CORRUPTION)
			randmutb(src)
			to_chat(src, SPAN_DAN69ER("Hi69h levels of toxins cause you to spontaneously69utate!"))
			domutcheck(src,null)


/mob/livin69/carbon/human/proc/burn_eyes()
	//The proc that handles eye burnin69.
	if(!species.has_process69OP_EYES69)
		return

	var/obj/item/or69an/internal/eyes/E = random_or69an_by_process(OP_EYES)
	if(E)
		if(prob(20)) to_chat(src, SPAN_DAN69ER("Your eyes burn!"))
		E.dama69e += 2.5
		eye_blurry =69in(eye_blurry+1.5,50)
		if (prob(max(0,E.dama69e - 15) + 1) &&!eye_blind)
			to_chat(src, SPAN_DAN69ER("You are blinded!"))
			eye_blind += 20

/mob/livin69/carbon/human/proc/pl_head_protected()
	//Checks if the head is ade69uately sealed.
	if(head)
		if(vsc.plc.PLASMA69UARD_ONLY)
			if(head.fla69s & PLASMA69UARD)
				return 1
		else if(head.body_parts_covered & EYES)
			return 1
	return 0

/mob/livin69/carbon/human/proc/pl_suit_protected()
	//Checks if the suit is ade69uately sealed.
	var/covera69e = 0
	for(var/obj/item/protection in list(wear_suit, 69loves, shoes))
		if(!protection)
			continue
		if(vsc.plc.PLASMA69UARD_ONLY && !(protection.fla69s & PLASMA69UARD))
			return 0
		covera69e |= protection.body_parts_covered

	if(vsc.plc.PLASMA69UARD_ONLY)
		return 1

	return BIT_TEST_ALL(covera69e, UPPER_TORSO|LOWER_TORSO|LE69S|ARMS)

/mob/livin69/carbon/human/proc/suit_contamination()
	//Runs over the thin69s that can be contaminated and does so.
	if(w_uniform) w_uniform.contaminate()
	if(shoes) shoes.contaminate()
	if(69loves) 69loves.contaminate()


turf/Entered(obj/item/I)
	. = ..()
	//Items that are in plasma, but69ot on a69ob, can still be contaminated.
	if(istype(I) &&69sc.plc.CLOTH_CONTAMINATION && I.can_contaminate())
		var/datum/69as_mixture/env = return_air(1)
		if(!env)
			return
		for(var/69 in env.69as)
			if(69as_data.fla69s696969 & X69M_69AS_CONTAMINANT && env.69as6696969 > 69as_data.overlay_limit6996969 + 1)
				I.contaminate()
				break
