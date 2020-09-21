/datum/individual_objetive/disturbance
	name = "Disturbance"
	req_department = list(DEPARTMENT_ENGINEERING)
	var/target_time = 1 MINUTES//work, change it to 10
	var/area/target_area

/datum/individual_objetive/disturbance/assign()
	..()
	var/list/candidates = ship_areas.Copy()
	for(var/area/A in candidates)
		if(A.is_maintenance)
			candidates -= A
			continue
		if(!A.apc)
			candidates -= A
			continue
	target_area = pick(candidates)
	desc = "Something in bluespace tries mess with ship systems. You need to go to [target_area] and power it down by APC \
	for [target_time/(1 MINUTES)] minutes to lower bluespace interference, before worst will happen."
	RegisterSignal(target_area, COMSIG_AREA_APC_UNOPERATING, .proc/task_completed)

/datum/individual_objetive/disturbance/task_completed(time)
	if(time >= target_time)
		completed()

/datum/individual_objetive/disturbance/completed()
	if(completed) return
	UnregisterSignal(target_area, COMSIG_AREA_APC_UNOPERATING)
	..()

/datum/individual_objetive/more_tech//work
	name = "Endless Search"
	req_department = list(DEPARTMENT_ENGINEERING)
	var/obj/item/target

/datum/individual_objetive/more_tech/proc/pick_candidates()
	return pickweight(list(
	/obj/item/weapon/tool_upgrade/reinforcement/guard = 1,
	/obj/item/weapon/tool_upgrade/productivity/ergonomic_grip = 1,
	/obj/item/weapon/tool_upgrade/productivity/red_paint = 1,
	/obj/item/weapon/tool_upgrade/productivity/diamond_blade = 1,
	/obj/item/weapon/tool_upgrade/productivity/motor = 1,
	/obj/item/weapon/tool_upgrade/refinement/laserguide = 1,
	/obj/item/weapon/tool_upgrade/refinement/stabilized_grip = 1,
	/obj/item/weapon/tool_upgrade/augment/expansion = 1,
	/obj/item/weapon/tool_upgrade/augment/dampener = 0.5,
	/obj/item/weapon/tool/screwdriver/combi_driver = 3,
	/obj/item/weapon/tool/wirecutters/armature = 3,
	/obj/item/weapon/tool/omnitool = 2,
	/obj/item/weapon/tool/crowbar/pneumatic = 3,
	/obj/item/weapon/tool/wrench/big_wrench = 3,
	/obj/item/weapon/tool/weldingtool/advanced = 3,
	/obj/item/weapon/tool/saw/circular/advanced = 2,
	/obj/item/weapon/tool/saw/chain = 1,
	/obj/item/weapon/tool/saw/hyper = 1,
	/obj/item/weapon/tool/pickaxe/diamonddrill = 2,
	/obj/item/weapon/gun_upgrade/mechanism/glass_widow = 1,
	/obj/item/weapon/gun_upgrade/barrel/excruciator = 1,
	/obj/item/device/destTagger = 1,
	/obj/item/device/makeshift_electrolyser = 1,
	/obj/item/device/makeshift_centrifuge = 1
	))

/datum/individual_objetive/more_tech/assign()
	..()
	target = pick_candidates()
	target = new target()
	desc = "As always, you need more technology to your possession. Acquire a [target.name]"
	RegisterSignal(mind_holder, COMSING_HUMAN_EQUITP, .proc/task_completed)

/datum/individual_objetive/more_tech/task_completed(obj/item/W)
	if(W.type == target.type)
		completed()

/datum/individual_objetive/more_tech/completed()
	if(completed) return
	UnregisterSignal(mind_holder, COMSING_HUMAN_EQUITP)
	..()
