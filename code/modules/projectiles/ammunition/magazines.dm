/////////////Standard/////////////
/obj/item/ammo_magazine/pistol
	name = "standard magazine (.35 Auto)"
	icon_state = "pistol_l"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	matter = list(MATERIAL_STEEL = 3)
	caliber = CAL_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/pistol/empty
	icon_state = "pistol"
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/practice
	name = "standard magazine (.35 Auto practice)"
	icon_state = "pistol_p"
	ammo_type = /obj/item/ammo_casing/pistol/practice
	rarity_value = 5

/obj/item/ammo_magazine/pistol/highvelocity
	name = "standard magazine (.35 Auto high-velocity)"
	icon_state = "pistol_hv"
	ammo_type = /obj/item/ammo_casing/pistol/hv
	rarity_value = 80

/obj/item/ammo_magazine/pistol/rubber
	name = "standard magazine (.35 Auto rubber)"
	icon_state = "pistol_r"
	ammo_type = /obj/item/ammo_casing/pistol/rubber
	rarity_value = 5


/////////////HighCap/////////////
/obj/item/ammo_magazine/hpistol
	name = "highcap magazine (.35 Auto)"
	icon_state = "hpistol_l"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_H_PISTOL
	matter = list(MATERIAL_STEEL = 3)
	caliber = CAL_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 16
	multiple_sprites = 1
	rarity_value = 20

/obj/item/ammo_magazine/hpistol/empty
	icon_state = "hpistol"
	initial_ammo = 0

/obj/item/ammo_magazine/hpistol/practice
	name = "highcap magazine (.35 Auto practice)"
	icon_state = "hpistol_p"
	ammo_type = /obj/item/ammo_casing/pistol/practice
	rarity_value = 10

/obj/item/ammo_magazine/hpistol/highvelocity
	name = "highcap magazine (.35 Auto high-velocity)"
	icon_state = "hpistol_hv"
	ammo_type = /obj/item/ammo_casing/pistol/hv
	rarity_value = 80

/obj/item/ammo_magazine/hpistol/rubber
	name = "highcap magazine (.35 Auto rubber)"
	icon_state = "hpistol_r"
	ammo_type = /obj/item/ammo_casing/pistol/rubber
	rarity_value = 10

/////////////.35 SMG/////////////

/obj/item/ammo_magazine/smg
	name = "smg magazine (.35 Auto)"
	icon_state = "smg_l"
	ammo_color = "-l"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_SMG
	matter = list(MATERIAL_STEEL = 4)
	caliber = CAL_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 35
	multiple_sprites = 1

/obj/item/ammo_magazine/smg/empty
	icon_state = "smg"
	ammo_color = ""
	initial_ammo = 0

/obj/item/ammo_magazine/smg/practice
	name = "smg magazine (.35 Auto practice)"
	icon_state = "smg_p"
	ammo_color = "-p"
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/smg/hv
	name = "smg magazine (.35 Auto high-velocity)"
	icon_state = "smg_hv"
	ammo_color = "-hv"
	ammo_type = /obj/item/ammo_casing/pistol/hv

/obj/item/ammo_magazine/smg/rubber
	name = "smg magazine (.35 Auto rubber)"
	icon_state = "smg_r"
	ammo_color = "-r"
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/////////////.40 SMG/////////////

/obj/item/ammo_magazine/msmg
	name = "smg magazine (.40 Magnum)"
	icon_state = "msmg_l"
	ammo_color = "-l"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_SMG
	matter = list(MATERIAL_STEEL = 5)
	caliber = CAL_MAGNUM
	ammo_type = /obj/item/ammo_casing/magnum
	max_ammo = 25
	multiple_sprites = 1

/obj/item/ammo_magazine/msmg/empty
	icon_state = "smg"
	ammo_color = ""
	initial_ammo = 0

/obj/item/ammo_magazine/msmg/practice
	name = "smg magazine (.40 Magnum practice)"
	icon_state = "msmg_p"
	ammo_color = "-p"
	ammo_type = /obj/item/ammo_casing/magnum/practice

/obj/item/ammo_magazine/msmg/hv
	name = "smg magazine (.40 Magnum high-velocity)"
	icon_state = "msmg_hv"
	ammo_color = "-hv"
	ammo_type = /obj/item/ammo_casing/magnum/hv

/obj/item/ammo_magazine/msmg/rubber
	name = "smg magazine (.40 Magnum rubber)"
	icon_state = "msmg_r"
	ammo_color = "-r"
	ammo_type = /obj/item/ammo_casing/magnum/rubber

///////////// .40 pistol ///////////

/obj/item/ammo_magazine/magnum
	name = "magazine (.40 Magnum)"
	icon_state = "magnum_l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	ammo_mag = "mag_cl40m"
	ammo_type = /obj/item/ammo_casing/magnum
	matter = list(MATERIAL_STEEL = 4)
	caliber = CAL_MAGNUM
	max_ammo = 10
	multiple_sprites = 1
	rarity_value = 5
	spawn_tags = SPAWN_TAG_AMMO_IH

/obj/item/ammo_magazine/magnum/empty
	icon_state = "magnum"
	initial_ammo = 0

/obj/item/ammo_magazine/magnum/practice
	name = "magazine (40 Magnum practice)"
	icon_state = "magnum_p"
	ammo_type = /obj/item/ammo_casing/magnum/practice
	spawn_tags = null

/obj/item/ammo_magazine/magnum/hv
	name = "magazine (40 Magnum high-velocity)"
	icon_state = "magnum_hv"
	ammo_type = /obj/item/ammo_casing/magnum/hv
	spawn_tags = null

/obj/item/ammo_magazine/magnum/rubber
	name = "magazine (40 Magnum rubber)"
	icon_state = "magnum_r"
	ammo_type = /obj/item/ammo_casing/magnum/rubber
	rarity_value = 3

///////////// .20 RIFLE /////////////

/obj/item/ammo_magazine/srifle
	name = "magazine (.20 Rifle)"
	icon_state = "srifle_l"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	caliber = CAL_SRIFLE
	matter = list(MATERIAL_STEEL = 6)
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 25
	multiple_sprites = 1

/obj/item/ammo_magazine/srifle/empty
	icon_state = "srifle"
	matter = list(MATERIAL_STEEL = 3)
	initial_ammo = 0

/obj/item/ammo_magazine/srifle/practice
	name = "magazine (.20 Rifle practice)"
	icon_state = "srifle_p"
	ammo_type = /obj/item/ammo_casing/srifle/practice

/obj/item/ammo_magazine/srifle/hv
	name = "magazine (.20 Rifle high-velocity)"
	icon_state = "srifle_hv"
	ammo_type = /obj/item/ammo_casing/srifle/hv

/obj/item/ammo_magazine/srifle/rubber
	name = "magazine (.20 Rifle rubber)"
	icon_state = "srifle_r"
	ammo_type = /obj/item/ammo_casing/srifle/rubber

////////// .25 RIFLE ///////////

/obj/item/ammo_magazine/c10x24
	name = "box magazine (.25 caseless)"
	icon_state = "10x24"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	caliber = CAL_CLRIFLE
	matter = list(MATERIAL_STEEL = 8, MATERIAL_PLASTIC = 1)
	ammo_type = /obj/item/ammo_casing/clrifle
	max_ammo = 99
	multiple_sprites = 1

/obj/item/ammo_magazine/ihclrifle
	name = "magazine (.25 Caseless Rifle)"
	icon_state = "ihclrifle_l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_IH
	ammo_type = /obj/item/ammo_casing/clrifle
	matter = list(MATERIAL_STEEL = 4)
	caliber = CAL_CLRIFLE
	max_ammo = 30
	multiple_sprites = 1
	spawn_tags = SPAWN_TAG_AMMO_IH
	rarity_value = 5

/obj/item/ammo_magazine/ihclrifle/empty
	icon_state = "ihclrifle"
	initial_ammo = 0

/obj/item/ammo_magazine/ihclrifle/practice
	name = "magazine (.25 Caseless Rifle practice)"
	icon_state = "ihclrifle_p"
	ammo_type = /obj/item/ammo_casing/clrifle/practice
	spawn_frequency = 5

/obj/item/ammo_magazine/ihclrifle/hv
	name = "magazine (.25 Caseless Rifle high-velocity)"
	icon_state = "ihclrifle_hv"
	ammo_type = /obj/item/ammo_casing/clrifle/hv
	spawn_tags = null

/obj/item/ammo_magazine/ihclrifle/rubber
	name = "magazine (.25 Caseless Rifle rubber)"
	icon_state = "ihclrifle_r"
	ammo_type = /obj/item/ammo_casing/clrifle/rubber



////////// .25 PISTOL //////////

/obj/item/ammo_magazine/cspistol
	name = "pistol magazine (.25 Caseless Rifle)"
	icon_state = "cspistol_l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	ammo_type = /obj/item/ammo_casing/clrifle
	matter = list(MATERIAL_STEEL = 4)
	caliber = CAL_CLRIFLE
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/cspistol/empty
	icon_state = "cspistol"
	initial_ammo = 0

/obj/item/ammo_magazine/cspistol/practice
	name = "pistol magazine (.25 Caseless Rifle practice)"
	icon_state = "cspistol_p"
	ammo_type = /obj/item/ammo_casing/clrifle/practice

/obj/item/ammo_magazine/cspistol/hv
	name = "pistol magazine (.25 Caseless Rifle high-velocity)"
	icon_state = "cspistol_hv"
	ammo_type = /obj/item/ammo_casing/clrifle/hv

/obj/item/ammo_magazine/cspistol/rubber
	name = "pistol magazine (.25 Caseless Rifle rubber)"
	icon_state = "cspistol_r"
	ammo_type = /obj/item/ammo_casing/clrifle/rubber

///////// .30 RIFLE ///////////

/obj/item/ammo_magazine/lrifle
	name = "magazine box (.30 Rifle)"
	icon_state = "lrifle_box"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_BOX
	caliber = CAL_LRIFLE
	matter = list(MATERIAL_STEEL = 8)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/lrifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/lrifle/pk
	name = "PK munitions box (.30 Rifle)"
	icon_state = "pk_box"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_BOX
	caliber = CAL_LRIFLE
	matter = list(MATERIAL_STEEL = 8)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 80
	multiple_sprites = 1

/obj/item/ammo_magazine/ammobox/lrifle/pk/update_icon()
	if (!stored_ammo.len)
		icon_state = "pk_box-0"
		return
	if (stored_ammo.len == max_ammo)
		icon_state = "pk_box"
		return

	var/number = 0
	if (stored_ammo.len && max_ammo)
		var/percent = (stored_ammo.len / max_ammo) * 100
		number = round(percent, 25)
	icon_state = "pk_box-[number]"

/obj/item/ammo_magazine/lrifle/pk/empty
	initial_ammo = 0

/obj/item/ammo_magazine/lrifle
	name = "long magazine (.30 Rifle)"
	icon_state = "lrifle_l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	caliber = CAL_LRIFLE
	matter = list(MATERIAL_STEEL = 5)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/lrifle/empty
	icon_state = "lrifle"
	initial_ammo = 0

/obj/item/ammo_magazine/lrifle/practice
	name = "long magazine (.30 Rifle practice)"
	icon_state = "lrifle_p"
	ammo_type = /obj/item/ammo_casing/lrifle/practice

/obj/item/ammo_magazine/lrifle/highvelocity
	name = "long magazine (.30 Rifle high-velocity)"
	icon_state = "lrifle_hv"
	ammo_type = /obj/item/ammo_casing/lrifle/hv

/obj/item/ammo_magazine/lrifle/rubber
	name = "long magazine (.30 Rifle rubber)"
	icon_state = "lrifle_r"
	ammo_type = /obj/item/ammo_casing/lrifle/rubber

/obj/item/ammo_magazine/maxim
	name = "pan magazine (.30 Rifle)"
	icon_state = "maxim"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PAN
	caliber = CAL_LRIFLE
	matter = list(MATERIAL_STEEL = 10)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 96
	multiple_sprites = 1

///////// SPEEDLOADERS ///////////

//////// .35 SPEEDLOADERS //////////
/obj/item/ammo_magazine/slpistol
	name = "speed loader (.35 Special)"
	icon_state = "slpistol_l"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = CAL_PISTOL
	matter = list(MATERIAL_STEEL = 3)
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 6
	multiple_sprites = 1
	rarity_value = 6.66

/obj/item/ammo_magazine/slpistol/practice
	name = "speed loader (.35 Special practice)"
	icon_state = "slpistol_p"
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/slpistol/hv
	name = "speed loader (.35 Special high-velocity)"
	icon_state = "slpistol_hv"
	ammo_type = /obj/item/ammo_casing/pistol/hv
	rarity_value = 80

/obj/item/ammo_magazine/slpistol/rubber
	name = "speed loader (.35 Special rubber)"
	icon_state = "slpistol_r"
	ammo_type = /obj/item/ammo_casing/pistol/rubber
	rarity_value = 5

//////// .40 SPEEDLOADERS //////////

/obj/item/ammo_magazine/slmagnum
	name = "speed loader (.40 Magnum)"
	icon_state = "slmagnum_l"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = CAL_MAGNUM
	ammo_type = /obj/item/ammo_casing/magnum
	matter = list(MATERIAL_STEEL = 3)
	max_ammo = 6
	multiple_sprites = 1
	spawn_tags = SPAWN_TAG_AMMO_IH
	rarity_value = 5

/obj/item/ammo_magazine/slmagnum/practice
	name = "speed loader (.40 Magnum practice)"
	icon_state = "slmagnum_p"
	ammo_type = /obj/item/ammo_casing/magnum/practice
	spawn_tags = null

/obj/item/ammo_magazine/slmagnum/highvelocity
	name = "speed loader (.40 Magnum high-velocity)"
	icon_state = "slmagnum_hv"
	ammo_type = /obj/item/ammo_casing/magnum/hv
	spawn_tags = null

/obj/item/ammo_magazine/slmagnum/rubber
	name = "speed loader (.40 Magnum rubber)"
	icon_state = "slmagnum_r"
	ammo_type = /obj/item/ammo_casing/magnum/rubber

//////// .30 RIFLE SPEEDLOADERS ////////
/obj/item/ammo_magazine/sllrifle
	name = "ammo strip (.30 Rifle)"
	icon_state = "lrifle"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = CAL_LRIFLE
	matter = list(MATERIAL_STEEL = 3)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 5
	multiple_sprites = 1

/// OTHER ///

/obj/item/ammo_magazine/caps
	name = "speed loader (caps)"
	icon_state = "slpistol_r"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = CAL_CAP
	color = "#FF0000"
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(MATERIAL_STEEL = 2)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/a75
	name = "ammo magazine (.70 Gyro)"
	icon_state = "gyropistol"
	icon = 'icons/obj/ammo_mags.dmi'
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	caliber = CAL_70
	ammo_type = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	max_ammo = 4
	rarity_value = 100

/obj/item/ammo_magazine/a75/empty
	initial_ammo = 0
	icon_state = "gyropistol-0"

////////////Shotguns!////////////

/obj/item/ammo_magazine/m12
	name = "ammo drum (.50 slug)"
	icon_state = "m12_slug"
	mag_type = MAGAZINE
	mag_well =  MAG_WELL_RIFLE
	caliber = CAL_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_STEEL = 6)
	multiple_sprites = 1
	max_ammo = 8
	ammo_color = "-slug"

/obj/item/ammo_magazine/m12/pellet
	name = "ammo drum (.50 pellet)"
	icon_state = "m12_pellets"
	ammo_type = /obj/item/ammo_casing/shotgun/pellet
	ammo_color = "-pellets"

/obj/item/ammo_magazine/m12/beanbag
	name = "ammo drum (.50 beanbag)"
	icon_state = "m12_beanbag"
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag
	ammo_color = "-beanbag"

/obj/item/ammo_magazine/m12/empty
	name = "ammo drum (.50)"
	icon_state = "m12"
	initial_ammo = 0
