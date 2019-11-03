/obj/item/ammo_magazine/a10mm
	name = "magazine (10mm)"
	icon_state = "10l"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	caliber = "10mm"
	matter = list(MATERIAL_STEEL = 2)
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 8
	multiple_sprites = 1

/obj/item/ammo_magazine/a10mm/empty
	icon_state = "10"
	initial_ammo = 0

/obj/item/ammo_magazine/a10mm/rubber
	name = "magazine (10mm rubber)"
	icon_state = "10r"
	ammo_type = /obj/item/ammo_casing/a10mm/rubber

/obj/item/ammo_magazine/a10mm/hv
	name = "magazine (10mm high-velocity)"
	icon_state = "10hv"
	ammo_type = /obj/item/ammo_casing/a10mm/hv

/obj/item/ammo_magazine/smg10mm
	name = "smg magazine (10mm)"
	icon_state = "12mml"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_SMG
	caliber = "10mm"
	matter = list(MATERIAL_STEEL = 4)
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/smg10mm/empty
	icon_state = "12mm"
	initial_ammo = 0

/obj/item/ammo_magazine/smg10mm/hv
	name = "smg magazine (10mm high-velocity)"
	icon_state = "12mmhv"
	ammo_type = /obj/item/ammo_casing/a10mm/hv

/obj/item/ammo_magazine/mc9mm
	name = "magazine (9mm)"
	icon_state = "9x19pl"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	matter = list(MATERIAL_STEEL = 3)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mm/empty
	icon_state = "9x19p"
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mm/flash
	name = "magazine (9mm flash)"
	icon_state = "9x19pf"
	ammo_type = /obj/item/ammo_casing/c9mm/flash

/obj/item/ammo_magazine/mc9mm/highvelocity
	name = "magazine (9mm high-velocity)"
	icon_state = "9x19phv"
	ammo_type = /obj/item/ammo_casing/c9mm/hv

/obj/item/ammo_magazine/mc9mm/rubber
	name = "magazine (9mm rubber)"
	icon_state = "9x19pr"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber

/obj/item/ammo_magazine/smg9mm
	name = "smg magazine (9mm)"
	icon_state = "smg9mml"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_SMG
	ammo_type = /obj/item/ammo_casing/c9mm
	matter = list(MATERIAL_STEEL = 4)
	caliber = "9mm"
	max_ammo = 35
	multiple_sprites = 1

/obj/item/ammo_magazine/smg9mm/empty
	icon_state = "smg9mm"
	initial_ammo = 0

/obj/item/ammo_magazine/smg9mm/rubber
	name = "smg magazine (9mm rubber)"
	icon_state = "smg9mmr"
	ammo_type = /obj/item/ammo_casing/c9mm/rubber

/obj/item/ammo_magazine/cl32
	name = "magazine (.32)"
	icon_state = "32trauma_l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	ammo_mag = "mag_cl32"
	ammo_type = /obj/item/ammo_casing/cl32
	matter = list(MATERIAL_STEEL = 4)
	caliber = ".32"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/cl32/empty
	icon_state = "32trauma"
	initial_ammo = 0

/obj/item/ammo_magazine/cl32/rubber
	name = "magazine (.32 rubber)"
	icon_state = "32trauma_r"
	ammo_type = /obj/item/ammo_casing/cl32/rubber

/obj/item/ammo_magazine/c45m
	name = "magazine (.45)"
	icon_state = "45l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(MATERIAL_STEEL = 3)
	caliber = ".45"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/c45m/empty
	icon_state = "45"
	initial_ammo = 0

/obj/item/ammo_magazine/c45m/flash
	name = "magazine (.45 flash)"
	icon_state = "45f"
	ammo_type = /obj/item/ammo_casing/c45/flash

/obj/item/ammo_magazine/c45m/practice
	name = "magazine (.45 practice)"
	icon_state = "45p"
	ammo_type = /obj/item/ammo_casing/c45/practice

/obj/item/ammo_magazine/c45m/rubber
	name = "magazine (.45 rubber)"
	icon_state = "45r"
	ammo_type = /obj/item/ammo_casing/c45/rubber

/obj/item/ammo_magazine/c45smg
	name = "smg magazine (.45)"
	icon_state = "smg45l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_SMG
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(MATERIAL_STEEL = 4)
	caliber = ".45"
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/c45smg/empty
	icon_state = "smg45"
	initial_ammo = 0

/obj/item/ammo_magazine/c45smg/rubber
	name = "smg magazine (.45 rubber)"
	icon_state = "smg45r"
	ammo_type = /obj/item/ammo_casing/c45/rubber

/obj/item/ammo_magazine/c10x24
	name = "magazine (10x24mm caseless)"
	icon_state = "10x24"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_CIVI_RIFLE
	caliber = "10x24"
	matter = list(MATERIAL_STEEL = 8, MATERIAL_PLASTIC = 1)
	ammo_type = /obj/item/ammo_casing/c10x24
	max_ammo = 99
	multiple_sprites = 1

/obj/item/ammo_magazine/a556
	name = "magazine (5.56mm)"
	icon_state = "5.56"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_CIVI_RIFLE
	caliber = "a556"
	matter = list(MATERIAL_STEEL = 3)
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/a556/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a556/practice
	name = "magazine (5.56mm practice)"
	ammo_type = /obj/item/ammo_casing/a556/practice

/obj/item/ammo_magazine/ih556
	name = "IH magazine (5.56mm)"
	icon_state = "WinMag"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_IH
	caliber = "a556"
	matter = list(MATERIAL_STEEL = 5)
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 30
	multiple_sprites = 1

//obj/item/ammo_magazine/ih556/highvelocity
//	name = "IH magazine (5.56mm high-velocity)"
//	icon_state = "WinMag_h"
//	ammo_type = /obj/item/ammo_casing/a556/hv

/obj/item/ammo_magazine/sol65
	name = "magazine (6.5mm)"
	icon_state = "mg_ih_sol_l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_IH
	ammo_mag = "ih_sol_l"
	ammo_mag = "ih_sol"
	ammo_type = /obj/item/ammo_casing/c65
	matter = list(MATERIAL_STEEL = 4)
	caliber = "6.5mm"
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/sol65/empty
	icon_state = "mg_ih_sol"
	initial_ammo = 0

/obj/item/ammo_magazine/sol65/rubber
	name = "magazine (6.5mm rubber)"
	icon_state = "mg_ih_sol_r"
	ammo_type = /obj/item/ammo_casing/c65/rubber

/obj/item/ammo_magazine/a762
	name = "magazine box (7.62mm)"
	icon_state = "a762"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_BOX
	caliber = "a762"
	matter = list(MATERIAL_STEEL = 8)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/a762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a762/pk
	name = "PK munitions box (7.62mm)"
	icon_state = "pk_box"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_BOX
	caliber = "a762"
	matter = list(MATERIAL_STEEL = 8)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 80
	multiple_sprites = 1

/obj/item/ammo_magazine/ammobox/a762/pk/update_icon()
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

/obj/item/ammo_magazine/a762/pk/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c762_short
	name = "short magazine (7.62mm)"
	icon_state = "AK_short-20"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_CIVI_RIFLE
	caliber = "a762"
	matter = list(MATERIAL_STEEL = 4)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/c762_short/empty
	icon_state = "AK_short"
	initial_ammo = 0

/obj/item/ammo_magazine/c762_long
	name = "long magazine (7.62mm)"
	icon_state = "AKMag_l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_AK
	caliber = "a762"
	matter = list(MATERIAL_STEEL = 5)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/c762_long/highvelocity
	name = "long magazine (7.62mm high-velocity)"
	icon_state = "AKMag_hv"
	ammo_type = /obj/item/ammo_casing/a762/hv

/obj/item/ammo_magazine/c762_long/empty
	icon_state = "AKMag"
	initial_ammo = 0

/obj/item/ammo_magazine/maxim
	name = "pan magazine (7.62mm)"
	icon_state = "maxim"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PAN
	caliber = "a762"
	matter = list(MATERIAL_STEEL = 10)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 96
	multiple_sprites = 1

/obj/item/ammo_magazine/sl357
	name = "speed loader (.357)"
	icon_state = "357l"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = "357"
	ammo_type = /obj/item/ammo_casing/a357
	matter = list(MATERIAL_STEEL = 3)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/sl357/highvelocity
	name = "speed loader (.357 high-velocity)"
	icon_state = "357hv"
	ammo_type = /obj/item/ammo_casing/a357/hv

/obj/item/ammo_magazine/sl38
	name = "speed loader (.38)"
	icon_state = "38l"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = ".38"
	matter = list(MATERIAL_STEEL = 3)
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/sl38/rubber
	name = "speed loader (.38 rubber)"
	icon_state = "38r"
	ammo_type = /obj/item/ammo_casing/c38/rubber

/obj/item/ammo_magazine/sl44
	name = "speed loader (.44)"
	icon_state = "44l"
	icon = 'icons/obj/ammo_speed.dmi'
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/cl44
	matter = list(MATERIAL_STEEL = 3)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/sl44/rubber
	name = "speed loader (.44 rubber)"
	icon_state = "44r"
	ammo_type = /obj/item/ammo_casing/cl44/rubber

/obj/item/ammo_magazine/cl44
	name = "magazine (.44)"
	icon_state = "mg_ih_pst_44l"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	ammo_mag = "mag_cl44"
	ammo_type = /obj/item/ammo_casing/cl44
	matter = list(MATERIAL_STEEL = 4)
	caliber = ".44"
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/cl44/rubber
	name = "magazine (.44 rubber)"
	icon_state = "mg_ih_pst_44r"
	ammo_type = /obj/item/ammo_casing/cl44/rubber

/obj/item/ammo_magazine/cl44/empty
	icon_state = "mg_ih_pst_44"
	initial_ammo = 0

/obj/item/ammo_magazine/a50
	name = "magazine (.50)"
	icon_state = "50ael"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	caliber = ".50"
	matter = list(MATERIAL_STEEL = 4)
	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/a50/empty
	icon_state = "50ae"
	initial_ammo = 0

/obj/item/ammo_magazine/a50/rubber
	name = "magazine (.50 rubber)"
	icon_state = "50aer"
	ammo_type = /obj/item/ammo_casing/a50/rubber

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
	name = "ammo magazine (20mm)"
	icon_state = "75"
	mag_type = MAGAZINE
	mag_well = MAG_WELL_PISTOL
	caliber = "75"
	ammo_type = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/a75/empty
	initial_ammo = 0