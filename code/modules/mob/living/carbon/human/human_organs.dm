/mob/living/carbon/human/proc/update_eyes()
	var/obj/item/organ/internal/eyes/eyes = random_organ_by_process(OP_EYES)
	if(eyes)
		eyes.update_colour()
		regenerate_icons()

/mob/living/carbon/var/list/internal_organs = list()
/mob/living/carbon/human/var/list/organs = list()
/mob/living/carbon/human/var/list/organs_by_name = list() //69ap organ69ames to organs
/mob/living/carbon/human/var/list/internal_organs_by_efficiency = list()

// Takes care of organ related updates, such as broken and69issing limbs
/mob/living/carbon/human/proc/handle_organs()

	var/force_process = 0
	var/damage_this_tick = getBruteLoss() + getFireLoss() + getToxLoss()
	if(damage_this_tick > last_dam)
		force_process = 1
	last_dam = damage_this_tick
	if(force_process)
		bad_external_organs.Cut()
		for(var/obj/item/organ/external/Ex in organs)
			bad_external_organs |= Ex

	//processing internal organs is pretty cheap, do that first.
	for(var/obj/item/organ/I in internal_organs)
		I.Process()

	handle_stance()
	handle_grasp()

	if(!force_process && !bad_external_organs.len)
		return

	for(var/obj/item/organ/external/E in organs)
		E.handle_bones()

	for(var/obj/item/organ/external/E in bad_external_organs)
		if(!E)
			continue
		if(!E.need_process())
			bad_external_organs -= E
			continue
		else
			E.Process()

			if (!lying && !buckled && world.time - l_move_time < 15)
			//Moving around with fractured ribs won't do you any good
				if (E.is_broken() && E.internal_organs && E.internal_organs.len && prob(15))
					var/obj/item/organ/I = pick(E.internal_organs)
					custom_pain("You feel broken bones69oving in your 69E.name69!", 1)
					I.take_damage(rand(3,5))

				//Moving69akes open wounds get infected69uch faster
				if (E.wounds.len)
					for(var/datum/wound/W in E.wounds)
						if (W.infection_check())
							W.germ_level += 1

/mob/living/carbon/human/proc/handle_stance()
	// Don't69eed to process any of this if they aren't standing anyways
	// unless their stance is damaged, and we want to check if they should stay down
	if (!stance_damage && (lying || resting) && (life_tick % 4) == 0)
		return

	stance_damage = 0

	// Buckled to a bed/chair. Stance damage is forced to 0 since they're sitting on something solid
	if (istype(buckled, /obj/structure/bed))
		return

	// Calculate limb effect on stance
	for(var/limb_tag in BP_LEGS)
		var/obj/item/organ/external/E = organs_by_name69limb_tag69

		// A69issing limb causes high stance damage
		if(!E)
			stance_damage += 4
		else
			stance_damage += E.get_tally()

	// Canes and crutches help you stand (if the latter is ever added)
	// One cane fully69itigates a broken leg.
	// Two canes are69eeded for a lost leg. If you are69issing both legs, canes aren't gonna help you.
	if(stance_damage > 0 && stance_damage < 8)
		if (l_hand && istype(l_hand, /obj/item/tool/cane))
			stance_damage -= 3
		if (r_hand && istype(r_hand, /obj/item/tool/cane))
			stance_damage -= 3
		stance_damage =69ax(stance_damage, 0)

	// standing is poor
	if(stance_damage >= 8 || (stance_damage >= 4 && prob(5)))
		if(!(lying || resting))
			if(species && !(species.flags &69O_PAIN))
				emote("scream")
			custom_emote(1, "collapses!")
		Weaken(5) //can't emote while weakened, apparently.

/mob/living/carbon/human/proc/handle_grasp()
	if(!l_hand && !r_hand)
		return

	// You should69ot be able to pick anything up, but stranger things have happened.
	if(l_hand)
		for(var/limb_tag in list(BP_L_ARM))
			var/obj/item/organ/external/E = get_organ(limb_tag)
			if(!E)
				visible_message(SPAN_DANGER("Lacking a functioning left hand, \the 69src69 drops \the 69l_hand69."))
				drop_from_inventory(l_hand)
				break

	if(r_hand)
		for(var/limb_tag in list(BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(limb_tag)
			if(!E)
				visible_message(SPAN_DANGER("Lacking a functioning right hand, \the 69src69 drops \the 69r_hand69."))
				drop_from_inventory(r_hand)
				break

	// Check again...
	if(!l_hand && !r_hand)
		return

	for (var/obj/item/organ/external/E in organs)
		if(!E || !(E.functions & BODYPART_GRASP) || (E.status & ORGAN_SPLINTED))
			continue

		if(E.is_broken() || E.is_dislocated() || E.limb_efficiency <= 50)
			switch(E.body_part)
				if(ARM_LEFT)
					if(!l_hand)
						continue
					drop_from_inventory(l_hand)
				if(ARM_RIGHT)
					if(!r_hand)
						continue
					drop_from_inventory(r_hand)

			var/emote_scream = pick("screams in pain and ", "lets out a sharp cry and ", "cries out and ")
			if(E.limb_efficiency <= 50)
				var/emote_2 = pick("unable to grasp it", "unable to feel it", "too weak to hold it")
				emote("me", 1, "drops what they were holding in their 69E.name69, 69emote_269!")

			else
				emote("me", 1, "69(species.flags &69O_PAIN) ? "" : emote_scream 69drops what they were holding in their 69E.name69!")

		else if(E.is_malfunctioning())
			switch(E.body_part)
				if(ARM_LEFT)
					if(!l_hand)
						continue
					drop_from_inventory(l_hand)
				if(ARM_RIGHT)
					if(!r_hand)
						continue
					drop_from_inventory(r_hand)

			emote("pain", 1, "drops what they were holding, their 69E.name6969alfunctioning!")

			var/datum/effect/effect/system/spark_spread/spark_system =69ew /datum/effect/effect/system/spark_spread()
			spark_system.set_up(5, 0, src)
			spark_system.attach(src)
			spark_system.start()
			spawn(10)
				qdel(spark_system)

//Handles chem traces
/mob/living/carbon/human/proc/handle_trace_chems()
	//New are added for reagents to random organs.
	for(var/datum/reagent/A in reagents.reagent_list)
		var/obj/item/organ/O = pick(organs)
		O.trace_chemicals69A.name69 = 100

/mob/living/carbon/human/proc/sync_organ_dna()
	var/list/all_bits = internal_organs|organs
	for(var/obj/item/organ/O in all_bits)
		O.set_dna(dna)

/mob/living/carbon/human/is_asystole()
	if(should_have_process(OP_HEART))
		var/obj/item/organ/internal/heart/heart = random_organ_by_process(OP_HEART)
		if(!istype(heart) || !heart.is_working())
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/organ_list_by_process(organ_process)
	RETURN_TYPE(/list)
	. = list()
	for(var/organ in internal_organs_by_efficiency69organ_process69)
		. += organ

/mob/living/carbon/human/proc/random_organ_by_process(organ_process)
	if(organ_list_by_process(organ_process).len)
		return pick(organ_list_by_process(organ_process))
	return	FALSE

// basically has_limb()
/mob/living/carbon/human/has_appendage(var/appendage_check)	//returns TRUE if found, type of organ69odification if limb is robotic, FALSE if69ot found

	if (appendage_check == BP_CHEST)
		return TRUE

	var/obj/item/organ/external/appendage
	appendage = organs_by_name69appendage_check69

	if(appendage && !appendage.is_stump())
		if(BP_IS_ROBOTIC(appendage))
			return appendage.nature
		else return TRUE
	return FALSE

/mob/living/carbon/human/proc/restore_organ(organ_type,69ar/show_message = FALSE,69ar/heal = FALSE,)
	var/obj/item/organ/E = organs_by_name69organ_type69
	if(E && E.organ_tag != BP_HEAD && !E.vital && !E.is_usable())	//Skips heads and69ital bits...
		QDEL_NULL(E) //...because69o one wants their head to explode to69ake way for a69ew one.

	if(!E)
		if(organ_type in BP_ALL_LIMBS)
			var/datum/organ_description/organ_data = species.has_limbs69organ_type69
			var/obj/item/organ/external/O = organ_data.create_organ(src)
			var/datum/reagent/organic/blood/B = locate(/datum/reagent/organic/blood) in69essel.reagent_list
			blood_splatter(src,B,1)
			O.set_dna(dna)
			update_body()
			if (show_message)
				to_chat(src, SPAN_DANGER("With a shower of fresh blood, a69ew 69O.name69 forms."))
				visible_message(SPAN_DANGER("With a shower of fresh blood, a length of biomass shoots from 69src69's 69O.amputation_point69, forming a69ew 69O.name69!"))
			return TRUE
		else
			var/list/organ_data = species.has_process69organ_type69
			var/organ_path = organ_data69"path"69
			var/obj/item/organ/internal/O =69ew organ_path(src)
			organ_data69"descriptor"69 = O.name
			O.set_dna(dna)
			update_body()
			if(is_carrion(src) && O.organ_tag == BP_BRAIN)
				O.vital = 0
			return TRUE
	else
		if(organ_type in BP_ALL_LIMBS)
			var/obj/item/organ/external/O = E
			if (heal && (O.damage > 0 || O.status & (ORGAN_BROKEN) || O.has_internal_bleeding()))
				O.status &= ~ORGAN_BROKEN
				for(var/datum/wound/W in O.wounds)
					if(W.internal)
						O.wounds.Remove(W)
						qdel(W)
						O.update_wounds()
				for(var/datum/wound/W in O.wounds)
					if(W.wound_damage() == 0 && prob(50))
						O.wounds -= W
				return TRUE
		else
			if (heal && (E.damage > 0 || E.status & (ORGAN_BROKEN)))
				E.status &= ~ORGAN_BROKEN
				return TRUE
	return FALSE
/mob/living/carbon/human/get_limb_efficiency(bodypartdefine)
	var/obj/item/organ/external/E = get_organ(bodypartdefine)
	if(E)
		return E.limb_efficiency
	return 0

