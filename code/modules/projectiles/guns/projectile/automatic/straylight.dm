/obj/item/weapon/gun/projectile/automatic/straylight
	name = "FS SMG .35 Auto \"Straylight\""
	desc = "A compact and lightweight submachinegun that sprays small rounds rapidly. It supposed to be testing ground for newly \
			developed firing mechanism that later was supposed to be used in other \"Frozen Star\" designs, but it turned out to \
			be practically useless for other weapons due to suffering similar limitations as \"Molly\" - lack of firepower \
			and extra kickback. After minor redesign it made a great rapid-firing less than lethal weapon made with rubber ammo \
			in mind instead. Has excellent fire rate. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/straylight.dmi'
	icon_state = "straylight"
	item_state = "straylight"
	w_class = ITEM_SIZE_NORMAL
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	ammo_type = "/obj/item/ammo_casing/pistol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 7, MATERIAL_STEEL = 3, MATERIAL_PLASTIC = 10)
	price_tag = 1600
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	damage_multiplier = 0.65 //made with rubber rounds in mind, specifically for rubber rounds. For lethality refer to Wintermute.
	penetration_multiplier = 0.5 //practically no AP, 2.5 with regular rounds and 5 with HV. Still deadly to unarmored targets.
	recoil_buildup = 3
	silencer_type = /obj/item/weapon/silencer

	firemodes = list(
		FULL_AUTO_800,
		SEMI_AUTO_NODELAY
		)

/obj/item/weapon/gun/projectile/automatic/straylight/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if (ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"

	if (!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/weapon/gun/projectile/automatic/straylight/Initialize()
	. = ..()
	update_icon()
