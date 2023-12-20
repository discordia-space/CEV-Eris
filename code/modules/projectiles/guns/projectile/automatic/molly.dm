/obj/item/gun/projectile/automatic/molly
	name = "FS MP .35 Auto \"Molly\""
	desc = "An experimental pistol featuring a 3 and 6-round hyperburst, designed as a middle ground between SMGs and Pistols. \
			Primarily employed in CQC scenarios or as a civilian self defence tool. \
			Takes both highcap pistol and smg mags. Uses .35 Auto rounds."

	icon = 'icons/obj/guns/projectile/molly.dmi'
	icon_state = "molly"
	item_state = "molly"

	volumeClass = ITEM_SIZE_NORMAL
	can_dual = TRUE
	caliber = CAL_PISTOL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = /obj/item/ammo_casing/pistol
	load_method = MAGAZINE
	mag_well = MAG_WELL_H_PISTOL|MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'

	gun_tags = list(GUN_SILENCABLE)
	init_firemodes = list(
		SEMI_AUTO_300,
		BURST_3_ROUND_SMG,
		BURST_6_ROUND_SMG
		)

	can_dual = 1
	auto_eject = 1
	damage_multiplier = 0.8 //good for rubber takedowns or self-defence, not so good to kill someone, you might want to use better smg
	init_recoil = HANDGUN_RECOIL(0.6)

	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 3)

	price_tag = 1000
	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	wield_delay = 0 // pistols don't get delays. X Doubt
	gun_parts = list(/obj/item/part/gun/frame/molly = 1, /obj/item/part/gun/modular/grip/rubber = 1, /obj/item/part/gun/modular/mechanism/pistol = 1, /obj/item/part/gun/modular/barrel/pistol = 1)
	serial_type = "FS"

/obj/item/gun/projectile/automatic/molly/update_icon()
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

/obj/item/gun/projectile/automatic/molly/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/molly
	name = "Molly frame"
	desc = "A Molly machine pistol frame. Toeing the line between pistol and SMG."
	icon_state = "frame_autopistol"
	resultvars = list(/obj/item/gun/projectile/automatic/molly)
	gripvars = list(/obj/item/part/gun/modular/grip/rubber)
	mechanismvar = /obj/item/part/gun/modular/mechanism/pistol
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol)
