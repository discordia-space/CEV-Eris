/obj/item/ammo_casing/a10mm
	desc = "A 10mm bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/a10mm

/obj/item/ammo_casing/a10mm/rubber
	desc = "A 10mm rubber bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/a10mm/rubber

/obj/item/ammo_casing/a10mm/hv
	desc = "A 10mm high-velocity bullet casing."
	caliber = "10mm"
	projectile_type = /obj/item/projectile/bullet/a10mm/hv

/obj/item/ammo_casing/c9mm
	desc = "A 9mm bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/c9mm

/obj/item/ammo_casing/c9mm/flash
	desc = "A 9mm flash shell casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/c9mm/hv
	desc = "A 9mm high-velocity bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/c9mm/hv

/obj/item/ammo_casing/c9mm/practice
	desc = "A 9mm practice bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/c9mm/practice

/obj/item/ammo_casing/c9mm/rubber
	desc = "A 9mm rubber bullet casing."
	caliber = "9mm"
	projectile_type = /obj/item/projectile/bullet/c9mm/rubber

/obj/item/ammo_casing/cl32
	desc = "A .32 FS hollow point bullet casing."
	caliber = ".32"
	projectile_type = /obj/item/projectile/bullet/cl32

/obj/item/ammo_casing/cl32/rubber
	desc = "A .32 FS rubber bullet casing."
	caliber = ".32"
	projectile_type = /obj/item/projectile/bullet/cl32/rubber

/obj/item/ammo_casing/c45
	desc = "A .45 bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/c45

/obj/item/ammo_casing/c45/flash
	desc = "A .45 flash shell casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/c45/practice
	desc = "A .45 practice bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/c45/practice

/obj/item/ammo_casing/c45/rubber
	desc = "A .45 rubber bullet casing."
	caliber = ".45"
	projectile_type = /obj/item/projectile/bullet/c45/rubber

/obj/item/ammo_casing/c10x24
	desc = "A 10mm x 24 caseless ammo."
	caliber = "10x24"
	projectile_type = /obj/item/projectile/bullet/c10x24
	is_caseless = TRUE

/obj/item/ammo_casing/a556
	desc = "A 5.56mm bullet casing."
	caliber = "a556"
	projectile_type = /obj/item/projectile/bullet/a556

/obj/item/ammo_casing/a556/practice
	desc = "A 5.56mm practice bullet casing."
	caliber = "a556"
	projectile_type = /obj/item/projectile/bullet/a556/practice

/obj/item/ammo_casing/c65
	desc = "A 6.5mm bullet casing."
	caliber = "6.5mm"
	projectile_type = /obj/item/projectile/bullet/c65

/obj/item/ammo_casing/c65/rubber
	desc = "A 6.5mm rubber bullet casing."
	caliber = "6.5mm"
	projectile_type = /obj/item/projectile/bullet/c65/rubber

/obj/item/ammo_casing/a762
	desc = "A 7.62mm bullet casing."
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/a762

/obj/item/ammo_casing/a762/hv
	desc = "A 7.62mm high-velocity bullet casing."
	caliber = "a762"
	projectile_type = /obj/item/projectile/bullet/a762/hv

/obj/item/ammo_casing/a357
	desc = "A .357 bullet casing."
	caliber = "357"
	projectile_type = /obj/item/projectile/bullet/a357

/obj/item/ammo_casing/a357/hv
	desc = "A .357 high-velocity bullet casing."
	caliber = "357"
	projectile_type = /obj/item/projectile/bullet/a357/hv

/obj/item/ammo_casing/c38
	desc = "A .38 bullet casing."
	caliber = ".38"
	projectile_type = /obj/item/projectile/bullet/c38

/obj/item/ammo_casing/c38/rubber
	desc = "A .38 rubber bullet casing."
	caliber = ".38"
	projectile_type = /obj/item/projectile/bullet/c38/rubber

/obj/item/ammo_casing/cl44
	desc = "A .44 Frozen Star hollow point bullet casing."
	caliber = ".44"
	projectile_type = /obj/item/projectile/bullet/cl44

/obj/item/ammo_casing/cl44/rubber
	desc = "A .44 Frozen Star rubber bullet casing."
	caliber = ".44"
	projectile_type = /obj/item/projectile/bullet/cl44/rubber

/obj/item/ammo_casing/a50
	desc = "A .50AE bullet casing."
	caliber = ".50"
	projectile_type = /obj/item/projectile/bullet/a50

/obj/item/ammo_casing/a50/rubber
	desc = "A .50AE rubber bullet casing."
	caliber = ".50"
	projectile_type = /obj/item/projectile/bullet/a50/rubber

/obj/item/ammo_casing/a145
	name = "shell casing"
	desc = "A 14.5mm shell."
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = "14.5mm"
	projectile_type = /obj/item/projectile/bullet/a145
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/a145/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A 12 gauge slug."
	icon_state = "slshell"
	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/shotgun/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A beanbag shell."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/shotgun/beanbag/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A 12 gauge shell."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/shotgun/pellet/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A blank shell."
	icon_state = "blshell"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/shotgun/blank/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A practice shell."
	icon_state = "pshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/shotgun/practice/prespawned
	amount = 5

//Can stun in one hit if aimed at the head, but
//is blocked by clothing that stops tasers and is vulnerable to EMP
/obj/item/ammo_casing/shotgun/stunshell
	name = "taser shell"
	desc = "A 12 gauge taser cartridge."
	icon_state = "stunshell"
	spent_icon = "stunshell-spent"
	projectile_type = /obj/item/projectile/energy/electrode/stunshot
	matter = list(MATERIAL_STEEL = 1, MATERIAL_SILVER = 0.5)
	maxamount = 5

/obj/item/ammo_casing/shotgun/stunshell/emp_act(severity)
	if(prob(100/severity)) BB = null
	update_icon()

/obj/item/ammo_casing/shotgun/stunshell/prespawned
	amount = 5

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(MATERIAL_STEEL = 1, MATERIAL_SILVER = 0.5)
	maxamount = 5

/obj/item/ammo_casing/shotgun/flash/prespawned
	amount = 5

/obj/item/ammo_casing/rocket
	name = "PG-7VL grenade"
	desc = "A 40mm warhead designed for the RPG-7 launcher. Has tubular shape."
	icon_state = "rocketshell"
	projectile_type = /obj/item/projectile/bullet/rocket
	caliber = "rocket"
	maxamount = 1
	reload_delay = 15
	is_caseless = TRUE
	w_class = ITEM_SIZE_NORMAL

/obj/item/ammo_casing/a75
	desc = "A 20mm bullet casing."
	caliber = "75"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = "caps"
	color = "#FF0000"
	projectile_type = /obj/item/projectile/bullet/cap