/*
	A tool upgrade is a little attachment for a tool that improves it in some way
	Tool upgrades are generally permanant

	Some upgrades have multiple bonuses. Some have drawbacks in addition to boosts
*/


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
			if (I.type == parent.type)
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
		if(upgrades[UPGRADE_PRECISION])
			T.precision += upgrades[UPGRADE_PRECISION]
		if(upgrades[UPGRADE_WORKSPEED])
			T.workspeed += upgrades[UPGRADE_WORKSPEED]
		if(upgrades[UPGRADE_DEGRADATION_MULT])
			T.degradation *= upgrades[UPGRADE_DEGRADATION_MULT]
		if(upgrades[UPGRADE_FORCE_MULT])
			T.force *= upgrades[UPGRADE_FORCE_MULT]
			T.switched_on_force *= upgrades[UPGRADE_FORCE_MULT]
		if(upgrades[UPGRADE_FORCE_MOD])
			T.force += upgrades[UPGRADE_FORCE_MOD]
			T.switched_on_force += upgrades[UPGRADE_FORCE_MOD]
		if(upgrades[UPGRADE_FUELCOST_MULT])
			T.use_fuel_cost *= upgrades[UPGRADE_FUELCOST_MULT]
		if(upgrades[UPGRADE_POWERCOST_MULT])
			T.use_power_cost *= upgrades[UPGRADE_POWERCOST_MULT]
		if(upgrades[UPGRADE_BULK])
			T.extra_bulk += upgrades[UPGRADE_BULK]
		if(upgrades[UPGRADE_HEALTH_THRESHOLD])
			T.health_threshold += upgrades[UPGRADE_HEALTH_THRESHOLD]
		if(upgrades[UPGRADE_MAXFUEL])
			T.max_fuel += upgrades[UPGRADE_MAXFUEL]
		if(upgrades[UPGRADE_MAXUPGRADES])
			T.max_upgrades += upgrades[UPGRADE_MAXUPGRADES]
		if(upgrades[UPGRADE_SHARP])
			T.sharp = upgrades[UPGRADE_SHARP]
		if(upgrades[UPGRADE_COLOR])
			T.color = upgrades[UPGRADE_COLOR]
		if(upgrades[UPGRADE_ITEMFLAGPLUS])
			T.item_flags |= upgrades[UPGRADE_ITEMFLAGPLUS]
		if(upgrades[UPGRADE_CELLPLUS])
			switch(T.suitable_cell)
				if(/obj/item/weapon/cell/medium)
					T.suitable_cell = /obj/item/weapon/cell/large
					prefix = "large-cell"
				if(/obj/item/weapon/cell/small)
					T.suitable_cell = /obj/item/weapon/cell/medium
		T.prefixes |= prefix
	return TRUE

/datum/component/item_upgrade/proc/on_examine(var/mob/user)
	if (upgrades[UPGRADE_PRECISION] > 0)
		to_chat(user, SPAN_NOTICE("Enhances precision by [upgrades[UPGRADE_PRECISION]]"))
	else if (upgrades[UPGRADE_PRECISION] < 0)
		to_chat(user, SPAN_WARNING("Reduces precision by [abs(upgrades[UPGRADE_PRECISION])]"))
	if (upgrades[UPGRADE_WORKSPEED])
		to_chat(user, SPAN_NOTICE("Enhances workspeed by [upgrades[UPGRADE_WORKSPEED]*100]%"))

	if (upgrades[UPGRADE_DEGRADATION_MULT] && upgrades[UPGRADE_DEGRADATION_MULT] < 1)
		to_chat(user, SPAN_NOTICE("Reduces tool degradation by [(1-upgrades[UPGRADE_DEGRADATION_MULT])*100]%"))
	else if	(upgrades[UPGRADE_DEGRADATION_MULT] > 1)
		to_chat(user, SPAN_WARNING("Increases tool degradation by [(upgrades[UPGRADE_DEGRADATION_MULT]-1)*100]%"))

	if (upgrades[UPGRADE_FORCE_MULT] >= 1)
		to_chat(user, SPAN_NOTICE("Increases tool damage by [(upgrades[UPGRADE_FORCE_MULT]-1)*100]%"))
	if (upgrades[UPGRADE_FORCE_MOD])
		to_chat(user, SPAN_NOTICE("Increases tool damage by [upgrades[UPGRADE_FORCE_MOD]]"))
	if (upgrades[UPGRADE_POWERCOST_MULT] >= 1)
		to_chat(user, SPAN_WARNING("Modifies power usage by [(upgrades[UPGRADE_POWERCOST_MULT]-1)*100]%"))
	if (upgrades[UPGRADE_FUELCOST_MULT] >= 1)
		to_chat(user, SPAN_WARNING("Modifies fuel usage by [(upgrades[UPGRADE_FUELCOST_MULT]-1)*100]%"))
	if (upgrades[UPGRADE_MAXFUEL])
		to_chat(user, SPAN_NOTICE("Modifies fuel storage by [upgrades[UPGRADE_MAXFUEL]] units."))
	if (upgrades[UPGRADE_BULK])
		to_chat(user, SPAN_WARNING("Increases tool size by [upgrades[UPGRADE_BULK]]"))

	if (required_qualities.len)
		to_chat(user, SPAN_WARNING("Requires a tool with one of the following qualities:"))
		to_chat(user, english_list(required_qualities, and_text = " or "))


/obj/item/weapon/tool_upgrade
	name = "tool upgrade"
	icon = 'icons/obj/tool_upgrades.dmi'
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL
	price_tag = 200