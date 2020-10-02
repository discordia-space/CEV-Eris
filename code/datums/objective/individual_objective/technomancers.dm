/datum/individual_objective/disturbance
	name = "Disturbance"
	req_department = list(DEPARTMENT_ENGINEERING)
	units_requested = 3 MINUTES//work, change it to 10
	based_time = TRUE
	var/area/target_area
	var/timer	

/datum/individual_objective/disturbance/assign()
	..()
	target_area = random_ship_area()
	desc = "Something in bluespace tries mess with ship systems. You need to go to [target_area] and power it down by APC \
	for [unit2time(units_requested)] minutes to lower bluespace interference, before worst will happen."
	RegisterSignal(target_area, COMSIG_AREA_APC_OPERATING, .proc/task_completed)

/datum/individual_objective/disturbance/task_completed(on=TRUE)
	if(on)
		units_completed = 0
		timer = world.time
	else
		units_completed += abs(world.time - timer)
		timer = world.time
	if(check_for_completion())
		completed()

/datum/individual_objective/disturbance/completed()
	if(completed) return
	UnregisterSignal(target_area, COMSIG_AREA_APC_OPERATING)
	..()

/datum/individual_objective/more_tech
	name = "Endless Search"
	req_department = list(DEPARTMENT_ENGINEERING) //test
	var/obj/item/target

/datum/individual_objective/more_tech/proc/pick_candidates()
	var/candidates = list()
	var/obj/randomcatcher/CATCH = new /obj/randomcatcher
	candidates += CATCH.get_item(/obj/spawner/tool_upgrade/rare)
	candidates += CATCH.get_item(/obj/spawner/tool/advanced)
	candidates += CATCH.get_item(/obj/spawner/tool/advanced)
	return pick(candidates)

/datum/individual_objective/more_tech/assign()
	..()
	target = pick_candidates()
	desc = "As always, you need more technology to your possession. Acquire a [target.name]"
	RegisterSignal(mind_holder, COMSING_HUMAN_EQUITP, .proc/task_completed)

/datum/individual_objective/more_tech/task_completed(obj/item/W)
	for(var/obj/item/I in mind_holder.GetAllContents())
		if(I.type == target.type)
			completed()
			return

/datum/individual_objective/more_tech/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSING_HUMAN_EQUITP)
	..()

/datum/individual_objective/oddity
	name = "Warded"
	req_department = list(DEPARTMENT_ENGINEERING)
	units_requested = 5

/datum/individual_objective/oddity/assign()
	..()
	desc = "Acquire at least [units_requested] oddities at the same time to be on you"
	RegisterSignal(mind_holder, COMSING_HUMAN_EQUITP, .proc/task_completed)

/datum/individual_objective/oddity/task_completed(obj/item/W)
	units_completed = 0
	for(var/obj/item/I in mind_holder.GetAllContents())
		if(I.GetComponent(/datum/component/inspiration))
			..(1)

/datum/individual_objective/oddity/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSING_HUMAN_EQUITP)
	..()

/datum/individual_objective/tribalism
	name = "Advanced Tribalism"
	req_department = list(DEPARTMENT_ENGINEERING)
	limited_antag = TRUE
	rarity = 4
	var/obj/item/target

/datum/individual_objective/tribalism/assign()
	..()
	target = pick_faction_item(mind_holder)
	desc = "It is time to greater sacrifice. Put \the [target] in Techno-Tribalism Enforcer."
	RegisterSignal(mind_holder, COMSIG_OBJ_TECHNO_TRIBALISM, .proc/task_completed)

/datum/individual_objective/tribalism/task_completed(obj/item/I) 
	if(target.type == I.type)
		..(1)

/datum/individual_objective/tribalism/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_OBJ_TECHNO_TRIBALISM)
	..()
