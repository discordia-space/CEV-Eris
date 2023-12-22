/////////////Standard/////////////
/obj/item/ammo_magazine/pistol
	name = "standard magazine (.35 Auto)"
	icon_state = "pistol"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	matter = list(MATERIAL_STEEL = 3)
	caliber = CAL_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 10
	ammo_states = list(2, 4, 6, 8, 10)

/obj/item/ammo_magazine/pistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/practice
	ammo_type = /obj/item/ammo_casing/pistol/practice
	rarity_value = 5

/obj/item/ammo_magazine/pistol/highvelocity
	ammo_type = /obj/item/ammo_casing/pistol/hv
	rarity_value = 80

/obj/item/ammo_magazine/pistol/rubber
	ammo_type = /obj/item/ammo_casing/pistol/rubber
	rarity_value = 5

/obj/item/ammo_magazine/pistol/scrap
	ammo_type = /obj/item/ammo_casing/pistol/scrap
	rarity_value = 5
	spawn_tags = SPAWN_AMMO_COMMON

/////////////HighCap/////////////
/obj/item/ammo_magazine/hpistol
	name = "highcap magazine (.35 Auto)"
	icon_state = "hpistol"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_H_PISTOL
	matter = list(MATERIAL_STEEL = 3)
	caliber = CAL_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 16
	rarity_value = 20
	ammo_states = list(2, 4, 6, 8, 10, 12, 14, 16)

/obj/item/ammo_magazine/hpistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/hpistol/practice
	ammo_type = /obj/item/ammo_casing/pistol/practice
	rarity_value = 10

/obj/item/ammo_magazine/hpistol/highvelocity
	ammo_type = /obj/item/ammo_casing/pistol/hv
	rarity_value = 80

/obj/item/ammo_magazine/hpistol/rubber
	ammo_type = /obj/item/ammo_casing/pistol/rubber
	rarity_value = 10

/////////////.35 SMG/////////////

/obj/item/ammo_magazine/smg
	name = "smg magazine (.35 Auto)"
	icon_state = "smg"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_SMG
	matter = list(MATERIAL_STEEL = 4)
	caliber = CAL_PISTOL
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 35
	ammo_states = list(35)

/obj/item/ammo_magazine/smg/empty
	icon_state = "smg"
	initial_ammo = 0

/obj/item/ammo_magazine/smg/practice
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/smg/hv
	ammo_type = /obj/item/ammo_casing/pistol/hv

/obj/item/ammo_magazine/smg/rubber
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/smg/scrap
	ammo_type = /obj/item/ammo_casing/pistol/scrap
	spawn_tags = SPAWN_AMMO_COMMON

/////////////.40 SMG/////////////

/obj/item/ammo_magazine/msmg
	name = "smg magazine (.40 Magnum)"
	icon_state = "msmg"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_SMG
	matter = list(MATERIAL_STEEL = 5)
	caliber = CAL_MAGNUM
	ammo_type = /obj/item/ammo_casing/magnum
	max_ammo = 25
	ammo_states = list(25)

/obj/item/ammo_magazine/msmg/empty
	initial_ammo = 0

/obj/item/ammo_magazine/msmg/practice
	ammo_type = /obj/item/ammo_casing/magnum/practice

/obj/item/ammo_magazine/msmg/hv
	ammo_type = /obj/item/ammo_casing/magnum/hv

/obj/item/ammo_magazine/msmg/rubber
	ammo_type = /obj/item/ammo_casing/magnum/rubber

/obj/item/ammo_magazine/msmg/scrap
	ammo_type = /obj/item/ammo_casing/magnum/scrap
	spawn_tags = SPAWN_AMMO_COMMON

///////////// .40 pistol ///////////

/obj/item/ammo_magazine/magnum
	name = "magazine (.40 Magnum)"
	icon_state = "magnum"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	ammo_mag = "mag_cl40m"
	ammo_type = /obj/item/ammo_casing/magnum
	matter = list(MATERIAL_STEEL = 4)
	caliber = CAL_MAGNUM
	max_ammo = 10
	rarity_value = 5
	spawn_tags = SPAWN_TAG_AMMO_IH
	ammo_states = list(2, 4, 6, 8, 10)

/obj/item/ammo_magazine/magnum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/magnum/practice
	ammo_type = /obj/item/ammo_casing/magnum/practice
	spawn_tags = null

/obj/item/ammo_magazine/magnum/hv
	ammo_type = /obj/item/ammo_casing/magnum/hv
	spawn_tags = null

/obj/item/ammo_magazine/magnum/rubber
	ammo_type = /obj/item/ammo_casing/magnum/rubber
	rarity_value = 3

/obj/item/ammo_magazine/magnum/scrap
	ammo_type = /obj/item/ammo_casing/magnum/scrap
	rarity_value = 3
	spawn_tags = SPAWN_AMMO_COMMON

///////////// .20 RIFLE /////////////

/obj/item/ammo_magazine/srifle
	name = "magazine (.20 Rifle)"
	icon_state = "srifle"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	caliber = CAL_SRIFLE
	matter = list(MATERIAL_STEEL = 4)
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 25
	ammo_states = list(25)

/obj/item/ammo_magazine/srifle/empty
	icon_state = "srifle"
	matter = list(MATERIAL_STEEL = 3)
	initial_ammo = 0

/obj/item/ammo_magazine/srifle/practice
	icon_state = "srifle"
	ammo_type = /obj/item/ammo_casing/srifle/practice

/obj/item/ammo_magazine/srifle/hv
	icon_state = "srifle"
	ammo_type = /obj/item/ammo_casing/srifle/hv

/obj/item/ammo_magazine/srifle/rubber
	icon_state = "srifle"
	ammo_type = /obj/item/ammo_casing/srifle/rubber

/obj/item/ammo_magazine/srifle/scrap
	icon_state = "srifle"
	ammo_type = /obj/item/ammo_casing/srifle/scrap
	spawn_tags = SPAWN_AMMO_COMMON

////////// .20 LONG ///////////

/obj/item/ammo_magazine/srifle/long
	name = "extended magazine (.20 Rifle)"
	desc = "Extended .20 caliber magazine, holds 35 rounds."
	icon_state = "srifle_long"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE_L
	caliber = CAL_SRIFLE
	matter = list(MATERIAL_STEEL = 6)
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 35
	ammo_states = list(35)
	rarity_value = 20

/obj/item/ammo_magazine/srifle/long/empty
	matter = list(MATERIAL_STEEL = 4)
	initial_ammo = 0

/obj/item/ammo_magazine/srifle/long/practice
	ammo_type = /obj/item/ammo_casing/srifle/practice

/obj/item/ammo_magazine/srifle/long/hv
	ammo_type = /obj/item/ammo_casing/srifle/hv

/obj/item/ammo_magazine/srifle/long/rubber
	ammo_type = /obj/item/ammo_casing/srifle/rubber

/obj/item/ammo_magazine/srifle/long/scrap
	ammo_type = /obj/item/ammo_casing/srifle/scrap
	spawn_tags = SPAWN_AMMO_COMMON

////////// .20 DRUM ///////////

/obj/item/ammo_magazine/srifle/drum
	name = "drum magazine (.20 Rifle)"
	desc = "Heavy .20 caliber magazine, holds 60 rounds. Only fits \"Sermak\"."
	icon_state = "srifle_drum"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE_D
	caliber = CAL_SRIFLE
	matter = list(MATERIAL_STEEL = 9)
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 60
	ammo_states = list(60)
	w_class = ITEM_SIZE_NORMAL
	spawn_blacklisted = TRUE // Not in use yet

/obj/item/ammo_magazine/srifle/drum/empty
	matter = list(MATERIAL_STEEL = 9)
	initial_ammo = 0

/obj/item/ammo_magazine/srifle/drum/practice
	ammo_type = /obj/item/ammo_casing/srifle/practice

/obj/item/ammo_magazine/srifle/drum/hv
	ammo_type = /obj/item/ammo_casing/srifle/hv

/obj/item/ammo_magazine/srifle/drum/rubber
	ammo_type = /obj/item/ammo_casing/srifle/rubber

/obj/item/ammo_magazine/srifle/drum/scrap
	ammo_type = /obj/item/ammo_casing/srifle/scrap
	spawn_tags = SPAWN_AMMO_COMMON

////////// .25 RIFLE ///////////

/obj/item/ammo_magazine/c10x24
	name = "box magazine (.25 caseless)"
	icon_state = "10x24"
	modular_sprites = FALSE
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	caliber = CAL_CLRIFLE
	matter = list(MATERIAL_STEEL = 8, MATERIAL_PLASTIC = 1)
	ammo_type = /obj/item/ammo_casing/clrifle
	max_ammo = 99
	ammo_states = list(25, 50, 75, 99)

/obj/item/ammo_magazine/ihclrifle
	name = "magazine (.25 Caseless Rifle)"
	icon_state = "ihclrifle"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_IH
	ammo_type = /obj/item/ammo_casing/clrifle
	matter = list(MATERIAL_STEEL = 4)
	caliber = CAL_CLRIFLE
	max_ammo = 30
	spawn_tags = SPAWN_TAG_AMMO_IH
	rarity_value = 5
	ammo_states = list(30)

/obj/item/ammo_magazine/ihclrifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/ihclrifle/practice
	ammo_type = /obj/item/ammo_casing/clrifle/practice
	spawn_frequency = 5

/obj/item/ammo_magazine/ihclrifle/hv
	ammo_type = /obj/item/ammo_casing/clrifle/hv
	spawn_tags = null

/obj/item/ammo_magazine/ihclrifle/rubber
	ammo_type = /obj/item/ammo_casing/clrifle/rubber

/obj/item/ammo_magazine/ihclrifle/scrap
	ammo_type = /obj/item/ammo_casing/clrifle/scrap
	spawn_tags = SPAWN_AMMO_COMMON

/obj/item/ammo_magazine/ihclmg
	name = "LMG munitions box (.25 Caseless Rifle)"
	icon_state = "pk_box"
	modular_sprites = FALSE
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_BOX
	caliber = CAL_CLRIFLE
	matter = list(MATERIAL_STEEL = 8)
	ammo_type = /obj/item/ammo_casing/clrifle
	max_ammo = 80
	w_class = ITEM_SIZE_NORMAL
	ammo_states = list(15, 30, 50, 79, 80)
////////// .25 PISTOL //////////

/obj/item/ammo_magazine/cspistol
	name = "pistol magazine (.25 Caseless Rifle)"
	icon_state = "cspistol"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	ammo_type = /obj/item/ammo_casing/clrifle
	matter = list(MATERIAL_STEEL = 2)
	caliber = CAL_CLRIFLE
	max_ammo = 10
	ammo_states = list(2, 4, 6, 8, 10)

/obj/item/ammo_magazine/cspistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/cspistol/practice
	ammo_type = /obj/item/ammo_casing/clrifle/practice

/obj/item/ammo_magazine/cspistol/hv
	ammo_type = /obj/item/ammo_casing/clrifle/hv

/obj/item/ammo_magazine/cspistol/rubber
	ammo_type = /obj/item/ammo_casing/clrifle/rubber

///////// .30 RIFLE ///////////

/obj/item/ammo_magazine/lrifle
	name = "long magazine (.30 Rifle)"
	icon_state = "lrifle"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	caliber = CAL_LRIFLE
	matter = list(MATERIAL_STEEL = 4)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 30
	ammo_states = list(30)

/obj/item/ammo_magazine/lrifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/lrifle/practice
	ammo_type = /obj/item/ammo_casing/lrifle/practice

/obj/item/ammo_magazine/lrifle/highvelocity
	ammo_type = /obj/item/ammo_casing/lrifle/hv

/obj/item/ammo_magazine/lrifle/rubber
	ammo_type = /obj/item/ammo_casing/lrifle/rubber

/obj/item/ammo_magazine/lrifle/scrap
	ammo_type = /obj/item/ammo_casing/lrifle/scrap
	spawn_tags = SPAWN_AMMO_COMMON

/obj/item/ammo_magazine/lrifle/pk
	name = "LMG munitions box (.30 Rifle)"
	icon_state = "pk_box"
	modular_sprites = FALSE
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_BOX
	caliber = CAL_LRIFLE
	matter = list(MATERIAL_STEEL = 8)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 80
	w_class = ITEM_SIZE_NORMAL
	ammo_states = list(15, 30, 50, 79, 80)

///////// .30 DRUM ///////////

/obj/item/ammo_magazine/lrifle/drum
	name = "drum magazine (.30 Rifle)"
	desc = "Heavy .30 caliber magazine, holds 45 rounds. Only fits \"Krinkov\" and \"Sermak\"."
	icon_state = "lrifle_drum"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE_D
	caliber = CAL_LRIFLE
	matter = list(MATERIAL_STEEL = 6)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 45
	ammo_states = list(45)
	w_class = ITEM_SIZE_NORMAL
	rarity_value = 20

/obj/item/ammo_magazine/lrifle/drum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/lrifle/drum/practice
	ammo_type = /obj/item/ammo_casing/lrifle/practice

/obj/item/ammo_magazine/lrifle/drum/highvelocity
	ammo_type = /obj/item/ammo_casing/lrifle/hv

/obj/item/ammo_magazine/lrifle/drum/rubber
	ammo_type = /obj/item/ammo_casing/lrifle/rubber

/obj/item/ammo_magazine/lrifle/drum/scrap
	ammo_type = /obj/item/ammo_casing/lrifle/scrap
	spawn_tags = SPAWN_AMMO_COMMON

//Magazine type for the mech PK, you shouldn't see this

/obj/item/ammo_magazine/lrifle/pk/mech
	name = "LMG munitions box (.30 Rifle, Exosuit)"
	matter = list()
	spawn_blacklisted = TRUE
	bad_type = /obj/item/ammo_magazine/lrifle/pk/mech

/obj/item/ammo_magazine/lrifle/pk/empty
	initial_ammo = 0

///////// .30 MAXIM ///////////

/obj/item/ammo_magazine/maxim
	name = "pan magazine (.30 Rifle)"
	icon_state = "maxim"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PAN
	caliber = CAL_LRIFLE
	matter = list(MATERIAL_STEEL = 10)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 96
	w_class = ITEM_SIZE_NORMAL
	ammo_states = list(96)

/obj/item/ammo_magazine/maxim/rubber
	ammo_type = /obj/item/ammo_casing/lrifle/rubber

///////// SPEEDLOADERS ///////////

//////// .35 SPEEDLOADERS //////////
/obj/item/ammo_magazine/slpistol
	name = "speed loader (.35 Auto)"
	icon = 'icons/obj/ammo_speed.dmi'
	icon_state = "slpistol_base"
	caliber = CAL_PISTOL
	matter = list(MATERIAL_STEEL = 1)
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 6
	rarity_value = 6.66
	w_class = ITEM_SIZE_TINY

/obj/item/ammo_magazine/slpistol/update_icon()
	cut_overlays()
	var/count = 0
	for(var/obj/item/ammo_casing/AC in stored_ammo)
		count++
		overlays += "slpistol_[AC.shell_color]-[count]"

/obj/item/ammo_magazine/slpistol/empty
	initial_ammo = 0

/obj/item/ammo_magazine/slpistol/practice
	ammo_type = /obj/item/ammo_casing/pistol/practice

/obj/item/ammo_magazine/slpistol/hv
	ammo_type = /obj/item/ammo_casing/pistol/hv
	rarity_value = 80

/obj/item/ammo_magazine/slpistol/rubber
	ammo_type = /obj/item/ammo_casing/pistol/rubber
	rarity_value = 5

/obj/item/ammo_magazine/slpistol/scrap
	ammo_type = /obj/item/ammo_casing/pistol/scrap
	rarity_value = 5
	spawn_tags = SPAWN_AMMO_COMMON

//////// .40 SPEEDLOADERS //////////

/obj/item/ammo_magazine/slmagnum
	name = "speed loader (.40 Magnum)"
	icon = 'icons/obj/ammo_speed.dmi'
	icon_state = "slmagnum_base"
	caliber = CAL_MAGNUM
	ammo_type = /obj/item/ammo_casing/magnum
	matter = list(MATERIAL_STEEL = 1)
	max_ammo = 6
	spawn_tags = SPAWN_TAG_AMMO_IH
	rarity_value = 5
	w_class = ITEM_SIZE_TINY

/obj/item/ammo_magazine/slmagnum/update_icon()
	cut_overlays()
	var/count = 0
	for(var/obj/item/ammo_casing/AC in stored_ammo)
		count++
		overlays += "slmagnum_[AC.shell_color]-[count]"

/obj/item/ammo_magazine/slmagnum/Initialize()
	. = ..()
	update_icon()

/obj/item/ammo_magazine/slmagnum/empty
	initial_ammo = 0

/obj/item/ammo_magazine/slmagnum/practice
	ammo_type = /obj/item/ammo_casing/magnum/practice
	spawn_tags = null

/obj/item/ammo_magazine/slmagnum/highvelocity
	ammo_type = /obj/item/ammo_casing/magnum/hv
	spawn_tags = null

/obj/item/ammo_magazine/slmagnum/rubber
	ammo_type = /obj/item/ammo_casing/magnum/rubber

/obj/item/ammo_magazine/slmagnum/scrap
	ammo_type = /obj/item/ammo_casing/magnum/scrap
	spawn_tags = SPAWN_AMMO_COMMON

//////// .30 RIFLE SPEEDLOADERS ////////
/obj/item/ammo_magazine/sllrifle
	name = "ammo strip (.30 Rifle)"
	icon = 'icons/obj/ammo_speed.dmi'
	icon_state = "lrifle"
	modular_sprites = FALSE
	caliber = CAL_LRIFLE
	matter = list(MATERIAL_STEEL = 1)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 5
	w_class = ITEM_SIZE_TINY
	ammo_states = list(1, 2, 3, 4, 5)

/obj/item/ammo_magazine/sllrifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/sllrifle/hv
	ammo_type = /obj/item/ammo_casing/lrifle/hv

/obj/item/ammo_magazine/sllrifle/scrap
	ammo_type = /obj/item/ammo_casing/lrifle/scrap

//////// .20 RIFLE SPEEDLOADERS ////////

/obj/item/ammo_magazine/slsrifle
	name = "ammo strip (.20 Rifle)"
	icon = 'icons/obj/ammo_speed.dmi'
	icon_state = "stripper_base"
	caliber = CAL_SRIFLE
	matter = list(MATERIAL_STEEL = 1)
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 6
	w_class = ITEM_SIZE_TINY

/obj/item/ammo_magazine/slsrifle/update_icon()
	cut_overlays()
	var/count = 0
	for(var/obj/item/ammo_casing/AC in stored_ammo)
		count++
		overlays += "stripper_[AC.shell_color]-[count]"

/obj/item/ammo_magazine/slsrifle/Initialize()
	. = ..()
	update_icon()

/obj/item/ammo_magazine/slsrifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/slsrifle/hv
	ammo_type = /obj/item/ammo_casing/srifle/hv

/obj/item/ammo_magazine/slsrifle/practice
	ammo_type = /obj/item/ammo_casing/srifle/practice

/obj/item/ammo_magazine/slsrifle/rubber
	ammo_type = /obj/item/ammo_casing/srifle/rubber

/obj/item/ammo_magazine/slsrifle/scrap
	ammo_type = /obj/item/ammo_casing/srifle/scrap

/obj/item/ammo_magazine/slsrifle_rev
	name = "speed loader (.20 Rifle)"
	icon = 'icons/obj/ammo_speed.dmi'
	icon_state = "slsrifle_base"
	caliber = CAL_SRIFLE
	matter = list(MATERIAL_STEEL = 1)
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 8
	w_class = ITEM_SIZE_TINY

/obj/item/ammo_magazine/slsrifle_rev/update_icon()
	cut_overlays()
	var/count = 0
	for(var/obj/item/ammo_casing/AC in stored_ammo)
		count++
		overlays += "slsrifle_[AC.shell_color]-[count]"

/obj/item/ammo_magazine/slsrifle_rev/Initialize()
	. = ..()
	update_icon()

/obj/item/ammo_magazine/slsrifle_rev/hv
	ammo_type = /obj/item/ammo_casing/srifle/hv

/obj/item/ammo_magazine/slsrifle_rev/practice
	ammo_type = /obj/item/ammo_casing/srifle/practice

/obj/item/ammo_magazine/slsrifle_rev/rubber
	ammo_type = /obj/item/ammo_casing/srifle/rubber

/obj/item/ammo_magazine/slsrifle_rev/scrap
	ammo_type = /obj/item/ammo_casing/srifle/scrap

//////// .25 RIFLE SPEEDLOADERS ////////
/obj/item/ammo_magazine/slclrifle
	name = "ammo strip (.25 Rifle)"
	icon = 'icons/obj/ammo_speed.dmi'
	icon_state = "clrifle_base"
	caliber = CAL_CLRIFLE
	matter = list(MATERIAL_STEEL = 1)
	ammo_type = /obj/item/ammo_casing/clrifle
	max_ammo = 5
	w_class = ITEM_SIZE_TINY

/obj/item/ammo_magazine/slclrifle/update_icon()
	cut_overlays()
	var/count = 0
	for(var/obj/item/ammo_casing/AC in stored_ammo)
		count++
		overlays += "clrifle_[AC.shell_color]-[count]"

/obj/item/ammo_magazine/slclrifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/slclrifle/Initialize()
	. = ..()
	update_icon()

/obj/item/ammo_magazine/slclrifle/hv
	ammo_type = /obj/item/ammo_casing/clrifle/hv

/obj/item/ammo_magazine/slclrifle/practice
	ammo_type = /obj/item/ammo_casing/clrifle/practice

/obj/item/ammo_magazine/slclrifle/rubber
	ammo_type = /obj/item/ammo_casing/clrifle/rubber

/obj/item/ammo_magazine/slclrifle/scrap
	ammo_type = /obj/item/ammo_casing/clrifle/scrap

/// OTHER ///

/obj/item/ammo_magazine/caps
	name = "speed loader (caps)"
	icon_state = "slpistol"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = CAL_CAP
	color = "#FF0000"
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(MATERIAL_STEEL = 2)
	max_ammo = 6
	ammo_states = list(1, 2, 3, 4, 5, 6)

/obj/item/ammo_magazine/a75
	name = "ammo magazine (.70 Gyro)"
	icon_state = "gyropistol"
	icon = 'icons/obj/ammo_mags.dmi'
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	caliber = CAL_70
	ammo_type = /obj/item/ammo_casing/a75
	max_ammo = 4
	rarity_value = 100
	spawn_blacklisted = TRUE
	ammo_states = list(4)

/obj/item/ammo_magazine/a75/empty
	initial_ammo = 0

////////////Shotguns!////////////

/obj/item/ammo_magazine/m12
	name = "ammo drum (.50)"
	icon_state = "m12"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE_D
	caliber = CAL_SHOTGUN
	ammo_type = /obj/item/ammo_casing/shotgun
	matter = list(MATERIAL_STEEL = 8)
	w_class = ITEM_SIZE_NORMAL
	max_ammo = 16
	ammo_names = list(
		"hv" = "slug",
		"r" = "beanbag",
		"l" = "pellet",
		"p" = "practice",
		"f" = "flash",
		"i" = "incendiary",
		"b" = "blank",
		"scrap" = "scrap slug",
		"scrap_r" = "scrap beanbag",
		"scrap_s" = "scrap pellet")

/obj/item/ammo_magazine/m12/update_icon()
	..()
	cut_overlays()

	if(stored_ammo.len)
		var/obj/item/ammo_casing/LS = stored_ammo[1]
		overlays += "m12_shell_[LS.shell_color]" // Last shell is sticking out

/obj/item/ammo_magazine/m12/Initialize()
	. = ..()
	update_icon()

/obj/item/ammo_magazine/m12/pellet
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/ammo_magazine/m12/beanbag
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/ammo_magazine/m12/empty
	initial_ammo = 0

/obj/item/ammo_magazine/m12/short
	name = "magazine (.50)"
	icon_state = "m12_short"
	mag_well = MAG_WELL_RIFLE
	matter = list(MATERIAL_STEEL = 3)
	w_class = ITEM_SIZE_SMALL
	max_ammo = 8

/obj/item/ammo_magazine/m12/short/update_icon()
	..()
	cut_overlays()

	if(stored_ammo.len)
		var/obj/item/ammo_casing/LS = stored_ammo[1]
		overlays += "m12_short_shell_[LS.shell_color]"

/obj/item/ammo_magazine/m12/short/Initialize()
	. = ..()
	update_icon()

obj/item/ammo_magazine/m12/short/pellet
	ammo_type = /obj/item/ammo_casing/shotgun/pellet

/obj/item/ammo_magazine/m12/short/beanbag
	ammo_type = /obj/item/ammo_casing/shotgun/beanbag

/obj/item/ammo_magazine/m12/short/empty
	initial_ammo = 0
