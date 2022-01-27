/obj/item/gun/projectile/automatic/straylight
	name = "FS SMG .35 Auto \"Straylight\""
	desc = "A compact, lightweight and cheap rapid-firing submachine gun. In past was primarily used for testing ammunition and weapon69odifications, \
			novadays69ass produced for IH security forces. Suffers from poor recoil control and underperforming ballistic impact, \
			but69akes up for this through sheer firerate. Especially effective with rubber ammunition. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/straylight.dmi'
	icon_state = "straylight"
	item_state = "straylight"
	w_class = ITEM_SIZE_NORMAL
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	load_method =69AGAZINE
	mag_well =69AG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 12,69ATERIAL_STEEL = 2,69ATERIAL_PLASTIC = 8)
	price_tag = 1400
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	damage_multiplier = 0.65	 //made with rubber rounds in69ind. For lethality refer to Wintermute. Still 69uite lethal if you69anage to land69ost shots.
	penetration_multiplier = 0.5 //practically69o AP, 2.5 with regular rounds and 5 with HV. Still deadly to unarmored targets.
	recoil_buildup = 1
	one_hand_penalty = 5 //smg level
	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_600,
		SEMI_AUTO_NODELAY
		)

	wield_delay = 0 // Super weak SMG

	spawn_tags = SPAWN_TAG_FS_PROJECTILE

/obj/item/gun/projectile/automatic/straylight/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""

	if(ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"

	if(!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if(silenced)
		iconstring += "_s"
		itemstring += "_s"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/automatic/straylight/Initialize()
	. = ..()
	update_icon()
