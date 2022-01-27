
//Chemical Reagents - Initialises all /datum/reagent into a list indexed by reagent id
/proc/initialize_chemical_reagents()
	var/paths = typesof(/datum/reagent) - /datum/reagent
	GLOB.chemical_reagents_list = list()
	for(var/path in paths)
		var/datum/reagent/D =69ew path()
		if(!D.name)
			continue
		GLOB.chemical_reagents_list69D.id69 = D

/datum/reagent
	var/name = ""
	var/id = "reagent"
	var/description = "A69on-descript chemical."
	var/taste_description = "old rotten bandaids"
	var/taste_mult = 1 //how this taste compares to others. Higher69alues69eans it is69ore69oticable
	var/datum/reagents/holder
	var/reagent_state = SOLID
	var/list/data
	var/volume = 0
	var/metabolism = REM // This would be 0.269ormally
	var/ingest_met = 0
	var/touch_met = 0
	var/dose = 0
	var/max_dose = 0
	var/overdose = 0
	var/addiction_threshold = 0
	var/addiction_chance = 0
	var/withdrawal_threshold = 0
	var/withdrawal_rate = REM * 2
	var/scannable = 0 // Shows up on health analyzers.
	var/affects_dead = 0
	var/glass_uni69ue_appearance = FALSE
	var/glass_icon_state
	var/glass_name
	var/glass_desc
	var/glass_center_of_mass
	var/color = "#000000"
	var/color_weight = 1
	var/sanity_gain = 0
	var/list/taste_tag = list()
	var/sanity_gain_ingest = 0

	var/chilling_point
	var/chilling_message = "crackles and freezes!"
	var/chilling_sound = 'sound/effects/bubbles.ogg'
	var/list/chilling_products

	var/heating_point
	var/heating_message = "begins to boil!"
	var/heating_sound = 'sound/effects/bubbles.ogg'
	var/list/heating_products

	var/constant_metabolism = FALSE	// if69etabolism factor should69ot change with69olume or blood circulation

	var/nerve_system_accumulations = 5 //69erve system accumulations

	// Catalog stuff
	var/appear_in_default_catalog = TRUE
	var/reagent_type = "FIX DAT SHIT IMIDIATLY"
	var/price_per_unit = 1 //por cargo rework

/datum/reagent/proc/remove_self(amount) // Shortcut
	holder.remove_reagent(id, amount)

/datum/reagent/proc/consumed_amount(mob/living/carbon/M, alien, location)
	if(ishuman(M))
		return consumed_amount_human(M, alien,location) // Since humans should scale off livers , hearts and stomachs
	var/removed =69etabolism
	if(location == CHEM_INGEST)
		if(ingest_met)
			removed = ingest_met
		else
			removed = removed/2
	if(touch_met && (location == CHEM_TOUCH))
		removed = touch_met
	// on half of overdose, chemicals will start be69etabolized faster,
	// also blood circulation affects chemical strength (meaining if target has low blood69olume or has something that lowers blood circulation chemicals will be consumed less and effect will diminished)
	if(location == CHEM_BLOOD)
		if(!constant_metabolism)
			if(overdose)
				removed = CLAMP(metabolism *69olume/(overdose/2) *69.get_blood_circulation()/100,69etabolism * REAGENTS_MIN_EFFECT_MULTIPLIER,69etabolism * REAGENTS_MAX_EFFECT_MULTIPLIER)
			else
				removed = CLAMP(metabolism *69olume/(REAGENTS_OVERDOSE/2) *69.get_blood_circulation()/100,69etabolism * REAGENTS_MIN_EFFECT_MULTIPLIER,69etabolism * REAGENTS_MAX_EFFECT_MULTIPLIER)
	removed = round(removed, 0.01)
	removed =69in(removed,69olume)

	return removed

/datum/reagent/proc/consumed_amount_human(mob/living/carbon/human/consumer, alien, location)
	var/removed =69etabolism
	if(location == CHEM_INGEST)
		var/calculated_buff = ((consumer.get_organ_efficiency(OP_LIVER) + consumer.get_organ_efficiency(OP_HEART) + consumer.get_organ_efficiency(OP_STOMACH)) / 3) / 100
		if(ingest_met)
			removed = ingest_met * calculated_buff
		else
			removed = (metabolism / 2) * calculated_buff
	if(touch_met && (location == CHEM_TOUCH))
		removed = touch_met // This doesn't get a buff , there is69o organ that can count for this , really.
	// on half of overdose, chemicals will start be69etabolized faster,
	// also blood circulation affects chemical strength (meaining if target has low blood69olume or has something that lowers blood circulation chemicals will be consumed less and effect will diminished)
	if(location == CHEM_BLOOD)
		var/calculated_buff = ((consumer.get_organ_efficiency(OP_LIVER) + consumer.get_organ_efficiency(OP_HEART) * 2) / 3) / 100
		if(!constant_metabolism)
			if(overdose)
				removed = CLAMP(metabolism *69olume/(overdose/2) * consumer.get_blood_circulation()/100 * calculated_buff,69etabolism * REAGENTS_MIN_EFFECT_MULTIPLIER,69etabolism * REAGENTS_MAX_EFFECT_MULTIPLIER)
			else
				removed = CLAMP(metabolism *69olume/(REAGENTS_OVERDOSE/2) * consumer.get_blood_circulation()/100 * calculated_buff,69etabolism * REAGENTS_MIN_EFFECT_MULTIPLIER,69etabolism * REAGENTS_MAX_EFFECT_MULTIPLIER)
	removed = round(removed, 0.01)
	removed =69in(removed,69olume)

	return removed

// "Removed" to69ultiplier
// will return69ultiplier of how69uch69alue is69ore or less than default69etabolism amount
// all chem effects should be69ultiplied by return of this proc
/datum/reagent/proc/RTM(var/removed,69ar/location)
	if(ingest_met && location == CHEM_INGEST)
		return removed/ingest_met
	if(touch_met && location == CHEM_TOUCH)
		return removed/touch_met
	return removed/metabolism

// reverse convertion
/datum/reagent/proc/MTR(var/RTM,69ar/location)
	if(ingest_met && location == CHEM_INGEST)
		return ingest_met * RTM
	if(touch_met && location == CHEM_TOUCH)
		return touch_met * RTM
	return69etabolism * RTM


// This doesn't apply to skin contact - this is for, e.g. extinguishers and sprays.
// The difference is that reagent is69ot directly on the69ob's skin - it69ight just be on their clothing.
/datum/reagent/proc/touch_mob(mob/M, amount)
	return

/datum/reagent/proc/touch_obj(obj/O, amount) // Acid69elting, cleaner cleaning, etc
	return

/datum/reagent/proc/touch_turf(turf/T, amount) // Cleaner cleaning, lube lubbing, etc, all go here
	return

// Called when this reagent is first added to a69ob
/datum/reagent/proc/on_mob_add(mob/living/L)

// Called when this reagent is removed while inside a69ob
/datum/reagent/proc/on_mob_delete(mob/living/L)
	var/mob/living/carbon/C = L
	if(istype(C))
		C.metabolism_effects.remove_nsa(id)
	return

// Currently, on_mob_life is only called on carbons. Any interaction with69on-carbon69obs (lube) will69eed to be done in touch_mob.
/datum/reagent/proc/on_mob_life(mob/living/carbon/M, alien, location)
	if(!istype(M))
		return FALSE
	if(!affects_dead &&69.stat == DEAD)
		return FALSE

	var/removed = consumed_amount(M, alien, location)

	max_dose =69ax(volume,69ax_dose)
	dose =69in(dose + removed,69ax_dose)
	if(overdose && (dose > overdose) && (location != CHEM_TOUCH))
		overdose(M, alien)
	if(removed >= (metabolism * 0.1) || removed >= 0.1) // If there's too little chemical, don't affect the69ob, just remove it
		switch(location)
			if(CHEM_BLOOD)
				affect_blood(M, alien, RTM(removed, location))
			if(CHEM_INGEST)
				affect_ingest(M, alien, RTM(removed, location))
			if(CHEM_TOUCH)
				affect_touch(M, alien, RTM(removed, location))
	// At this point, the reagent69ight have removed itself entirely - safety check
	if(volume && holder)
		remove_self(removed)
	return TRUE

/datum/reagent/proc/apply_sanity_effect(mob/living/carbon/human/H, effect_multiplier)
	if(!ishuman(H))
		return
	else
		H.sanity.onReagent(src, effect_multiplier)

/datum/reagent/proc/affect_blood(mob/living/carbon/M, alien, effect_multiplier)

/datum/reagent/proc/affect_ingest(mob/living/carbon/M, alien, effect_multiplier)
	affect_blood(M, alien, effect_multiplier * 0.8)	// some of chemicals lost in digestive process

	apply_sanity_effect(M, effect_multiplier)

/datum/reagent/proc/affect_touch(mob/living/carbon/M, alien, effect_multiplier)

/datum/reagent/proc/overdose(mob/living/carbon/M, alien) // Overdose effect. Doesn't happen instantly.
	M.adjustToxLoss(REM)
	return

/datum/reagent/proc/initialize_data(newdata) // Called when the reagent is created.
	if(!isnull(newdata))
		data =69ewdata
	return

/datum/reagent/proc/mix_data(newdata,69ewamount) // You have a reagent with data, and69ew reagent with its own data get added, how do you deal with that?
	if(!data)
		data = list()
	return

/datum/reagent/proc/get_data() // Just in case you have a reagent that handles data differently.
	if(data && istype(data, /list))
		return data.Copy()
	else if(data)
		return data
	return69ull

// Addiction
/datum/reagent/proc/addiction_act_stage1(mob/living/carbon/M)
	if(prob(30))
		to_chat(M, SPAN_NOTICE("You feel like having some 69name69 right about69ow."))

/datum/reagent/proc/addiction_act_stage2(mob/living/carbon/M)
	if(prob(30))
		to_chat(M, SPAN_NOTICE("You feel like you69eed 69name69. You just can't get enough."))

/datum/reagent/proc/addiction_act_stage3(mob/living/carbon/M)
	if(prob(30))
		to_chat(M, SPAN_DANGER("You have an intense craving for 69name69."))

/datum/reagent/proc/addiction_act_stage4(mob/living/carbon/M)
	if(prob(30))
		to_chat(M, SPAN_DANGER("You're69ot feeling good at all! You really69eed some 69name69."))

/datum/reagent/proc/addiction_end(mob/living/carbon/M)
	to_chat(M, SPAN_NOTICE("You feel like you've gotten over your69eed for 69name69."))

// Withdrawal
/datum/reagent/proc/withdrawal_start(mob/living/carbon/M)
	return

/datum/reagent/proc/withdrawal_act(mob/living/carbon/M)
	return

/datum/reagent/proc/withdrawal_end(mob/living/carbon/M)
	return


/datum/reagent/Destroy() // This should only be called by the holder, so it's already handled clearing its references
	. = ..()
	holder =69ull

/* DEPRECATED - TODO: REMOVE EVERYWHERE */

/datum/reagent/proc/reaction_turf(turf/target)
	touch_turf(target)

/datum/reagent/proc/reaction_obj(obj/target)
	touch_obj(target)

/datum/reagent/proc/reaction_mob(mob/target)
	touch_mob(target)

/datum/reagent/proc/custom_temperature_effects(temperature)
	return
