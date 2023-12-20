/obj/item/gun/projectile/selfload
	name = "S HG .35 Auto \"Clarissa\""
	desc = "A small, easily concealable, but somewhat underpowered gun. Uses both standard and highcap .35 Auto mags."

	icon = 'icons/obj/guns/projectile/clarissa.dmi'
	icon_state = "clarissa"
	item_state = "clarissa"

	volumeClass = ITEM_SIZE_SMALL
	can_dual = TRUE
	silenced = FALSE
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	price_tag = 1000
	fire_sound = 'sound/weapons/guns/fire/pistol_fire.ogg'
	caliber = CAL_PISTOL
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL|MAG_WELL_H_PISTOL
	magazine_type = /obj/item/ammo_magazine/pistol
	rarity_value = 16
	damage_multiplier = 0.9
	init_recoil = HANDGUN_RECOIL(0.75)

	gun_tags = list(GUN_SILENCABLE)
	init_firemodes = list(
		SEMI_AUTO_300,
		FULL_AUTO_800
		)


	//spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/clarissa = 1, /obj/item/part/gun/modular/grip/black = 1, /obj/item/part/gun/modular/mechanism/pistol = 1, /obj/item/part/gun/modular/barrel/pistol = 1)
	serial_type = "S"

/obj/item/gun/projectile/selfload/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"
		wielded_item_state = "_doble_s"
	else
		wielded_item_state = "_doble"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/part/gun/frame/clarissa
	name = "Clarissa frame"
	desc = "A Clarissa pistol frame. Concealable yet anemic yet fast."
	icon_state = "frame_clarissa"
	resultvars = list(/obj/item/gun/projectile/selfload)
	gripvars = list(/obj/item/part/gun/modular/grip/black)
	mechanismvar = /obj/item/part/gun/modular/mechanism/pistol
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol)

/obj/item/gun/projectile/selfload/makarov
	name = "Excelsior .35 Auto \"Makarov\""
	desc = "Old-designed pistol of space communists. Small and easily concealable. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/makarov.dmi'
	icon_state = "makarov"
	damage_multiplier = 1.5
	init_recoil = HANDGUN_RECOIL(0.75)
	price_tag = 1400
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 2, TECH_COVERT = 3)
	init_firemodes = list(
		SEMI_AUTO_300
		)
	gun_parts = list(/obj/item/part/gun/frame/makarov = 1, /obj/item/part/gun/modular/grip/excel = 1, /obj/item/part/gun/modular/mechanism/pistol = 1, /obj/item/part/gun/modular/barrel/pistol = 1)
	serial_type = "Excelsior"

/obj/item/part/gun/frame/makarov
	name = "Makarov frame"
	desc = "A Makarov pistol frame. Technology may have stagnated, but effectiveness hasn't."
	icon_state = "frame_makarov"
	resultvars = list(/obj/item/gun/projectile/selfload/makarov)
	gripvars = list(/obj/item/part/gun/modular/grip/excel)
	mechanismvar = /obj/item/part/gun/modular/mechanism/pistol
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol)

/obj/item/gun/projectile/selfload/moebius
	name = "ML HG .35 Auto \"Anne\"" // ML stands for Moebius Laboratories
	desc = "Self-loading pistol of Syndicate design rebranded by Moebius Laboratories. Uses both standard and highcap .35 Auto mags."
	icon = 'icons/obj/guns/projectile/clarissa_white.dmi'
	serial_type = "ML"
