/obj/item/organ/internal
	layer = ABOVE_LYING_MOB_LAYER
	origin_tech = list(TECH_BIO = 2)
	bad_type = /obj/item/organ/internal
	spawn_tags = SPAWN_TAG_ORGAN_INTERNAL
	max_damage = 10
	min_bruised_damage = 2
	min_broken_damage = 4
	desc = "A vital organ."
	var/list/owner_verbs = list()
	var/list/initial_owner_verbs = list()
	var/list/organ_efficiency = list()	//Efficency of an organ, should become the most important variable
	var/list/initial_organ_efficiency = list()
	var/scanner_hidden = FALSE	//Does this organ show up on the body scanner
	var/unique_tag	//If an organ is unique and doesn't scale off of organ processes
	var/specific_organ_size = 1  //Space organs take up in weight calculations, unaffected by w_class for balance reasons
	var/max_blood_storage = 0	//How much blood an organ stores. Base is 5 * blood_req, so the organ can survive without blood for 5 ticks beofre taking damage (+ blood supply of blood vessels)
	var/current_blood = 100	//How much blood is currently in the organ
	var/blood_req = 0	//How much blood an organ takes to funcion
	var/nutriment_req = 0	//Controls passive nutriment loss
	var/oxygen_req = 0	//If oxygen reqs are not satisfied, get debuff and brain starts taking damage
	var/list/prefixes = list()

	// Internal
	var/signals_registered = FALSE		// Needs to exist because mobs don't get their tags until after organs are created. Tags are needed to register signals.

/obj/item/organ/internal/New(mob/living/carbon/human/holder, datum/organ_description/OD)
	..()
	initialize_organ_efficiencies()
	initialize_owner_verbs()
	update_icon()

/obj/item/organ/internal/Process()
	// Needs to exist because mobs don't get their tags until after organs are created. Tags are needed to register signals.
	if(!signals_registered)
		RegisterSignal(src, COMSIG_I_ORGAN_ADD_WOUND, .proc/add_wound)
		RegisterSignal(src, COMSIG_I_ORGAN_REMOVE_WOUND, .proc/remove_wound)
		RegisterSignal(src, COMSIG_I_ORGAN_REFRESH, .proc/refresh_upgrades)
		if(parent)
			RegisterSignal(parent, COMSIG_I_ORGAN_WOUND_COUNT, .proc/wound_count)
		signals_registered = TRUE

	refresh_damage()	// Death check is in the parent proc
	..()
	handle_blood()
	handle_regeneration()

/obj/item/organ/internal/Destroy()
	var/list/organ_components = GetComponents(/datum/component)
	for(var/datum/component/comp in organ_components)
		if(istype(comp, /datum/component/internal_wound))
			remove_wound(comp)
		else
			qdel(comp)
	for(var/mod in item_upgrades)
		qdel(mod)
	item_upgrades.Cut()
	UnregisterSignal(src, COMSIG_I_ORGAN_ADD_WOUND)
	UnregisterSignal(src, COMSIG_I_ORGAN_REMOVE_WOUND)
	UnregisterSignal(src, COMSIG_I_ORGAN_REFRESH)
	if(parent)
		UnregisterSignal(parent, COMSIG_I_ORGAN_WOUND_COUNT)
	..()

/obj/item/organ/internal/removed()
	UnregisterSignal(parent, COMSIG_I_ORGAN_WOUND_COUNT)
	SEND_SIGNAL(src, COMSIG_WOUND_FLAGS_REMOVE)
	..()

/obj/item/organ/internal/removed_mob()
	for(var/process in organ_efficiency)
		owner.internal_organs_by_efficiency[process] -= src

	owner.internal_organs -= src

	var/skipverbs = FALSE
	for(var/organ in owner.internal_organs)
		var/obj/I = organ
		if(I.type == type)
			skipverbs = TRUE
	if(!skipverbs)
		for(var/verb_path in owner_verbs)
			verbs -= verb_path
	..()

/obj/item/organ/internal/replaced(obj/item/organ/external/affected)
	..()
	parent.internal_organs |= src
	RegisterSignal(parent, COMSIG_I_ORGAN_WOUND_COUNT, .proc/wound_count)
	SEND_SIGNAL(src, COMSIG_WOUND_FLAGS_ADD)

/obj/item/organ/internal/replaced_mob(mob/living/carbon/human/target)
	..()
	owner.internal_organs |= src
	for(var/process in organ_efficiency)
		if(!islist(owner.internal_organs_by_efficiency[process]))
			owner.internal_organs_by_efficiency[process] = list()
		owner.internal_organs_by_efficiency[process] += src

	for(var/proc_path in owner_verbs)
		verbs |= proc_path

/obj/item/organ/internal/proc/get_process_efficiency(process_define)
	var/organ_eff = organ_efficiency[process_define]
	return organ_eff - (organ_eff * (damage / max_damage))

/obj/item/organ/internal/take_damage(amount, silent, damage_type = null, sharp = FALSE, edge = FALSE)	//Deals damage to the organ itself
	if(!damage_type)
		return

	// Determine possible wounds based on nature and damage type
	var/is_robotic = BP_IS_ROBOTIC(src) || BP_IS_ASSISTED(src)
	var/is_organic = BP_IS_ORGANIC(src) || BP_IS_ASSISTED(src)
	var/list/possible_wounds = list()

	var/total_damage = amount * (100 / (parent ? parent.limb_efficiency : 100))
	var/wound_count = max(0, round(total_damage / 10, 1))	// Every 10 points of damage is a wound

	if((!is_organic && !is_robotic) || !wound_count)
		return

	switch(damage_type)
		if(BRUTE)
			if(!edge)
				if(sharp)
					if(is_organic)
						LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/organic/sharp))
					if(is_robotic)
						LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/robotic/sharp))
				else
					if(is_organic)
						LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/organic/blunt))
					if(is_robotic)
						LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/robotic/blunt))
			else
				if(is_organic)
					LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/organic/edge))
				if(is_robotic)
					LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/robotic/edge))
		if(BURN)
			if(is_organic)
				LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/organic/burn))
			if(is_robotic)
				LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/robotic/emp_burn))
		if(TOX)
			if(is_organic)
				LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/organic/poisoning))
			if(is_robotic)
				LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/robotic/build_up))

	if(is_organic)
		LAZYREMOVE(possible_wounds, GetComponents(/datum/component/internal_wound/organic))	// Organic wounds don't stack

	if(LAZYLEN(possible_wounds))
		for(var/i in 1 to wound_count)
			var/choice = pick(possible_wounds)
			add_wound(choice)	
			if(ispath(choice, /datum/component/internal_wound/organic))
				LAZYREMOVE(possible_wounds, choice)
			if(!LAZYLEN(possible_wounds))
				break

	if(!BP_IS_ROBOTIC(src) && owner && parent && amount > 0 && !silent)
		owner.custom_pain("Something inside your [parent.name] hurts a lot.", 1)

/obj/item/organ/internal/proc/handle_blood()
	if(BP_IS_ROBOTIC(src) || !owner)
		return
	if(!blood_req)
		return
	if(OP_BLOOD_VESSEL in organ_efficiency && !(owner.status_flags & BLEEDOUT))
		current_blood = min(current_blood + 5, max_blood_storage)	//Blood vessels get an extra flat 5 blood regen

	if(owner.status_flags & BLEEDOUT)
		current_blood = max(current_blood - blood_req, 0)
		if(!current_blood)	//When all blood is lost, take blood from blood vessels
			var/obj/item/organ/internal/BV
			for(var/organ in shuffle(parent.internal_organs))
				var/obj/item/organ/internal/I = organ
				if(OP_BLOOD_VESSEL in I.organ_efficiency)
					BV = I
					break
			if(BV)
				BV.current_blood = max(BV.current_blood - blood_req, 0)
			if(BV?.current_blood == 0)	//When all blood from the organ and blood vessel is lost, 
				add_wound(/datum/component/internal_wound/organic/blood_loss)

		return

	current_blood = min(current_blood + blood_req, max_blood_storage)

/obj/item/organ/internal/proc/handle_regeneration()
	return

/obj/item/organ/internal/examine(mob/user)
	. = ..()
	if(user.stats?.getStat(STAT_BIO) > STAT_LEVEL_BASIC)
		to_chat(user, SPAN_NOTICE("Organ size: [specific_organ_size]"))
	if(user.stats?.getStat(STAT_BIO) > STAT_LEVEL_EXPERT - 5)
		var/organs
		for(var/organ in organ_efficiency)
			organs += organ + " ([organ_efficiency[organ]]), "
		organs = copytext(organs, 1, length(organs) - 1)

		to_chat(user, SPAN_NOTICE("Requirements: <span style='color:red'>[blood_req]</span>/<span style='color:blue'>[oxygen_req]</span>/<span style='color:orange'>[nutriment_req]</span>"))
		to_chat(user, SPAN_NOTICE("Organ tissues present (efficiency): <span style='color:pink'>[organs ? organs : "none"]</span>"))

		if(item_upgrades.len)
			to_chat(user, SPAN_NOTICE("Organ grafts present ([item_upgrades.len]/[max_upgrades]). Use a laser cutting tool to remove."))

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/heal_damage(amount, natural = TRUE)
	return

/obj/item/organ/internal/emp_act(severity)
	if(!BP_IS_ROBOTIC(src))
		return
	switch(severity)
		if(1)
			take_damage(18, FALSE, BURN)
		if(2)
			take_damage(12, FALSE, BURN)
		if(3)
			take_damage(6, FALSE, BURN)

// Is body part open for most surgerical operations?
/obj/item/organ/internal/is_open()
	var/obj/item/organ/external/limb = get_limb()

	if(limb)
		return limb.is_open()
	else
		return TRUE

// The bone zone
/obj/item/organ/internal/proc/fracture()
	if(LAZYACCESS(organ_efficiency, OP_BONE))
		// Determine possible wounds based on nature and damage type
		var/is_robotic = BP_IS_ROBOTIC(src) || BP_IS_ASSISTED(src)
		var/is_organic = BP_IS_ORGANIC(src) || BP_IS_ASSISTED(src)
		var/list/possible_wounds = list()

		if(is_organic)
			LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/organic/bone_fracture))
		if(is_robotic)
			LAZYADD(possible_wounds, typesof(/datum/component/internal_wound/robotic/deformation))

		if(LAZYLEN(possible_wounds))
			var/choice = pick(possible_wounds)
			add_wound(choice)

		if(owner)
			owner.visible_message(
				SPAN_DANGER("You hear a loud cracking sound coming from \the [owner]."),
				SPAN_DANGER("Something feels like it shattered in your [name]"),
				SPAN_DANGER("You hear a sickening crack.")
			)
			if(owner.species && !(owner.species.flags & NO_PAIN))
				owner.emote("scream")
		
			// Fractures have a chance of getting you out of restraints
			if(prob(25))
				parent.release_restraints()

/obj/item/organ/internal/proc/mend()
	if(LAZYACCESS(organ_efficiency, OP_BONE))
		parent.status &= ~ORGAN_SPLINTED

		// Determine possible wounds based on nature and damage type
		var/is_robotic = BP_IS_ROBOTIC(src) || BP_IS_ASSISTED(src)
		var/is_organic = BP_IS_ORGANIC(src) || BP_IS_ASSISTED(src)

		if(is_organic)
			remove_wound(/datum/component/internal_wound/organic/bone_fracture)
		if(is_robotic)
			remove_wound(/datum/component/internal_wound/robotic/deformation)

/obj/item/organ/internal/get_actions()
	var/list/actions_list = ..()

	if(LAZYACCESS(organ_efficiency, OP_BONE))
		if(BP_IS_ROBOTIC(src))
			if(parent.status & ORGAN_BROKEN)
				actions_list.Add(list(list(
					"name" = "Mend",
					"organ" = "\ref[src]",
					"step" = /datum/surgery_step/robotic/fix_bone
				)))
		else
			actions_list.Add(list(list(
				"name" = (parent.status & ORGAN_BROKEN) ? "Mend" : "Break",
				"organ" = "\ref[src]",
				"step" = (parent.status & ORGAN_BROKEN) ? /datum/surgery_step/mend_bone : /datum/surgery_step/break_bone
			)))
			actions_list.Add(list(list(
					"name" = "Replace",
					"organ" = "\ref[src]",
					"step" = /datum/surgery_step/replace_bone
				)))

	return actions_list
// End of the bone zone

/obj/item/organ/internal/proc/get_wounds()
	var/list/wound_list = GetComponents(/datum/component/internal_wound)
	var/list/wound_data = list()

	if(wound_list && LAZYLEN(wound_list) && wound_list[1])	// GetComponents with no components returns a list with a null element 
		for(var/wound in wound_list)
			var/datum/component/internal_wound/IW = wound
			var/treatment_info = ""
			var/list/treatments = IW.treatments_item + IW.treatments_tool + IW.treatments_chem

			// Make treatments into a string for the UI
			for(var/treatment in treatments)
				treatment_info += "[treatment] ([num2text(treatments[treatment])]), "
			
			if(length(treatment_info))
				treatment_info = copytext(treatment_info, 1, length(treatment_info) - 1)

			wound_data += list(list(
				"name" = IW.name,
				"severity" = IW.severity,
				"severity_max" = IW.severity_max,
				"treatments" = treatment_info,
				"wound" = "\ref[IW]"
			))

	return wound_data

/obj/item/organ/internal/proc/get_mods()
	var/list/mod_data = list()

	if(item_upgrades && LAZYLEN(item_upgrades))
		for(var/mod in item_upgrades)
			var/obj/item/modification/M = mod

			mod_data += list(list(
				"name" = M.name
			))

	return mod_data

// Store these so we can properly restore them when installing/removing mods
/obj/item/organ/internal/proc/initialize_organ_efficiencies()
	initial_organ_efficiency = organ_efficiency.Copy()

/obj/item/organ/internal/proc/initialize_owner_verbs()
	initial_owner_verbs = owner_verbs.Copy()

/obj/item/organ/internal/refresh_upgrades()
	name = initial(name)
	color = initial(color)
	max_upgrades = initial(max_upgrades)
	prefixes = list()
	min_bruised_damage = initial(min_bruised_damage)
	min_broken_damage = initial(min_broken_damage)
	max_damage = initial(max_damage)
	owner_verbs = initial(owner_verbs)
	organ_efficiency = initial_organ_efficiency.Copy()
	scanner_hidden = initial(scanner_hidden)
	unique_tag = initial(unique_tag)
	specific_organ_size = initial(specific_organ_size)
	max_blood_storage = initial(max_blood_storage)
	current_blood = initial(current_blood)
	blood_req = initial(blood_req)
	nutriment_req = initial(nutriment_req)
	oxygen_req = initial(oxygen_req)
	SEND_SIGNAL(src, COMSIG_WOUND_FLAGS_REMOVE)

	// Should split this into two procs due to the flags overwriting each other

	SEND_SIGNAL(src, COMSIG_WOUND_EFFECTS)
	SEND_SIGNAL(src, COMSIG_APPVAL, src)
	SEND_SIGNAL(src, COMSIG_WOUND_FLAGS_ADD)

	for(var/prefix in prefixes)
		name = "[prefix] [name]"

/obj/item/organ/internal/proc/refresh_damage()
	damage = initial(damage)
	SEND_SIGNAL(src, COMSIG_WOUND_DAMAGE)

/obj/item/organ/internal/proc/add_wound(datum/component/new_wound)
	var/datum/component/internal_wound/IW = new_wound
	if(!IW || initial(IW.wound_nature) != nature)
		return

	var/datum/component/internal_wound/to_add = AddComponent(IW)
	SSinternal_wounds.processing += to_add		// We don't use START_PROCESSING because it doesn't allow for multiple subsystems
	refresh_upgrades()

/obj/item/organ/internal/proc/remove_wound(datum/component/wound)
	if(!wound)
		return
	SSinternal_wounds.processing -= wound	// We don't use STOP_PROCESSING because we don't use START_PROCESSING
	qdel(wound)
	refresh_upgrades()

/obj/item/organ/internal/proc/wound_count()
	if(!parent)
		return
	var/list/wounds = GetComponents(/datum/component/internal_wound)
	if(wounds)
		parent.number_internal_wounds += LAZYLEN(wounds)
		parent.severity_internal_wounds += damage
