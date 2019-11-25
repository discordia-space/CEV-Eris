/*
IMPORTANT

There are important things regarding this file:

 * Rubbers are non sharp, embed capable objects, with non existing armor penetration. Their agony damage is generally lower then actuall one
 * The caliber ammont was lowered for a reason, don't add more bloat. If you need different values, use gun vars.
 * HV exist as antag option for better ammo.
 * Step delays - default value is 1. Lower value makes bullet go faster, higher value makes bullet go slower.

*/
//Low-caliber pistols and SMGs
/obj/item/projectile/bullet/pistol
	damage = 24
	armor_penetration = 15
	can_ricochet = TRUE

/obj/item/projectile/bullet/pistol/hv
	damage = 28
	armor_penetration = 20
	penetrating = 1
	step_delay = 0.75

/obj/item/projectile/bullet/pistol/practice
	name = "practice bullet"
	damage = 2
	agony = 3
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/pistol/rubber
	name = "rubber bullet"
	damage = 3
	agony = 22
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

//Carbines and rifles
/obj/item/projectile/bullet/srifle
	damage = 25
	armor_penetration = 35
	penetrating = 2
	can_ricochet = TRUE

/obj/item/projectile/bullet/srifle/nomuzzle
	muzzle_type = null

/obj/item/projectile/bullet/srifle/practice
	name = "practice bullet"
	damage = 2
	agony = 2
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/clrifle
	damage = 27
	armor_penetration = 35
	penetrating = 1
	sharp = FALSE
	can_ricochet = TRUE

/obj/item/projectile/bullet/clrifle/rubber
	name = "rubber bullet"
	damage = 3
	agony = 16
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/lrifle
	damage = 28
	armor_penetration = 30
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/lrifle/hv
	damage = 30
	armor_penetration = 35
	penetrating = 2
	step_delay = 0.75

//Revolvers and high-caliber pistols
/obj/item/projectile/bullet/magnum
	damage = 32
	armor_penetration = 20
	can_ricochet = TRUE

/obj/item/projectile/bullet/magnum/hv
	damage = 35
	armor_penetration = 25
	penetrating = 1
	step_delay = 0.75

/obj/item/projectile/bullet/magnum/rubber
	name = "rubber bullet"
	damage = 8
	agony = 32
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE


//Sniper rifles
/obj/item/projectile/bullet/antim
	damage = 70
	armor_penetration = 80
	stun = 3
	weaken = 3
	penetrating = 5
	hitscan = TRUE //so the PTR isn't useless as a sniper weapon

//Shotguns
/obj/item/projectile/bullet/shotgun
	name = "slug"
	icon_state = "slug"
	damage = 64
	armor_penetration = 10
	knockback = 1
	step_delay = 1.5

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	icon_state = "buckshot"
	check_armour = ARMOR_MELEE
	damage = 10
	agony = 60
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/shotgun/practice
	name = "practice slug"
	damage = 50 * 0
	agony = 50 * 0.1
	armor_penetration = 12 * 0.2
	embed = FALSE
	knockback = 0

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	icon_state = "birdshot-1"
	damage = 9
	armor_penetration = 8
	pellets = 6
	range_step = 1
	spread_step = 10
	knockback = 1

/obj/item/projectile/bullet/pellet/shotgun/Initialize()
	. = ..()
	icon_state = "birdshot-[rand(1,4)]"

//Miscellaneous
/obj/item/projectile/bullet/blank
	invisibility = 101
	damage = 1
	embed = FALSE

/obj/item/projectile/bullet/cap
	name = "cap"
	damage_type = HALLOSS
	nodamage = TRUE
	damage = 0
	embed = FALSE
	sharp = FALSE
