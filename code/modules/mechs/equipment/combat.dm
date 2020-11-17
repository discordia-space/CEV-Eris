/obj/item/weapon/gun/energy/get_hardpoint_maptext()
	return "[round(cell.charge / charge_cost)]/[round(cell.maxcharge / charge_cost)]"

/obj/item/weapon/gun/energy/get_hardpoint_status_value()
	var/obj/item/weapon/cell/C = get_cell()
	if(istype(C))
		return C.charge/C.maxcharge
	return null

/obj/item/mech_equipment/mounted_system/taser
	name = "mounted taser carbine"
	desc = "A dual fire mode taser system connected to the exosuit's targetting system."
	icon_state = "mech_taser"
	holding_type = /obj/item/weapon/gun/energy/taser/carbine/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 24, MATERIAL_PLASTIC = 10, MATERIAL_SILVER = 3)

/obj/item/weapon/gun/energy/taser/carbine/mounted/mech
	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	charge_cost = MECH_WEAPON_POWER_COST
	spawn_blacklisted = TRUE

/obj/item/mech_equipment/mounted_system/taser/ion
	name = "mounted ion rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	icon_state = "mech_ionrifle"
	holding_type = /obj/item/weapon/gun/energy/ionrifle/mounted/mech
	matter = list(MATERIAL_PLASTEEL = 24, MATERIAL_SILVER = 10)
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)

/obj/item/weapon/gun/energy/ionrifle/mounted/mech
	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	charge_cost = MECH_WEAPON_POWER_COST * 2
	spawn_blacklisted = TRUE

/obj/item/mech_equipment/mounted_system/taser/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	icon_state = "mech_lasercarbine"
	holding_type = /obj/item/weapon/gun/energy/laser/mounted/mech
	matter = list(MATERIAL_PLASTEEL = 26, MATERIAL_SILVER = 5)
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)
/obj/item/weapon/gun/energy/laser/mounted/mech
	name = "\improper CH-PS \"Immolator\" laser"
	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	charge_cost = MECH_WEAPON_POWER_COST * 1.75

/obj/item/mech_equipment/mounted_system/taser/plasma
	name = "mounted plasma cutter"
	desc = "An industrial plasma cutter mounted onto the chassis of the mech. "
	icon_state = "railauto" //TODO: Make a new sprite that doesn't get sec called on you.
	holding_type = /obj/item/weapon/gun/energy/plasmacutter/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	origin_tech = list(TECH_MATERIAL = 4, TECH_PLASMA = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)
	matter = list(MATERIAL_STEEL = 20, MATERIAL_URANIUM = 5)
	spawn_blacklisted = TRUE

/obj/item/weapon/gun/energy/plasmacutter
	bad_type = /obj/item/weapon/gun/energy/plasmacutter

/obj/item/weapon/gun/energy/plasmacutter/mounted/mech
	use_external_power = TRUE
	restrict_safety = TRUE
	twohanded = FALSE
	self_recharge = FALSE
	charge_cost = MECH_WEAPON_POWER_COST * 1.5
	spawn_blacklisted = TRUE

/obj/item/weapon/gun/projectile/get_hardpoint_maptext()
	return "[get_ammo()]/[ammo_magazine.max_ammo]"

/obj/item/weapon/gun/projectile/get_hardpoint_status_value()
	if(ammo_magazine)
		return get_ammo()/ammo_magazine.max_ammo
	return null

/obj/item/mech_equipment/mounted_system/ballistic
	bad_type = /obj/item/mech_equipment/mounted_system/ballistic

/obj/item/mech_equipment/mounted_system/ballistic/pk
	name = "SA \"VJP\""
	desc = "A reverse engineered Pulemyot Kalashnikova fitted for mech use. Fires in 15 round bursts. Horribly inaccurate, but packs quite a punch."
	icon_state = "mech_pk"
	holding_type = /obj/item/weapon/gun/projectile/automatic/lmg/pk/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 60)
	spawn_blacklisted = TRUE

/obj/item/weapon/gun/projectile/automatic/lmg/pk/mounted/mech
	name = 	"SA \"VJP\""
	desc = "A reverse engineered Pulemyot Kalashnikova fitted for mech use. Fires in 15 round bursts. Horribly inaccurate, but packs quite a punch."
	restrict_safety = TRUE
	twohanded = FALSE
	init_firemodes = list(
		list(mode_name="spit fire",  burst=15, burst_delay=0.8, move_delay=15,  icon="burst")
		)
	spawn_blacklisted = TRUE

/obj/item/weapon/gun/projectile/automatic/lmg/pk/mounted/mech/Initialize()
	. = ..()
	ammo_magazine = new /obj/item/ammo_magazine/lrifle/pk(src)

/obj/item/weapon/gun/projectile/automatic/lmg/pk/mounted/mech/afterattack(atom/A, mob/living/user)
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo && !ammo_magazine.stored_ammo.len)
		qdel(ammo_magazine)
		playsound(src.loc, 'sound/weapons/guns/interact/lmg_open.ogg', 100, 1)
		var/mob/living/exosuit/E = loc
		if(istype(E))
			var/obj/item/weapon/cell/cell = E.get_cell()
			if(istype(cell))
				cell.use(500)
		ammo_magazine = new /obj/item/ammo_magazine/lrifle/pk(src)
		spawn(1)
			playsound(src.loc, 'sound/weapons/guns/interact/lmg_cock.ogg', 100, 1)
		spawn(2)
			playsound(src.loc, 'sound/weapons/guns/interact/lmg_close.ogg', 100, 1)
