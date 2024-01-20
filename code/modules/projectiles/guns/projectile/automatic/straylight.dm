/obj/item/gun/projectile/automatic/straylight
	name = "FS SMG .35 Auto \"Straylight\""
	desc = "A compact, lightweight and cheap rapid-firing submachine gun. In past was primarily used for testing ammunition and weapon modifications, \
			nowadays mass produced for IH security forces. Suffers from poor recoil control and underperforming ballistic impact, \
			but makes up for this through sheer firerate. Especially effective with rubber ammunition. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/straylight.dmi'
	icon_state = "straylight"
	item_state = "straylight"
	volumeClass = ITEM_SIZE_NORMAL
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT
	load_method = MAGAZINE
	mag_well = MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_STEEL = 2, MATERIAL_PLASTIC = 8)
	price_tag = 1400
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	damage_multiplier = 0.8	 //made with rubber rounds in mind. For lethality refer to Wintermute. Still quite lethal if you manage to land most shots.
	init_recoil = SMG_RECOIL(0.55)
	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_600,
		SEMI_AUTO_300
		)

	wield_delay = 0 // Super weak SMG

	spawn_tags = SPAWN_TAG_FS_PROJECTILE
	gun_parts = list(/obj/item/part/gun/frame/straylight = 1, /obj/item/part/gun/modular/grip/rubber = 1, /obj/item/part/gun/modular/mechanism/smg = 1, /obj/item/part/gun/modular/barrel/pistol = 1)
	serial_type = "FS"

/obj/item/gun/projectile/automatic/straylight/update_icon()
	..()

	var/iconstring = initial(icon_state)
	var/itemstring = ""
	wielded_item_state = "_doble"

	if(ammo_magazine)
		iconstring += "_mag"
		itemstring += "_mag"
		wielded_item_state += "_mag"

	if(!ammo_magazine || !length(ammo_magazine.stored_ammo))
		iconstring += "_slide"

	if(silenced)
		iconstring += "_s"
		itemstring += "_s"
		wielded_item_state += "_s"

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/gun/projectile/automatic/straylight/Initialize()
	. = ..()
	update_icon()

/obj/item/part/gun/frame/straylight
	name = "Straylight frame"
	desc = "A Straylight SMG frame. A rabidly fast bullet hose."
	icon_state = "frame_ihsmg"
	resultvars = list(/obj/item/gun/projectile/automatic/straylight)
	gripvars = list(/obj/item/part/gun/modular/grip/rubber)
	mechanismvar = /obj/item/part/gun/modular/mechanism/smg
	barrelvars = list(/obj/item/part/gun/modular/barrel/pistol)
