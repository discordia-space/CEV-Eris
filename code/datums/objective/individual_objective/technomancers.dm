/datum/individual_objective/disturbance
	name = "Disturbance"
	req_department = list(DEPARTMENT_ENGINEERING)
	units_requested = 1069INUTES
	based_time = TRUE
	var/area/target_area
	var/timer

/datum/individual_objective/disturbance/assign()
	..()
	target_area = random_ship_area(need_apc=TRUE)
	desc = "Something in bluespace tries69ess with ship systems. You need to go to 69target_area69 and power it down its APC \
	for 69unit2time(units_requested)6969inutes to lower bluespace interference, before something worse will happen."
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
		target_area.bluespace_entropy -= rand(25,50)
		GLOB.bluespace_entropy -= rand(5,25)

/datum/individual_objective/disturbance/completed()
	if(completed) return
	UnregisterSignal(target_area, COMSIG_AREA_APC_OPERATING)
	..()

/datum/individual_objective/more_tech
	name = "Endless Search"
	req_department = list(DEPARTMENT_ENGINEERING)
	var/obj/item/target

/datum/individual_objective/more_tech/proc/pick_candidates()
	var/candidates = list()
	var/obj/randomcatcher/CATCH = new /obj/randomcatcher
	candidates += CATCH.get_item(/obj/spawner/tool_upgrade/rare)
	candidates += CATCH.get_item(/obj/spawner/tool/advanced)
	return pick(candidates)

/datum/individual_objective/more_tech/assign()
	..()
	target = pick_candidates()
	desc = "As always, you need69ore technology to your possession. Acquire a 69target.name69."
	RegisterSignal(mind_holder, COMSING_HUMAN_EQUITP, .proc/task_completed)

/datum/individual_objective/more_tech/task_completed(obj/item/W)
	for(var/obj/item/I in69ind_holder.GetAllContents())
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
	desc = "Acquire at least 69units_requested69 oddities at the same time to be on you."
	RegisterSignal(mind_holder, COMSING_HUMAN_EQUITP, .proc/task_completed)

/datum/individual_objective/oddity/task_completed(obj/item/W)
	units_completed = 0
	for(var/obj/item/I in69ind_holder.GetAllContents())
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

/datum/individual_objective/tribalism/can_assign(mob/living/L)
	if(!..())
		return FALSE
	if(locate(/obj/item/device/techno_tribalism))
		return pick_faction_item(L)
	return FALSE

/datum/individual_objective/tribalism/assign()
	..()
	target = pick_faction_item(mind_holder)
	desc = "It is time to greater sacrifice. Put \the 69target69 in Techno-Tribalism Enforcer."
	RegisterSignal(mind_holder, COMSIG_OBJ_TECHNO_TRIBALISM, .proc/task_completed)

/datum/individual_objective/tribalism/task_completed(obj/item/I)
	if(target.type == I.type)
		..(1)

/datum/individual_objective/tribalism/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSIG_OBJ_TECHNO_TRIBALISM)
	..()
