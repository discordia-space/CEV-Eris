/obj/item/gun/projectile/boltgun/levergun
	name = "FS BR .40 \"Svengali\""
	desc = "A perfect modernization of an old earth classic hailing popular use with gun ho lawmen and bounty hunters. \
	When you need someone to have a closed casket funeral!"
	icon_state = "lever_winchester"
	item_suffix  = "_winchester"
	force = WEAPON_FORCE_DANGEROUS
	armor_divisor = ARMOR_PEN_GRAZING
	caliber = CAL_MAGNUM
	damage_multiplier = 1.6
	style_damage_multiplier = 1
	penetration_multiplier = 0
	init_recoil = RIFLE_RECOIL(2)
	init_offset = 0
	max_shells = 6
	zoom_factor = 0
	magazine_type = /obj/item/ammo_magazine/magnum
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 15, MATERIAL_PLASTEEL = 20)
	wielded_item_state = "_doble_winchester"
	sharp = FALSE
	spawn_blacklisted = TRUE
	sawn = /obj/item/gun/projectile/boltgun/levergun/sawn
	message = "lever"
	serial_type = "FS"

/obj/item/gun/projectile/boltgun/levergun/hand_spin(mob/living/carbon/caller)
	bolt_act(caller)

/obj/item/gun/projectile/boltgun/levergun/sawn
	name = "sawn-off FS BR .40 \"Svengali\""
	icon_state = "lever_winchester_sawn"
	w_class = ITEM_SIZE_NORMAL
	proj_step_multiplier = 1.2
	damage_multiplier = 1.3
	penetration_multiplier = -0.1
	slot_flags = SLOT_BACK|SLOT_BELT|SLOT_HOLSTER
	init_recoil = CARBINE_RECOIL(6)
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 8, MATERIAL_PLASTEEL = 20)
	item_suffix  = "_winchester_sawn"
	wielded_item_state = "_doble_winchester_sawn"
	saw_off = TRUE
	can_dual = TRUE
	twohanded = FALSE
	serial_type = "FS"

/obj/item/gun/projectile/boltgun/levergun/shotgun
	name = "FS BR \"Sogekihei\""
	desc = "A refined weapon for the lawmen who wants to get up close and personal. \
	Marketed as the number one choice for crack shots on Oberth colonies and large vessels."
	icon_state = "lever_shotgun"
	item_suffix  = "_shotgun"
	force = WEAPON_FORCE_DANGEROUS
	armor_divisor = ARMOR_PEN_GRAZING
	caliber = CAL_SHOTGUN
	damage_multiplier = 1.1
	penetration_multiplier = 0.3
	proj_step_multiplier = 0.8
	max_shells = 9
	init_recoil = RIFLE_RECOIL(2.3)
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTIC = 10, MATERIAL_PLASTEEL = 15)
	wielded_item_state = "_doble_shotgun"
	sawn = /obj/item/gun/projectile/boltgun/levergun/shotgun/sawn
	serial_type = "FS"

/obj/item/gun/projectile/boltgun/levergun/shotgun/sawn
	name = "sawn-off FS BR \"Sogekihei\""
	icon_state = "lever_shotgun_sawn"
	w_class = ITEM_SIZE_NORMAL
	proj_step_multiplier = 1.2
	slot_flags = SLOT_BACK|SLOT_BELT|SLOT_HOLSTER
	damage_multiplier = 0.8
	init_recoil = CARBINE_RECOIL(5)
	matter = list(MATERIAL_STEEL = 8, MATERIAL_PLASTIC = 5, MATERIAL_PLASTEEL = 8)
	item_suffix  = "_shotgun_sawn"
	wielded_item_state = "_doble_shotgun_sawn"
	saw_off = TRUE
	can_dual = TRUE
	twohanded = FALSE
