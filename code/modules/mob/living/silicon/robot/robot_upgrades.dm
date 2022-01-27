// robot_upgrades.dm
// Contains69arious borg upgrades.

/obj/item/borg/upgrade
	name = "borg upgrade69odule."
	desc = "Protected by FRM."
	icon = 'icons/obj/module.dmi'
	icon_state = "cyborg_upgrade"
	matter = list(MATERIAL_STEEL = 10)
	spawn_tags = list(SPAWN_TAG_ELECTRONICS)
	rarity_value = 50
	var/locked = 0
	var/require_module = FALSE
	var/installed = 0

/obj/item/borg/upgrade/proc/action(var/mob/living/silicon/robot/R)
	if(R.stat == DEAD)
		to_chat(usr, SPAN_WARNING("The 69src69 will not function on a deceased robot."))
		return 1
	return 0


/obj/item/borg/upgrade/reset
	name = "robotic69odule reset board"
	desc = "Used to reset a cyborg's69odule. Destroys any other upgrades applied to the robot."
	icon_state = "cyborg_upgrade1"
	require_module = TRUE

/obj/item/borg/upgrade/reset/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	R.uneq_all()
	R.modtype = initial(R.modtype)

	R.notify_ai(ROBOT_NOTIFICATION_MODULE_RESET, R.module.name)
	R.module.Reset(R)
	qdel(R.module)
	R.module = null
	R.updatename("Default")

	return 1

/obj/item/borg/upgrade/rename
	name = "robot reclassification board"
	desc = "Used to rename a cyborg."
	icon_state = "cyborg_upgrade1"
	var/heldname = "default name"

/obj/item/borg/upgrade/rename/attack_self(mob/user as69ob)
	heldname = sanitizeSafe(input(user, "Enter new robot name", "Robot Reclassification", heldname),69AX_NAME_LEN)

/obj/item/borg/upgrade/rename/action(var/mob/living/silicon/robot/R)
	if(..()) return 0
	R.notify_ai(ROBOT_NOTIFICATION_NEW_NAME, R.name, heldname)
	R.name = heldname
	R.custom_name = heldname
	R.real_name = heldname

	return 1

/obj/item/borg/upgrade/floodlight
	name = "robot floodlight69odule"
	desc = "Used to boost cyborg's light intensity."
	icon_state = "cyborg_upgrade1"

/obj/item/borg/upgrade/floodlight/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.intenselight)
		to_chat(usr, "This cyborg's light was already upgraded")
		return 0
	else
		R.intenselight = 1
		R.update_robot_light()
		to_chat(R, "Lighting systems upgrade detected.")
	return 1

/obj/item/borg/upgrade/restart
	name = "robot emergency restart69odule"
	desc = "Used to force a restart of a disabled-but-repaired robot, bringing it back online."
	icon_state = "cyborg_upgrade1"
	matter = list(MATERIAL_STEEL = 6,69ATERIAL_GLASS = 5)


/obj/item/borg/upgrade/restart/action(var/mob/living/silicon/robot/R)
	if(R.health < 0)
		to_chat(usr, "You have to repair the robot before using this69odule!")
		return 0

	if(!R.key)
		for(var/mob/observer/ghost/ghost in GLOB.player_list)
			if(ghost.mind && ghost.mind.current == R)
				R.key = ghost.key

	R.stat = CONSCIOUS
	GLOB.dead_mob_list -= R
	GLOB.living_mob_list |= R
	R.death_notified = FALSE
	R.notify_ai(ROBOT_NOTIFICATION_NEW_UNIT)
	return 1


/obj/item/borg/upgrade/vtec
	name = "robotic69TEC69odule"
	desc = "Used to kick in a robot's69TEC systems, increasing their speed."
	icon_state = "cyborg_upgrade2"
	matter = list(MATERIAL_STEEL = 8,69ATERIAL_GLASS = 6,69ATERIAL_GOLD = 5)
	require_module = TRUE

/obj/item/borg/upgrade/vtec/action(var/mob/living/silicon/robot/R)
	if(..())
		return 0

	R.speed_factor += 0.1
	return 1


/obj/item/borg/upgrade/tasercooler
	name = "robotic Rapid Taser Cooling69odule"
	desc = "Used to cool a69ounted taser, increasing the potential current in it and thus its recharge rate."
	icon_state = "cyborg_upgrade3"
	matter = list(MATERIAL_STEEL = 8,69ATERIAL_GLASS = 6,69ATERIAL_GOLD = 2,69ATERIAL_DIAMOND = 2)
	require_module = TRUE


/obj/item/borg/upgrade/tasercooler/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade69ounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no69ounting point for the69odule!")
		return 0

	var/obj/item/gun/energy/taser/mounted/cyborg/T = locate() in R.module
	if(!T)
		T = locate() in R.module.contents
	if(!T)
		T = locate() in R.module.modules
	if(!T)
		to_chat(usr, "This robot has had its taser removed!")
		return 0

	if(T.recharge_time <= 2)
		to_chat(R, "Maximum cooling achieved for this hardpoint!")
		to_chat(usr, "There's no room for another cooling unit!")
		return 0

	else
		T.recharge_time =69ax(2 , T.recharge_time - 4)

	return 1

/obj/item/borg/upgrade/jetpack
	name = "mining robot jetpack"
	desc = "A carbon dioxide jetpack suitable for low-gravity69ining operations."
	icon_state = "cyborg_upgrade3"
	require_module = TRUE

/obj/item/borg/upgrade/jetpack/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade69ounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no69ounting point for the69odule!")
		return 0
	else
		R.module.modules += new/obj/item/tank/jetpack/carbondioxide
//		for(var/obj/item/tank/jetpack/carbondioxide in R.module.modules)
//			R.internals = src
		//R.icon_state="Miner+j"
		R.module.Initialize() //Fixes layering and possible tool issues
		return 1

/obj/item/borg/upgrade/rcd
	name = "engineering robot RCD"
	desc = "A rapid construction device69odule for use during construction operations."
	icon_state = "cyborg_upgrade3"
	matter = list(MATERIAL_PLASTEEL = 15,69ATERIAL_PLASMA = 10,69ATERIAL_URANIUM = 10)
	require_module = TRUE

/obj/item/borg/upgrade/rcd/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(!R.module || !(type in R.module.supported_upgrades))
		to_chat(R, "Upgrade69ounting error!  No suitable hardpoint detected!")
		to_chat(usr, "There's no69ounting point for the69odule!")
		return 0
	else
		R.module.modules += new/obj/item/rcd/borg(R.module)
		R.module.Initialize() //Fixes layering and possible tool issues
		return 1

/obj/item/borg/upgrade/syndicate
	name = "illegal equipment69odule"
	desc = "Unlocks the hidden, deadlier functions of a robot"
	icon_state = "cyborg_upgrade3"
	matter = list(MATERIAL_STEEL = 10,69ATERIAL_GLASS = 15,69ATERIAL_DIAMOND = 10)
	require_module = TRUE

/obj/item/borg/upgrade/syndicate/action(var/mob/living/silicon/robot/R)
	if(..()) return 0

	if(R.emagged == 1)
		return 0

	R.emagged = 1
	return 1
