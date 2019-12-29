/*
	A tool upgrade is a little attachment for a tool that improves it in some way
	Tool upgrades are generally permanant

	Some upgrades have multiple bonuses. Some have drawbacks in addition to boosts
*/

#define REQ_FUEL 1
#define REQ_CELL 2
#define REQ_FUEL_OR_CELL 4

/*/client/verb/debugupgrades()
	for (var/t in subtypesof(/obj/item/weapon/tool_upgrade))
		new t(usr.loc)
*/
/datum/component/item_upgrade
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/prefix = "upgraded" //Added to the tool's name

	//The upgrade can be applied to a tool that has any of these qualities
	var/list/required_qualities = list()

	//The upgrade can not be applied to a tool that has any of these qualities
	var/list/negative_qualities = list()

	//If REQ_FUEL, can only be applied to tools that use fuel. If REQ_CELL, can only be applied to tools that use cell, If REQ_FUEL_OR_CELL, can be applied if it has fuel OR a cell
	var/req_fuel_cell = FALSE

	//Actual effects of upgrades
	var/list/upgrades = list() //variable name(string) -> num

/datum/component/item_upgrade/Initialize()
	RegisterSignal(parent, COMSIG_IATTACK, .proc/attempt_install)
	RegisterSignal(parent, COMSIG_EXAMINE, .proc/on_examine)
	RegisterSignal(parent, COMSIG_REMOVE, .proc/uninstall)

/datum/component/item_upgrade/proc/attempt_install(atom/A, var/mob/living/user, params)
	return can_apply(A, user) && apply(A, user)

/datum/component/item_upgrade/proc/can_apply(var/atom/A, var/mob/living/user)
	if (isrobot(A))
		var/mob/living/silicon/robot/R = A
		if(!R.opened)
			to_chat(user, SPAN_WARNING("You need to open [R]'s panel to access its tools."))
		var/list/robotools = list()
		for(var/obj/item/weapon/tool/robotool in R.module.modules)
			robotools.Add(robotool)
		if(robotools.len)
			var/obj/item/weapon/tool/chosen_tool = input(user,"Which tool are you trying to modify?","Tool Modification","Cancel") in robotools + "Cancel"
			if(chosen_tool == "Cancel")
				return FALSE
			return can_apply(chosen_tool,user)
		else
			to_chat(user, SPAN_WARNING("[R] has no modifiable tools."))
		return FALSE

	if (istool(A))
		var/obj/item/weapon/tool/T = A
		if (T.item_upgrades.len >= T.max_upgrades)
			to_chat(user, SPAN_WARNING("This tool can't fit anymore modifications!"))
			return FALSE

		if (required_qualities.len)
			var/qmatch = FALSE
			for (var/q in required_qualities)
				if (T.ever_has_quality(q))
					qmatch = TRUE
					break

			if (!qmatch)
				to_chat(user, SPAN_WARNING("This tool lacks the required qualities!"))
				return FALSE

		if(negative_qualities.len)
			for(var/i in negative_qualities)
				if(T.ever_has_quality(i))
					to_chat(user, SPAN_WARNING("This tool can not accept the modification!"))
					return FALSE

		if ((req_fuel_cell & REQ_FUEL) && !T.use_fuel_cost)
			to_chat(user, SPAN_WARNING("This tool does not use fuel!"))
			return FALSE

		if((req_fuel_cell & REQ_CELL) && !T.use_power_cost)
			to_chat(user, SPAN_WARNING("This tool does not use power!"))
			return FALSE

		if((req_fuel_cell & REQ_FUEL_OR_CELL) && (!T.use_power_cost && !T.use_fuel_cost))
			to_chat(user, SPAN_WARNING("This tool does not use [T.use_power_cost?"fuel":"power"]!"))
			return FALSE

		if(upgrades["cell_hold_upgrades"])
			if(!(T.suitable_cell == /obj/item/weapon/cell/medium || T.suitable_cell == /obj/item/weapon/cell/small))
				to_chat(user, SPAN_WARNING("This tool does not require a cell holding upgrade."))
				return FALSE
			if(T.cell)
				to_chat(user, SPAN_WARNING("Remove the cell from the tool first!"))
				return FALSE
		//No using multiples of the same upgrade
		for (var/obj/item/I in T.item_upgrades)
			if (I.type == type)
				to_chat(user, SPAN_WARNING("An upgrade of this type is already installed!"))
				return FALSE

		return TRUE
	to_chat(user, SPAN_WARNING("This can only be applied to a tool!"))
	return FALSE

/datum/component/item_upgrade/proc/apply(var/obj/item/A, var/mob/living/user)
	if (user)
		user.visible_message(SPAN_NOTICE("[user] starts applying [parent] to [A]"), SPAN_NOTICE("You start applying \the [parent] to \the [A]"))
		var/obj/item/I = parent
		if (!I.use_tool(user = user, target =  A, base_time = WORKTIME_FAST, required_quality = null, fail_chance = FAILCHANCE_ZERO, required_stat = STAT_MEC, forced_sound = WORKSOUND_WRENCHING))
			return FALSE
		to_chat(user, SPAN_NOTICE("You have successfully installed \the [parent] in \the [A]"))
		user.drop_from_inventory(parent)
	//If we get here, we succeeded in the applying
	var/obj/item/I = parent
	I.forceMove(A)
	A.item_upgrades.Add(I)
	RegisterSignal(A, COMSIG_APPVAL, .proc/apply_values)
	A.refresh_upgrades()
	return TRUE

/datum/component/item_upgrade/proc/uninstall(var/obj/item/I)
	var/obj/item/P = parent
	I.item_upgrades -= P
	P.forceMove(get_turf(I))
	UnregisterSignal(I, COMSIG_APPVAL)

/datum/component/item_upgrade/proc/apply_values(var/atom/holder)
	if (!holder)
		return
	if(istype(holder, /obj/item/weapon/tool))
		var/obj/item/weapon/tool/T = holder
		if(upgrades["precision"])
			T.precision += upgrades["precision"]
		if(upgrades["workspeed"])
			T.workspeed += upgrades["workspeed"]
		if(upgrades["degradation_mult"])
			T.degradation *= upgrades["degradation_mult"]
		if(upgrades["force_mult"])
			T.force *= upgrades["force_mult"]
			T.switched_on_force *= upgrades["force_mult"]
		if(upgrades["force_mod"])
			T.force += upgrades["force_mod"]
			T.switched_on_force += upgrades["force_mod"]
		if(upgrades["fuelcost_mult"])
			T.use_fuel_cost *= upgrades["fuelcost_mult"]
		if(upgrades["powercost_mult"])
			T.use_power_cost *= upgrades["powercost_mult"]
		if(upgrades["bulk_mod"])
			T.extra_bulk += upgrades["bulk_mod"]
		if(upgrades["health_threshold_modifier"])
			T.health_threshold += upgrades["health_threshold_modifier"]
		if(upgrades["max_fuel"])
			T.max_fuel += upgrades["max_fuel"]
		if(upgrades["max_upgrades"])
			T.max_upgrades += upgrades["max_upgrades"]
		if(upgrades["sharp"])
			T.sharp = upgrades["sharp"]
		if(upgrades["color"])
			T.color = upgrades["color"]
		if(upgrades["item_flag_add"])
			T.item_flags |= upgrades["item_flag_add"]
		if(upgrades["cell_hold_upgrade"])
			switch(T.suitable_cell)
				if(/obj/item/weapon/cell/medium)
					T.suitable_cell = /obj/item/weapon/cell/large
					prefix = "large-cell"
				if(/obj/item/weapon/cell/small)
					T.suitable_cell = /obj/item/weapon/cell/medium
		T.prefixes |= prefix
	return TRUE

/datum/component/item_upgrade/proc/on_examine(var/mob/user)
	if (upgrades["precision"] > 0)
		to_chat(user, SPAN_NOTICE("Enhances precision by [upgrades["precision"]]"))
	else if (upgrades["precision"] < 0)
		to_chat(user, SPAN_WARNING("Reduces precision by [abs(upgrades["precision"])]"))
	if (upgrades["workspeed"])
		to_chat(user, SPAN_NOTICE("Enhances workspeed by [upgrades["workspeed"]*100]%"))

	if (upgrades["degradation_mult"] < 1)
		to_chat(user, SPAN_NOTICE("Reduces tool degradation by [(1-upgrades["degradation_mult"])*100]%"))
	else if	(upgrades["degradation_mult"] > 1)
		to_chat(user, SPAN_WARNING("Increases tool degradation by [(upgrades["degradation_mult"]-1)*100]%"))

	if (upgrades["force_mult"] != 1)
		to_chat(user, SPAN_NOTICE("Increases tool damage by [(upgrades["force_mult"]-1)*100]%"))
	if (upgrades["force_mod"])
		to_chat(user, SPAN_NOTICE("Increases tool damage by [upgrades["force_mod"]]"))
	if (upgrades["powercost_mult"] != 1)
		to_chat(user, SPAN_WARNING("Modifies power usage by [(upgrades["powercost_mult"]-1)*100]%"))
	if (upgrades["fuelcost_mult"] != 1)
		to_chat(user, SPAN_WARNING("Modifies fuel usage by [(upgrades["fuelcost_mult"]-1)*100]%"))
	if (upgrades["max_fuel"])
		to_chat(user, SPAN_NOTICE("Modifies fuel storage by [upgrades["max_fuel"]] units."))
	if (upgrades["bulk_mod"])
		to_chat(user, SPAN_WARNING("Increases tool size by [upgrades["bulk_mod"]]"))

	if (required_qualities.len)
		to_chat(user, SPAN_WARNING("Requires a tool with one of the following qualities:"))
		to_chat(user, english_list(required_qualities, and_text = " or "))


/obj/item/weapon/tool_upgrade
	name = "tool upgrade"
	icon = 'icons/obj/tool_upgrades.dmi'
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL
	price_tag = 200