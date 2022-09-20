/obj/item/gun/projectile/boltgun/bancroft
	name = "HM \"Bancroft\""
	desc = "A hefty cannon, essentially a handmade elephant gun used by hunters of dangerous game, with added bayonet. \
			The shorter barrel does not allow it to reach the same bullet speed as antimateriel rifles, but look \
			no further if you want something that will put a kaiser down through walls."
	icon = 'icons/obj/guns/projectile/bancroft.dmi'
	icon_state = "bancroft"
	item_suffix  = "_bancroft"
	w_class = ITEM_SIZE_HUGE
	force = WEAPON_FORCE_ROBUST
	armor_divisor = ARMOR_PEN_DEEP
	slot_flags = SLOT_BACK
	proj_step_multiplier = 0.8
	damage_multiplier = 1
	pierce_multiplier = 2 // still a .60 gun, and AMR pierces 6 walls
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	caliber = CAL_ANTIM
	fire_delay = 8
	init_recoil = RIFLE_RECOIL(1)
	init_offset = 0 // slight tweak since massive recoil kills rof and accuracy
	load_method = SINGLE_CASING
	max_shells = 5
	ammo_type = /obj/item/ammo_casing/antim
	fire_sound = 'sound/weapons/guns/fire/sniper_fire.ogg'
	reload_sound = 'sound/weapons/guns/interact/rifle_load.ogg'
	matter = list(MATERIAL_STEEL = 35, MATERIAL_PLASTEEL = 26, MATERIAL_WOOD = 16, MATERIAL_GLASS = 5)
	price_tag = 900
	zoom_factor = 0.3
	gun_parts = list(/obj/item/part/gun/frame/boltgun/bancroft = 1, /obj/item/part/gun/grip/wood = 1, /obj/item/part/gun/mechanism/boltgun = 1, /obj/item/part/gun/barrel/antim = 1)
	message = "lever"
	spawn_blacklisted = FALSE
	spawn_tags = SPAWN_TAG_GUN_HANDMADE

/obj/item/part/gun/frame/boltgun/bancroft
	name = "Bancroft frame"
	desc = "A Bancroft Kaiser gun. For hunting big game."
	icon_state = "frame_bancroft"
	matter = list(MATERIAL_STEEL = 20, MATERIAL_WOOD = 10)
	result = /obj/item/gun/projectile/boltgun/bancroft
	gripvars = /obj/item/part/gun/grip/wood
	mechanismvar = /obj/item/part/gun/mechanism/boltgun
	barrelvars = list(/obj/item/part/gun/barrel/shotgun, /obj/item/part/gun/barrel/antim)

/obj/item/gun/projectile/boltgun/bancroft/hand_spin(mob/living/carbon/caller)
	bolt_act(caller)
