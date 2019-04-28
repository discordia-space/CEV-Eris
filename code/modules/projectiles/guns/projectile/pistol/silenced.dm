/obj/item/weapon/gun/projectile/silenced
	name = "FS HG .45 \"Mandella\""
	desc = "A small, quiet,  easily concealable gun. Uses .45 rounds. Has an integrated silencer which can't be removed."
	icon_state = "mandella"
	item_state = "pistol_s"
	w_class = ITEM_SIZE_NORMAL
	caliber = ".45"
	silencer_type = /obj/item/weapon/silencer/integrated
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 8)
	matter = list(MATERIAL_PLASTEEL = 12, MATERIAL_PLASTIC = 6)
	price_tag = 1500
	load_method = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	magazine_type = /obj/item/ammo_magazine/c45m
	recoil = 0.4 //less than regular pistol because of integrated silencer

//This comes with a preinstalled silencer
/obj/item/weapon/gun/projectile/silenced/Initialize()
	.=..()
	apply_silencer(new /obj/item/weapon/silencer/integrated(src), null)