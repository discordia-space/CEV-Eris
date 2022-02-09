/obj/item/gun/projectile/boltgun/levergun
	name = "FS BR .40 \"Svengali\""
	desc = "A well-made Frozen Star battle rifle. Uses .40 rounds."
	icon_state = "lever_winchester"
	item_suffix  = "_winchester"
	force = WEAPON_FORCE_DANGEROUS
	armor_penetration = ARMOR_PEN_GRAZING
	caliber = CAL_MAGNUM
	damage_multiplier = 1.6
	penetration_multiplier = 1.6
	recoil_buildup = 15
	init_offset = 0
	one_hand_penalty = 15
	max_shells = 6
	zoom_factor = 0
	magazine_type = /obj/item/ammo_magazine/magnum
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 15, MATERIAL_PLASTEEL = 20)
	wielded_item_state = "_doble_winchester"
	sharp = FALSE
	spawn_blacklisted = TRUE
	sawn = /obj/item/gun/projectile/boltgun/levergun/sawn
	message = "lever"

/obj/item/gun/projectile/boltgun/levergun/sawn
	name = "sawn-off FS BR .40 \"Svengali\""
	icon_state = "lever_winchester_sawn"
	w_class = ITEM_SIZE_NORMAL
	proj_step_multiplier = 1.2
	slot_flags = SLOT_BACK|SLOT_BELT|SLOT_HOLSTER
	recoil_buildup = 20
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 8, MATERIAL_PLASTEEL = 20)
	one_hand_penalty = 10
	item_suffix  = "_winchester_sawn"
	wielded_item_state = "_doble_winchester_sawn"
	saw_off = TRUE
	can_dual = TRUE
	twohanded = FALSE

/obj/item/gun/projectile/boltgun/levergun/shotgun
	name = "FS BR \"Sogekihei\""
	desc = "A well-made Frozen Star shotgun. Uses shotgun shells."
	icon_state = "lever_shotgun"
	item_suffix  = "_shotgun"
	force = WEAPON_FORCE_DANGEROUS
	armor_penetration = ARMOR_PEN_GRAZING
	caliber = CAL_SHOTGUN
	damage_multiplier = 1.2
	penetration_multiplier = 0.65
	max_shells = 9
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTIC = 10, MATERIAL_PLASTEEL = 15)
	wielded_item_state = "_doble_shotgun"
	sawn = /obj/item/gun/projectile/boltgun/levergun/shotgun/sawn

/obj/item/gun/projectile/boltgun/levergun/shotgun/sawn
	name = "sawn-off FS BR \"Sogekihei\""
	icon_state = "lever_shotgun_sawn"
	w_class = ITEM_SIZE_NORMAL
	proj_step_multiplier = 1.2
	slot_flags = SLOT_BACK|SLOT_BELT|SLOT_HOLSTER
	damage_multiplier = 0.7
	recoil_buildup = 12
	matter = list(MATERIAL_STEEL = 8, MATERIAL_PLASTIC = 5, MATERIAL_PLASTEEL = 8)
	one_hand_penalty = 10
	item_suffix  = "_shotgun_sawn"
	wielded_item_state = "_doble_shotgun_sawn"
	saw_off = TRUE
	can_dual = TRUE
	twohanded = FALSE
