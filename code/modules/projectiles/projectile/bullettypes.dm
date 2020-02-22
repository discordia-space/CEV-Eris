/*
IMPORTANT

There are important things regarding this file:

 * Rubbers are non sharp, embed capable objects, with non existing armor penetration. Their agony damage is generally lower then actuall one
 * The caliber ammont was lowered for a reason, don't add more bloat. If you need different values, use gun vars.
 * HV exist as antag option for better ammo.
 * Step delays - default value is 1. Lower value makes bullet go faster, higher value makes bullet go slower.

*/
//Low-caliber pistols and SMGs .35
/obj/item/projectile/bullet/pistol
	damage = 24
	armor_penetration = 5
	can_ricochet = TRUE

/obj/item/projectile/bullet/pistol/hv
	damage = 28
	armor_penetration = 10
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

// .20 rifle

/obj/item/projectile/bullet/srifle
	damage = 25
	armor_penetration = 25
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

/obj/item/projectile/bullet/srifle/hv
	damage = 30
	armor_penetration = 30
	penetrating = 4
	step_delay = 0.75

/obj/item/projectile/bullet/srifle/rubber
	name = "rubber bullet"
	damage = 3
	agony = 30
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

// .25 caseless rifle

/obj/item/projectile/bullet/clrifle
	damage = 27
	armor_penetration = 15
	penetrating = 1
	sharp = TRUE
	can_ricochet = FALSE //to reduce collateral damage and FF, since IH use it in their primary firearm

/obj/item/projectile/bullet/clrifle/practice
	name = "practice bullet"
	damage = 2
	agony = 2
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/clrifle/hv
	damage = 32
	armor_penetration = 20
	penetrating = 2
	step_delay = 0.75
	can_ricochet = TRUE

/obj/item/projectile/bullet/clrifle/rubber
	name = "rubber bullet"
	damage = 3
	agony = 16
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = TRUE

// .30 rifle

/obj/item/projectile/bullet/lrifle
	damage = 28
	armor_penetration = 20
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/lrifle/practice
	name = "practice bullet"
	damage = 2
	agony = 2
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/lrifle/hv
	damage = 30
	armor_penetration = 30
	penetrating = 2
	step_delay = 0.75

/obj/item/projectile/bullet/lrifle/rubber
	name = "rubber bullet"
	damage = 3
	agony = 25
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

//Revolvers and high-caliber pistols .40
/obj/item/projectile/bullet/magnum
	damage = 32
	armor_penetration = 15
	can_ricochet = TRUE

/obj/item/projectile/bullet/magnum/practice
	name = "practice bullet"
	damage = 2
	agony = 3
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/magnum/hv
	damage = 35
	armor_penetration = 20
	penetrating = 1
	step_delay = 0.75

/obj/item/projectile/bullet/magnum/rubber
	name = "rubber bullet"
	damage = 8
	agony = 32
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

//Sniper rifles .60
/obj/item/projectile/bullet/antim
	damage = 70
	armor_penetration = 50
	stun = 3
	weaken = 3
	penetrating = 5
	hitscan = TRUE //so the PTR isn't useless as a sniper weapon

//Shotguns .50
/obj/item/projectile/bullet/shotgun
	name = "slug"
	icon_state = "slug"
	damage = 54
	armor_penetration = 10
	knockback = 1
	step_delay = 1.65

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
	damage = 1
	agony = 5
	armor_penetration = 0
	embed = FALSE
	knockback = 0

/obj/item/projectile/bullet/shotgun/incendiary
	damage = 10
	agony = 5
	armor_penetration = 0
	embed = FALSE
	knockback = 0
	var/fire_stacks = 4

/obj/item/projectile/bullet/shotgun/incendiary/on_hit(atom/target, blocked = FALSE)
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.IgniteMob()

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	icon_state = "birdshot-1"
	damage = 10
	pellets = 8
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
