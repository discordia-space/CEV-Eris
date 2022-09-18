/datum/individual_objective/upgrade
	name = "Upgrade"
	desc =  "Its time to improve your meat with shiny chrome. Gain new bionics, implant, or any mutation."
	allow_cruciform = FALSE

/datum/individual_objective/upgrade/can_assign(mob/living/carbon/human/H)
	if(!..())
		return FALSE
	for(var/obj/item/organ/external/Ex in H.organs)
		if(!BP_IS_ROBOTIC(Ex))
			return TRUE
	return FALSE

/datum/individual_objective/upgrade/assign()
	..()
	RegisterSignal(mind_holder, COMSIG_HUMAN_ROBOTIC_MODIFICATION, .proc/completed)

/datum/individual_objective/upgrade/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_ROBOTIC_MODIFICATION)
	..()

/datum/individual_objective/inspiration
	name = "Triumph of the Spirit"
	desc =  "Observer at least one positive breakdown. Inspiring!"
	var/breakdown_type = /datum/breakdown/positive

/datum/individual_objective/inspiration/assign()
	..()
	RegisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN, .proc/task_completed)

/datum/individual_objective/inspiration/task_completed(mob/living/L, datum/breakdown/breakdown)
	if(istype(breakdown, breakdown_type) && L != mind_holder)
		completed()

/datum/individual_objective/inspiration/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN)
	..()

/datum/individual_objective/derange
	name = "Derange"
	limited_antag = TRUE
	rarity = 4
	var/mob/living/carbon/human/target

/datum/individual_objective/derange/can_assign(mob/living/L)
	if(!..())
		return FALSE
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - L
	return candidates.len

/datum/individual_objective/derange/assign()
	..()
	var/list/valid_targets = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - mind_holder
	target = pick(valid_targets)
	desc = "[target] really pisses you off, ensure that they will get a mental breakdown."
	RegisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN, .proc/task_completed)

/datum/individual_objective/derange/task_completed(mob/living/L, datum/breakdown/breakdown)
	if(L == target)
		completed()

/datum/individual_objective/derange/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN)
	..()

#define MOB_ADD_DRUG 1
#define ON_MOB_DRUG 2
#define MOB_DELETE_DRUG 3

/datum/individual_objective/addict
	name = "Oil the Cogs"
	based_time = TRUE
	units_requested = 5 MINUTES
	var/list/drugs = list()
	var/timer

/datum/individual_objective/addict/assign()
	..()
	timer = world.time
	desc = "Stay intoxicated by alcohol or recreational drugs for [unit2time(units_requested)] minutes."
	RegisterSignal(mind_holder, COMSIG_CARBON_HAPPY, .proc/task_completed)

/datum/individual_objective/addict/task_completed(datum/reagent/happy, signal)
	if(!drugs.len)
		timer = world.time
	if(!(happy.id in drugs))
		if(signal != MOB_DELETE_DRUG)
			drugs += happy.id
	else if(signal == MOB_DELETE_DRUG)
		drugs -= happy.id
	else if(signal == ON_MOB_DRUG)
		units_completed += abs(world.time - timer)
		timer = world.time
	if(check_for_completion())
		completed()

/datum/individual_objective/addict/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_CARBON_HAPPY)
	..()

/datum/individual_objective/gift
	name = "Gift"
	desc = "You feel a need to leave a mark in other people lives. Ensure that at \
			least someone will level up with oddity that you touched."

/datum/individual_objective/gift/assign()
	..()
	RegisterSignal(mind_holder, COMSIG_HUMAN_ODDITY_LEVEL_UP, .proc/task_completed)

/datum/individual_objective/gift/task_completed(mob/living/carbon/human/H, obj/item/O)
	if(mind_holder == H) return
	var/full_print = mind_holder.get_full_print()
	if(full_print in O.fingerprints)
		completed()

/datum/individual_objective/gift/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_ODDITY_LEVEL_UP)
	..()

/datum/individual_objective/protector
	name = "Protector"
	units_requested = 15 MINUTES
	based_time = TRUE
	var/mob/living/carbon/human/target
	var/timer
	var/health_threshold = 50

/datum/individual_objective/protector/can_assign(mob/living/L)
	if(!..())
		return FALSE
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - L
	return candidates.len

/datum/individual_objective/protector/assign()
	..()
	var/list/valid_targets = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - mind_holder
	target = pick(valid_targets)
	desc = "Ensure that [target] will not get their health lowered to [health_threshold] and below \
			for [unit2time(units_requested)] minutes. Timer resets if health reaches the threshold."
	timer = world.time
	RegisterSignal(target, COMSIG_HUMAN_HEALTH, .proc/task_completed)

/datum/individual_objective/protector/task_completed(health)
	if(health < health_threshold)
		units_completed = 0
		timer = world.time
		return
	var/n_timer = world.time
	if(n_timer > timer)
		units_completed += n_timer - timer
		timer = world.time
	if(check_for_completion())
		completed()

/datum/individual_objective/protector/completed()
	if(completed) return
	UnregisterSignal(target, COMSIG_HUMAN_HEALTH)
	..()

/datum/individual_objective/helper
	name = "Helping Hand"
	units_requested = 5 MINUTES
	based_time = TRUE
	var/mob/living/carbon/human/target
	var/timer
	var/sanity_threshold = 50

/datum/individual_objective/helper/can_assign(mob/living/L)
	if(!..())
		return FALSE
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - L
	return candidates.len

/datum/individual_objective/helper/assign()
	..()
	var/list/valid_targets = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - mind_holder
	target = pick(valid_targets)
	desc = "Ensure that [target] will not get their sanity lowered to [sanity_threshold] and below \
			for [unit2time(units_requested)] minutes. Timer resets if sanity reaches the threshold."
	timer = world.time
	RegisterSignal(target, COMSIG_HUMAN_SANITY, .proc/task_completed)

/datum/individual_objective/helper/task_completed(sanity)
	if(sanity < sanity_threshold)
		units_completed = 0
		timer = world.time
		return
	var/n_timer = world.time
	if(n_timer > timer)
		units_completed += n_timer - timer
		timer = world.time
	if(check_for_completion())
		completed()

/datum/individual_objective/helper/completed()
	if(completed) return
	UnregisterSignal(target, COMSIG_HUMAN_SANITY)
	..()

/datum/individual_objective/obsession
	name = "Obsessive Observation"
	var/mob/living/carbon/human/target
	var/timer
	units_requested = 3 MINUTES
	based_time = TRUE

/datum/individual_objective/obsession/can_assign(mob/living/L)
	if(!..())
		return FALSE
	var/list/candidates = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - L
	return candidates.len

/datum/individual_objective/obsession/assign()
	..()
	var/list/valid_targets = (GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - mind_holder
	target = pick(valid_targets)
	desc = "There is something interesting in [target]. For [unit2time(units_requested)] minutes, you need \
			to keep eye contact with them, and keep them in your view. Cameras will not work."
	timer = world.time
	RegisterSignal(mind_holder, COMSIG_MOB_LIFE, .proc/task_completed)

/datum/individual_objective/obsession/task_completed()
	if(mind_holder.stat == DEAD)
		return
	if(target in view(mind_holder))
		units_completed += abs(world.time - timer)
		timer = world.time
	else
		timer = world.time
		units_completed = 0
	if(check_for_completion())
		completed()

/datum/individual_objective/obsession/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_MOB_LIFE)
	..()

/datum/individual_objective/greed
	name = "Greed"
	units_requested = 10 MINUTES
	based_time = TRUE
	limited_antag = TRUE
	rarity = 4
	var/obj/item/target
	var/timer

/datum/individual_objective/greed/can_assign(mob/living/L)
	if(!..())
		return FALSE
	return pick_faction_item(L, TRUE)

/datum/individual_objective/greed/assign()
	..()
	target = pick_faction_item(mind_holder, TRUE)
	desc = "Acquire and hold \the [target] for [unit2time(units_requested)] minutes."
	timer = world.time
	RegisterSignal(mind_holder, COMSIG_MOB_LIFE, .proc/task_completed)

/datum/individual_objective/greed/task_completed()
	if(mind_holder.stat == DEAD)
		return
	var/find = FALSE
	for(var/obj/item/I in mind_holder.GetAllContents())
		if(target.type == I.type)
			units_completed += abs(world.time - timer)
			timer = world.time
			find = TRUE
	if(!find)
		timer = world.time
		units_completed = 0
	if(check_for_completion())
		completed()

/datum/individual_objective/greed/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_MOB_LIFE)
	..()

/datum/individual_objective/collenction
	name = "Collection"
	var/obj/item/target

/datum/individual_objective/collenction/proc/pick_candidates()
	var/obj/randomcatcher/CATCH = new /obj/randomcatcher
	return CATCH.get_item(/obj/spawner/gun/normal)

/datum/individual_objective/collenction/assign()
	..()
	target = pick_candidates()
	desc = "Get your hands on a [target.name]."
	RegisterSignal(mind_holder, COMSING_HUMAN_EQUITP, .proc/task_completed)

/datum/individual_objective/collenction/task_completed(obj/item/W)
	if(W.type == target.type)
		completed()
	else
		for(var/obj/item/I in mind_holder.GetAllContents())
			if(I.type == target.type)
				completed()

/datum/individual_objective/collenction/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSING_HUMAN_EQUITP)
	..()

/datum/individual_objective/economy
	name = "Businessman"
	var/datum/money_account/target

/datum/individual_objective/economy/can_assign(mob/living/L)
	if(!..())
		return FALSE
	if(!L.mind.initial_account)
		return FALSE
	var/list/valids_targets = list()
	for(var/mob/living/carbon/human/H in ((GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) - L))
		if(H.mind && H.mind.initial_account)
			valids_targets += H.mind.initial_account
	valids_targets -= L.mind.initial_account
	return valids_targets.len

/datum/individual_objective/economy/assign()
	..()
	var/list/valids_targets = list()
	for(var/mob/living/carbon/human/H in ((GLOB.player_list & GLOB.living_mob_list & GLOB.human_mob_list) -mind_holder))
		if(H.mind && H.mind.initial_account)
			valids_targets += H.mind.initial_account
	valids_targets -= owner.initial_account
	target = pick(valids_targets)
	units_requested = rand(500, 1000)
	desc = "The money must always flow but you must also prevent fees from ruining you.  \
			Make a bank transfer from you personal account for amount of [units_requested][CREDITS]."
	RegisterSignal(owner.initial_account, COMSIG_TRANSATION, .proc/task_completed)

/datum/individual_objective/economy/task_completed(datum/money_account/S, datum/money_account/T, amount)
	if(S == owner.initial_account && amount >= units_requested && T != S)
		..(amount)

/datum/individual_objective/economy/completed()
	if(completed) return
	UnregisterSignal(owner.initial_account, COMSIG_TRANSATION)
	..()
