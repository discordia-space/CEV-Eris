
//// .35 ////
/obj/item/ammo_casing/pistol
	desc = "A .35 Auto bullet casing."
	caliber = CAL_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_casing/pistol/hv
	desc = "A .35 Auto high-velocity bullet casing."
	caliber = CAL_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol/hv

/obj/item/ammo_casing/pistol/practice
	desc = "A .35 Auto practice bullet casing."
	caliber = CAL_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol/practice

/obj/item/ammo_casing/pistol/rubber
	desc = "A .35 Auto rubber bullet casing."
	caliber = CAL_PISTOL
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

//// .40 ////

/obj/item/ammo_casing/magnum
	desc = "A .40 Magnum hollow point bullet casing."
	caliber = CAL_MAGNUM
	projectile_type = /obj/item/projectile/bullet/magnum

/obj/item/ammo_casing/magnum/practice
	desc = "A .40 Magnum practice bullet casing."
	caliber = CAL_MAGNUM
	projectile_type = /obj/item/projectile/bullet/magnum/practice

/obj/item/ammo_casing/magnum/hv
	desc = "A .40 Magnum high-velocity bullet casing."
	caliber = CAL_MAGNUM
	projectile_type = /obj/item/projectile/bullet/magnum/hv

/obj/item/ammo_casing/magnum/rubber
	desc = "A .40 Magnum rubber bullet casing."
	caliber = CAL_MAGNUM
	projectile_type = /obj/item/projectile/bullet/magnum/rubber

//// .20 ////

/obj/item/ammo_casing/srifle
	desc = "A .20 Rifle bullet casing."
	caliber = CAL_SRIFLE
	projectile_type = /obj/item/projectile/bullet/srifle

/obj/item/ammo_casing/srifle/practice
	desc = "A .20 Rifle practice bullet casing."
	caliber = CAL_SRIFLE
	projectile_type = /obj/item/projectile/bullet/srifle/practice

/obj/item/ammo_casing/srifle/hv
	desc = "A .20 Rifle high-velocity bullet casing."
	caliber = CAL_SRIFLE
	projectile_type = /obj/item/projectile/bullet/srifle/hv

/obj/item/ammo_casing/srifle/rubber
	desc = "A .20 Rifle rubber bullet casing."
	caliber = CAL_SRIFLE
	projectile_type = /obj/item/projectile/bullet/srifle/rubber

//// .25 ////

/obj/item/ammo_casing/clrifle
	desc = "A .25 Caseless Rifle bullet casing."
	caliber = CAL_CLRIFLE
	projectile_type = /obj/item/projectile/bullet/clrifle
	is_caseless = TRUE

/obj/item/ammo_casing/clrifle/practice
	desc = "A .25 Caseless Rifle practice bullet casing."
	caliber = CAL_CLRIFLE
	projectile_type = /obj/item/projectile/bullet/clrifle/practice
	is_caseless = TRUE

/obj/item/ammo_casing/clrifle/hv
	desc = "A .25 Caseless Rifle high-velocity bullet casing."
	caliber = CAL_CLRIFLE
	projectile_type = /obj/item/projectile/bullet/clrifle/hv
	is_caseless = TRUE

/obj/item/ammo_casing/clrifle/rubber
	desc = "A .25 Caseless Rifle rubber bullet casing."
	caliber = CAL_CLRIFLE
	projectile_type = /obj/item/projectile/bullet/clrifle/rubber
	is_caseless = TRUE

//// .30 ////

/obj/item/ammo_casing/lrifle
	desc = "A .30 rifle bullet casing."
	caliber = CAL_LRIFLE
	projectile_type = /obj/item/projectile/bullet/lrifle

/obj/item/ammo_casing/lrifle/practice
	desc = "A .30 rifle practice bullet casing."
	caliber = CAL_LRIFLE
	projectile_type = /obj/item/projectile/bullet/lrifle/practice

/obj/item/ammo_casing/lrifle/hv
	desc = "A .30 Rifle high-velocity bullet casing."
	caliber = CAL_LRIFLE
	projectile_type = /obj/item/projectile/bullet/lrifle/hv

/obj/item/ammo_casing/lrifle/rubber
	desc = "A .30 Rifle rubber bullet casing."
	caliber = CAL_LRIFLE
	projectile_type = /obj/item/projectile/bullet/lrifle/rubber

//// .60 ////

/obj/item/ammo_casing/antim
	name = "shell casing"
	desc = "A .60 Anti-Material shell."
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = CAL_ANTIM
	projectile_type = /obj/item/projectile/bullet/antim
	matter = list(MATERIAL_STEEL = 2)
	maxamount = 5

/obj/item/ammo_casing/antim/prespawned
	amount = 5

//// .50 Shotgun ////

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A .50 slug."
	icon_state = "slshell"
	spent_icon = "slshell-spent"
	caliber = CAL_SHOTGUN
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/shotgun/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A .50 beanbag shell."
	icon_state = "bshell"
	spent_icon = "bshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(MATERIAL_STEEL = 1)

/obj/item/ammo_casing/shotgun/beanbag/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A .50 shell."
	icon_state = "gshell"
	spent_icon = "gshell-spent"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	matter = list(MATERIAL_STEEL = 1)

/obj/item/ammo_casing/shotgun/pellet/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A .50 blank shell."
	icon_state = "blshell"
	spent_icon = "blshell-spent"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(MATERIAL_STEEL = 1)

/obj/item/ammo_casing/shotgun/blank/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A .50 practice shell."
	icon_state = "pshell"
	spent_icon = "pshell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/practice
	matter = list(MATERIAL_STEEL = 1)

/obj/item/ammo_casing/shotgun/practice/prespawned
	amount = 5

//Does not stun, only blinds, but has area of effect.
/obj/item/ammo_casing/shotgun/flash
	name = "flash shell"
	desc = "A .50 chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	spent_icon = "fshell-spent"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(MATERIAL_STEEL = 1, MATERIAL_SILVER = 0.5)

/obj/item/ammo_casing/shotgun/flash/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/incendiary
	name = "incendiary shell"
	desc = "A .50 chemical shell with highly flammable load."
	icon_state = "ishell"
	spent_icon = "ishell-spent"
	projectile_type = /obj/item/projectile/bullet/shotgun/incendiary
	matter = list(MATERIAL_STEEL = 1, MATERIAL_PLASMA = 0.5)

/obj/item/ammo_casing/shotgun/incendiary/prespawned
	amount = 5

//// Other ////

/obj/item/ammo_casing/rocket
	name = "PG-7VL grenade"
	desc = "A 1.5 warhead designed for the RPG-7 launcher. Has tubular shape."
	icon_state = "rocketshell"
	projectile_type = /obj/item/projectile/bullet/rocket
	caliber = CAL_ROCKET
	maxamount = 1
	reload_delay = 15
	is_caseless = TRUE
	w_class = ITEM_SIZE_NORMAL

/obj/item/ammo_casing/a75
	desc = "A .70 bullet casing."
	caliber = CAL_70
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = CAL_CAP
	color = "#FF0000"
	projectile_type = /obj/item/projectile/bullet/cap