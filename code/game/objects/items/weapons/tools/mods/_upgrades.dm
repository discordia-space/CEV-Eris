/*
	A tool upgrade is a little attachment for a tool that improves it in some way
	Tool upgrades are generally permanant

	Some upgrades have69ultiple bonuses. Some have drawbacks in addition to boosts
*/

/*/client/verb/debugupgrades()
	for (var/t in subtypesof(/obj/item/tool_upgrade))
		new t(usr.loc)
*/
/datum/component/item_upgrade
	dupe_mode = COMPONENT_DUPE_UNI69UE
	can_transfer = TRUE
	var/prefix = "upgraded" //Added to the tool's name

	var/removal_time = WORKTIME_SLOW
	var/removal_difficulty = FAILCHANCE_CHALLENGING
	var/destroy_on_removal = FALSE
	//The upgrade can be applied to a tool that has any of these 69ualities
	var/list/re69uired_69ualities = list()
	var/removable = TRUE
	var/breakable = TRUE //Some69ods69eant to be tamper-resistant and should be removed only in a hard way

	//The upgrade can not be applied to a tool that has any of these 69ualities
	var/list/negative_69ualities = list()

	//If RE69_FUEL, can only be applied to tools that use fuel. If RE69_CELL, can only be applied to tools that use cell, If RE69_FUEL_OR_CELL, can be applied if it has fuel OR a cell
	var/re69_fuel_cell = FALSE

	var/exclusive_type

	//Actual effects of upgrades
	var/list/tool_upgrades = list() //variable name(string) -> num

	//Weapon upgrades
	var/list/gun_loc_tag //Define(string). For checking if the gun already has something of this installed (No double trigger69ods, for instance)
	var/list/re69_gun_tags = list() //Define(string).69ust69atch all to be able to install it.
	var/list/weapon_upgrades = list() //variable name(string) -> num

/datum/component/item_upgrade/RegisterWithParent()
	RegisterSignal(parent, COMSIG_IATTACK, .proc/attempt_install)
	RegisterSignal(parent, COMSIG_EXAMINE, .proc/on_examine)
	RegisterSignal(parent, COMSIG_REMOVE, .proc/uninstall)

/datum/component/item_upgrade/proc/attempt_install(atom/A,69ob/living/user, params)
	return can_apply(A, user) && apply(A, user)

/datum/component/item_upgrade/proc/can_apply(atom/A,69ob/living/user)
	if(isrobot(A))
		return check_robot(A, user)

	if(isitem(A))
		var/obj/item/T = A
		//No using69ultiples of the same upgrade
		for (var/obj/item/I in T.item_upgrades)
			if(I.type == parent.type || (exclusive_type && istype(I.type, exclusive_type)))
				if(user)
					to_chat(user, SPAN_WARNING("An upgrade of this type is already installed!"))
				return FALSE

	if(istool(A))
		return check_tool(A, user)

	if(isgun(A))
		return check_gun(A, user)

	return FALSE

/datum/component/item_upgrade/proc/check_robot(mob/living/silicon/robot/R,69ob/living/user)
	if(!R.opened)
		if(user)
			to_chat(user, SPAN_WARNING("You need to open 69R69's panel to access its tools."))
		return FALSE
	var/list/robotools = list()
	for(var/obj/item/tool/robotool in R.module.modules)
		robotools.Add(robotool)
	if(robotools.len)
		var/obj/item/tool/chosen_tool = input(user,"Which tool are you trying to69odify?","Tool69odification","Cancel") in robotools + "Cancel"
		if(chosen_tool == "Cancel")
			return FALSE
		return can_apply(chosen_tool,user)
	if(user)
		to_chat(user, SPAN_WARNING("69R69 has no69odifiable tools."))
	return FALSE

/datum/component/item_upgrade/proc/check_tool(obj/item/tool/T,69ob/living/user)
	if(!tool_upgrades.len)
		to_chat(user, SPAN_WARNING("\The 69parent69 can not be attached to a tool."))
		return FALSE

	if(T.item_upgrades.len >= T.max_upgrades)
		if(user)
			to_chat(user, SPAN_WARNING("This tool can't fit anymore69odifications!"))
		return FALSE

	if(re69uired_69ualities.len)
		var/69match = FALSE
		for (var/69 in re69uired_69ualities)
			if(T.ever_has_69uality(69))
				69match = TRUE
				break

		if(!69match)
			if(user)
				to_chat(user, SPAN_WARNING("This tool lacks the re69uired 69ualities!"))
			return FALSE

	if(negative_69ualities.len)
		for(var/i in negative_69ualities)
			if(T.ever_has_69uality(i))
				if(user)
					to_chat(user, SPAN_WARNING("This tool can not accept the69odification!"))
				return FALSE

	if((re69_fuel_cell & RE69_FUEL) && !T.use_fuel_cost)
		if(user)
			to_chat(user, SPAN_WARNING("This tool does not use fuel!"))
		return FALSE

	if((re69_fuel_cell & RE69_CELL) && !T.use_power_cost)
		if(user)
			to_chat(user, SPAN_WARNING("This tool does not use power!"))
		return FALSE

	if((re69_fuel_cell & RE69_FUEL_OR_CELL) && (!T.use_power_cost && !T.use_fuel_cost))
		if(user)
			to_chat(user, SPAN_WARNING("This tool does not use 69T.use_power_cost?"fuel":"power"69!"))
		return FALSE

	if(tool_upgrades69UPGRADE_SANCTIFY69)
		if(SANCTIFIED in T.aspects)
			if(user)
				to_chat(user, SPAN_WARNING("This tool already sanctified!"))
			return FALSE

	if(tool_upgrades69UPGRADE_CELLPLUS69)
		if(!(T.suitable_cell == /obj/item/cell/medium || T.suitable_cell == /obj/item/cell/small))
			if(user)
				to_chat(user, SPAN_WARNING("This tool does not re69uire a cell holding upgrade."))
			return FALSE
		if(T.cell)
			if(user)
				to_chat(user, SPAN_WARNING("Remove the cell from the tool first!"))
			return FALSE

	return TRUE

/datum/component/item_upgrade/proc/check_gun(obj/item/gun/G,69ob/living/user)
	if(!weapon_upgrades.len)
		if(user)
			to_chat(user, SPAN_WARNING("\The 69parent69 can not be applied to guns!"))
		return FALSE //Can't be applied to a weapon

	if(G.item_upgrades.len >= G.max_upgrades)
		if(user)
			to_chat(user, SPAN_WARNING("This weapon can't fit anymore69odifications!"))
		return FALSE

	for(var/obj/I in G.item_upgrades)
		var/datum/component/item_upgrade/IU = I.GetComponent(/datum/component/item_upgrade)
		if(IU && IU.gun_loc_tag == gun_loc_tag)
			if(user)
				to_chat(user, SPAN_WARNING("There is already something attached to \the 69G69's 69gun_loc_tag69!"))
			return FALSE

	for(var/I in re69_gun_tags)
		if(!G.gun_tags.Find(I))
			if(user)
				to_chat(user, SPAN_WARNING("\The 69G69 lacks the following property: 69I69"))
			return FALSE

	if((re69_fuel_cell & RE69_CELL) && !istype(G, /obj/item/gun/energy))
		if(user)
			to_chat(user, SPAN_WARNING("This weapon does not use power!"))
		return FALSE
	return TRUE

/datum/component/item_upgrade/proc/apply(obj/item/A,69ob/living/user)
	if(user)
		user.visible_message(SPAN_NOTICE("69user69 starts applying 69parent69 to 69A69"), SPAN_NOTICE("You start applying \the 69parent69 to \the 69A69"))
		var/obj/item/I = parent
		if(!I.use_tool(user = user, target =  A, base_time = WORKTIME_FAST, re69uired_69uality = null, fail_chance = FAILCHANCE_ZERO, re69uired_stat = STAT_MEC, forced_sound = WORKSOUND_WRENCHING))
			return FALSE
		to_chat(user, SPAN_NOTICE("You have successfully installed \the 69parent69 in \the 69A69"))
		user.drop_from_inventory(parent)
	//If we get here, we succeeded in the applying
	var/obj/item/I = parent
	I.forceMove(A)
	A.item_upgrades.Add(I)
	RegisterSignal(A, COMSIG_APPVAL, .proc/apply_values)
	RegisterSignal(A, COMSIG_ADDVAL, .proc/add_values)
	A.AddComponent(/datum/component/upgrade_removal)
	A.refresh_upgrades()
	return TRUE

/datum/component/item_upgrade/proc/uninstall(obj/item/I,69ob/living/user)
	var/obj/item/P = parent
	I.item_upgrades -= P
	if(destroy_on_removal)
		UnregisterSignal(I, COMSIG_ADDVAL)
		UnregisterSignal(I, COMSIG_APPVAL)
		69del(P)
		return
	P.forceMove(get_turf(I))
	UnregisterSignal(I, COMSIG_ADDVAL)
	UnregisterSignal(I, COMSIG_APPVAL)

/datum/component/item_upgrade/proc/apply_values(atom/holder)
	if(!holder)
		return
	if(istool(holder))
		apply_values_tool(holder)
	if(isgun(holder))
		apply_values_gun(holder)
	return TRUE

/datum/component/item_upgrade/proc/add_values(atom/holder)
	ASSERT(holder)
	if(isgun(holder))
		add_values_gun(holder)
	return TRUE

/datum/component/item_upgrade/proc/apply_values_tool(obj/item/tool/T)
	if(tool_upgrades69UPGRADE_SANCTIFY69)
		T.aspects += list(SANCTIFIED)
	if(tool_upgrades69UPGRADE_PRECISION69)
		T.precision += tool_upgrades69UPGRADE_PRECISION69
	if(tool_upgrades69UPGRADE_WORKSPEED69)
		T.workspeed += tool_upgrades69UPGRADE_WORKSPEED69
	if(tool_upgrades69UPGRADE_DEGRADATION_MULT69)
		T.degradation *= tool_upgrades69UPGRADE_DEGRADATION_MULT69
	if(tool_upgrades69UPGRADE_FORCE_MULT69)
		T.force_upgrade_mults += tool_upgrades69UPGRADE_FORCE_MULT69 - 1
	if(tool_upgrades69UPGRADE_FORCE_MOD69)
		T.force_upgrade_mods += tool_upgrades69UPGRADE_FORCE_MOD69
	if(tool_upgrades69UPGRADE_FUELCOST_MULT69)
		T.use_fuel_cost *= tool_upgrades69UPGRADE_FUELCOST_MULT69
	if(tool_upgrades69UPGRADE_POWERCOST_MULT69)
		T.use_power_cost *= tool_upgrades69UPGRADE_POWERCOST_MULT69
	if(tool_upgrades69UPGRADE_BULK69)
		T.extra_bulk += tool_upgrades69UPGRADE_BULK69
	if(tool_upgrades69UPGRADE_HEALTH_THRESHOLD69)
		T.health_threshold += tool_upgrades69UPGRADE_HEALTH_THRESHOLD69
	if(tool_upgrades69UPGRADE_MAXFUEL69)
		T.max_fuel += tool_upgrades69UPGRADE_MAXFUEL69
	if(tool_upgrades69UPGRADE_MAXUPGRADES69)
		T.max_upgrades += tool_upgrades69UPGRADE_MAXUPGRADES69
	if(tool_upgrades69UPGRADE_SHARP69)
		T.sharp = tool_upgrades69UPGRADE_SHARP69
	if(tool_upgrades69UPGRADE_COLOR69)
		T.color = tool_upgrades69UPGRADE_COLOR69
	if(tool_upgrades69UPGRADE_ITEMFLAGPLUS69)
		T.item_flags |= tool_upgrades69UPGRADE_ITEMFLAGPLUS69
	if(tool_upgrades69UPGRADE_CELLPLUS69)
		switch(T.suitable_cell)
			if(/obj/item/cell/medium)
				T.suitable_cell = /obj/item/cell/large
				prefix = "large-cell"
			if(/obj/item/cell/small)
				T.suitable_cell = /obj/item/cell/medium
	T.force = initial(T.force) * T.force_upgrade_mults + T.force_upgrade_mods
	T.switched_on_force = initial(T.switched_on_force) * T.force_upgrade_mults + T.force_upgrade_mods
	T.prefixes |= prefix

/datum/component/item_upgrade/proc/apply_values_gun(var/obj/item/gun/G)
	if(weapon_upgrades69GUN_UPGRADE_DAMAGE_MULT69)
		G.damage_multiplier *= weapon_upgrades69GUN_UPGRADE_DAMAGE_MULT69
	if(weapon_upgrades69GUN_UPGRADE_DAMAGEMOD_PLUS69)
		G.damage_multiplier += weapon_upgrades69GUN_UPGRADE_DAMAGEMOD_PLUS69
	if(weapon_upgrades69GUN_UPGRADE_PEN_MULT69)
		G.penetration_multiplier *= weapon_upgrades69GUN_UPGRADE_PEN_MULT69
	if(weapon_upgrades69GUN_UPGRADE_PIERC_MULT69)
		G.pierce_multiplier += weapon_upgrades69GUN_UPGRADE_PIERC_MULT69
	if(weapon_upgrades69GUN_UPGRADE_RICO_MULT69)
		G.ricochet_multiplier += weapon_upgrades69GUN_UPGRADE_RICO_MULT69
	if(weapon_upgrades69GUN_UPGRADE_STEPDELAY_MULT69)
		G.proj_step_multiplier *= weapon_upgrades69GUN_UPGRADE_STEPDELAY_MULT69
	if(weapon_upgrades69GUN_UPGRADE_FIRE_DELAY_MULT69)
		G.fire_delay *= weapon_upgrades69GUN_UPGRADE_FIRE_DELAY_MULT69
	if(weapon_upgrades69GUN_UPGRADE_MOVE_DELAY_MULT69)
		G.move_delay *= weapon_upgrades69GUN_UPGRADE_MOVE_DELAY_MULT69
	if(weapon_upgrades69GUN_UPGRADE_RECOIL69)
		G.recoil_buildup *= weapon_upgrades69GUN_UPGRADE_RECOIL69
	if(weapon_upgrades69GUN_UPGRADE_MUZZLEFLASH69)
		G.muzzle_flash *= weapon_upgrades69GUN_UPGRADE_MUZZLEFLASH69
	if(weapon_upgrades69GUN_UPGRADE_SILENCER69)
		G.silenced = weapon_upgrades69GUN_UPGRADE_SILENCER69
	if(weapon_upgrades69GUN_UPGRADE_OFFSET69)
		G.init_offset =69ax(0, G.init_offset+weapon_upgrades69GUN_UPGRADE_OFFSET69)
	if(weapon_upgrades69GUN_UPGRADE_DAMAGE_BRUTE69)
		G.proj_damage_adjust69BRUTE69 += weapon_upgrades69GUN_UPGRADE_DAMAGE_BRUTE69
	if(weapon_upgrades69GUN_UPGRADE_DAMAGE_BURN69)
		G.proj_damage_adjust69BURN69 += weapon_upgrades69GUN_UPGRADE_DAMAGE_BURN69
	if(weapon_upgrades69GUN_UPGRADE_DAMAGE_TOX69)
		G.proj_damage_adjust69TOX69 += weapon_upgrades69GUN_UPGRADE_DAMAGE_TOX69
	if(weapon_upgrades69GUN_UPGRADE_DAMAGE_OXY69)
		G.proj_damage_adjust69OXY69 += weapon_upgrades69GUN_UPGRADE_DAMAGE_OXY69
	if(weapon_upgrades69GUN_UPGRADE_DAMAGE_CLONE69)
		G.proj_damage_adjust69CLONE69 += weapon_upgrades69GUN_UPGRADE_DAMAGE_CLONE69
	if(weapon_upgrades69GUN_UPGRADE_DAMAGE_HALLOSS69)
		G.proj_damage_adjust69HALLOSS69 += weapon_upgrades69GUN_UPGRADE_DAMAGE_HALLOSS69
	if(weapon_upgrades69GUN_UPGRADE_DAMAGE_RADIATION69)
		G.proj_damage_adjust69IRRADIATE69 += weapon_upgrades69GUN_UPGRADE_DAMAGE_RADIATION69
	if(weapon_upgrades69GUN_UPGRADE_DAMAGE_PSY69)
		G.proj_damage_adjust69PSY69 += weapon_upgrades69GUN_UPGRADE_DAMAGE_PSY69
	if(weapon_upgrades69GUN_UPGRADE_HONK69)
		G.fire_sound = 'sound/items/bikehorn.ogg'
	if(weapon_upgrades69GUN_UPGRADE_RIGGED69)
		G.rigged = TRUE
	if(weapon_upgrades69GUN_UPGRADE_EXPLODE69)
		G.rigged = 2
	if(weapon_upgrades69GUN_UPGRADE_ZOOM69)
		G.zoom_factor += weapon_upgrades69GUN_UPGRADE_ZOOM69
		G.initialize_scope()
		if(ismob(G.loc))
			var/mob/user = G.loc
			user.update_action_buttons()
	if(weapon_upgrades69GUN_UPGRADE_THERMAL69)
		G.vision_flags = SEE_MOBS
	if(weapon_upgrades69GUN_UPGRADE_GILDED69)
		G.gilded = TRUE

	if(weapon_upgrades69GUN_UPGRADE_BAYONET69)
		G.attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
		G.sharp = TRUE
	if(weapon_upgrades69GUN_UPGRADE_MELEEDAMAGE69)
		G.force += weapon_upgrades69GUN_UPGRADE_MELEEDAMAGE69
	if(weapon_upgrades69GUN_UPGRADE_MELEEPENETRATION69)
		G.armor_penetration += weapon_upgrades69GUN_UPGRADE_MELEEPENETRATION69
	if(weapon_upgrades69GUN_UPGRADE_ONEHANDPENALTY69)
		G.one_hand_penalty *= weapon_upgrades69GUN_UPGRADE_ONEHANDPENALTY69

	if(weapon_upgrades69GUN_UPGRADE_DNALOCK69)
		G.dna_compare_samples = TRUE
		if(G.dna_lock_sample == "not_set")
			G.dna_lock_sample = usr.real_name

	if(G.dna_compare_samples == FALSE)
		G.dna_lock_sample = "not_set"

	if(G.dna_lock_sample == "not_set") //that69ay look stupid, but without it previous two lines won't trigger on DNALOCK removal.
		G.dna_compare_samples = FALSE
	
	if(!isnull(weapon_upgrades69GUN_UPGRADE_FORCESAFETY69))
		G.restrict_safety = TRUE
		G.safety = weapon_upgrades69GUN_UPGRADE_FORCESAFETY69
	if(istype(G, /obj/item/gun/energy))
		var/obj/item/gun/energy/E = G
		if(weapon_upgrades69GUN_UPGRADE_CHARGECOST69)
			E.charge_cost *= weapon_upgrades69GUN_UPGRADE_CHARGECOST69
		if(weapon_upgrades69GUN_UPGRADE_OVERCHARGE_MAX69)
			E.overcharge_rate *= weapon_upgrades69GUN_UPGRADE_OVERCHARGE_MAX69
		if(weapon_upgrades69GUN_UPGRADE_OVERCHARGE_MAX69)
			E.overcharge_max *= weapon_upgrades69GUN_UPGRADE_OVERCHARGE_MAX69
		if(weapon_upgrades69GUN_UPGRADE_AGONY_MULT69)
			E.proj_agony_multiplier *= weapon_upgrades69GUN_UPGRADE_AGONY_MULT69

	if(istype(G, /obj/item/gun/projectile))
		var/obj/item/gun/projectile/P = G
		if(weapon_upgrades69GUN_UPGRADE_MAGUP69)
			P.max_shells += weapon_upgrades69GUN_UPGRADE_MAGUP69

	for(var/datum/firemode/F in G.firemodes)
		apply_values_firemode(F)

/datum/component/item_upgrade/proc/add_values_gun(obj/item/gun/G)
	if(weapon_upgrades69GUN_UPGRADE_FULLAUTO69)
		G.add_firemode(FULL_AUTO_400)

/datum/component/item_upgrade/proc/apply_values_firemode(datum/firemode/F)
	for(var/i in F.settings)
		switch(i)
			if("fire_delay")
				if(weapon_upgrades69GUN_UPGRADE_FIRE_DELAY_MULT69)
					F.settings69i69 *= weapon_upgrades69GUN_UPGRADE_FIRE_DELAY_MULT69
			if("move_delay")
				if(weapon_upgrades69GUN_UPGRADE_MOVE_DELAY_MULT69)
					F.settings69i69 *= weapon_upgrades69GUN_UPGRADE_MOVE_DELAY_MULT69

/datum/component/item_upgrade/proc/on_examine(mob/user)
	if(tool_upgrades69UPGRADE_SANCTIFY69)
		to_chat(user, SPAN_NOTICE("Does additional burn damage to69utants."))
	if (tool_upgrades69UPGRADE_PRECISION69 > 0)
		to_chat(user, SPAN_NOTICE("Enhances precision by 69tool_upgrades69UPGRADE_PRECISION6969"))
	else if(tool_upgrades69UPGRADE_PRECISION69 < 0)
		to_chat(user, SPAN_WARNING("Reduces precision by 69abs(tool_upgrades69UPGRADE_PRECISION69)69"))
	if(tool_upgrades69UPGRADE_WORKSPEED69)
		to_chat(user, SPAN_NOTICE("Enhances workspeed by 69tool_upgrades69UPGRADE_WORKSPEED69*10069%"))

	if(tool_upgrades69UPGRADE_DEGRADATION_MULT69)
		if(tool_upgrades69UPGRADE_DEGRADATION_MULT69 < 1)
			to_chat(user, SPAN_NOTICE("Reduces tool degradation by 69(1-tool_upgrades69UPGRADE_DEGRADATION_MULT69)*10069%"))
		else if	(tool_upgrades69UPGRADE_DEGRADATION_MULT69 > 1)
			to_chat(user, SPAN_WARNING("Increases tool degradation by 69(tool_upgrades69UPGRADE_DEGRADATION_MULT69-1)*10069%"))

	if(tool_upgrades69UPGRADE_FORCE_MULT69 >= 1)
		to_chat(user, SPAN_NOTICE("Increases tool damage by 69(tool_upgrades69UPGRADE_FORCE_MULT69-1)*10069%"))
	if(tool_upgrades69UPGRADE_FORCE_MOD69)
		to_chat(user, SPAN_NOTICE("Increases tool damage by 69tool_upgrades69UPGRADE_FORCE_MOD6969"))
	if(tool_upgrades69UPGRADE_POWERCOST_MULT69 >= 1)
		to_chat(user, SPAN_WARNING("Modifies power usage by 69(tool_upgrades69UPGRADE_POWERCOST_MULT69-1)*10069%"))
	if(tool_upgrades69UPGRADE_FUELCOST_MULT69 >= 1)
		to_chat(user, SPAN_WARNING("Modifies fuel usage by 69(tool_upgrades69UPGRADE_FUELCOST_MULT69-1)*10069%"))
	if(tool_upgrades69UPGRADE_MAXFUEL69)
		to_chat(user, SPAN_NOTICE("Modifies fuel storage by 69tool_upgrades69UPGRADE_MAXFUEL6969 units."))
	if(tool_upgrades69UPGRADE_BULK69)
		to_chat(user, SPAN_WARNING("Increases tool size by 69tool_upgrades69UPGRADE_BULK6969"))
	if(tool_upgrades69UPGRADE_MAXUPGRADES69)
		to_chat(user, SPAN_NOTICE("Adds 69tool_upgrades69UPGRADE_MAXUPGRADES6969 additional69odification slots."))
	if(re69uired_69ualities.len)
		to_chat(user, SPAN_WARNING("Re69uires a tool with one of the following 69ualities:"))
		to_chat(user, english_list(re69uired_69ualities, and_text = " or "))

	if(weapon_upgrades.len)
		to_chat(user, SPAN_NOTICE("Can be attached to a firearm, giving the following benefits:"))

		if(weapon_upgrades69GUN_UPGRADE_DAMAGE_MULT69)
			var/amount = weapon_upgrades69GUN_UPGRADE_DAMAGE_MULT69-1
			if(amount > 0)
				to_chat(user, SPAN_NOTICE("Increases projectile damage by 69amount*10069%"))
			else
				to_chat(user, SPAN_WARNING("Decreases projectile damage by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_PEN_MULT69)
			var/amount = weapon_upgrades69GUN_UPGRADE_PEN_MULT69-1
			if(amount > 0)
				to_chat(user, SPAN_NOTICE("Increases projectile penetration by 69amount*10069%"))
			else
				to_chat(user, SPAN_WARNING("Decreases projectile penetration by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_PIERC_MULT69)
			var/amount = weapon_upgrades69GUN_UPGRADE_PIERC_MULT69
			if(amount > 1)
				to_chat(user, SPAN_NOTICE("Increases projectile piercing penetration by 69amount69 walls"))
			else if(amount == 1)
				to_chat(user, SPAN_NOTICE("Increases projectile piercing penetration by 69amount69 wall"))
			else if(amount == -1)
				to_chat(user, SPAN_WARNING("Decreases projectile piercing penetration by 69amount69 wall"))
			else
				to_chat(user, SPAN_WARNING("Decreases projectile piercing penetration by 69amount69 walls"))

		if(weapon_upgrades69GUN_UPGRADE_RICO_MULT69)
			var/amount = weapon_upgrades69GUN_UPGRADE_RICO_MULT69
			if(amount > 0)
				to_chat(user, SPAN_WARNING("Increases projectile ricochet by 69amount*10069%"))
			else
				to_chat(user, SPAN_NOTICE("Decreases projectile ricochet by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_FIRE_DELAY_MULT69)
			var/amount = weapon_upgrades69GUN_UPGRADE_FIRE_DELAY_MULT69-1
			if(amount > 0)
				to_chat(user, SPAN_WARNING("Increases fire delay by 69amount*10069%"))
			else
				to_chat(user, SPAN_NOTICE("Decreases fire delay by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_MOVE_DELAY_MULT69)
			var/amount = weapon_upgrades69GUN_UPGRADE_MOVE_DELAY_MULT69-1
			if(amount > 0)
				to_chat(user, SPAN_WARNING("Increases69ove delay by 69amount*10069%"))
			else
				to_chat(user, SPAN_NOTICE("Decreases69ove delay by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_STEPDELAY_MULT69)
			var/amount = weapon_upgrades69GUN_UPGRADE_STEPDELAY_MULT69-1
			if(amount > 0)
				to_chat(user, SPAN_WARNING("Slows down the weapons projectile by 69amount*10069%"))
			else
				to_chat(user, SPAN_NOTICE("Speeds up the weapons projectile by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_DAMAGE_BRUTE69)
			to_chat(user, SPAN_NOTICE("Modifies projectile brute damage by 69weapon_upgrades69GUN_UPGRADE_DAMAGE_BRUTE6969 damage points"))

		if(weapon_upgrades69GUN_UPGRADE_DAMAGE_BURN69)
			to_chat(user, SPAN_NOTICE("Modifies projectile burn damage by 69weapon_upgrades69GUN_UPGRADE_DAMAGE_BURN6969 damage points"))

		if(weapon_upgrades69GUN_UPGRADE_DAMAGE_TOX69)
			to_chat(user, SPAN_NOTICE("Modifies projectile toxic damage by 69weapon_upgrades69GUN_UPGRADE_DAMAGE_TOX6969 damage points"))

		if(weapon_upgrades69GUN_UPGRADE_DAMAGE_OXY69)
			to_chat(user, SPAN_NOTICE("Modifies projectile oxy-loss damage by 69weapon_upgrades69GUN_UPGRADE_DAMAGE_OXY6969 damage points"))

		if(weapon_upgrades69GUN_UPGRADE_DAMAGE_CLONE69)
			to_chat(user, SPAN_NOTICE("Modifies projectile clone damage by 69weapon_upgrades69GUN_UPGRADE_DAMAGE_CLONE6969 damage points"))

		if(weapon_upgrades69GUN_UPGRADE_DAMAGE_HALLOSS69)
			to_chat(user, SPAN_NOTICE("Modifies projectile pseudo damage by 69weapon_upgrades69GUN_UPGRADE_DAMAGE_HALLOSS6969 damage points"))

		if(weapon_upgrades69GUN_UPGRADE_DAMAGE_RADIATION69)
			to_chat(user, SPAN_NOTICE("Modifies projectile radiation damage by 69weapon_upgrades69GUN_UPGRADE_DAMAGE_RADIATION6969 damage points"))

		if(weapon_upgrades69GUN_UPGRADE_DAMAGE_PSY69)
			to_chat(user, SPAN_NOTICE("Modifies projectile psy damage by 69weapon_upgrades69GUN_UPGRADE_DAMAGE_PSY6969 damage points"))

		if(weapon_upgrades69GUN_UPGRADE_RECOIL69)
			var/amount = weapon_upgrades69GUN_UPGRADE_RECOIL69-1
			if(amount > 0)
				to_chat(user, SPAN_WARNING("Increases kickback by 69amount*10069%"))
			else
				to_chat(user, SPAN_NOTICE("Decreases kickback by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_MUZZLEFLASH69)
			var/amount = weapon_upgrades69GUN_UPGRADE_MUZZLEFLASH69-1
			if(amount > 0)
				to_chat(user, SPAN_WARNING("Increases69uzzle flash by 69amount*10069%"))
			else
				to_chat(user, SPAN_NOTICE("Decreases69uzzle flash by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_MAGUP69)
			var/amount = weapon_upgrades69GUN_UPGRADE_MAGUP69
			if(amount > 1)
				to_chat(user, SPAN_NOTICE("Increases internal69agazine size by 69amount69"))
			else
				to_chat(user, SPAN_WARNING("Decreases internal69agazine size by 69amount69"))

		if(weapon_upgrades69GUN_UPGRADE_SILENCER69 == 1)
			to_chat(user, SPAN_NOTICE("Silences the weapon."))

		if(weapon_upgrades69GUN_UPGRADE_FORCESAFETY69 == 0)
			to_chat(user, SPAN_WARNING("Disables the safety toggle of the weapon."))
		else if(weapon_upgrades69GUN_UPGRADE_FORCESAFETY69 == 1)
			to_chat(user, SPAN_WARNING("Forces the safety toggle of the weapon to always be on."))
		
		if(weapon_upgrades69GUN_UPGRADE_DNALOCK69 == 1)
			to_chat(user, SPAN_WARNING("Adds a biometric scanner to the weapon."))

		if(weapon_upgrades69GUN_UPGRADE_CHARGECOST69)
			var/amount = weapon_upgrades69GUN_UPGRADE_CHARGECOST69-1
			if(amount > 0)
				to_chat(user, SPAN_WARNING("Increases cell firing cost by 69amount*10069%"))
			else
				to_chat(user, SPAN_NOTICE("Decreases cell firing cost by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_OVERCHARGE_MAX69)
			var/amount = weapon_upgrades69GUN_UPGRADE_OVERCHARGE_MAX69-1
			if(amount > 0)
				to_chat(user, SPAN_WARNING("Increases overcharge69aximum by 69amount*10069%"))
			else
				to_chat(user, SPAN_NOTICE("Decreases overcharge69aximum by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_OVERCHARGE_RATE69)
			var/amount = weapon_upgrades69GUN_UPGRADE_OVERCHARGE_RATE69-1
			if(amount > 0)
				to_chat(user, SPAN_NOTICE("Increases overcharge rate by 69amount*10069%"))
			else
				to_chat(user, SPAN_WARNING("Decreases overcharge rate by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_OFFSET69)
			var/amount = weapon_upgrades69GUN_UPGRADE_OFFSET69-1
			if(amount > 0)
				to_chat(user, SPAN_WARNING("Increases weapon inaccuracy by 69amount*10069%"))
			else
				to_chat(user, SPAN_NOTICE("Decreases weapon inaccuracy by 69abs(amount*100)69%"))

		if(weapon_upgrades69GUN_UPGRADE_HONK69)
			to_chat(user, SPAN_WARNING("Cheers up the firing sound of the weapon."))

		if(weapon_upgrades69GUN_UPGRADE_RIGGED69)
			to_chat(user, SPAN_WARNING("Rigs the weapon to fire back on its user."))

		if(weapon_upgrades69GUN_UPGRADE_EXPLODE69)
			to_chat(user, SPAN_WARNING("Rigs the weapon to explode."))

		if(weapon_upgrades69GUN_UPGRADE_ZOOM69)
			var/amount = weapon_upgrades69GUN_UPGRADE_ZOOM69
			if(amount > 0)
				to_chat(user, SPAN_NOTICE("Increases scope zoom by x69amount69"))
			else
				to_chat(user, SPAN_WARNING("Decreases scope zoom by x69amount69"))

		to_chat(user, SPAN_WARNING("Re69uires a weapon with the following properties"))
		to_chat(user, english_list(re69_gun_tags))

/datum/component/item_upgrade/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_IATTACK)
	UnregisterSignal(parent, COMSIG_EXAMINE)
	UnregisterSignal(parent, COMSIG_REMOVE)

/datum/component/item_upgrade/PostTransfer()
	return COMPONENT_TRANSFER

/datum/component/upgrade_removal
	dupe_mode = COMPONENT_DUPE_UNI69UE

/datum/component/upgrade_removal/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATTACKBY, .proc/attempt_uninstall)

/datum/component/upgrade_removal/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_ATTACKBY)

/datum/component/upgrade_removal/proc/attempt_uninstall(obj/item/C,69ob/living/user)
	if(!isitem(C))
		return 0

	var/obj/item/upgrade_loc = parent

	var/obj/item/tool/T //For dealing damage to the item

	if(istool(upgrade_loc))
		T = upgrade_loc

	ASSERT(istype(upgrade_loc))
	//Removing upgrades from a tool.69ery difficult, but passing the check only gets you the perfect result
	//You can also get a lesser success (remove the upgrade but break it in the process) if you fail
	//Using a laser guided stabilised screwdriver is recommended. Precision69ods will69ake this easier
	if(upgrade_loc.item_upgrades.len && C.has_69uality(69UALITY_SCREW_DRIVING))
		var/list/possibles = upgrade_loc.item_upgrades.Copy()
		possibles += "Cancel"
		var/obj/item/tool_upgrade/toremove = input("Which upgrade would you like to try to remove? The upgrade will probably be destroyed in the process","Removing Upgrades") in possibles
		if(toremove == "Cancel")
			return 1
		var/datum/component/item_upgrade/IU = toremove.GetComponent(/datum/component/item_upgrade)
		if(IU.removable == FALSE)
			to_chat(user, SPAN_DANGER("\the 69toremove69 seems to be fused with the 69upgrade_loc69"))
		else
			if(C.use_tool(user = user, target =  upgrade_loc, base_time = IU.removal_time, re69uired_69uality = 69UALITY_SCREW_DRIVING, fail_chance = IU.removal_difficulty, re69uired_stat = STAT_MEC))
				//If you pass the check, then you69anage to remove the upgrade intact
				if(!IU.destroy_on_removal && user)
					to_chat(user, SPAN_NOTICE("You successfully remove \the 69toremove69 while leaving it intact."))
				SEND_SIGNAL(toremove, COMSIG_REMOVE, upgrade_loc)
				upgrade_loc.refresh_upgrades()
				return 1
			else
				//You failed the check, lets see what happens
				if(IU.breakable == FALSE)
					to_chat(user, SPAN_DANGER("You failed to remove \the 69toremove69."))
					upgrade_loc.refresh_upgrades()
					user.update_action_buttons()
				else if(prob(50))
					//50% chance to break the upgrade and remove it
					to_chat(user, SPAN_DANGER("You successfully remove \the 69toremove69, but destroy it in the process."))
					SEND_SIGNAL(toremove, COMSIG_REMOVE, parent)
					69DEL_NULL(toremove)
					upgrade_loc.refresh_upgrades()
					user.update_action_buttons()
					return 1
				else if(T && T.degradation) //Because robot tools are unbreakable
					//otherwise, damage the host tool a bit, and give you another try
					to_chat(user, SPAN_DANGER("You only69anaged to damage \the 69upgrade_loc69, but you can retry."))
					T.adjustToolHealth(-(5 * T.degradation), user) // inflicting 4 times use damage
					upgrade_loc.refresh_upgrades()
					user.update_action_buttons()
					return 1
	return 0

/obj/item/tool_upgrade
	name = "tool upgrade"
	icon = 'icons/obj/tool_upgrades.dmi'
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL
	spawn_tags = SPAWN_TAG_TOOL_UPGRADE
	price_tag = 200
	rarity_value = 15
	bad_type = /obj/item/tool_upgrade
