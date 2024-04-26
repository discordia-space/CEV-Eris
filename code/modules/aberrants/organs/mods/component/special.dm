/datum/component/modification/organ/on_item_examine
	exclusive_type = /obj/item/modification/organ/internal/on_item_examine
	trigger_signal = COMSIG_EXAMINE

/datum/component/modification/organ/on_item_examine/brainloss
	var/damage = 1

/datum/component/modification/organ/on_item_examine/brainloss/moderate
	damage = 5

/datum/component/modification/organ/on_item_examine/brainloss/get_function_info()
	var/description = "<span style='color:purple'>Functional information (secondary):</span> causes brain damage when viewed closely"
	return description

/datum/component/modification/organ/on_item_examine/brainloss/trigger(mob/user)
	if(!user)
		return
	if(ishuman(user))
		var/mob/living/carbon/human/L = user	// NOTE: In this case, user means the mob that examined the holder, not the mob the holder is attached to
		L.adjustBrainLoss(damage)
		L.apply_damage(damage, PSY)


/datum/component/modification/organ/on_pickup
	exclusive_type = /obj/item/modification/organ/internal/on_pickup
	trigger_signal = COMSIG_ITEM_PICKED

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
	exclusive_type = /obj/item/modification/organ/internal/on_cooldown
	trigger_signal = COMSIG_ABERRANT_SECONDARY

/datum/component/modification/organ/on_cooldown/reagents_blood
	adjustable = FALSE
	var/reagent

/datum/component/modification/organ/on_cooldown/reagents_blood/get_function_info()
	var/datum/reagent/R = reagent

	var/description = "<span style='color:purple'>Functional information (secondary):</span> produces reagents in blood"
	description += "\n<span style='color:purple'>Reagents produced:</span> [initial(R.name)]"

	return description

/datum/component/modification/organ/on_cooldown/reagents_blood/trigger(obj/item/holder, mob/living/carbon/owner)
	if(!holder || !owner)
		return
	if(!istype(holder, /obj/item/organ/internal/scaffold))
		return

	var/obj/item/organ/internal/scaffold/S = holder
	var/organ_multiplier = ((S.max_damage - S.damage) / S.max_damage) * (S.aberrant_cooldown_time / (2 SECONDS))	// Life() is called every 2 seconds
	var/datum/reagents/metabolism/RM = owner.get_metabolism_handler(CHEM_BLOOD)

	var/datum/reagent/output = reagent
	var/amount_to_add = initial(output.metabolism) * organ_multiplier
	RM.add_reagent(initial(output.id), amount_to_add)

/datum/component/modification/organ/on_cooldown/chemical_effect
	adjustable = TRUE
	var/effect

/datum/component/modification/organ/on_cooldown/chemical_effect/modify(obj/item/I, mob/living/user)
	if(!effect)
		return

	var/list/possibilities = list(
		"blood restoration, type 1" = /datum/reagent/hormone/bloodrestore,
		"blood clotting, type 1" = /datum/reagent/hormone/bloodclot,
		"painkiller, type 1" = /datum/reagent/hormone/painkiller,
		"anti-toxin, type 1" = /datum/reagent/hormone/antitox,
		"oxygenation, type 1" = /datum/reagent/hormone/oxygenation,
		"augmented agility, type 1" = /datum/reagent/hormone/speedboost,
		"blood restoration, type 2" = /datum/reagent/hormone/bloodrestore/type_2,
		"blood clotting, type 2" = /datum/reagent/hormone/bloodclot/type_2,
		"painkiller, type 2" = /datum/reagent/hormone/painkiller/type_2,
		"anti-toxin, type 2" = /datum/reagent/hormone/antitox/type_2,
		"oxygenation, type 2" = /datum/reagent/hormone/oxygenation/type_2,
		"augmented agility, type 2" = /datum/reagent/hormone/speedboost/type_2
	)

	var/decision = input("Choose a hormone effect (current: [effect])","Adjusting Organoid") as null|anything in possibilities
	if(!decision)
		return

	effect = possibilities[decision]

/datum/component/modification/organ/on_cooldown/chemical_effect/get_function_info()
	var/datum/reagent/hormone/H
	if(ispath(effect, /datum/reagent/hormone))
		H = effect

	var/effect_desc
	switch(effect)
		if(/datum/reagent/hormone/bloodrestore, /datum/reagent/hormone/bloodrestore/type_2)
			effect_desc = "blood restoration"
		if(/datum/reagent/hormone/bloodclot, /datum/reagent/hormone/bloodclot/type_2)
			effect_desc = "blood clotting"
		if(/datum/reagent/hormone/painkiller, /datum/reagent/hormone/painkiller/type_2)
			effect_desc = "painkiller"
		if(/datum/reagent/hormone/antitox, /datum/reagent/hormone/antitox/type_2)
			effect_desc = "anti-toxin"
		if(/datum/reagent/hormone/oxygenation, /datum/reagent/hormone/oxygenation/type_2)
			effect_desc = "oxygenation"
		if(/datum/reagent/hormone/speedboost, /datum/reagent/hormone/speedboost/type_2)
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
	adjustable = TRUE
	var/stat
	var/boost

/datum/component/modification/organ/on_cooldown/stat_boost/modify(obj/item/I, mob/living/user)
	if(!stat)
		return

	var/list/possibilities = ALL_STATS

	var/decision = input("Choose an affinity (current: [stat])","Adjusting Organoid") as null|anything in possibilities
	if(!decision)
		return

	stat = decision

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
		H.stats.addTempStat(stat, boost * effect_multiplier, delay, "aberrant_membrane")


/datum/component/modification/organ/symbiotic
	exclusive_type = /obj/item/modification/organ/internal/symbiotic
	adjustable = TRUE
	trigger_signal = COMSIG_ITEM_PICKED

/datum/component/modification/organ/symbiotic/get_function_info()
	var/description

	if(trigger_signal == COMSIG_IATTACK)
		description = "<span style='color:purple'>Functional information (secondary):</span> can be implanted through unprotected skin"
	else if(trigger_signal == COMSIG_ITEM_PICKED)
		description = "<span style='color:purple'>Functional information (secondary):</span> can implant itself through unprotected skin"

	return description

/datum/component/modification/organ/symbiotic/modify(obj/item/I, mob/living/user)
	var/list/can_adjust = list("organ tissue", "implant behavior")

	var/decision_adjust = input("What do you want to adjust?","Adjusting Organoid") as null|anything in can_adjust
	if(!decision_adjust)
		return

	switch(decision_adjust)
		if("organ tissue")
			var/list/organ_efficiency_base
			var/specific_organ_size_base
			var/max_blood_storage_base
			var/blood_req_base
			var/nutriment_req_base
			var/oxygen_req_base

			if(!islist(modifications[ORGAN_EFFICIENCY_NEW_BASE]))
				modifications[ORGAN_EFFICIENCY_NEW_BASE] = list()

			organ_efficiency_base = modifications[ORGAN_EFFICIENCY_NEW_BASE]

			var/list/possibilities = ALL_STANDARD_ORGAN_EFFICIENCIES

			for(var/organ in organ_efficiency_base)
				if(LAZYLEN(organ_efficiency_base) > 1)
					for(var/organ_eff in possibilities)
						if(organ != organ_eff && LAZYFIND(organ_efficiency_base, organ_eff))
							LAZYREMOVE(possibilities, organ_eff)

				var/decision = input("Choose an organ type (current: [organ])","Adjusting Organoid") as null|anything in possibilities
				if(!decision)
					decision = organ

				var/list/organ_stats = ALL_ORGAN_STATS[decision]
				var/modifier = round(organ_efficiency_base[organ] / 100, 0.01)

				if(!modifier)
					return

				organ_efficiency_base -= organ
				organ_efficiency_base[decision] += round(organ_stats[1] * modifier, 1)
				specific_organ_size_base 		+= round(organ_stats[2] * modifier, 0.01)
				max_blood_storage_base			+= round(organ_stats[3] * modifier, 1)
				blood_req_base 					+= round(organ_stats[4] * modifier, 0.01)
				nutriment_req_base 				+= round(organ_stats[5] * modifier, 0.01)
				oxygen_req_base 				+= round(organ_stats[6] * modifier, 0.01)

			modifications[ORGAN_SPECIFIC_SIZE_BASE] = specific_organ_size_base
			modifications[ORGAN_MAX_BLOOD_STORAGE_BASE] = max_blood_storage_base
			modifications[ORGAN_BLOOD_REQ_BASE] = blood_req_base
			modifications[ORGAN_NUTRIMENT_REQ_BASE] = nutriment_req_base
			modifications[ORGAN_OXYGEN_REQ_BASE] = oxygen_req_base
		if("implant behavior")
			var/list/possibilities = list(
				"on pick-up" = COMSIG_ITEM_PICKED,
				"on insertion" = COMSIG_IATTACK
				)
			var/list/inverted_possibles = list(
				COMSIG_ITEM_PICKED = "on pick-up",
				COMSIG_IATTACK = "on insertion"
			)

			var/decision = input("Choose an implant method (current: [inverted_possibles[trigger_signal]])","Adjusting Organoid") as null|anything in possibilities
			if(!decision)
				return

			trigger_signal = possibilities[decision]

/datum/component/modification/organ/symbiotic/trigger(atom/A, mob/M)
	if(!A || !M)
		return

	if(trigger_signal == COMSIG_IATTACK)
		trigger_iattack(A, M)
	else if(trigger_signal == COMSIG_ITEM_PICKED)
		trigger_pickup(A, M)

/datum/component/modification/organ/symbiotic/proc/trigger_pickup(obj/item/holder, mob/owner)
	if(!holder || !owner)
		return

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		var/obj/item/organ/external/active_hand = H.get_active_hand_organ()
		if(BP_IS_ROBOTIC(active_hand))
			return
		if(istype(holder, /obj/item/organ/internal))
			var/obj/item/organ/internal/I = holder
			if(H.getarmor_organ(active_hand, ARMOR_BIO) < 75 && active_hand.get_total_occupied_volume() + I.specific_organ_size < active_hand.max_volume)
				H.drop_item()
				I.replaced(active_hand)
				H.apply_damage(10, HALLOSS, active_hand)
				H.apply_damage(5, BRUTE, active_hand)
				to_chat(owner, SPAN_WARNING("\The [holder] forces its way into your [active_hand.name]!"))

/datum/component/modification/organ/symbiotic/proc/trigger_iattack(atom/A, mob/living/user)
	if(!A || !user)
		return

	if(ishuman(A) && ishuman(user))
		var/mob/living/carbon/human/target = A
		var/mob/living/carbon/human/attacker = user
		var/obj/item/organ/external/affected = target.organs_by_name[attacker.targeted_organ]
		if(!affected)
			user.visible_message(SPAN_NOTICE("[user.name] attempts to implant [target.name], but misses!"), SPAN_WARNING("The target limb is missing."))
		if(BP_IS_ROBOTIC(affected))
			to_chat(user, SPAN_NOTICE("The target limb is robotic. This organ can only be implanted in organic limbs."))
			return
		var/duration = max(5 SECONDS - attacker.stats.getStat(STAT_BIO), 0)		// Every point of BIO reduces the duration by a decisecond
		if(!do_after(attacker, duration, target))
			return
		if(target.getarmor_organ(affected, ARMOR_BIO) < 75)
			var/atom/movable/AM = parent
			if(istype(AM.loc, /obj/item/organ/internal))
				var/obj/item/organ/internal/I = AM.loc
				if(affected.max_volume < affected.get_total_occupied_volume() + I.specific_organ_size)
					to_chat(user, SPAN_NOTICE("The target limb does not have enough space to hold \the [I]."))
					return
				attacker.drop_item()
				I.replaced(affected)
				target.apply_damage(10, HALLOSS, affected)
				target.apply_damage(5, BRUTE, affected)
				user.visible_message(SPAN_WARNING("[user.name] implants \the [I] into [target.name]'s [affected.name]!"), SPAN_WARNING("You implant \the [I] into [target.name]'s [affected.name]!"))
		else
			to_chat(user, SPAN_NOTICE("The target limb has too much protection."))

/datum/component/modification/organ/deployable
	exclusive_type = /obj/item/modification/organ/internal/deployable
	somatic = TRUE
	var/obj/item/stored_object
	var/stored_type

/datum/component/modification/organ/deployable/apply(obj/item/organ/O, mob/living/user)
	. = ..()

	// If the mod failed to install, do nothing
	if(!.)
		return FALSE

	if(stored_type)
		stored_object = new stored_type(parent)
		stored_object.canremove = FALSE

/datum/component/modification/organ/deployable/trigger(obj/item/organ/holder, mob/living/carbon/human/user)
	if(!holder || !user)
		return

	var/obj/item/organ/external/E = holder.parent

	if(!E)
		return

	if(stored_object.loc == parent) //item not in hands
		if(user.put_in_active_hand(stored_object))
			user.visible_message(
				SPAN_WARNING("[user] extends \his [stored_object.name] from [E]."),
				SPAN_NOTICE("You extend your [stored_object.name] from [E].")
			)
	else if(stored_object.loc == user)
		user.drop_from_inventory(stored_object)
		user.visible_message(
			SPAN_WARNING("[user] retracts \his [stored_object.name] into [E]."),
			SPAN_NOTICE("You retract your [stored_object.name] into [E].")
		)
		stored_object.forceMove(parent)
	else
		to_chat(user, SPAN_WARNING("ERROR: Stored object does not exist or is in the wrong place."))
