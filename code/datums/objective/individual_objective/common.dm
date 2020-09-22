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

/datum/individual_objetive/inspiration//work
	name = "Triumph of the Spirit"
	desc =  "Observer at least one positive breakdown. Inspiring!"
	var/breakdown_type = /datum/breakdown/positive

/datum/individual_objetive/inspiration/assign()
	..()
	RegisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN, .proc/task_completed)

/datum/individual_objetive/inspiration/task_completed(mob/living/L, datum/breakdown/breakdown)
	//if(istype(breakdown, breakdown_type) && L != mind_holder)//uncoment
	if(istype(breakdown, breakdown_type))//delete
		completed()

/datum/individual_objetive/inspiration/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_BREAKDOWN)
	..()

/datum/individual_objetive/derange//work but limit it to more of the one player
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

#define MOB_ADD_DRUG 1
#define ON_MOB_DRUG 2
#define MOB_DELETE_DRUG 3

/datum/individual_objetive/addict
	name = "Oil the Cogs"
	based_time = TRUE
	var/list/drugs = list()
	var/timer
	units_requested = 3 MINUTES//change to 5

/datum/individual_objetive/addict/assign()
	..()
	timer = world.time
	desc = "Stay intoxicated by alcohol or recreational drugs for [unit2time(units_requested)] minutes"
	RegisterSignal(mind_holder, COMSIGN_CARBON_HAPPY, .proc/task_completed)

/datum/individual_objetive/addict/task_completed(datum/reagent/happy, ntimer, signal)
	if(!(happy.id in drugs))
		if(signal != MOB_ADD_DRUG || signal == ON_MOB_DRUG)
			if(!drugs.len)
				timer = world.time
			drugs += happy.id
	else if(signal == MOB_DELETE_DRUG)
		drugs -= happy.id
		if(!drugs.len)
			timer = world.time
	else if(signal == ON_MOB_DRUG)
		if(ntimer > timer)
			units_requested += ntimer - timer
			timer = world.time
	if(check_for_completion())
		completed()

/datum/individual_objetive/addict/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIGN_CARBON_HAPPY)
	..()

/datum/individual_objetive/gift//test requiered
	name = "Gift"
	desc = "You feel a need to leave a mark in other people lives. Ensure that at \
			least someone will level up with oddity that you touched"

/datum/individual_objetive/gift/assign()
	..()
	RegisterSignal(mind_holder, COMSIG_HUMAN_LEVEL_UP, .proc/task_completed)

/datum/individual_objetive/gift/task_completed(mob/living/carbon/human/H, obj/item/O)
	//if(mind_holder == H) return //coment for rest for test
	var/full_print = mind_holder.get_full_print()
	if(full_print in O.fingerprints)
		completed()

/datum/individual_objetive/gift/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_HUMAN_LEVEL_UP)
	..()

/datum/individual_objetive/protector//test requiered
	name = "Protector"
	var/mob/living/carbon/human/target
	var/timer
	units_requested = 3 MINUTES//change to 15
	based_time = TRUE
	var/health_threshold = 50

/datum/individual_objetive/protector/assign()
	..()
	var/list/valid_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		valid_targets += H
	target = pick(valid_targets)//todo: no mind.current
	desc = "Ensure that [target] will not get their health slowered to [health_threshold] and below \
			for [unit2time(units_requested)] minutes. Timer resets if sanity reaches the threshold."
	timer = world.time
	RegisterSignal(target, COMSIGN_HUMAN_HEALTH, .proc/task_completed)

/datum/individual_objetive/protector/task_completed(health)
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

/datum/individual_objetive/protector/completed()
	if(completed) return
	UnregisterSignal(target, COMSIGN_HUMAN_HEALTH)
	..()

/datum/individual_objetive/helper//test requiered
	name = "Helping Hand"
	var/mob/living/carbon/human/target
	var/timer
	units_requested = 3 MINUTES//change to 15
	based_time = TRUE
	var/sanity_threshold = 50

/datum/individual_objetive/helper/assign()
	..()
	var/list/valid_targets = list()
	for(var/mob/living/carbon/human/H in GLOB.player_list)
		valid_targets += H
	target = pick(valid_targets)//todo: no mind.current
	desc = "Ensure that [target] will not get their sanity lowered to [sanity_threshold] and below \
			for 15 minutes. Timer resets if sanity reaches the threshold"
	timer = world.time
	RegisterSignal(target, COMSIG_HUMAN_SANITY, .proc/task_completed)

/datum/individual_objetive/helper/task_completed(sanity)
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

/datum/individual_objetive/helper/completed()
	if(completed) return
	UnregisterSignal(target, COMSIG_HUMAN_SANITY)
	..()
