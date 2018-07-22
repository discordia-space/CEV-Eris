/*This code for boxes with ammo, you cant use them as magazines, but should be able to fill magazines with them.*/
/obj/item/ammo_magazine/ammobox	//Should not be used bu its own
	name = "ammunition box"
	desc = "Gun ammunition puted in shiny new box. You can see caliber details on on the label."
	mag_type = SPEEDLOADER	//To prevent load in magazine filled guns
	multiple_sprites = 1
	reload_delay = 30

/obj/item/ammo_magazine/ammobox/c9mm
	name = "ammunition box (9mm)"
	icon_state = "box9mm"
	matter = list(MATERIAL_STEEL = 5)
	caliber = "9mm"
	ammo_type = /obj/item/ammo_casing/c9mm
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/c9mm/rubber
	name = "ammunition box (9mm rubber)"
	icon_state = "box9mm-rubber"
	ammo_type = /obj/item/ammo_casing/c9mmr

/obj/item/ammo_magazine/ammobox/c9mm/flash
	name = "ammunition box (9mm flash)"
	icon_state = "box9mm-flash"
	ammo_type = /obj/item/ammo_casing/c9mmf

/obj/item/ammo_magazine/ammobox/c9mm/practice
	name = "ammunition box (9mm practice)"
	icon_state = "box9mm-practice"
	ammo_type = /obj/item/ammo_casing/c9mmp

/obj/item/ammo_magazine/ammobox/a10mm
	name = "ammunition box (10mm)"
	icon_state = "box10mm"
	matter = list(MATERIAL_STEEL = 6)
	caliber = "10mm"
	ammo_type = /obj/item/ammo_casing/a10mm
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/c38
	name = "ammunition box (.38)"
	icon_state = "box38"
	matter = list(MATERIAL_STEEL = 5)
	caliber = "38"
	ammo_type = /obj/item/ammo_casing/c38
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/c38/rubber
	name = "ammunition box (.38 rubber)"
	icon_state = "box38-rubber"
	ammo_type = /obj/item/ammo_casing/c38r

/obj/item/ammo_magazine/ammobox/cl32
	name = "ammunition box (.32)"
	icon_state = "box32"
	matter = list(MATERIAL_STEEL = 5)
	caliber = "38"
	ammo_type = /obj/item/ammo_casing/cl32
	max_ammo = 40

/obj/item/ammo_magazine/ammobox/cl32/rubber
	name = "ammunition box (.32 rubber)"
	icon_state = "box32-rubber"
	ammo_type = /obj/item/ammo_casing/cl32r

/obj/item/ammo_magazine/ammobox/c357
	name = "ammunition box (.357)"
	icon_state = "box357"
	matter = list(MATERIAL_STEEL = 5)
	caliber = "357"
	ammo_type = /obj/item/ammo_casing/a357
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/c44
	name = "ammunition box (.44)"
	icon_state = "box44"
	matter = list(MATERIAL_STEEL = 5)
	caliber = ".44"
	ammo_type = /obj/item/ammo_casing/cl44
	max_ammo = 20

/obj/item/ammo_magazine/ammobox/c44/rubber
	name = "ammunition box (.44 rubber)"
	icon_state = "box44-rubber"
	ammo_type = /obj/item/ammo_casing/cl44r

/obj/item/ammo_magazine/ammobox/c45
	name = "ammunition box (.45)"
	icon_state = "box45"
	matter = list(MATERIAL_STEEL = 8)
	caliber = ".45"
	ammo_type = /obj/item/ammo_casing/c45
	max_ammo = 30

/obj/item/ammo_magazine/ammobox/c45/rubber
	name = "ammunition box (.45)"
	icon_state = "box45-rubber"
	ammo_type = /obj/item/ammo_casing/c45r

/obj/item/ammo_magazine/ammobox/c45/flash
	name = "ammunition box (.45)"
	icon_state = "box45-flash"
	ammo_type = /obj/item/ammo_casing/c45f

/obj/item/ammo_magazine/ammobox/c45practice
	name = "ammunition box (.45)"
	icon_state = "box45-practice"
	ammo_type = /obj/item/ammo_casing/c45p

/obj/item/ammo_magazine/ammobox/c50
	name = "ammunition box (.50)"
	icon_state = "box50"
	matter = list(MATERIAL_STEEL = 10)
	caliber = ".50"
	ammo_type = /obj/item/ammo_casing/a50
	max_ammo = 20

/obj/item/ammo_magazine/ammobox/c50/rubber
	name = "ammunition box (.50 rubber)"
	icon_state = "box50-rubber"
	ammo_type = /obj/item/ammo_casing/a50r

/obj/item/ammo_magazine/ammobox/c65mm
	name = "ammunition box (6.5mm)"
	icon_state = "box65mm"
	matter = list(MATERIAL_STEEL = 10)
	w_class = ITEM_SIZE_LARGE
	caliber = "6.5mm"
	ammo_type = /obj/item/ammo_casing/c65
	max_ammo = 80

/obj/item/ammo_magazine/ammobox/c65mm/rubber
	name = "ammunition box (6.5mm rubber)"
	icon_state = "box65mm-rubber"
	ammo_type = /obj/item/ammo_casing/c65r

/obj/item/ammo_magazine/ammobox/a556
	name = "ammunition box (5.56mm)"
	icon_state = "box556mm"
	matter = list(MATERIAL_STEEL = 10)
	w_class = ITEM_SIZE_LARGE
	caliber = "a556"
	ammo_type = /obj/item/ammo_casing/a556
	max_ammo = 80

/obj/item/ammo_magazine/ammobox/a556/practice
	name = "ammunition box (5.56mm practice)"
	icon_state = "box556mm-practice"
	ammo_type = /obj/item/ammo_casing/a556p

/obj/item/ammo_magazine/ammobox/a762
	name = "ammunition box (7.62mm)"
	icon_state = "box762mm"
	matter = list(MATERIAL_STEEL = 10)
	w_class = ITEM_SIZE_LARGE
	caliber = "a762"
	ammo_type = /obj/item/ammo_casing/a762
	max_ammo = 80

/obj/item/ammo_magazine/ammobox/a145
	name = "ammunition box (14.5mm)"
	icon_state = "box145mm"
	matter = list(MATERIAL_STEEL = 8)
	w_class = ITEM_SIZE_LARGE
	caliber = "14.5mm"
	ammo_type = /obj/item/ammo_casing/a145
	max_ammo = 30
