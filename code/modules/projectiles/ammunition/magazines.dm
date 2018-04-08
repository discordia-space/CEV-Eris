/obj/item/ammo_magazine/sl357
	name = "speed loader (.357)"
	icon_state = "357"
	caliber = "357"
	ammo_type = /obj/item/ammo_casing/a357
	matter = list(MATERIAL_STEEL = 3)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/sl38
	name = "speed loader (.38)"
	icon_state = "38"
	caliber = "38"
	matter = list(MATERIAL_STEEL = 3)
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/sl38/rubber
	name = "speed loader (.38 rubber)"
	icon_state = "38r"
	ammo_type = /obj/item/ammo_casing/c38r

/obj/item/ammo_magazine/sl44
	name = "speed loader (.44)"
	icon_state = "44"
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/cl44
	matter = list(MATERIAL_STEEL = 3)
	max_ammo = 6
	multiple_sprites = 1

/obj/item/ammo_magazine/sl44/rubber
	name = "speed loader (.44 rubber)"
	icon_state = "44r"
	ammo_type = /obj/item/ammo_casing/cl44r

/obj/item/ammo_magazine/c45m
	name = "magazine (.45)"
	icon_state = "45"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c45
	matter = list(MATERIAL_STEEL = 3)
	caliber = ".45"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/c45m/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c45m/rubber
	name = "magazine (.45 rubber)"
	ammo_type = /obj/item/ammo_casing/c45r

/obj/item/ammo_magazine/c45m/practice
	name = "magazine (.45 practice)"
	ammo_type = /obj/item/ammo_casing/c45p

/obj/item/ammo_magazine/c45m/flash
	name = "magazine (.45 flash)"
	ammo_type = /obj/item/ammo_casing/c45f

/obj/item/ammo_magazine/mc9mm
	name = "magazine (9mm)"
	icon_state = "9x19p"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	matter = list(MATERIAL_STEEL = 3)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mm/rubber
	name = "magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/c9mmr

/obj/item/ammo_magazine/mc9mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mm/flash
	ammo_type = /obj/item/ammo_casing/c9mmf

/obj/item/ammo_magazine/mc9mmt
	name = "top mounted magazine (9mm)"
	icon_state = "9mmt"
	mag_type = MAGAZINE
	ammo_type = /obj/item/ammo_casing/c9mm
	matter = list(MATERIAL_STEEL = 3)
	caliber = "9mm"
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/mc9mmt/empty
	initial_ammo = 0

/obj/item/ammo_magazine/mc9mmt/rubber
	name = "top mounted magazine (9mm rubber)"
	ammo_type = /obj/item/ammo_casing/c9mmr

/obj/item/ammo_magazine/mc9mmt/practice
	name = "top mounted magazine (9mm practice)"
	ammo_type = /obj/item/ammo_casing/c9mmp

/obj/item/ammo_magazine/a10mm
	name = "magazine (10mm)"
	icon_state = "12mm"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "10mm"
	matter = list(MATERIAL_STEEL = 4)
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/a10mm/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a556
	name = "magazine (5.56mm)"
	icon_state = "5.56"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "a556"
	matter = list(MATERIAL_STEEL = 3)
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/a556/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a556/practice
	name = "magazine (5.56mm practice)"
	ammo_type = /obj/item/ammo_casing/a556p

/obj/item/ammo_magazine/a50
	name = "magazine (.50)"
	icon_state = "50ae"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = ".50"
	matter = list(MATERIAL_STEEL = 4)
	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/a50/rubber
	name = "magazine (.50 rubber)"
	ammo_type = /obj/item/ammo_casing/a50r
/obj/item/ammo_magazine/a50/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a75
	name = "ammo magazine (20mm)"
	icon_state = "75"
	mag_type = MAGAZINE
	caliber = "75"
	ammo_type = /obj/item/ammo_casing/a75
	multiple_sprites = 1
	max_ammo = 4

/obj/item/ammo_magazine/a75/empty
	initial_ammo = 0

/obj/item/ammo_magazine/a762
	name = "magazine box (7.62mm)"
	icon_state = "a762"
	origin_tech = list(TECH_COMBAT = 2)
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(MATERIAL_STEEL = 8)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 50
	multiple_sprites = 1

/obj/item/ammo_magazine/a762/empty
	initial_ammo = 0

/obj/item/ammo_magazine/c762
	name = "magazine (7.62mm)"
	icon_state = "c762"
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(MATERIAL_STEEL = 4)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 20
	multiple_sprites = 1

/obj/item/ammo_magazine/caps
	name = "speed loader (caps)"
	icon_state = "38r"
	caliber = "caps"
	color = "#FF0000"
	ammo_type = /obj/item/ammo_casing/cap
	matter = list(MATERIAL_STEEL = 2)
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/sol65
	name = "magazine (6.5mm)"
	icon_state = "mg_ih_sol"
	mag_type = MAGAZINE
	ammo_mag = "ih_sol"
	ammo_type = /obj/item/ammo_casing/c65
	matter = list(MATERIAL_STEEL = 4)
	caliber = "6.5mm"
	max_ammo = 30
	multiple_sprites = 1

/obj/item/ammo_magazine/sol65/rubber
	name = "magazine (6.5mm rubber)"
	ammo_type = /obj/item/ammo_casing/c65r

/obj/item/ammo_magazine/cl44
	name = "magazine (.44)"
	icon_state = "mg_ih_pst_44"
	mag_type = MAGAZINE
	ammo_mag = "mag_cl44"
	ammo_type = /obj/item/ammo_casing/cl44
	matter = list(MATERIAL_STEEL = 4)
	caliber = ".44"
	max_ammo = 10
	multiple_sprites = 1

/obj/item/ammo_magazine/cl44/rubber
	name = "magazine (.44 rubber)"
	ammo_type = /obj/item/ammo_casing/cl44r

/obj/item/ammo_magazine/cl32
	name = "magazine (.32)"
	icon_state = "32trauma"
	mag_type = MAGAZINE
	ammo_mag = "mag_cl32"
	ammo_type = /obj/item/ammo_casing/cl32
	matter = list(MATERIAL_STEEL = 4)
	caliber = ".32"
	max_ammo = 7
	multiple_sprites = 1

/obj/item/ammo_magazine/cl32/rubber
	name = "magazine (.32 rubber)"
	ammo_type = /obj/item/ammo_casing/cl32r

/obj/item/ammo_magazine/ak47
	name = "magazine (7.62mm)"
	icon_state = "AKMag"
	mag_type = MAGAZINE
	caliber = "a762"
	matter = list(MATERIAL_STEEL = 5)
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 30
	multiple_sprites = 1
