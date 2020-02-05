/obj/item/weapon/gun/projectile/automatic/molly
	name = "FS MP .35 Auto \"Molly\""
	desc = "An experimental fully automatic pistol. Was designed as a middle ground between SMGs and pistols to put superior \
			firepower of first into frame of second, but unfortunately ended up too underpowered even for a pistol. \
			Still quite deadly in CQC due to full auto capability. Not very successful design, but certanly far from failure. \
			Often issued to non-combatants among Ironhammer as self-protection sidearm. \
			Custom magwell allows it to feed both from highcap pistol and SMG magazines. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/molly.dmi'
	icon_state = "molly"
	item_state = "molly"
	w_class = ITEM_SIZE_NORMAL
	can_dual = 1
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	ammo_type = "/obj/item/ammo_casing/pistol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_H_PISTOL|MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	auto_eject = 1
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 3)
	price_tag = 1700
	auto_eject_sound = 'sound/weapons/smg_empty_alarm.ogg'
	silencer_type = /obj/item/weapon/silencer
	damage_multiplier = 0.7 //good for rubber takedowns or self-defence, not so good to kill someone, you might want to use better smg
	recoil_buildup = 3

	firemodes = list(
		FULL_AUTO_400,
		SEMI_AUTO_NODELAY,
		)

/obj/item/weapon/gun/projectile/automatic/molly/update_icon()
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

	icon_state = iconstring
	set_item_state(itemstring)

/obj/item/weapon/gun/projectile/automatic/molly/Initialize()
	. = ..()
	update_icon()
