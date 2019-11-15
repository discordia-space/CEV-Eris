/obj/item/ammo_casing/pistol
	desc = "A .35 Auto bullet casing."
	caliber = "pistol"
	projectile_type = /obj/item/projectile/bullet/pistol

/obj/item/ammo_casing/pistol/flash
	desc = "A .35 Auto flash shell casing."
	caliber = "pistol"
	projectile_type = /obj/item/projectile/energy/flash

/obj/item/ammo_casing/pistol/hv
	desc = "A .35 Auto high-velocity bullet casing."
	caliber = "pistol"
	projectile_type = /obj/item/projectile/bullet/pistol/hv

/obj/item/ammo_casing/pistol/practice
	desc = "A .35 Auto practice bullet casing."
	caliber = "pistol"
	projectile_type = /obj/item/projectile/bullet/pistol/practice

/obj/item/ammo_casing/pistol/rubber
	desc = "A .35 Auto rubber bullet casing."
	caliber = "pistol"
	projectile_type = /obj/item/projectile/bullet/pistol/rubber

/obj/item/ammo_casing/srifle
	desc = "A .20 Rifle bullet casing."
	caliber = "srifle"
	projectile_type = /obj/item/projectile/bullet/srifle

/obj/item/ammo_casing/srifle/practice
	desc = "A .20 Rifle practice bullet casing."
	caliber = "srifle"
	projectile_type = /obj/item/projectile/bullet/srifle/practice

/obj/item/ammo_casing/clrifle
	desc = "A .25 Caseless Rifle bullet casing."
	caliber = "clrifle"
	projectile_type = /obj/item/projectile/bullet/clrifle

/obj/item/ammo_casing/clrifle/rubber
	desc = "A .25 Caseless Rifle rubber bullet casing."
	caliber = "clrifle"
	projectile_type = /obj/item/projectile/bullet/clrifle/rubber

/obj/item/ammo_casing/lrifle
	desc = "A .30 rifle bullet casing."
	caliber = "lrifle"
	projectile_type = /obj/item/projectile/bullet/lrifle

/obj/item/ammo_casing/lrifle/hv
	desc = "A .30 Rifle high-velocity bullet casing."
	caliber = "lrifle"
	projectile_type = /obj/item/projectile/bullet/lrifle/hv

/obj/item/ammo_casing/magnum
	desc = "A .40 Magnum Frozen Star hollow point bullet casing."
	caliber = "magnum"
	projectile_type = /obj/item/projectile/bullet/magnum

/obj/item/ammo_casing/magnum/hv
	desc = "A .40 Magnum high-velocity bullet casing."
	caliber = "magnum"
	projectile_type = /obj/item/projectile/bullet/magnum/hv

/obj/item/ammo_casing/magnum/rubber
	desc = "A .40 Magnum Frozen Star rubber bullet casing."
	caliber = "magnum"
	projectile_type = /obj/item/projectile/bullet/magnum/rubber

/obj/item/ammo_casing/antim
	name = "shell casing"
	desc = "A .60 Anti-Material shell."
	icon_state = "lcasing"
	spent_icon = "lcasing-spent"
	caliber = "antim"
	projectile_type = /obj/item/projectile/bullet/antim
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/antim/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun
	name = "shotgun slug"
	desc = "A .50 slug."
	icon_state = "slshell"
	caliber = "shotgun"
	projectile_type = /obj/item/projectile/bullet/shotgun
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/shotgun/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/beanbag
	name = "beanbag shell"
	desc = "A .50 beanbag shell."
	icon_state = "bshell"
	projectile_type = /obj/item/projectile/bullet/shotgun/beanbag
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/shotgun/beanbag/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/pellet
	name = "shotgun shell"
	desc = "A .50 shell."
	icon_state = "gshell"
	projectile_type = /obj/item/projectile/bullet/pellet/shotgun
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/shotgun/pellet/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/blank
	name = "shotgun shell"
	desc = "A .50 blank shell."
	icon_state = "blshell"
	projectile_type = /obj/item/projectile/bullet/blank
	matter = list(MATERIAL_STEEL = 1)
	maxamount = 5

/obj/item/ammo_casing/shotgun/blank/prespawned
	amount = 5

/obj/item/ammo_casing/shotgun/practice
	name = "shotgun shell"
	desc = "A .50 practice shell."
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
	desc = "A .50 taser cartridge."
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
	desc = "A .50 chemical shell used to signal distress or provide illumination."
	icon_state = "fshell"
	projectile_type = /obj/item/projectile/energy/flash/flare
	matter = list(MATERIAL_STEEL = 1, MATERIAL_SILVER = 0.5)
	maxamount = 5

/obj/item/ammo_casing/shotgun/flash/prespawned
	amount = 5

/obj/item/ammo_casing/rocket
	name = "PG-7VL grenade"
	desc = "A 1.5 warhead designed for the RPG-7 launcher. Has tubular shape."
	icon_state = "rocketshell"
	projectile_type = /obj/item/projectile/bullet/rocket
	caliber = "rocket"
	maxamount = 1
	reload_delay = 15
	is_caseless = TRUE
	w_class = ITEM_SIZE_NORMAL

/obj/item/ammo_casing/a75
	desc = "A .70 bullet casing."
	caliber = "70"
	projectile_type = /obj/item/projectile/bullet/gyro

/obj/item/ammo_casing/cap
	name = "cap"
	desc = "A cap for children toys."
	caliber = "caps"
	color = "#FF0000"
	projectile_type = /obj/item/projectile/bullet/cap