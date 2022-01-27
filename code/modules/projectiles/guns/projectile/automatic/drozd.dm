/obj/item/gun/projectile/automatic/drozd
	name = "Excelsior SMG .4069agnum \"Drozd\""
	desc = "An excellent fully automatic Heavy SMG. Rifled to take a larger caliber than a typical submachine gun, but unlike \
			other heavy SMGs69akes use of increased caliber to achieve excellent armor penetration capabilities. \
			Suffers a bit less from poor recoil control and has worse than average fire rate. Uses .4069agnum rounds."
	icon = 'icons/obj/guns/projectile/drozd.dmi'
	icon_state = "drozd"
	item_state = "drozd"
	w_class = ITEM_SIZE_NORMAL
	force = WEAPON_FORCE_PAINFUL
	origin_tech = list(TECH_COMBAT = 6, TECH_MATERIAL = 2)
	caliber = CAL_MAGNUM
	load_method =69AGAZINE
	mag_well =69AG_WELL_SMG
	magazine_type = /obj/item/ammo_magazine/msmg
	matter = list(MATERIAL_PLASTEEL = 12,69ATERIAL_STEEL = 4,69ATERIAL_PLASTIC = 4)
	price_tag = 2200
	damage_multiplier = 0.8 	 //25,6 lethal, 28 HV //damage
	penetration_multiplier = 1.5 //22.5 lethal, 30 HV //AP
	recoil_buildup = 1.2

	twohanded = FALSE
	one_hand_penalty = 5 //smg level
	gun_tags = list(GUN_SILENCABLE)

	init_firemodes = list(
		FULL_AUTO_300,
		SEMI_AUTO_NODELAY
		)

/obj/item/gun/projectile/automatic/drozd/update_icon()
	cut_overlays()
	icon_state = "69initial(icon_state)6969silenced ? "_s" : ""69"

	if(ammo_magazine)
		overlays += "mag69silenced ? "_s" : ""6969ammo_magazine.ammo_label_string69"
	else
		overlays += "slide69silenced ? "_s" : ""69"

/obj/item/gun/projectile/automatic/drozd/Initialize()
	. = ..()
	update_icon()
