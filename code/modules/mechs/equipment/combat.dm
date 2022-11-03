#warn TODO: fix mech headlights, fix mech-welder intaction runtime, do something w/ flamer, do something w/ mech ballistics, mech exit time, mech jetpack
/obj/item/gun/energy/get_hardpoint_maptext()
	return "[round(cell.charge / charge_cost)]/[round(cell.maxcharge / charge_cost)]"

/obj/item/gun/energy/get_hardpoint_status_value()
	var/obj/item/cell/C = get_cell()
	if(istype(C))
		return C.charge/C.maxcharge
	return null

/obj/item/mech_equipment/mounted_system/energy
	name = "energy thing"
	desc = "You shouldn't be seeing this."
	icon_state = "mecha_taser"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	matter = list()
	origin_tech = list()

/////Start of Energy-Weaponry/////

/obj/item/mech_equipment/mounted_system/energy/taser
	name = "mounted taser carbine"
	desc = "A dual fire mode taser system connected to the exosuit's targetting system."
	icon_state = "mech_taser"
	holding_type = /obj/item/gun/energy/taser/mounted/mech
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 10, MATERIAL_SILVER = 10)
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3)

/obj/item/gun/energy/taser/mounted/mech
	charge_cost = MECH_WEAPON_POWER_COST * 0.5 // Pew pew pew pew pew pew pew pew pew pew
	burst = 3
	burst_delay = 1 // PEW PEW PEW
	init_recoil = LMG_RECOIL(1)
	init_offset = 10 // Pew pew in all directions

	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	fire_delay = 0
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/obj/item/gun/energy/taser/mounted
	bad_type = /obj/item/gun/energy/taser/mounted
	spawn_tags = null

/////

/obj/item/mech_equipment/mounted_system/energy/ion
	name = "mounted ion rifle"
	desc = "An exosuit-mounted ion rifle. Handle with care."
	icon_state = "mech_ionrifle"
	holding_type = /obj/item/gun/energy/ionrifle/mounted/mech
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 10, MATERIAL_SILVER = 10)
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 4)

/obj/item/gun/energy/ionrifle/mounted/mech
	charge_cost = MECH_WEAPON_POWER_COST * 0.75

	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	fire_delay = 0
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/////

/obj/item/gun/energy/ionrifle/mounted
	bad_type = /obj/item/gun/energy/ionrifle/mounted
	spawn_tags = null

/obj/item/mech_equipment/mounted_system/energy/laser
	name = "\improper CH-PS \"Immolator\" laser"
	desc = "An exosuit-mounted laser rifle. Handle with care."
	icon_state = "mech_lasercarbine"
	holding_type = /obj/item/gun/energy/laser/mounted/mech
	matter = list(MATERIAL_PLASTEEL = 25, MATERIAL_PLASTIC = 10, MATERIAL_SILVER = 10)
	origin_tech = list(TECH_COMBAT = 4, TECH_MAGNET = 3)

/obj/item/gun/energy/laser/mounted/mech
	name = "\improper CH-PS \"Immolator\" laser"
	charge_cost = MECH_WEAPON_POWER_COST
	burst = 2
	init_firemodes = list()
	burst_delay = 1.5

	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	fire_delay = 0
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/obj/item/gun/energy/laser/mounted
	bad_type = /obj/item/gun/energy/laser/mounted
	spawn_tags = null

/////

/obj/item/mech_equipment/mounted_system/energy/plasma
	name = "mounted plasma cutter"
	desc = "An industrial plasma cutter mounted onto the chassis of the mech. "
	icon_state = "mech_plasma"
	holding_type = /obj/item/gun/energy/plasmacutter/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	origin_tech = list(TECH_MATERIAL = 4, TECH_PLASMA = 4, TECH_ENGINEERING = 6, TECH_COMBAT = 3)
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTEEL = 5)
	spawn_blacklisted = TRUE

/obj/item/gun/energy/plasmacutter/mounted/mech
	charge_cost = MECH_WEAPON_POWER_COST * 1.5
	projectile_type = /obj/item/projectile/beam/cutter

	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	fire_delay = 0
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/obj/item/gun/energy/plasmacutter
	bad_type = /obj/item/gun/energy/plasmacutter

/obj/item/gun/energy/plasmacutter/mounted
	bad_type = /obj/item/gun/energy/plasmacutter/mounted
	spawn_tags = null

/////

/obj/item/mech_equipment/mounted_system/energy/cannon // TODO: Make bang gun actually go bang not pew?
	name = "short cannon"
	desc = "A weapon for combat exosuits. It lobs low-velocity cannon rounds."
	icon_state = "mecha_gauss"
	holding_type = /obj/item/gun/energy/cannon/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3)
	matter = list(MATERIAL_STEEL = 30, MATERIAL_PLASTEEL = 30)

/obj/item/gun/energy/cannon/mounted/mech
	name = "cannon"
	desc = "An authentic cannon from the late 1700s, modified to fit on a mech. On closer inspection the tube contains a miniaturized gauss accelerator.."
	fire_sound = 'sound/weapons/guns/misc/mech_rifle.ogg'
	projectile_type = /obj/item/projectile/bullet/cannon
	charge_cost = MECH_WEAPON_POWER_COST * 1.7

	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	fire_delay = 0
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/obj/item/gun/energy/cannon/mounted
	bad_type = /obj/item/gun/energy/cannon/mounted
	spawn_tags = null

/////

/obj/item/mech_equipment/mounted_system/energy/flamer
	name = "ballistic flamer"
	desc = "A weapon for combat exosuits. It lobs globs of burning material."
	icon_state = "mecha_flamer_lit"
	holding_type = /obj/item/gun/energy/flamer/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASMA = 12) // It's not very good // TODO: Port CM flamers

/obj/item/gun/energy/flamer/mounted/mech
	name = "flamer"
	desc = "A ballistic weapon that's been modified to lob polymer casings filled with a sticky substance that ignites regardless of environmental factors."
	fire_sound = 'sound/weapons/guns/misc/mech_rifle.ogg'
	projectile_type = /obj/item/projectile/flamer_lob
	charge_cost = MECH_WEAPON_POWER_COST * 1.5

	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	fire_delay = 0
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/obj/item/gun/energy/flamer/mounted
	bad_type = /obj/item/gun/energy/flamer/mounted
	spawn_tags = null

/////

/obj/item/mech_equipment/mounted_system/launcher/missile
	name = "missile rack"
	desc = "The SRM-8 missile rack is loaded with explosive missiles."
	icon_state = "mech_missile_pod"
	holding_type = /obj/item/gun/energy/missile/mounted/mech
	restricted_hardpoints = list(HARDPOINT_BACK, HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTEEL = 20, MATERIAL_PLASMA = 15)

/obj/item/gun/energy/missile/mounted/mech
	name = "missile rack"
	desc = "A large crate containing energy-produced missiles, ready to launch."
	fire_sound = 'sound/weapons/guns/misc/mech_mortar.ogg'
	projectile_type = /obj/item/projectile/bullet/rocket/mech
	charge_cost = MECH_WEAPON_POWER_COST * 3

	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	fire_delay = 0
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/obj/item/gun/energy/missile/mounted
	bad_type = /obj/item/gun/energy/missile/mounted
	spawn_tags = null

/////

/obj/item/mech_equipment/mounted_system/launcher/grenadefrag
	name = "frag grenade launcher"
	desc = "The SGL-6FR grenade launcher is designed to launch primed fragmentation grenades."
	icon_state = "mech_gl"
	holding_type = /obj/item/gun/energy/launcher/frag/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/gun/energy/launcher/frag/mounted/mech
	name = "grenade launcher"
	desc = "A sealed, maintenance-free crate of freshly energized fragmentation grenades, ready to be used."
	fire_sound = 'sound/weapons/guns/misc/mech_mortar.ogg'
	projectile_type = /obj/item/projectile/bullet/grenade/frag
	charge_cost = MECH_WEAPON_POWER_COST * 2.5

	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	fire_delay = 0
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/obj/item/gun/energy/launcher/frag/mounted
	bad_type = /obj/item/gun/energy/launcher/frag/mounted
	spawn_tags = null

/////

/obj/item/mech_equipment/mounted_system/launcher/grenadesting
	name = "stingball launcher"
	desc = "The SGL-6FL grenade launcher is designated to launch primed stingballs."
	icon_state = "mech_glst"
	holding_type = /obj/item/gun/energy/launcher/sting/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)

/obj/item/gun/energy/launcher/sting/mounted/mech
	name = "grenade launcher"
	desc = "A sealed, maintenance-free crate of freshly energized stinger grenades, ready to be used."
	fire_sound = 'sound/weapons/guns/misc/mech_mortar.ogg'
	projectile_type = /obj/item/projectile/bullet/grenade/frag/sting
	charge_cost = MECH_WEAPON_POWER_COST * 2

	use_external_power = TRUE
	restrict_safety = TRUE
	self_recharge = TRUE
	twohanded = FALSE
	fire_delay = 0
	cell_type = /obj/item/cell/medium/mech
	matter = list()

/obj/item/gun/energy/launcher/sting/mounted
	bad_type = /obj/item/gun/energy/launcher/sting/mounted
	spawn_tags = null

/////End of Energy-Weaponry/////

/obj/item/gun/projectile/get_hardpoint_maptext()
	return "[get_ammo()]/[ammo_magazine.max_ammo]"

/obj/item/gun/projectile/get_hardpoint_status_value()
	if(ammo_magazine)
		return get_ammo()/ammo_magazine.max_ammo
	return null

/obj/item/mech_equipment/mounted_system/ballistic/pk
	name = "SA \"VJP\""
	desc = "A reverse engineered Pulemyot Kalashnikova fitted for mech use. Fires in 5 round bursts. Horribly inaccurate, but packs quite a punch."
	icon_state = "mech_pk"
	holding_type = /obj/item/gun/projectile/automatic/lmg/pk/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3)
	matter = list(MATERIAL_PLASTEEL = 50, MATERIAL_GOLD = 8, MATERIAL_SILVER = 5) // Gold and silver for it's ammo-regeneration electronics
	spawn_blacklisted = TRUE

/obj/item/mech_equipment/mounted_system/ballistic
	bad_type = /obj/item/mech_equipment/mounted_system/ballistic

/obj/item/gun/projectile/automatic/lmg/pk/mounted/mech
	name = 	"SA \"VJP\""
	desc = "A reverse engineered Pulemyot Kalashnikova fitted for mech use. Fires in 5 round bursts. Slightly inaccurate, but packs quite a punch."
	restrict_safety = TRUE
	twohanded = FALSE
	init_firemodes = list(
		list(mode_name="spit fire",  burst=5, burst_delay=0.8, fire_delay=0, move_delay=5, one_hand_penalty=0, icon="burst")
		)
	spawn_tags = null
	matter = list()
	magazine_type = /obj/item/ammo_magazine/lrifle/pk/mech

/obj/item/gun/projectile/automatic/lmg/pk/mounted/mech/Initialize()
	. = ..()
	ammo_magazine = new /obj/item/ammo_magazine/lrifle/pk/mech(src)

/obj/item/gun/projectile/automatic/lmg/pk/mounted/mech/afterattack(atom/A, mob/living/user)
	..()
	if(ammo_magazine && ammo_magazine.stored_ammo && !ammo_magazine.stored_ammo.len)
		qdel(ammo_magazine)
		playsound(src.loc, 'sound/weapons/guns/interact/lmg_open.ogg', 100, 1)
		var/mob/living/exosuit/E = loc
		if(istype(E))
			var/obj/item/cell/cell = E.get_cell()
			if(istype(cell))
				cell.use(500)
		ammo_magazine = new /obj/item/ammo_magazine/lrifle/pk/mech(src)
		spawn(1)
			playsound(src.loc, 'sound/weapons/guns/interact/lmg_cock.ogg', 100, 1)
		spawn(2)
			playsound(src.loc, 'sound/weapons/guns/interact/lmg_close.ogg', 100, 1)

/obj/item/gun/projectile/automatic/lmg/pk/mounted
	bad_type = /obj/item/gun/projectile/automatic/lmg/pk/mounted
