/obj/item/weapon/gun/projectile/automatic/drozd
	name = "Excelsior .35 Auto \"Drozd\""
	desc = "An excellent fully automatic submachinegun. Made by \"Excelsior\" by reverse-engineering and improving upon Moebius \
			reverse-engineered C20r robust design to sevelop even more deadly weapon. Damage is subpar, but armor penetration \
			capabilities are excellent. Blueprints didn't make it onto the Means of Production disk for some logistic reasons \
			and few existing disks was lost. Famous for it's perfomance in close quarters. Has better than average fire rate. \
			Uses .35 Auto rounds."
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
	damage_multiplier = 0.8
	penetration_multiplier = 4 //20 for regular lethal rounds and 40 for HV. Fills rare role of AP SMG. Basically counterpart of
	recoil_buildup = 2		   //Dallas no one asked for. Very rare and can be found either as gun itself or on dedicated disk.
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