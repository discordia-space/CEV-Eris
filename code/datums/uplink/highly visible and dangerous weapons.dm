/***************************************
* Highly Visible and Dangerous Weapons *
***************************************/
/datum/uplink_item/item/visible_weapons
	category = /datum/uplink_category/visible_weapons

/datum/uplink_item/item/visible_weapons/dartgun
	name = "Z-H P \"Artemis\" Dart Gun"
	item_cost = 4
	path = /obj/item/storage/box/syndie_kit/dartgun

/datum/uplink_item/item/visible_weapons/crossbow
	name = "Energy Crossbow"
	item_cost = 6
	path = /obj/item/gun/energy/crossbow

/datum/uplink_item/item/visible_weapons/energy_sword
	name = "Energy Sword"
	item_cost = 6
	path = /obj/item/melee/energy/sword

/datum/uplink_item/item/visible_weapons/pistol
	name = "OR HG .25 CS \"Mandella\" Silenced Handgun"
	item_cost = 6
	path = /obj/item/storage/box/syndie_kit/pistol

/datum/uplink_item/item/visible_weapons/riggedlaser
	name = "Exosuit 'Immolator' Energy Weapon"
	item_cost = 4
	path = /obj/item/mech_equipment/mounted_system/taser/laser


/datum/uplink_item/item/visible_weapons/revolver
	name = "FS REV .40 Magnum \"Miller\" Revolver"
	item_cost = 7
	antag_roles = list(ROLE_CONTRACTOR,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/revolver

/datum/uplink_item/item/visible_weapons/hornet
	name = "OR REV .20 \"LBR-8 Hornet\" Revolver"
	item_cost = 7
	antag_roles = list(ROLE_MARSHAL)
	path = /obj/item/storage/box/syndie_kit/hornet

/datum/uplink_item/item/visible_weapons/submachinegun
	name = "S SMG .35 \"C-20r\" Submachinegun"
	item_cost = 8
	path = /obj/item/storage/box/syndie_kit/c20r

/datum/uplink_item/item/visible_weapons/assaultrifle
	name = "OR BR \"STS-35\" Battle Rifle"
	item_cost = 10
	antag_roles = list(ROLE_CONTRACTOR,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/sts35

/datum/uplink_item/item/visible_weapons/winchesterrifle
	name = "FS BR .40 \"Svengali\""
	item_cost = 10
	antag_roles = list(ROLE_MARSHAL)
	path = /obj/item/storage/box/syndie_kit/winchester

/datum/uplink_item/item/visible_weapons/lshotgun
	name = "FS BR \"Sogekihei\""
	item_cost = 8
	antag_roles = list(ROLE_MARSHAL)
	path = /obj/item/storage/box/syndie_kit/lshotgun

/datum/uplink_item/item/visible_weapons/pug
	name = "SA SG \"Bojevic\" Pug Shotgun"
	item_cost = 8
	antag_roles = list(ROLE_CONTRACTOR,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/storage/box/syndie_kit/pug

/datum/uplink_item/item/visible_weapons/heavysniper
	name = "SA AMR .60 \"Hristov\" Anti-material Rifle"
	item_cost = 20
	path = /obj/item/storage/briefcase/antimaterial_rifle

/datum/uplink_item/item/visible_weapons/rigged
	name = "Weapon reverse loader"
	item_cost = 5
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/gun_upgrade/mechanism/reverse_loader

/datum/uplink_item/item/visible_weapons/boom_trigger
	name = "Syndicate \"Self Desturct\" trigger"
	item_cost = 5
	antag_roles = list(ROLE_CONTRACTOR,ROLE_MARSHAL,ROLE_INQUISITOR,ROLE_MERCENARY,ROLE_CARRION)
	path = /obj/item/gun_upgrade/trigger/boom

/datum/uplink_item/item/visible_weapons/dna_trigger
	name = "Frozen Star \"DNA lock\" trigger"
	item_cost = 5
	path = /obj/item/gun_upgrade/trigger/dnalock

/datum/uplink_item/item/visible_weapons/dna_trigger
	name = "Frozen Star \"DNA lock\" trigger"
	item_cost = 5
	path = /obj/item/gun_upgrade/trigger/dnalock

/datum/uplink_item/item/visible_weapons/gauss
	name = "Syndicate \"Gauss Coil\" barrel"
	item_cost = 7
	path = /obj/item/gun_upgrade/barrel/gauss

/datum/uplink_item/item/visible_weapons/blender
	name = "OR \"Bullet Blender\" barrel"
	item_cost = 5
	path = /obj/item/gun_upgrade/barrel/blender

/datum/uplink_item/item/visible_weapons/psychic_lasercannon
	name = "Prototype: psychic laser cannon"
	desc = "A laser cannon that attacks the minds of people, causing sanity loss and inducing mental breakdowns. Also can be used to complete mind fryer contracts."
	item_cost = 12
	path = /obj/item/gun/energy/psychic/lasercannon

/datum/uplink_item/item/visible_weapons/psychic_lasercannon/buy(obj/item/device/uplink/U)
	. = ..()
	if(.)
		var/obj/item/gun/energy/psychic/lasercannon/L = .
		L.owner = U.uplink_owner
/*
/datum/uplink_item/item/visible_weapons/pickle
	name = "Pickle"
	item_cost = 100
	path = /obj/item/storage/box/syndie_kit/pickle
*/

//********** Blitzshell weapon uplink upgrades **********//

/datum/uplink_item/item/visible_weapons/blitz_plasma_burst
	name = "Blitzshell Plasma Burst Mechanism"
	desc = "Activates the burstfire mechanism of the embedded Sprengen plasma rifle."
	item_cost = 5
	antag_roles = list(ROLE_BLITZ)

/datum/uplink_item/item/visible_weapons/blitz_plasma_burst/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/living/user)
	if(user && istype(user, /mob/living/silicon/robot/drone/blitzshell))
		var/mob/living/silicon/robot/drone/blitzshell/BS = user
		var/obj/item/gun/energy/plasma/mounted/blitz/GUN = locate(/obj/item/gun/energy/plasma/mounted/blitz) in BS.module.modules
		if(istype(GUN))
			GUN.init_firemodes += list(list(mode_name="Burst", mode_desc="A three-round burst of light plasma rounds, for dealing with unruly crowds", projectile_type=/obj/item/projectile/plasma/light, fire_sound='sound/weapons/energy/melt.ogg', burst=3, fire_delay=12, burst_delay=1, charge_cost=15, icon="burst", projectile_color = "#0088ff"))
			GUN.refresh_upgrades()
			U.blacklist += name
			return TRUE
	return FALSE

/datum/uplink_item/item/visible_weapons/blitz_plasma_burst/can_view(obj/item/device/uplink/U)
	return ..() && !(name in U.blacklist)


/datum/uplink_item/item/visible_weapons/blitz_plasma_detonate
	name = "Blitzshell Plasma Detonation Mechanism"
	desc = "Activates the AP mechanism of the embedded Sprengen plasma rifle."
	item_cost = 8
	antag_roles = list(ROLE_BLITZ)

/datum/uplink_item/item/visible_weapons/blitz_plasma_detonate/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/living/user)
	if(user && istype(user, /mob/living/silicon/robot/drone/blitzshell))
		var/mob/living/silicon/robot/drone/blitzshell/BS = user
		var/obj/item/gun/energy/plasma/mounted/blitz/GUN = locate(/obj/item/gun/energy/plasma/mounted/blitz) in BS.module.modules
		if(istype(GUN))
			GUN.init_firemodes += list(list(mode_name="Detonate", mode_desc="A heavy armor-stripping plasma round", projectile_type=/obj/item/projectile/plasma/aoe/heat, fire_sound='sound/weapons/energy/incinerate.ogg', burst=1, fire_delay=16, charge_cost=90, icon="destroy", projectile_color = "#FFFFFF"))
			GUN.refresh_upgrades()
			U.blacklist += name
			return TRUE
	return FALSE


/datum/uplink_item/item/visible_weapons/blitz_plasma_detonate
	name = "Blitzshell Plasma Detonation Mechanism"
	desc = "Activates the AP mechanism of the embedded Sprengen plasma rifle."
	item_cost = 8
	antag_roles = list(ROLE_BLITZ)

/datum/uplink_item/item/visible_weapons/blitz_plasma_detonate/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/living/user)
	if(user && istype(user, /mob/living/silicon/robot/drone/blitzshell))
		var/mob/living/silicon/robot/drone/blitzshell/BS = user
		var/obj/item/gun/energy/plasma/mounted/blitz/GUN = locate(/obj/item/gun/energy/plasma/mounted/blitz) in BS.module.modules
		if(istype(GUN))
			GUN.init_firemodes += list(list(mode_name="Detonate", mode_desc="A heavy armor-stripping plasma round", projectile_type=/obj/item/projectile/plasma/aoe/heat, fire_sound='sound/weapons/energy/incinerate.ogg', burst=1, fire_delay=18, charge_cost=90, icon="destroy", projectile_color = "#FFFFFF"))
			GUN.refresh_upgrades()
			U.blacklist += name
			return TRUE
	return FALSE

/datum/uplink_item/item/visible_weapons/blitz_plasma_detonate/can_view(obj/item/device/uplink/U)
	return ..() && !(name in U.blacklist)


/datum/uplink_item/item/visible_weapons/blitz_plasma_emp
	name = "Blitzshell Plasma EMP Mechanism"
	desc = "Activates the EMP mechanism of the embedded Sprengen plasma rifle."
	item_cost = 8
	antag_roles = list(ROLE_BLITZ)

/datum/uplink_item/item/visible_weapons/blitz_plasma_emp/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/living/user)
	if(user && istype(user, /mob/living/silicon/robot/drone/blitzshell))
		var/mob/living/silicon/robot/drone/blitzshell/BS = user
		var/obj/item/gun/energy/plasma/mounted/blitz/GUN = locate(/obj/item/gun/energy/plasma/mounted/blitz) in BS.module.modules
		if(istype(GUN))
			GUN.init_firemodes += list(list(mode_name="Pulse", mode_desc="A plasma round configured to cause a pulse of EMP", projectile_type=/obj/item/projectile/plasma/aoe/ion, fire_sound='sound/weapons/Taser.ogg', burst=1, fire_delay=12, charge_cost=90, icon="stun", projectile_color = "#00FFFF"))
			GUN.refresh_upgrades()
			U.blacklist += name
			return TRUE
	return FALSE

/datum/uplink_item/item/visible_weapons/blitz_plasma_emp/can_view(obj/item/device/uplink/U)
	return ..() && !(name in U.blacklist)


/datum/uplink_item/item/visible_weapons/blitz_laserweapon
	name = "Blitzshell Laser Weapons Upgrade"
	desc = "Activates the embedded laser weapon system."
	item_cost = 10
	antag_roles = list(ROLE_BLITZ)

/datum/uplink_item/item/visible_weapons/blitz_laserweapon/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/living/user)
	if(user && istype(user, /mob/living/silicon/robot/drone/blitzshell))
		var/mob/living/silicon/robot/drone/blitzshell/BS = user
		if(locate(/obj/item/gun/energy/laser/mounted/blitz) in BS.module.modules)
			to_chat(BS, SPAN_WARNING("You already have a laser system installed."))
			return 0
		BS.module.modules += new /obj/item/gun/energy/laser/mounted/blitz(BS.module)
		U.blacklist += name
		return TRUE
	return FALSE

/datum/uplink_item/item/visible_weapons/blitz_laserweapon/can_view(obj/item/device/uplink/U)
	return ..() && !(name in U.blacklist)


/datum/uplink_item/item/visible_weapons/blitz_laser_stun
	name = "Blitzshell Laser Stun Mechanism"
	desc = "Activates the stun mechanism of the embedded Strahl laser rifle."
	item_cost = 5
	antag_roles = list(ROLE_BLITZ)

/datum/uplink_item/item/visible_weapons/blitz_laser_stun/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/living/user)
	if(user && istype(user, /mob/living/silicon/robot/drone/blitzshell))
		var/mob/living/silicon/robot/drone/blitzshell/BS = user
		var/obj/item/gun/energy/laser/mounted/blitz/GUN = locate(/obj/item/gun/energy/laser/mounted/blitz) in BS.module.modules
		if(istype(GUN))
			GUN.init_firemodes += list(STUNBOLT)
			GUN.refresh_upgrades()
			U.blacklist += name
			return TRUE
	return FALSE

/datum/uplink_item/item/visible_weapons/blitz_laser_stun/can_view(obj/item/device/uplink/U)
	return ..() && !(name in U.blacklist) && ("Blitzshell Laser Weapons Upgrade" in U.blacklist)


/datum/uplink_item/item/visible_weapons/blitz_laser_burst
	name = "Blitzshell Laser Dual Mechanism"
	desc = "Activates the dual-firing mechanism of the embedded Strahl laser rifle."
	item_cost = 10
	antag_roles = list(ROLE_BLITZ)

/datum/uplink_item/item/visible_weapons/blitz_laser_burst/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/living/user)
	if(user && istype(user, /mob/living/silicon/robot/drone/blitzshell))
		var/mob/living/silicon/robot/drone/blitzshell/BS = user
		var/obj/item/gun/energy/laser/mounted/blitz/GUN = locate(/obj/item/gun/energy/laser/mounted/blitz) in BS.module.modules
		if(istype(GUN))
			GUN.init_firemodes += list(BURST_2_BEAM)
			GUN.refresh_upgrades()
			U.blacklist += name
			return TRUE
	return FALSE

/datum/uplink_item/item/visible_weapons/blitz_laser_burst/can_view(obj/item/device/uplink/U)
	return ..() && !(name in U.blacklist) && ("Blitzshell Laser Weapons Upgrade" in U.blacklist)


/datum/uplink_item/item/visible_weapons/blitz_shotgun
	name = "Blitzshell electro-shrapnel cannon"
	desc = "Activates the embedded pneumatic weapon system."
	item_cost = 25
	antag_roles = list(ROLE_BLITZ)

/datum/uplink_item/item/visible_weapons/blitz_shotgun/get_goods(var/obj/item/device/uplink/U, var/loc, var/mob/living/user)
	if(user && istype(user, /mob/living/silicon/robot/drone/blitzshell))
		var/mob/living/silicon/robot/drone/blitzshell/BS = user
		if(locate(/obj/item/gun/energy/shrapnel/mounted) in BS.module.modules)
			to_chat(BS, SPAN_WARNING("You already have a shrapnel cannon installed."))
			return FALSE
		BS.module.modules += new /obj/item/gun/energy/shrapnel/mounted(BS.module)
		U.blacklist += name
		return TRUE
	return FALSE

/datum/uplink_item/item/visible_weapons/blitz_shotgun/can_view(obj/item/device/uplink/U)
	return ..() && !(name in U.blacklist)
