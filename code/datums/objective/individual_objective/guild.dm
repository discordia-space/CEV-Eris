/datum/individual_objective/repossession//test requiered
	name = "Repossession"
	req_department = list(DEPARTMENT_GUILD)
	limited_antag = TRUE
	var/obj/item/target

/datum/individual_objective/repossession/assign()
	..()
	target = pick_faction_item(mind_holder)
	desc = "Sold \the [target] item of other faction via cargo."
	RegisterSignal(SSsupply.shuttle, COMSIG_SHUTTLE_SUPPLY, .proc/task_completed)

/datum/individual_objective/repossession/task_completed(atom/movable/AM) 
	if(target.type == AM.type)
		..(1)

/datum/individual_objective/repossession/completed()
	if(completed) return
	UnregisterSignal(SSsupply.shuttle, COMSIG_SHUTTLE_SUPPLY)
	..()

/datum/individual_objective/museum//test requiered
	name = "It Belongs to Museum"
	desc = "Ensure that 3-4 oddities were sold via cargo."
	req_department = list(DEPARTMENT_GUILD)

/datum/individual_objective/museum/assign()
	..()
	units_requested = rand(3,4)
	desc = "Ensure that [units_requested] oddities were sold via cargo."
	RegisterSignal(SSsupply.shuttle, COMSIG_SHUTTLE_SUPPLY, .proc/task_completed)

/datum/individual_objective/museum/task_completed(atom/movable/AM) 
	if(AM.GetComponent(/datum/component/inspiration))
		..(1)

/datum/individual_objective/museum/completed()
	if(completed) return
	UnregisterSignal(SSsupply.shuttle, COMSIG_SHUTTLE_SUPPLY)
	..()


/datum/individual_objective/order//test requiered
	name = "Special Order"
	req_department = list(DEPARTMENT_GUILD)
	var/obj/item/target

/datum/individual_objective/order/proc/pick_candidates()
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

/datum/individual_objective/order/assign()
	..()
	target = pick_candidates()
	target = new target()
	desc = "A friend of yours on the other side on trade teleporter is waiting for a [target]. Ensure it will be sold via cargo."
	RegisterSignal(SSsupply.shuttle, COMSIG_SHUTTLE_SUPPLY, .proc/task_completed)

/datum/individual_objective/order/task_completed(atom/movable/AM) 
	if(AM.type == target.type)
		completed()
		return

/datum/individual_objective/order/completed()
	if(completed) return
	UnregisterSignal(SSsupply.shuttle, COMSIG_SHUTTLE_SUPPLY)
	..()
