/datum/individual_objetive/upgrade
	name = "Upgrade"
	desc =  "Its time to improve your meat with shiny chrome. Gain new bionics, implant, or any mutation."
	allow_cruciform = FALSE

/datum/individual_objetive/upgrade/assign()
	..()
	RegisterSignal(mind_holder, COMSIG_HUMAN_ROBOTIC_MODIFICATION, .proc/completed)

/datum/individual_objetive/upgrade/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_ROBOTIC_MODIFICATION)
	..()

/datum/individual_objetive/inspiration
	name = "Triumph of the Spirit"
	desc =  "Observer at least one positive breakdown. Inspiring!"
	var/breakdown_type = /datum/breakdown/positive

/datum/individual_objetive/inspiration/assign()
	..()
	RegisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN, .proc/task_completed)

/datum/individual_objetive/inspiration/task_completed(mob/living/L, datum/breakdown/breakdown)
	if(istype(breakdown, breakdown_type) && L != mind_holder)
		completed()

/datum/individual_objetive/inspiration/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN)
	..()

/datum/individual_objetive/derange
	name = "Derange"
	limited_antag = TRUE
	var/mob/living/carbon/human/target

/datum/individual_objetive/derange/assign()
	..()
	var/list/valid_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		valid_targets += H
	target = pick(valid_targets)
	desc = "[target] really pisses you off, ensure that they will get \
			a mental breakdown. Characters from your own faction are blacklisted"
	RegisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN, .proc/task_completed)

/datum/individual_objetive/derange/task_completed(mob/living/L, datum/breakdown/breakdown)
	if(L == target)
		completed()

/datum/individual_objetive/derange/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN)
	..()
