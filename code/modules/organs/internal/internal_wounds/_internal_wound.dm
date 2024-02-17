/datum/component/internal_wound
	var/name = "internal injury"
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	var/list/treatments_item = list()	// list(/obj/item = amount)
	var/list/treatments_tool = list()	// list(QUALITY_TOOL = FAILCHANCE)
	var/list/treatments_chem = list()	// list(CE_CHEMEFFECT = strength)
	var/datum/component/scar			// If defined, applies this wound type when successfully treated

	var/diagnosis_stat					// BIO for organic, MEC for robotic
	var/diagnosis_difficulty			// basic - 25, adv - 40

	// Wound characteristics
	// IWOUND_CAN_DAMAGE - Applies wound severity damage to the parent organ
	// IWOUND_PROGRESS - Allows the wound to progress
	// IWOUND_PROGRESS_DEATH - Allows the wound to progress after organ death
	// IWOUND_SPREAD - Allows the wound to spread to another organ
	// IWOUND_HALLUCINATE - Causes hallucinations
	var/characteristic_flag = IWOUND_CAN_DAMAGE|IWOUND_PROGRESS

	var/severity = 0					// How much the wound contributes to internal organ damage
	var/severity_max = 3				// How far the wound can progress, default is 2

	var/datum/component/next_wound					// If defined, applies a wound of this type when severity is at max
	var/progression_threshold = IWOUND_4_MINUTES	// How many ticks until the wound progresses, default is 3 minutes
	var/current_progression_tick					// Current tick towards progression

	var/spread_threshold = 0			// Severity at which the wound spreads a single time

	var/wound_nature					// Make sure we don't apply organic wounds to robotic organs and vice versa

	// Damage applied to mob each process tick
	var/hal_damage			// Stored on the limb and applied in shock.dm
	var/psy_damage			// Not the same as sanity damage, but does deal sanity damage

	// Additional effects
	var/ticks_per_hallucination = IWOUND_1_MINUTE
	var/current_hallucination_tick

	// Organ adjustments - preferably used for more severe wounds
	var/list/organ_efficiency_mod = list()
	var/organ_efficiency_multiplier = null
	var/specific_organ_size_multiplier = null
	var/max_blood_storage_multiplier = null
	var/blood_req_multiplier = null
	var/nutriment_req_multiplier = null
	var/oxygen_req_multiplier = null

	// Parent organ adjustments
	var/status_flag = ORGAN_WOUNDED		// Causes the parent limb to start processing

/datum/component/internal_wound/RegisterWithParent()
	// Internal organ parent
	RegisterSignal(parent, COMSIG_IWOUND_EFFECTS, PROC_REF(apply_effects))
	RegisterSignal(parent, COMSIG_IWOUND_LIMB_EFFECTS, PROC_REF(apply_limb_effects))
	RegisterSignal(parent, COMSIG_IWOUND_FLAGS_ADD, PROC_REF(apply_flags))
	RegisterSignal(parent, COMSIG_IWOUND_FLAGS_REMOVE, PROC_REF(remove_flags))
	RegisterSignal(parent, COMSIG_IWOUND_DAMAGE, PROC_REF(apply_damage))
	RegisterSignal(parent, COMSIG_IWOUND_TREAT, PROC_REF(treatment))

	// Surgery
	RegisterSignal(src, COMSIG_ATTACKBY, PROC_REF(apply_tool))

	START_PROCESSING(SSinternal_wounds, src)

/datum/component/internal_wound/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_IWOUND_EFFECTS)
	UnregisterSignal(parent, COMSIG_IWOUND_LIMB_EFFECTS)
	UnregisterSignal(parent, COMSIG_IWOUND_FLAGS_ADD)
	UnregisterSignal(parent, COMSIG_IWOUND_FLAGS_REMOVE)
	UnregisterSignal(parent, COMSIG_IWOUND_DAMAGE)
	UnregisterSignal(parent, COMSIG_IWOUND_TREAT)
	UnregisterSignal(src, COMSIG_ATTACKBY)

	if(LAZYACCESS(SSinternal_wounds.processing, src))
		STOP_PROCESSING(SSinternal_wounds, src)

/datum/component/internal_wound/InheritComponent()	// Getting a new wound of the same type as an existing wound will progress it
	progress()

/datum/component/internal_wound/Process(delta_time)
	var/obj/item/organ/O = parent
	var/obj/item/organ/external/E = parent ? O.parent : null
	var/mob/living/carbon/human/H = parent ? O.owner : null

	// Don't process when the parent limb or owner is dead. Organs don't process in corpses and won't die from wounds.
	if((!parent || O.status & ORGAN_DEAD) && !(characteristic_flag & IWOUND_PROGRESS_DEATH))
		return PROCESS_KILL

	// Progress if not in a cryo tube or in stasis
	if(characteristic_flag & IWOUND_PROGRESS && (H && !(H.bodytemperature < 170 || H.in_stasis)))
		++current_progression_tick
		if(current_progression_tick >= progression_threshold)
			current_progression_tick = 0
			progress()
			if(H)
				H.custom_pain("Something inside your [E.name] hurts a lot.", 0)

	if(!H)
		return

	// Chemical treatment handling
	var/list/owner_ce = H.chem_effects
	for(var/chem_effect in owner_ce)
		var/treatment_threshold = LAZYACCESS(treatments_chem, chem_effect)
		if(treatment_threshold && owner_ce[chem_effect] >= treatment_threshold)
			owner_ce[chem_effect] -= treatment_threshold
			treatment(FALSE)
			return

	// Spread once
	if(characteristic_flag & IWOUND_SPREAD)
		if(severity == spread_threshold)
			var/list/internal_organs_sans_parent = H.internal_organs.Copy() - O
			var/obj/item/organ/next_organ = pick(internal_organs_sans_parent)
			SEND_SIGNAL_OLD(next_organ, COMSIG_IORGAN_ADD_WOUND, type)

	// Deal damage - halloss is handled in shock.dm
	if(psy_damage)
		H.sanity.onPsyDamage(psy_damage * severity)

	// Apply effects
	if(characteristic_flag & IWOUND_HALLUCINATE)
		++current_hallucination_tick
		if(current_hallucination_tick >= ticks_per_hallucination && H.sanity)
			var/num = rand(1,4)
			switch(num)
				if(1)
					H.sanity.effect_emote()
				if(2)
					H.sanity.effect_quote()
				if(3)
					H.sanity.effect_sound()
				if(4)
					H.sanity.effect_hallucination()
			current_hallucination_tick = 0

/datum/component/internal_wound/proc/progress()
	if(!(characteristic_flag & IWOUND_PROGRESS))
		return

	if(severity < severity_max)
		++severity
	else
		characteristic_flag &= ~(IWOUND_PROGRESS|IWOUND_PROGRESS_DEATH)	// Lets us remove the wound from processing
		if(next_wound && ispath(next_wound, /datum/component))
			var/chosen_wound_type = pick(subtypesof(next_wound))
			SEND_SIGNAL_OLD(parent, COMSIG_IORGAN_ADD_WOUND, chosen_wound_type)

	SEND_SIGNAL(parent, COMSIG_IORGAN_REFRESH_SELF)

/datum/component/internal_wound/proc/apply_tool(obj/item/I, mob/user)
	var/success = FALSE
	var/obj/item/organ/internal/organ = parent
	var/obj/item/organ/limb = organ.parent

	if(istype(I, /obj/item/reagent_containers/syringe))
		var/obj/item/reagent_containers/syringe/S = I
		if(S.mode == 1)		// SYRINGE_INJECT = 1
			var/obj/item/organ/O = parent
			if(O.owner)
				S.afterattack(O.owner, user, TRUE)
			return
		else
			to_chat(user, SPAN_WARNING("You cannot draw blood like this."))

	if(!I.tool_qualities || !LAZYLEN(I.tool_qualities))
		var/charges_needed
		for(var/path in treatments_item)
			if(istype(I, path))
				charges_needed = treatments_item[path]
		var/is_treated = FALSE
		var/free_use = FALSE
		var/user_stat_level = user.stats.getStat(diagnosis_stat)
		if(charges_needed)
			if(istype(I, /obj/item/stack))
				var/obj/item/stack/S = I
				if(do_after(user, WORKTIME_NORMAL - user_stat_level, parent))
					if(prob(10 + user_stat_level))
						free_use = TRUE
						is_treated = TRUE
					else
						is_treated = S.use(charges_needed)
			else if(istype(I)) // check for using items without stacks
				is_treated = TRUE
				qdel(I)
			if(is_treated)
				if(free_use)
					to_chat(user, SPAN_NOTICE("You have managed to waste less [I.name]."))
				success = TRUE
	else
		for(var/tool_quality in treatments_tool)
			if(I.use_tool(user, parent, WORKTIME_NORMAL, tool_quality, treatments_tool[tool_quality], diagnosis_stat))
				success = TRUE
				break

	if(success)
		treatment(TRUE)

	if(user)
		if(success)
			to_chat(user, SPAN_NOTICE("You treat the [name] with \the [I]."))
			if(limb)
				SSnano.update_user_uis(user, limb)
		else
			to_chat(user, SPAN_WARNING("You cannot treat the [name] with \the [I]."))

	return success

/datum/component/internal_wound/proc/treatment(used_tool, used_autodoc = FALSE)
	if(severity > 0 && !used_tool)
		--severity
		// If it was turned off by reaching the max, turn it on again.
		if(initial(characteristic_flag) & IWOUND_PROGRESS)
			characteristic_flag |= IWOUND_PROGRESS
	else
		if(!used_autodoc && scar && ispath(scar, /datum/component))
			SEND_SIGNAL_OLD(parent, COMSIG_IORGAN_ADD_WOUND, pick(subtypesof(scar)))
		SEND_SIGNAL_OLD(parent, COMSIG_IORGAN_REMOVE_WOUND, src)

/datum/component/internal_wound/proc/apply_effects()
	var/obj/item/organ/internal/O = parent

	if(!islist(O.organ_efficiency))
		O.organ_efficiency = list()

	if(LAZYLEN(organ_efficiency_mod))
		for(var/organ in organ_efficiency_mod)
			var/added_efficiency = organ_efficiency_mod[organ]
			if(O.organ_efficiency.Find(organ))
				O.organ_efficiency[organ] += round(added_efficiency, 1)
			else
				O.organ_efficiency.Add(organ)
				O.organ_efficiency[organ] = round(added_efficiency, 1)

		if(O.owner && istype(O.owner, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = O.owner
			for(var/process in organ_efficiency_mod)
				if(!islist(H.internal_organs_by_efficiency[process]))
					H.internal_organs_by_efficiency[process] = list()
				H.internal_organs_by_efficiency[process] |= O

	if(organ_efficiency_multiplier)
		for(var/organ in O.organ_efficiency)
			O.organ_efficiency[organ] = round(O.organ_efficiency[organ] * (1 + organ_efficiency_multiplier), 1)

	if(specific_organ_size_multiplier)
		O.specific_organ_size *= 1 + round(specific_organ_size_multiplier, 0.01)
	if(max_blood_storage_multiplier)
		O.max_blood_storage *= 1 - round(max_blood_storage_multiplier, 0.01)
	if(blood_req_multiplier)
		O.blood_req *= 1 + round(blood_req_multiplier, 0.01)
	if(nutriment_req_multiplier)
		O.nutriment_req *= 1 + round(nutriment_req_multiplier, 0.01)
	if(oxygen_req_multiplier)
		O.oxygen_req *= 1 + round(oxygen_req_multiplier, 0.01)

/datum/component/internal_wound/proc/apply_limb_effects()
	var/obj/item/organ/internal/O = parent

	if(!O.parent)
		return

	if(hal_damage)
		O.parent.internal_wound_hal_dam += hal_damage * severity

/datum/component/internal_wound/proc/apply_flags()
	var/obj/item/organ/internal/O = parent

	if(!O.parent)
		return

	if(status_flag)
		O.parent.status |= status_flag

/datum/component/internal_wound/proc/remove_flags()
	var/obj/item/organ/internal/O = parent

	if(!O.parent)
		return

	if(status_flag)
		O.parent.status &= ~status_flag

/datum/component/internal_wound/proc/apply_damage()
	if(!(characteristic_flag & IWOUND_CAN_DAMAGE))
		return

	var/obj/item/organ/internal/O = parent

	if(severity)
		O.damage += severity
