/datum/component/modification/organ/on_item_examine
	exclusive_type = /obj/item/modification/organ/internal/special/on_item_examine
	trigger_signal = COMSIG_EXAMINE

/datum/component/modification/organ/on_item_examine/try_modify()
	return

/datum/component/modification/organ/on_item_examine/brainloss
	var/damage = 1

/datum/component/modification/organ/on_item_examine/brainloss/get_function_info()
	var/description = "<span style='color:purple'>Functional information (secondary):</span> causes brain damage when examined"
	return description

/datum/component/modification/organ/on_item_examine/brainloss/moderate
	damage = 5

/datum/component/modification/organ/on_item_examine/brainloss/trigger(obj/item/holder, mob/owner)
	if(!holder || !owner)
		return
	if(isliving(owner))
		var/mob/living/L = owner	// NOTE: In this case, owner means the mob that examined the holder, not the mob the holder is attached to
		L.adjustBrainLoss(damage)
		L.apply_damage(PSY, damage)


/datum/component/modification/organ/on_pickup
	exclusive_type = /obj/item/modification/organ/internal/special/on_pickup
	trigger_signal = COMSIG_ITEM_PICKED

/datum/component/modification/organ/on_pickup/try_modify()
	return

/datum/component/modification/organ/on_pickup/shock
	var/damage = 5

/datum/component/modification/organ/on_pickup/shock/get_function_info()
	var/description = "<span style='color:purple'>Functional information (secondary):</span> electrocutes when touched"
	return description

/datum/component/modification/organ/on_pickup/shock/powerful
	damage = 25

/datum/component/modification/organ/on_pickup/shock/trigger(obj/item/holder, mob/owner)
	if(!holder || !owner)
		return

	if(isliving(owner))
		var/mob/living/L = owner
		L.electrocute_act(damage, parent)


/datum/component/modification/organ/on_cooldown
	exclusive_type = /obj/item/modification/organ/internal/special/on_cooldown
	trigger_signal = COMSIG_ABERRANT_SECONDARY

/datum/component/modification/organ/on_cooldown/try_modify()
	return

/datum/component/modification/organ/on_cooldown/chemical_effect
	var/effect

/datum/component/modification/organ/on_cooldown/chemical_effect/get_function_info()
	var/datum/reagent/hormone/H
	if(ispath(effect, /datum/reagent/hormone))
		H = effect

	var/effect_desc
	switch(effect)
		if(/datum/reagent/hormone/bloodrestore, /datum/reagent/hormone/bloodrestore/alt)
			effect_desc = "blood restoration"
		if(/datum/reagent/hormone/bloodclot, /datum/reagent/hormone/bloodclot/alt)
			effect_desc = "blood clotting"
		if(/datum/reagent/hormone/painkiller, /datum/reagent/hormone/painkiller/alt)
			effect_desc = "painkiller"
		if(/datum/reagent/hormone/antitox, /datum/reagent/hormone/antitox/alt)
			effect_desc = "anti-toxin"
		if(/datum/reagent/hormone/oxygenation, /datum/reagent/hormone/oxygenation/alt)
			effect_desc = "oxygenation"
		if(/datum/reagent/hormone/speedboost, /datum/reagent/hormone/speedboost/alt)
			effect_desc = "augmented agility"

	var/description = "<span style='color:purple'>Functional information (secondary):</span> secretes a hormone"
	description += "\n<span style='color:purple'>Effect produced:</span> [effect_desc] (type ["[initial(H.hormone_type)]"])"

	return description

/datum/component/modification/organ/on_cooldown/chemical_effect/trigger(obj/item/holder, mob/living/carbon/owner)
	if(!holder || !owner)
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/organ_multiplier = ((S.max_damage - S.damage) / S.max_damage) * (S.aberrant_cooldown_time / (2 SECONDS))	// Life() is called every 2 seconds
	var/datum/reagents/metabolism/RM = owner.get_metabolism_handler(CHEM_BLOOD)

	var/datum/reagent/output = effect
	var/amount_to_add = initial(output.metabolism) * organ_multiplier
	RM.add_reagent(initial(output.id), amount_to_add)

/datum/component/modification/organ/on_cooldown/stat_boost
	var/stat
	var/boost

/datum/component/modification/organ/on_cooldown/stat_boost/get_function_info()
	var/description = "<span style='color:purple'>Functional information (secondary):</span> augments physical/mental affinity"
	description += "\n<span style='color:purple'>Affinity:</span> [stat] ([boost])"

	return description

/datum/component/modification/organ/on_cooldown/stat_boost/trigger(obj/item/holder, mob/owner)
	if(!holder || !owner)
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/effect_multiplier = (S.max_damage - S.damage) / S.max_damage
	var/delay = S.aberrant_cooldown_time + 2 SECONDS

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		H.stats.addTempStat(stat, boost * effect_multiplier, delay, "\ref[parent]")
