/obj/item/weapon/gun/projectile/automatic/IH_machinepistol
	name = "FS MP 9x19 \"Molly\""
	desc = "An experimental fully automatic pistol. Compact and flexible, but somewhat underpowered. Issued to non-combatants among Ironhammer as powerful self-protection sidearm. Custom magwell allows it to feed both from pistol and SMG magazines. Uses 9mm rounds."
	icon_state = "IH_mp"
	item_state = "IH_mp"
	w_class = ITEM_SIZE_NORMAL
	caliber = "9mm"
	origin_tech = list(TECH_COMBAT = 5, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = "/obj/item/ammo_casing/c9mm"
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL|MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg9mm
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 3)
	price_tag = 1700
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	silencer_type = /obj/item/weapon/silencer
	damage_multiplier = 0.6
	recoil = 0.7 //slightly more than a standart pistol due to auto-firing mode
	recoil_buildup = 0.1 //smg level

	firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		list(mode_name="3-round bursts", burst=3, fire_delay=null, move_delay=4,     icon="burst"),
		)

/obj/item/weapon/gun/projectile/automatic/IH_machinepistol/update_icon()
	var/iconstring = initial(icon_state)
	var/itemstring = initial(item_state)

	if (ammo_magazine)
		iconstring += "_mag"

		if(!ammo_magazine.stored_ammo.len)
			iconstring += "_slide"

	if (silenced)
		iconstring += "_s"
		itemstring += "_s"

	icon_state = iconstring
	item_state = itemstring