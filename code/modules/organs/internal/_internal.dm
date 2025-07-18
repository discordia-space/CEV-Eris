/obj/item/organ/internal
	layer = ABOVE_LYING_MOB_LAYER
	origin_tech = list(TECH_BIO = 2)
	bad_type = /obj/item/organ/internal
	spawn_tags = SPAWN_TAG_ORGAN_INTERNAL
	max_damage = IORGAN_STANDARD_HEALTH
	min_bruised_damage = IORGAN_STANDARD_BRUISE
	min_broken_damage = IORGAN_STANDARD_BREAK
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
	var/list/wounddatums = list()

/obj/item/organ/internal/Initialize()
	. = ..()
	initialize_organ_efficiencies()
	initialize_owner_verbs()
	update_icon()
	RegisterSignal(src, COMSIG_IORGAN_ADD_WOUND, PROC_REF(add_wound))
	RegisterSignal(src, COMSIG_IORGAN_REMOVE_WOUND, PROC_REF(remove_wound))
	RegisterSignal(src, COMSIG_IORGAN_REFRESH_SELF, PROC_REF(refresh_upgrades))
	spawn(10)
		PostInit()

/obj/item/organ/internal/proc/PostInit()
	if(!get_limb())
		status |= ORGAN_CUT_AWAY

/obj/item/organ/internal/Process()
	refresh_damage()	// Death check is in the parent proc
	..()
	handle_blood()

/obj/item/organ/internal/die()
	..()
	handle_organ_eff()

/obj/item/organ/internal/Destroy()
	QDEL_LIST(item_upgrades)
	for(var/wound in wounddatums)
		var/datum/internal_wound/refwound = wounddatums[wound]
		wounddatums.Remove(wound)
		qdel(refwound)
		refwound.parent = null // don't want it clogging up the queue
	UnregisterSignal(src, COMSIG_IORGAN_ADD_WOUND)
	UnregisterSignal(src, COMSIG_IORGAN_REMOVE_WOUND)
	UnregisterSignal(src, COMSIG_IORGAN_REFRESH_SELF)
	..()

/obj/item/organ/internal/removed()
	UnregisterSignal(parent, COMSIG_IORGAN_WOUND_COUNT)
	UnregisterSignal(parent, COMSIG_IORGAN_REFRESH_PARENT)
	UnregisterSignal(parent, COMSIG_IORGAN_APPLY)
	SEND_SIGNAL(src, COMSIG_IWOUND_FLAGS_REMOVE)
	..()

/obj/item/organ/internal/removed_mob()
	action_button_name = initial(action_button_name)
	action_button_proc = initial(action_button_proc)
	action_button_is_hands_free = initial(action_button_is_hands_free)

	for(var/process in organ_efficiency)
		owner.internal_organs_by_efficiency[process] -= src

	owner.internal_organs -= src

	var/skipverbs = FALSE
	for(var/organ in owner.internal_organs)
		var/obj/I = organ
		if(I.type == type)
			skipverbs = TRUE
	if(!skipverbs)
		remove_verb(owner, owner_verbs)
	for(var/datum/internal_wound/got_wound in wounddatums)
		if(istype(got_wound, /datum/internal_wound/organic/parenchyma))
			owner.mutation_index--
	..()

/obj/item/organ/internal/replaced(obj/item/organ/external/affected)
	..()
	parent.internal_organs |= src
	parent.internal_organs[src] = specific_organ_size // Larger organs have greater pick weight for organ damage
	RegisterSignal(parent, COMSIG_IORGAN_WOUND_COUNT, PROC_REF(wound_count), TRUE)
	RegisterSignal(parent, COMSIG_IORGAN_REFRESH_PARENT, PROC_REF(refresh_organ_stats), TRUE)
	RegisterSignal(parent, COMSIG_IORGAN_APPLY, PROC_REF(apply_modifiers), TRUE)
	SEND_SIGNAL(src, COMSIG_IWOUND_FLAGS_ADD)

/obj/item/organ/internal/replaced_mob(mob/living/carbon/human/target)
	..()
	owner.internal_organs |= src
	for(var/process in organ_efficiency)
		if(!islist(owner.internal_organs_by_efficiency[process]))
			owner.internal_organs_by_efficiency[process] = list()
		if(is_usable())
			owner.internal_organs_by_efficiency[process] |= src
		else
			owner.internal_organs_by_efficiency[process] -= src

	add_verb(owner, owner_verbs)

	for(var/datum/internal_wound/got_wound in wounddatums)
		if(istype(got_wound, /datum/internal_wound/organic/parenchyma))
			owner.mutation_index++

	SEND_SIGNAL(src, COMSIG_ADDVAL)

/obj/item/organ/internal/proc/handle_organ_eff()
	for(var/process in organ_efficiency)
		if(is_usable())
			owner.internal_organs_by_efficiency[process] |= src
		else
			owner?.internal_organs_by_efficiency[process] -= src // dead organs don't necessarily have an owner

/obj/item/organ/internal/proc/get_process_efficiency(process_define)
	var/organ_eff = organ_efficiency[process_define]
	return organ_eff - (organ_eff * (damage / max_damage))

/obj/item/organ/internal/take_damage(amount, damage_type = BRUTE, wounding_multiplier = 1, silent = FALSE, sharp = FALSE, edge = FALSE)	//Deals damage to the organ itself
	if(!damage_type || status & ORGAN_DEAD)
		return FALSE
	var/fixed = amount / (damage_type == BRUTE || damage_type == BURN ? 4 : 8)
	var/wound_count = max(0, ROUND_PROB(fixed))	// At base values, every 8 points of damage is 1 wound, or 4 if brute or burn.

	if(!wound_count)
		return FALSE

	var/list/possible_wounds = get_possible_wounds(damage_type, sharp, edge)

	if(LAZYLEN(possible_wounds))
		for(var/i in 1 to wound_count)
			var/choice = pick(possible_wounds)
			add_wound(choice)
			//LAZYREMOVE(possible_wounds, choice) // If this is commented out, we can get a higher severity of a single wound
			if(!LAZYLEN(possible_wounds))
				break
	else
	
		return TRUE
	return FALSE

/obj/item/organ/internal/proc/get_possible_wounds(damage_type, sharp, edge)
	var/list/possible_wounds = list()

	// Determine possible wounds based on nature and damage type
	var/is_robotic = BP_IS_ROBOTIC(src) || BP_IS_ASSISTED(src)
	var/is_organic = BP_IS_ORGANIC(src) || BP_IS_ASSISTED(src)

	switch(damage_type)
		if(BRUTE)
			if(!edge)
				if(sharp)
					if(is_organic)
						LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/organic/sharp))
					if(is_robotic)
						LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/robotic/sharp))
				else
					if(is_organic)
						LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/organic/blunt))
					if(is_robotic)
						LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/robotic/blunt))
			else
				if(is_organic)
					LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/organic/edge))
				if(is_robotic)
					LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/robotic/edge))
		if(BURN)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/organic/burn))
			if(is_robotic)
				LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/robotic/emp_burn))
		if(TOX)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/organic/poisoning))
		if(CLONE)
			if(is_organic)
				LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/organic/radiation))
		if(PSY)
			if(LAZYACCESS(organ_efficiency, OP_EYES) || LAZYACCESS(organ_efficiency, BP_BRAIN))
				if(is_organic)
					LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/organic/sanity))
				if(is_robotic)
					LAZYADD(possible_wounds, subtypesof(/datum/internal_wound/robotic/sanity))

	return possible_wounds

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
			var/datum/internal_wound/currentcomponent = wounddatums[/datum/internal_wound/organic/oxy/blood_loss]
			if(!(BV?.current_blood) && !(currentcomponent?.name == "blood loss"))
				add_wound(/datum/internal_wound/organic/oxy/blood_loss)

		return

	// If the bleedout status is removed, remove blood loss wound
	if(damage)
		remove_wound(wounddatums[/datum/internal_wound/organic/oxy/blood_loss])

	current_blood = min(current_blood + blood_req, max_blood_storage)

/obj/item/organ/internal/examine(mob/user, extra_description = "")
	if(user.stats?.getStat(STAT_BIO) > STAT_LEVEL_BASIC)
		extra_description += SPAN_NOTICE("\nOrgan size: [specific_organ_size]")
	if(user.stats?.getStat(STAT_BIO) > STAT_LEVEL_EXPERT - 5)
		var/organs
		for(var/organ in organ_efficiency)
			organs += organ + " ([organ_efficiency[organ]]), "
		organs = copytext(organs, 1, length(organs) - 1)

		extra_description += SPAN_NOTICE("\nRequirements: <span style='color:red'>[blood_req]</span>/<span style='color:blue'>[oxygen_req]</span>/<span style='color:orange'>[nutriment_req]</span>")
		extra_description += SPAN_NOTICE("\nOrgan tissues present (efficiency): <span style='color:pink'>[organs ? organs : "none"]</span>")

		if(item_upgrades.len)
			extra_description += SPAN_NOTICE("\nOrgan grafts present ([item_upgrades.len]/[max_upgrades]). Use a laser cutting tool to remove.")
	..(user, extra_description)

/obj/item/organ/internal/is_usable()
	return ..() && !is_broken()

/obj/item/organ/internal/heal_damage(amount, natural = TRUE)
	return

/obj/item/organ/internal/emp_act(severity)
	if(!BP_IS_ROBOTIC(src))
		return
	switch(severity)
		if(1)
			take_damage(18, BURN)
		if(2)
			take_damage(12, BURN)
		if(3)
			take_damage(6, BURN)

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
			LAZYADD(possible_wounds, /datum/internal_wound/organic/bone_fracture)
		if(is_robotic)
			LAZYADD(possible_wounds, /datum/internal_wound/robotic/deformation)

		if(LAZYLEN(possible_wounds))
			var/choice = pick(possible_wounds)
			add_wound(choice)

		if(owner)
			playsound(loc, 'sound/weapons/jointORbonebreak.ogg', 50, 1, -1)

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
			var/organic_wound = wounddatums[/datum/internal_wound/organic/bone_fracture]
			if(organic_wound)
				remove_wound(organic_wound)
		if(is_robotic)
			var/robotic_wound =  wounddatums[/datum/internal_wound/robotic/deformation]
			if(robotic_wound)
				remove_wound(robotic_wound)

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
		else if(BP_IS_ASSISTED(src))
			actions_list.Add(list(list(
				"name" = (parent.status & ORGAN_BROKEN) ? "Mend" : "Break",
				"organ" = "\ref[src]",
				"step" = (parent.status & ORGAN_BROKEN) ? /datum/surgery_step/assisted/mend_bone : /datum/surgery_step/assisted/break_bone
			)))
			actions_list.Add(list(list(
					"name" = "Replace",
					"organ" = "\ref[src]",
					"step" = /datum/surgery_step/assisted/replace_bone
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

// Mutations
/obj/item/organ/internal/proc/unmutate()
	if(!BP_IS_ORGANIC(src) || !BP_IS_ASSISTED(src))
		return

	for(var/wound in wounddatums)
		if(ispath(wound, /datum/internal_wound/organic/radiation))
			remove_wound(wounddatums[wound])

/obj/item/organ/internal/proc/get_wounds()
	var/list/wound_data = list()

	for(var/woundpath in wounddatums)
		var/datum/internal_wound/IW = wounddatums[woundpath]
		var/treatment_info = ""
		var/list/treatments = IW.treatments_item + IW.treatments_tool + IW.treatments_chem

		// Make treatments into a string for the UI
		for(var/treatment in treatments)
			var/name = treatment
			if(ispath(treatment))
				var/atom/movable/AM = treatment
				name = initial(AM.name)
			treatment_info += "[name] ([num2text(treatments[treatment])]), "

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

	for(var/atom/M as anything in item_upgrades)

		mod_data += list(list(
			"name" = M.name
		))

	return mod_data

/obj/item/organ/internal/rejuvenate()
	status = null
	current_blood = initial(current_blood)
	for(var/woundtype in wounddatums)
		remove_wound(wounddatums[woundtype])

// Store these so we can properly restore them when installing/removing mods
/obj/item/organ/internal/proc/initialize_organ_efficiencies()
	initial_organ_efficiency = organ_efficiency.Copy()

/obj/item/organ/internal/proc/initialize_owner_verbs()
	initial_owner_verbs = owner_verbs.Copy()

/obj/item/organ/internal/refresh_upgrades()
	refresh_organ_stats()
	apply_modifiers()

/obj/item/organ/internal/proc/refresh_organ_stats()
	name = initial(name)
	color = initial(color)
	max_upgrades = initial(max_upgrades)
	prefixes = list()
	min_bruised_damage = initial(min_bruised_damage)
	min_broken_damage = initial(min_broken_damage)
	max_damage = initial(max_damage)
	if(owner)
		remove_verb(owner, owner_verbs)
	owner_verbs = initial_owner_verbs.Copy()
	if(owner)
		add_verb(owner, owner_verbs)
	organ_efficiency = initial_organ_efficiency.Copy()
	scanner_hidden = initial(scanner_hidden)
	unique_tag = initial(unique_tag)
	specific_organ_size = initial(specific_organ_size)
	max_blood_storage = initial(max_blood_storage)
	current_blood = initial(current_blood)
	blood_req = initial(blood_req)
	nutriment_req = initial(nutriment_req)
	oxygen_req = initial(oxygen_req)
	SEND_SIGNAL(src, COMSIG_IWOUND_FLAGS_REMOVE)

/obj/item/organ/internal/proc/apply_modifiers()
	for(var/type_wound in wounddatums)
		var/datum/internal_wound/got_wound = wounddatums[type_wound]
		got_wound.apply_effects()
		got_wound.apply_limb_effects()
		got_wound.apply_flags()
	SEND_SIGNAL(src, COMSIG_APPVAL)
	SEND_SIGNAL(src, COMSIG_APPVAL_MULT)
	SEND_SIGNAL(src, COMSIG_APPVAL_FLAT)

	refresh_damage()

	for(var/prefix in prefixes)
		name = "[prefix] [name]"

/obj/item/organ/internal/proc/refresh_damage()
	if(status & ORGAN_DEAD)
		damage = max_damage
		return
	damage = initial(damage)
	for(var/type_wound in wounddatums)
		var/datum/internal_wound/got_wound = wounddatums[type_wound]
		got_wound.apply_damage()

/obj/item/organ/internal/proc/add_wound(datum/internal_wound/IW, wound_name = null)
	if(!IW || initial(IW.wound_nature) != nature || status & ORGAN_DEAD)
		return
	if(IW in wounddatums)
		var/datum/internal_wound/old_wound = wounddatums[IW]
		old_wound.progress()	// Getting a new wound of the same type as an existing wound will progress it
	else
		var/datum/internal_wound/new_wound = new IW()
		if(wound_name)
			new_wound.name = wound_name
		wounddatums[new_wound.type] = new_wound
		new_wound.parent = src
		new_wound.Finalize()
	refresh_upgrades()

/obj/item/organ/internal/proc/remove_wound(datum/internal_wound/wound)
	if(!wound)
		return
	refresh_organ_stats()	// Split like this because we need to remove flags,
	wounddatums.Remove(wound.type)
	qdel(wound)				// remove the wound (which may apply a flag that shouldn't be there anymore),
	apply_modifiers()		// and re-apply existing flags

/obj/item/organ/internal/proc/wound_count()
	if(!parent)
		return
	if(wounddatums)
		parent.number_internal_wounds += LAZYLEN(wounddatums)
		parent.severity_internal_wounds += damage
	parent.total_internal_health += max_damage
