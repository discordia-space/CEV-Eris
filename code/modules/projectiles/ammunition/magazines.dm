/////////////Standard/////////////
/obj/item/ammo_magazine/pistol
	name = "standard magazine (.35 Auto)"
	icon_state = "9x19pl"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	matter = list(MATERIAL_STEEL = 3)
	caliber = "pistol"
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 10

/obj/item/ammo_magazine/pistol/update_icon()	//temp fix till sprites can be updated
	if (!stored_ammo.len)
		icon_state = "[initial(icon_state)]-0"
		return
	else
		icon_state = "[initial(icon_state)]-8"
		return

/obj/item/ammo_magazine/pistol/empty
	icon_state = "9x19p"
	initial_ammo = 0

/obj/item/ammo_magazine/pistol/flash
	name = "standard magazine (.35 Auto flash)"
	icon_state = "9x19pf"
	ammo_type = /obj/item/ammo_casing/pistol/flash

/obj/item/ammo_magazine/pistol/highvelocity
	name = "standard magazine (.35 Auto high-velocity)"
	icon_state = "9x19phv"
	ammo_type = /obj/item/ammo_casing/pistol/hv

/obj/item/ammo_magazine/pistol/rubber
	name = "standard magazine (.35 Auto rubber)"
	icon_state = "9x19pr"
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/////////////Holdout/////////////
/obj/item/ammo_magazine/lpistol
	name = "holdout magazine (.35 Auto)"
	icon_state = "10l"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_L_PISTOL
	matter = list(MATERIAL_STEEL = 3)
	caliber = "pistol"
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/lpistol/update_icon()	//temp fix till sprites can be updated
	if (!stored_ammo.len)
		icon_state = "[initial(icon_state)]-0"
		return
	else
		icon_state = "[initial(icon_state)]-8"
		return

/obj/item/ammo_magazine/lpistol/empty
	icon_state = "10"
	initial_ammo = 0

/obj/item/ammo_magazine/lpistol/flash
	name = "holdout magazine (.35 Auto flash)"
	icon_state = "10f"
	ammo_type = /obj/item/ammo_casing/pistol/flash

/obj/item/ammo_magazine/lpistol/highvelocity
	name = "holdout magazine (.35 Auto high-velocity)"
	icon_state = "10hv"
	ammo_type = /obj/item/ammo_casing/pistol/hv

/obj/item/ammo_magazine/lpistol/rubber
	name = "holdout magazine (.35 Auto rubber)"
	icon_state = "10r"
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/////////////HighCap/////////////
/obj/item/ammo_magazine/hpistol
	name = "highcap magazine (.35 Auto)"
	icon_state = "45l"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_H_PISTOL
	matter = list(MATERIAL_STEEL = 3)
	caliber = "pistol"
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 16
	multiple_sprites = 1

/obj/item/ammo_magazine/hpistol/update_icon()	//temp fix till sprites can be updated
	if (!stored_ammo.len)
		icon_state = "[initial(icon_state)]-0"
		return
	else
		icon_state = "[initial(icon_state)]-7"
		return

/obj/item/ammo_magazine/hpistol/empty
	icon_state = "45"
	initial_ammo = 0

/obj/item/ammo_magazine/hpistol/flash
	name = "highcap magazine (.35 Auto flash)"
	icon_state = "45f"
	ammo_type = /obj/item/ammo_casing/pistol/flash

/obj/item/ammo_magazine/hpistol/highvelocity
	name = "highcap magazine (.35 Auto high-velocity)"
	icon_state = "45hv"
	ammo_type = /obj/item/ammo_casing/pistol/hv

/obj/item/ammo_magazine/hpistol/rubber
	name = "highcap magazine (.35 Auto rubber)"
	icon_state = "45r"
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/////////////SMG/////////////
/obj/item/ammo_magazine/smg
	name = "smg magazine (.35 Auto)"
	icon_state = "smg9mml"
	ammo_color = "-l"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_SMG
	matter = list(MATERIAL_STEEL = 4)
	caliber = "pistol"
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 35
	multiple_sprites = 1

/obj/item/ammo_magazine/smg/empty
	icon_state = "smg9mm"
	ammo_color = ""
	initial_ammo = 0


/obj/item/ammo_magazine/smg/rubber
	name = "smg magazine (.35 Auto rubber)"
	icon_state = "smg9mmr"
	ammo_color = "-r"
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/smg/hv
	name = "smg magazine (.35 Auto high-velocity)"
	icon_state = "smg9mmhv"
	ammo_color = "-hv"
	ammo_type = /obj/item/ammo_casing/pistol/hv

/////////////Rifle/////////////
/obj/item/ammo_magazine/c10x24
	name = "box magazine (.25 caseless)"
	icon_state = "10x24"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	caliber = "clrifle"
	matter = list(MATERIAL_STEEL = 8, MATERIAL_PLASTIC = 1)
	ammo_type = /obj/item/ammo_casing/clrifle
	max_ammo = 99
	multiple_sprites = 1

/obj/item/ammo_magazine/srifle
	name = "magazine (.20 Rifle)"
	icon_state = "5.56"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	caliber = "srifle"
	matter = list(MATERIAL_STEEL = 3)
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/srifle/empty
	initial_ammo = 0

/obj/item/ammo_magazine/srifle/practice
	name = "magazine (.20 Rifle practice)"
	ammo_type = /obj/item/ammo_casing/srifle/practice

/obj/item/ammo_magazine/ihsrifle
	name = "IH magazine (.20 Rifle)"
	icon_state = "WinMag"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_IH
	caliber = "srifle"
	matter = list(MATERIAL_STEEL = 5)
	ammo_type = /obj/item/ammo_casing/srifle
	max_ammo = 30
	multiple_sprites = 1

//obj/item/ammo_magazine/ih556/highvelocity
//	name = "IH magazine (5.56mm high-velocity)"
//	icon_state = "WinMag_h"
//	ammo_type = /obj/item/ammo_casing/a556/hv

/obj/item/ammo_magazine/ihclrifle
	name = "magazine (.25 Caseless Rifle)"
	icon_state = "mg_ih_sol_l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_IH
	ammo_mag = "ih_sol_l"
	ammo_mag = "ih_sol"
	ammo_type = /obj/item/ammo_casing/clrifle
	matter = list(MATERIAL_STEEL = 4)
	caliber = "clrifle"
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/ihclrifler/empty
	icon_state = "mg_ih_sol"
	initial_ammo = 0

/obj/item/ammo_magazine/ihclrifle/rubber
	name = "magazine (.25 Caseless Rifle rubber)"
	icon_state = "mg_ih_sol_r"
	ammo_type = /obj/item/ammo_casing/clrifle/rubber

/obj/item/ammo_magazine/lrifle
	name = "magazine box (.30 Rifle)"
	icon_state = "a762"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_BOX
	caliber = "lrifle"
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
	caliber = "lrifle"
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

/obj/item/ammo_magazine/lrifle_short
	name = "short magazine (.30 Rifle)"
	icon_state = "AK_short-20"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	caliber = "lrifle"
	matter = list(MATERIAL_STEEL = 4)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/lrifle_short/empty
	icon_state = "AK_short"
	initial_ammo = 0

/obj/item/ammo_magazine/lrifle_long
	name = "long magazine (.30 Rifle)"
	icon_state = "AKMag_l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_RIFLE
	caliber = "lrifle"
	matter = list(MATERIAL_STEEL = 5)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/lrifle_long/highvelocity
	name = "long magazine (.30 Rifle high-velocity)"
	icon_state = "AKMag_hv"
	ammo_type = /obj/item/ammo_casing/lrifle/hv

/obj/item/ammo_magazine/lrifle_long/empty
	icon_state = "AKMag"
	initial_ammo = 0

/obj/item/ammo_magazine/maxim
	name = "pan magazine (.30 Rifle)"
	icon_state = "maxim"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PAN
	caliber = "lrifle"
	matter = list(MATERIAL_STEEL = 10)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 96
	multiple_sprites = 1

/obj/item/ammo_magazine/sllrifle
	name = "ammo strip (.30 Rifle)"
	icon_state = "lrifle"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = "lrifle"
	matter = list(MATERIAL_STEEL = 3)
	ammo_type = /obj/item/ammo_casing/lrifle
	max_ammo = 5
	multiple_sprites = 1

/obj/item/ammo_magazine/slpistol
	name = "speed loader (.35 Special)"
	icon_state = "38l"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = "pistol"
	matter = list(MATERIAL_STEEL = 3)
	ammo_type = /obj/item/ammo_casing/pistol
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/slpistol/rubber
	name = "speed loader (.35 Special rubber)"
	icon_state = "38r"
	ammo_type = /obj/item/ammo_casing/pistol/rubber

/obj/item/ammo_magazine/slmagnum
	name = "speed loader (.40 Magnum)"
	icon_state = "44l"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = "magnum"
	ammo_type = /obj/item/ammo_casing/magnum
	matter = list(MATERIAL_STEEL = 3)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/slmagnum/highvelocity
	name = "speed loader (.40 Magnum high-velocity)"
	icon_state = "44hv"
	ammo_type = /obj/item/ammo_casing/magnum/hv

/obj/item/ammo_magazine/slmagnum/rubber
	name = "speed loader (.40 Magnum rubber)"
	icon_state = "44r"
	ammo_type = /obj/item/ammo_casing/magnum/rubber

/obj/item/ammo_magazine/magnum
	name = "magazine (.40 Magnum)"
	icon_state = "mg_ih_pst_44l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	ammo_mag = "mag_cl40m"
	ammo_type = /obj/item/ammo_casing/magnum
	matter = list(MATERIAL_STEEL = 4)
	caliber = "magnum"
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/magnum/rubber
	name = "magazine (40 Magnum rubber)"
	icon_state = "mg_ih_pst_44r"
	ammo_type = /obj/item/ammo_casing/magnum/rubber

/obj/item/ammo_magazine/magnum/empty
	icon_state = "mg_ih_pst_44"
	initial_ammo = 0

/obj/item/ammo_magazine/magnum/hv
	name = "magazine (40 Magnum high-velocity)"
	icon_state = "mg_ih_pst_44hv"
	ammo_type = /obj/item/ammo_casing/pistol/hv

/obj/item/ammo_magazine/caps
	name = "speed loader (caps)"
	icon_state = "38r"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = "caps"
	color = "#FF0000"
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(MATERIAL_STEEL = 2)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/a75
	name = "ammo magazine (.70 Gyro)"
	icon_state = "75"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	caliber = "70"
	ammo_type = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/a75/empty
	initial_ammo = 0