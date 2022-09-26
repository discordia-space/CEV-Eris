/obj/item/gun/projectile/boltgun/levergun
	name = "FS BR .40 \"Svengali\""
	desc = "A perfect modernization of an old earth classic hailing popular use with gun ho lawmen and bounty hunters. \
	Marketed as the number one choice for crack shots on Oberth colonies and large vessels."
	icon_state = "lever_winchester"
	item_suffix  = "_winchester"
	force = WEAPON_FORCE_DANGEROUS
	armor_divisor = ARMOR_PEN_GRAZING
	caliber = CAL_MAGNUM
	damage_multiplier = 1.6
	style_damage_multiplier = 1
	penetration_multiplier = 0
	proj_step_multiplier = 0.8
	init_recoil = RIFLE_RECOIL(2)
	init_offset = 0
	max_shells = 10
	zoom_factors = list()
	magazine_type = /obj/item/ammo_magazine/magnum
	matter = list(MATERIAL_STEEL = 20, MATERIAL_PLASTIC = 15, MATERIAL_PLASTEEL = 20)
	wielded_item_state = "_doble_winchester"
	sharp = FALSE
	sawn = /obj/item/gun/projectile/boltgun/levergun/sawn
	message = "lever"
	serial_type = "FS"
	gun_parts = list(/obj/item/part/gun/frame/winchester = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/boltgun = 1, /obj/item/part/gun/barrel/magnum = 1)

/obj/item/part/gun/frame/winchester
	name = "Svengali frame"
	desc = "A Svengali lever rifle. If death is our destination this will surely bring it."
	icon_state = "frame_winchester"
	resultvars = list(/obj/item/gun/projectile/boltgun/levergun)
	gripvars = list(/obj/item/part/gun/grip/rubber)
	mechanismvar = /obj/item/part/gun/mechanism/boltgun
	barrelvars = list(/obj/item/part/gun/barrel/magnum)

/obj/item/gun/projectile/boltgun/levergun/hand_spin(mob/living/carbon/caller)
	bolt_act(caller)

/obj/item/gun/projectile/boltgun/levergun/sawn
	name = "sawn-off FS BR .40 \"Svengali\""
	icon_state = "lever_winchester_sawn"
	w_class = ITEM_SIZE_NORMAL
	proj_step_multiplier = 1
	damage_multiplier = 1.6
	penetration_multiplier = -0.2 // all sawn off variants have less pen and more recoil, but no change in damage
	slot_flags = SLOT_BACK|SLOT_BELT|SLOT_HOLSTER
	init_recoil = CARBINE_RECOIL(4)
	matter = list(MATERIAL_STEEL = 10, MATERIAL_PLASTIC = 8, MATERIAL_PLASTEEL = 10)
	item_suffix  = "_winchester_sawn"
	wielded_item_state = "_doble_winchester_sawn"
	can_dual = TRUE
	twohanded = FALSE

/obj/item/gun/projectile/boltgun/levergun/shotgun
	name = "FS BR \"Sogekihei\""
	desc = "A refined weapon for the lawmen who wants to get up close and personal. \
	When you need someone to have a closed casket funeral!"
	icon_state = "lever_shotgun"
	item_suffix  = "_shotgun"
	force = WEAPON_FORCE_DANGEROUS
	armor_divisor = ARMOR_PEN_GRAZING
	caliber = CAL_SHOTGUN
	damage_multiplier = 1.1
	penetration_multiplier = 0.2
	max_shells = 7
	init_recoil = RIFLE_RECOIL(2.3)
	matter = list(MATERIAL_STEEL = 15, MATERIAL_PLASTIC = 10, MATERIAL_PLASTEEL = 20)
	wielded_item_state = "_doble_shotgun"
	sawn = /obj/item/gun/projectile/boltgun/levergun/shotgun/sawn
	gun_parts = list(/obj/item/part/gun/frame/levershotgun = 1, /obj/item/part/gun/grip/rubber = 1, /obj/item/part/gun/mechanism/boltgun = 1, /obj/item/part/gun/barrel/shotgun= 1)

/obj/item/part/gun/frame/levershotgun
	name = "Sogekihei frame"
	desc = "A Sogekihei lever shotgun. You are only missing a horse."
	icon_state = "frame_levershotgun"
	resultvars = list(/obj/item/gun/projectile/boltgun/levergun/shotgun)
	gripvars = list(/obj/item/part/gun/grip/rubber)
	mechanismvar = /obj/item/part/gun/mechanism/boltgun // consistent with the other lever guns
	barrelvars = list(/obj/item/part/gun/barrel/shotgun)

/obj/item/gun/projectile/boltgun/levergun/shotgun/sawn
	name = "sawn-off FS BR \"Sogekihei\""
	icon_state = "lever_shotgun_sawn"
	w_class = ITEM_SIZE_NORMAL
	proj_step_multiplier = 1.1 // 1.2 with slugs
	slot_flags = SLOT_BACK|SLOT_BELT|SLOT_HOLSTER
	damage_multiplier = 1.1
	penetration_multiplier = 0
	init_recoil = CARBINE_RECOIL(4)
	matter = list(MATERIAL_STEEL = 8, MATERIAL_PLASTIC = 5, MATERIAL_PLASTEEL = 10)
	item_suffix  = "_shotgun_sawn"
	wielded_item_state = "_doble_shotgun_sawn"
	can_dual = TRUE
	twohanded = FALSE
