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
	name = ".35 caliber bullet"
	damage_types = list(BRUTE = 26)
	armor_penetration = 10
	can_ricochet = TRUE
	penetrating = 2
	style_damage = 20
	recoil = 3

/obj/item/projectile/bullet/pistol/hv
	armor_penetration = 20
	step_delay = 0.75

/obj/item/projectile/bullet/pistol/practice
	name = "practice bullet"
	damage_types = list(BRUTE = 2)
	agony = 3
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/pistol/rubber
	icon_state = "rubber"
	name = "rubber bullet"
	damage_types = list(BRUTE = 3)
	agony = 25
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/pistol/scrap
	damage_types = list(BRUTE = 23)

//Carbines and rifles

// .20 rifle

/obj/item/projectile/bullet/srifle
	name = ".20 caliber bullet"
	damage_types = list(BRUTE = 21)
	armor_penetration = 25
	penetrating = 2
	can_ricochet = TRUE
	recoil = 4

/obj/item/projectile/bullet/srifle/nomuzzle
	muzzle_type = null

/obj/item/projectile/bullet/srifle/practice
	name = "practice bullet"
	damage_types = list(BRUTE = 2)
	agony = 2
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/srifle/hv
	armor_penetration = 35
	step_delay = 0.75

/obj/item/projectile/bullet/srifle/rubber
	icon_state = "rubber"
	name = "rubber bullet"
	damage_types = list(BRUTE = 3)
	agony = 30
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/srifle/scrap
	damage_types = list(BRUTE = 18)

// .25 caseless rifle

/obj/item/projectile/bullet/clrifle
	name = ".25 caliber bullet"
	damage_types = list(BRUTE = 23)
	armor_penetration = 15
	penetrating = 2
	sharp = TRUE
	can_ricochet = FALSE //to reduce collateral damage and FF, since IH use it in their primary firearm
	recoil = 3.5

/obj/item/projectile/bullet/clrifle/practice
	name = "practice bullet"
	damage_types = list(BRUTE = 2)
	agony = 2
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/clrifle/hv
	armor_penetration = 25
	step_delay = 0.75
	can_ricochet = TRUE

/obj/item/projectile/bullet/clrifle/rubber
	icon_state = "rubber"
	name = "rubber bullet"
	damage_types = list(BRUTE = 3)
	agony = 22
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = TRUE

/obj/item/projectile/bullet/clrifle/scrap
	damage_types = list(BRUTE = 20)

// .30 rifle

/obj/item/projectile/bullet/lrifle
	name = ".30 caliber bullet"
	damage_types = list(BRUTE = 24)
	armor_penetration = 20
	penetrating = 2
	can_ricochet = TRUE
	recoil = 4.5

/obj/item/projectile/bullet/lrifle/practice
	name = "practice bullet"
	damage_types = list(BRUTE = 2)
	agony = 2
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/lrifle/hv
	armor_penetration = 30
	step_delay = 0.75

/obj/item/projectile/bullet/lrifle/rubber
	icon_state = "rubber"
	name = "rubber bullet"
	damage_types = list(BRUTE = 3)
	agony = 25
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/lrifle/scrap
	damage_types = list(BRUTE = 21)

//Revolvers and high-caliber pistols .40
/obj/item/projectile/bullet/magnum
	name = " .40 caliber bullet"
	damage_types = list(BRUTE = 31)
	armor_penetration = 15
	can_ricochet = TRUE
	penetrating = 2
	style_damage = 40
	recoil = 6

/obj/item/projectile/bullet/magnum/practice
	name = "practice bullet"
	damage_types = list(BRUTE = 2)
	agony = 3
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/magnum/hv
	armor_penetration = 25
	step_delay = 0.75

/obj/item/projectile/bullet/magnum/rubber
	icon_state = "rubber"
	name = "rubber bullet"
	damage_types = list(BRUTE = 8)
	agony = 32
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/magnum/scrap
	damage_types = list(BRUTE = 28)

//Sniper rifles .60
/obj/item/projectile/bullet/antim
	name = ".60 caliber bullet"
	damage_types = list(BRUTE = 65)
	armor_penetration = 50
	penetrating = 2
	hitscan = TRUE //so the PTR isn't useless as a sniper weapon
	style_damage = 70
	recoil = 30 // Good luck shooting these from a revolver

/obj/item/projectile/bullet/antim/emp
	damage_types = list(BRUTE = 30)
	armor_penetration = 40

/obj/item/projectile/bullet/antim/emp/on_hit(atom/target, blocked = FALSE)
	. = ..()
	empulse(target, 0, 0)

/obj/item/projectile/bullet/antim/uranium
	damage_types = list(BRUTE = 60)
	armor_penetration = 100
	irradiate = 200

/obj/item/projectile/bullet/antim/breach
	damage_types = list(BRUTE = 50)
	armor_penetration = 40
	agony = 40
	penetrating = -5
	step_delay = 0.6
	hitscan = FALSE
	nocap_structures = TRUE
	kill_count = 30

/obj/item/projectile/bullet/antim/breach/proc/get_tiles_passed(var/distance)
	var/tiles_passed = distance
	return ROUND_PROB(tiles_passed)

/obj/item/projectile/bullet/antim/breach/get_structure_damage()
	var/distance = get_dist(loc, starting)
	return  22 * get_tiles_passed(distance)


/obj/item/projectile/bullet/antim/breach/on_hit(atom/target, blocked = FALSE)
	. = ..()
	fragment_explosion_angled(target, starting ,/obj/item/projectile/bullet/pellet/fragment/strong, 5)
	playsound(target, 'sound/effects/explosion1.ogg', 100, 25, 8, 8)




/obj/item/projectile/bullet/antim/scrap
	damage_types = list(BRUTE = 63)

//Shotguns .50
/obj/item/projectile/bullet/shotgun
	name = "slug"
	icon_state = "slug"
	damage_types = list(BRUTE = 48)
	armor_penetration = 15
	knockback = 1
	step_delay = 1.1
	style_damage = 25
	recoil = 8

/obj/item/projectile/bullet/shotgun/scrap
	damage_types = list(BRUTE = 42)

/obj/item/projectile/bullet/shotgun/beanbag
	name = "beanbag"
	icon_state = "buckshot"
	check_armour = ARMOR_BULLET //neverforget
	damage_types = list(BRUTE = 10)
	agony = 60
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/shotgun/beanbag/scrap
	damage_types = list(BRUTE = 9)
	agony = 55

/obj/item/projectile/bullet/shotgun/practice
	name = "practice slug"
	damage_types = list(BRUTE = 1)
	agony = 5
	armor_penetration = 0
	embed = FALSE
	knockback = 0

/obj/item/projectile/bullet/shotgun/incendiary
	damage_types = list(BRUTE = 38)
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
	damage_types = list(BRUTE = 8)
	armor_penetration = 60
	pellets = 8
	range_step = 1
	spread_step = 10
	pellet_to_knockback_ratio = 2
	recoil = 8

/obj/item/projectile/bullet/pellet/shotgun/Initialize()
	. = ..()
	icon_state = "birdshot-[rand(1,4)]"

/obj/item/projectile/bullet/pellet/shotgun/scrap
	damage_types = list(BRUTE = 7)

//Miscellaneous
/obj/item/projectile/bullet/blank
	invisibility = 101
	damage_types = list(BRUTE = 1)
	embed = FALSE

/obj/item/projectile/bullet/cap
	name = "cap"
	damage_types = list(HALLOSS = 0)
	nodamage = TRUE
	embed = FALSE
	sharp = FALSE
	recoil = 1 // Pop

/obj/item/projectile/bullet/bolt
	name = "bolt"
	armor_penetration = 20
	can_ricochet = TRUE
	recoil = 3
	style_damage = 40

/obj/item/projectile/bullet/bolt/on_hit(mob/living/target, def_zone = BP_CHEST)
    if(istype(target))
        var/obj/item/stack/rods/R = new(null)
        target.embed(R, def_zone)
