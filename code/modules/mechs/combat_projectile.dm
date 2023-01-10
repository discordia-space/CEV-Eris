

//Procs.

/obj/item/gun/projectile/automatic/cannon

/obj/item/ammo_magazine/mecha/attack_self(mob/user)
	to_chat(user, SPAN_WARNING("It's pretty hard to extract ammo from a magazine that fits on a mech. You'll have to do it one round at a time."))
	return

/obj/item/mech_equipment/mounted_system/projectile/attackby(var/obj/item/O as obj, mob/user as mob)
	var/obj/item/gun/projectile/automatic/A = holding
	if(isCrowbar(O))
		A.unload_ammo(user)
		to_chat(user, SPAN_NOTICE("You remove the ammo magazine from the [src]."))
	if(istype(O, A.magazine_type))
		A.load_ammo(O, user)
		to_chat(user, SPAN_NOTICE("You load the ammo magazine into the [src]."))

/obj/item/mech_equipment/mounted_system/projectile/attack_self(var/mob/user)
	. = ..()
	if(. && holding)
		var/obj/item/gun/M = holding
		return M.switch_firemodes(user)

/obj/item/gun/projectile/automatic/get_hardpoint_status_value()
	if(!isnull(ammo_magazine))
		return ammo_magazine.stored_ammo.len
	else
		return null

/obj/item/gun/projectile/automatic/get_hardpoint_maptext()
	if(!isnull(ammo_magazine))
		return "[ammo_magazine.stored_ammo.len]/[ammo_magazine.max_ammo]"
	else
		return 0

//Weapons below this.
/obj/item/mech_equipment/mounted_system/projectile
	name = "mounted submachine gun"
	icon_state = "mech_uac2"
	holding_type = /obj/item/gun/projectile/automatic
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)


/obj/item/mech_equipment/mounted_system/projectile/cannon
	name = "short cannon"
	desc = "A weapon for combat exosuits. It lobs low-velocity cannon rounds."
	icon_state = "mecha_gauss"
	holding_type = /obj/item/gun/projectile/automatic/cannon/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_ENGINEERING = 4)
	matter = list(MATERIAL_STEEL = 30, MATERIAL_PLASTEEL = 40, MATERIAL_SILVER = 6, MATERIAL_GOLD = 6)

/obj/item/gun/projectile/automatic/cannon/mounted/mech
	name = "cannon"
	desc = "An authentic cannon from the late 1700s, modified to fit on a mech. On closer inspection the tube contains a miniaturized gauss accelerator.."
	magazine_type = /obj/item/ammo_magazine/mech/cannon_shot
	caliber = CAL_CANNON
	fire_sound = 'sound/weapons/guns/misc/mech_rifle.ogg'
	firemodes = list(
		list(mode_name="semi auto",       burst=1, fire_delay=null,    move_delay=null, one_hand_penalty=0, burst_accuracy=null, dispersion=null),
		)

	restrict_safety = TRUE
	twohanded = FALSE
	fire_delay = 0
	matter = list()

/obj/item/gun/cannon/mounted
	bad_type = /obj/item/gun/cannon/mounted
	spawn_tags = null

/////
/*
/obj/item/mech_equipment/mounted_system/projectile/flamer
	name = "ballistic flamer"
	desc = "A weapon for combat exosuits. It lobs globs of burning material."
	icon_state = "mech_flamer"
	holding_type = /obj/item/gun/projectile/automatic/flamer/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3)
	matter = list(MATERIAL_PLASTEEL = 20, MATERIAL_PLASMA = 12) // It's not very good // TODO: Port CM flamers

/obj/item/gun/flamer/projectile/automatic/mounted/mech
	name = "flamer"
	desc = "A ballistic weapon that's been modified to lob polymer casings filled with a sticky substance that ignites regardless of environmental factors."
	fire_sound = 'sound/weapons/guns/misc/mech_rifle.ogg'

	restrict_safety = TRUE
	twohanded = FALSE
	fire_delay = 0
	matter = list()

/obj/item/gun/flamer/mounted
	bad_type = /obj/item/gun/flamer/mounted
	spawn_tags = null
*/
/////

/obj/item/mech_equipment/mounted_system/projectile/top_launcher
	name = "launcher thing"
	desc = "You shouldn't be seeing this."
	icon_state = "mech_missile_pod"
	bad_type = /obj/item/mech_equipment/mounted_system/top_launcher
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	restricted_software = list(MECH_SOFTWARE_WEAPONS)
	matter = list()
	origin_tech = list()

/////

/obj/item/mech_equipment/mounted_system/top_launcher/missile
	name = "missile rack"
	desc = "The SRM-8 missile rack is loaded with concussion missiles."
	icon_state = "mech_missile_pod"
	holding_type = /obj/item/gun/projectile/automatic/missile/mounted/mech
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTEEL = 15, MATERIAL_PLASMA = 15, MATERIAL_GOLD = 4, MATERIAL_SILVER = 5 )
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3, TECH_ENGINEERING = 3)

/obj/item/gun/projectile/automatic/missile/mounted/mech
	name = "missile rack"
	desc = "A rack containing a small energy-to-matter fabricator and four tubes for launching less-then-lethal concussion missiles."
	magazine_type = /obj/item/ammo_magazine/mech/concussion_rocket
	caliber = CAL_ROCKET
	fire_sound = 'sound/weapons/guns/misc/mech_mortar.ogg'

	restrict_safety = TRUE
	twohanded = FALSE
	fire_delay = 0
	matter = list()

/obj/item/gun/missile/mounted
	bad_type = /obj/item/gun/missile/mounted
	spawn_tags = null

/////

/obj/item/mech_equipment/mounted_system/top_launcher/grenadefrag
	name = "frag grenade launcher"
	desc = "The SGL-6FR grenade launcher is designed to launch primed fragmentation grenades."
	icon_state = "mech_gl"
	holding_type = /obj/item/gun/projectile/automatic/launcher/frag/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3)
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTEEL = 18, MATERIAL_PLASMA = 15, MATERIAL_GOLD = 2, MATERIAL_SILVER = 3)

/obj/item/gun/projectile/automatic/launcher/frag/mounted/mech
	name = "grenade launcher"
	desc = "A sealed, maintenance-free crate of freshly energized fragmentation grenades."
	magazine_type = /obj/item/ammo_magazine/mech/frag_mag
	caliber = CAL_GRENADE
	fire_sound = 'sound/weapons/guns/misc/mech_mortar.ogg'

	restrict_safety = TRUE
	twohanded = FALSE
	fire_delay = 0
	matter = list()

/obj/item/gun/launcher/frag/mounted
	bad_type = /obj/item/gun/launcher/frag/mounted
	spawn_tags = null

/////

/obj/item/mech_equipment/mounted_system/top_launcher/grenadesting
	name = "stingball launcher"
	desc = "The SGL-6FL grenade launcher is designated to launch primed stingballs."
	icon_state = "mech_glst"
	holding_type = /obj/item/gun/projectile/automatic/launcher/sting/mounted/mech
	restricted_hardpoints = list(HARDPOINT_LEFT_SHOULDER, HARDPOINT_RIGHT_SHOULDER)
	origin_tech = list(TECH_MATERIAL = 3, TECH_COMBAT = 3)
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTEEL = 15, MATERIAL_PLASMA = 7, MATERIAL_GOLD = 2, MATERIAL_SILVER = 3)

/obj/item/gun/projectile/automatic/launcher/sting/mounted/mech
	name = "grenade launcher"
	desc = "A sealed, maintenance-free crate of freshly energized stinger grenades."
	magazine_type = /obj/item/ammo_magazine/mech/sting_mag
	caliber = CAL_GRENADE
	fire_sound = 'sound/weapons/guns/misc/mech_mortar.ogg'

	restrict_safety = TRUE
	twohanded = FALSE
	fire_delay = 0
	matter = list()

/obj/item/gun/launcher/sting/mounted
	bad_type = /obj/item/gun/launcher/sting/mounted
	spawn_tags = null

/////End of Energy-Weaponry/////

//magazines below this.

/obj/item/ammo_magazine/mech/cannon_shot
	name = "25mm cannon magazine"
	desc = ""
	icon_state = "icon"
	mag_type = MAGAZINE
	caliber = CAL_CANNON
	matter = list(MATERIAL_STEEL = 10000)
	ammo_type = /obj/item/ammo_casing/cannon
	max_ammo = 30

/obj/item/ammo_magazine/mech/concussion_rocket
	name = "concussive rocket"
	desc = ""
	icon_state = "icon"
	mag_type = MAGAZINE
	caliber = CAL_ROCKET
	matter = list(MATERIAL_STEEL = 10000)
	ammo_type = /obj/item/ammo_casing/rocket/concussion
	max_ammo = 8

/obj/item/ammo_magazine/mech/frag_mag
	name = "rotary fragmentation grenade magazine"
	desc = ""
	icon_state = "icon"
	mag_type = MAGAZINE
	caliber = CAL_GRENADE
	matter = list(MATERIAL_STEEL = 10000)
	ammo_type = /obj/item/ammo_casing/grenade/frag
	max_ammo = 6

/obj/item/ammo_magazine/mech/sting_mag
	name = "rotary stingball grenade magazine"
	desc = ""
	icon_state = "icon"
	mag_type = MAGAZINE
	caliber = CAL_GRENADE
	matter = list(MATERIAL_STEEL = 10000)
	ammo_type = /obj/item/ammo_casing/grenade
	max_ammo = 12

/*
/obj/item/ammo_magazine/mecha/smg_top
	name = "large 7mm magazine"
	desc = "A large magazine for a mech's gun. Looks way too big for a normal gun."
	icon_state = "smg_top"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/pistol/small
	matter = list(MATERIAL_STEEL = 7000)
	caliber = CALIBER_PISTOL_SMALL
	max_ammo = 90

/obj/item/ammo_magazine/mech/rifle
	name = "large assault rifle magazine"
	icon_state = "assault_rifle"
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE
	matter = list(MATERIAL_STEEL = 9000)
	ammo_type = /obj/item/ammo_casing/rifle
	max_ammo = 100

/obj/item/ammo_magazine/mech/mil_rifle
	name = "massive assault rifle magazine"
	icon_state = "bullup"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = CALIBER_RIFLE_MILITARY
	matter = list(MATERIAL_STEEL = 9000)
	ammo_type = /obj/item/ammo_casing/rifle/military
	max_ammo = 75
	multiple_sprites = 1
*/

/////Start of Exosuit Stuff/////

//*Individual Projectiles*//

/obj/item/projectile/bullet/cannon
	name = "cannon round"
	icon_state = "cannon"
	damage_types = list(BRUTE = 70)
	style_damage = 70
	recoil = 0
	step_delay = 1.8
	wounding_mult = 1

/obj/item/projectile/energy/flash/mechrocket
	name = "concussion rocket"
	icon_state = "rocket_shock"
	damage_types = list(BRUTE = 30, HALLOSS = 60) // stun rocket until a game-breaking runtime is fixed with RPGs
	armor_divisor = 1
	style_damage = 100
	check_armour = ARMOR_MELEE
	penetrating = -5
	recoil = 0
	can_ricochet = TRUE
	knockback = 1

/obj/item/projectile/bullet/rocket/mech/detonate(atom/target)
	explosion(get_turf(src), 0, 0, 5, 7)

/////End of Exosuit Stuff/////
