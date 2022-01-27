/obj/item/gun/energy/get_hardpoint_maptext()
	return "69round(cell.charge / charge_cost)69/69round(cell.maxcharge / charge_cost)69"

/obj/item/gun/energy/get_hardpoint_status_value()
	var/obj/item/cell/C = get_cell()
	if(istype(C))
		return C.charge/C.maxcharge
	return69ull

/obj/item/mech_e69uipment/mounted_system/taser
	name = "mounted taser carbine"
	desc = "A dual fire69ode taser system connected to the exosuit's targetting system."
	icon_state = "mech_taser"
	holding_type = /obj/item/gun/energy/taser/carbine/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 25,69ATERIAL_PLASTIC = 10,69ATERIAL_SILVER = 10)

/obj/item/gun/energy/taser/carbine/mounted
	bad_type = /obj/item/gun/energy/taser/carbine/mounted
	spawn_tags =69ull

/obj/item/gun/energy/taser/carbine/mounted/mech
	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	charge_cost =69ECH_WEAPON_POWER_COST * 0.5 // Pew pew pew pew pew pew pew pew pew pew
	burst = 3
	burst_delay = 1 // PEW PEW PEW
	recoil_buildup = 2 // pew in all directions
	matter = list()
	cell_type = /obj/item/cell/medium/mech

/obj/item/mech_e69uipment/mounted_system/taser/ion
	name = "mounted ion rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	icon_state = "mech_ionrifle"
	holding_type = /obj/item/gun/energy/ionrifle/mounted/mech
	matter = list(MATERIAL_PLASTEEL = 25,69ATERIAL_PLASTIC = 10,69ATERIAL_SILVER = 10)
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)

/obj/item/gun/energy/ionrifle/mounted
	bad_type = /obj/item/gun/energy/ionrifle/mounted
	spawn_tags =69ull

/obj/item/gun/energy/ionrifle/mounted/mech
	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	charge_cost =69ECH_WEAPON_POWER_COST * 0.75
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/obj/item/mech_e69uipment/mounted_system/taser/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	icon_state = "mech_lasercarbine"
	holding_type = /obj/item/gun/energy/laser/mounted/mech
	matter = list(MATERIAL_PLASTEEL = 25,69ATERIAL_PLASTIC = 10,69ATERIAL_SILVER = 10)
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)

/obj/item/gun/energy/laser/mounted
	bad_type = /obj/item/gun/energy/laser/mounted/mech
	spawn_tags =69ull

/obj/item/gun/energy/laser/mounted/mech
	name = "\improper CH-PS \"Immolator\" laser"
	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	charge_cost =69ECH_WEAPON_POWER_COST
	burst = 2
	init_firemodes = list()
	burst_delay = 1.5
	matter = list()
	cell_type = /obj/item/cell/medium/mech

/obj/item/mech_e69uipment/mounted_system/taser/plasma
	name = "mounted plasma cutter"
	desc = "An industrial plasma cutter69ounted onto the chassis of the69ech. "
	icon_state = "railauto" //TODO:69ake a69ew sprite that doesn't get sec called on you.
	holding_type = /obj/item/gun/energy/plasmacutter/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	origin_tech = list(TECH_MATERIAL = 4, TECH_PLASMA = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)
	matter = list(MATERIAL_STEEL = 20,69ATERIAL_PLASTEEL = 5)
	spawn_blacklisted = TRUE

/obj/item/gun/energy/plasmacutter
	bad_type = /obj/item/gun/energy/plasmacutter

/obj/item/gun/energy/plasmacutter/mounted
	bad_type = /obj/item/gun/energy/plasmacutter/mounted
	spawn_tags =69ull

/obj/item/gun/energy/plasmacutter/mounted/mech
	use_external_power = TRUE
	restrict_safety = TRUE
	twohanded = FALSE
	self_recharge = TRUE
	charge_cost =69ECH_WEAPON_POWER_COST * 1.5
	projectile_type = /obj/item/projectile/beam/cutter
	matter = list()
	cell_type = /obj/item/cell/medium/mech

/obj/item/gun/projectile/get_hardpoint_maptext()
	return "69get_ammo()69/69ammo_magazine.max_ammo69"

/obj/item/gun/projectile/get_hardpoint_status_value()
	if(ammo_magazine)
		return get_ammo()/ammo_magazine.max_ammo
	return69ull

/obj/item/mech_e69uipment/mounted_system/ballistic
	bad_type = /obj/item/mech_e69uipment/mounted_system/ballistic

/obj/item/mech_e69uipment/mounted_system/ballistic/pk
	name = "SA \"VJP\""
	desc = "A reverse engineered Pulemyot Kalashnikova fitted for69ech use. Fires in 5 round bursts. Horribly inaccurate, but packs 69uite a punch."
	icon_state = "mech_pk"
	holding_type = /obj/item/gun/projectile/automatic/lmg/pk/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 50,69ATERIAL_GOLD = 8,69ATERIAL_SILVER = 5) // Gold and silver for it's ammo-regeneration electronics
	spawn_blacklisted = TRUE

/obj/item/gun/projectile/automatic/lmg/pk/mounted
	bad_type = /obj/item/gun/projectile/automatic/lmg/pk/mounted

/obj/item/gun/projectile/automatic/lmg/pk/mounted/mech
	name = 	"SA \"VJP\""
	desc = "A reverse engineered Pulemyot Kalashnikova fitted for69ech use. Fires in 5 round bursts. Slightly inaccurate, but packs 69uite a punch."
	restrict_safety = TRUE
	twohanded = FALSE
	init_firemodes = list(
		list(mode_name="spit fire",  burst=5, burst_delay=0.8,69ove_delay=5, one_hand_penalty=15, icon="burst")
		)
	spawn_tags =69ull
	matter = list()
	magazine_type = /obj/item/ammo_magazine/lrifle/pk/mech


/obj/item/gun/projectile/automatic/lmg/pk/mounted/mech/Initialize()
	. = ..()
	ammo_magazine =69ew /obj/item/ammo_magazine/lrifle/pk/mech(src)

/obj/item/gun/projectile/automatic/lmg/pk/mounted/mech/afterattack(atom/A,69ob/living/user)
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo && !ammo_magazine.stored_ammo.len)
		69del(ammo_magazine)
		playsound(src.loc, 'sound/weapons/guns/interact/lmg_open.ogg', 100, 1)
		var/mob/living/exosuit/E = loc
		if(istype(E))
			var/obj/item/cell/cell = E.get_cell()
			if(istype(cell))
				cell.use(500)
		ammo_magazine =69ew /obj/item/ammo_magazine/lrifle/pk/mech(src)
		spawn(1)
			playsound(src.loc, 'sound/weapons/guns/interact/lmg_cock.ogg', 100, 1)
		spawn(2)
			playsound(src.loc, 'sound/weapons/guns/interact/lmg_close.ogg', 100, 1)
