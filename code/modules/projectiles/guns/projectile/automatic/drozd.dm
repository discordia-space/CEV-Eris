/obj/item/weapon/gun/projectile/automatic/drozd
	name = "Excelsior .35 Auto \"Drozd\""
	desc = "An excellent fully automatic submachinegun. Made by \"Excelsior\" by reverse-engineering and improving upon Moebius \
			reverse-engineered C20r robust design to sevelop even more deadly weapon. Famous for it's perfomance in close quarters. \
			Has better than average fire rate. Uses .35 Auto rounds."
	icon = 'icons/obj/guns/projectile/drozd.dmi'
	icon_state = "drozd"
	item_state = "drozd"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	caliber = CAL_PISTOL
	origin_tech = list(TECH_COMBAT = 4, TECH_MATERIAL = 2)
	ammo_type = "/obj/item/ammo_casing/pistol"
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL|MAG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/smg
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_STEEL = 4, MATERIAL_PLASTIC = 4)
	price_tag = 2200
	damage_multiplier = 1.1
	penetration_multiplier = 2 //10 for regular lethal rounds and 20 for HV, seems legit
	recoil_buildup = 2
	silencer_type = /obj/item/weapon/silencer

	firemodes = list(
		FULL_AUTO_600,
		SEMI_AUTO_NODELAY
		)

/obj/item/weapon/gun/projectile/automatic/drozd/update_icon()
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
	item_state = itemstring

/obj/item/weapon/gun/projectile/automatic/drozd/Initialize()
	. = ..()
	update_icon()