/*
IMPORTANT

There are important things regarding this file:

 * Wounding multiplier is generally based on bullet width
 * The caliber amount was lowered for a reason, don't add more bloat. If you need different values, use gun vars.
 * Defaultrmor divisor is 1 for shorter calibers
 * Step delays - default value is 1. Lower value makes bullet go faster, higher value makes bullet go slower.

 * Rubbers are non sharp, embed incapable objects, with halved armor divisors. Their agony damage is generally lower than actual one.
 * HV exists as an antag option for better ammo, keeps wounding multiplier and increased armor divisor.
 * Scrap ammunition has less armor divisor and more recoil without impacting raw damage.
*/
//Low-caliber pistols and SMGs .35
/obj/item/projectile/bullet/pistol
	name = ".35 caliber bullet"
	damage_types = list(BRUTE = 26)
	armor_divisor = 1
	can_ricochet = TRUE
	penetrating = 2
	recoil = 3
	matter = list(MATERIAL_STEEL = 0.05)

/obj/item/projectile/bullet/pistol/hv
	armor_divisor = 1.5
	step_delay = 0.75

/obj/item/projectile/bullet/pistol/practice
	name = "practice bullet"
	damage_types = list(BRUTE = 4, HALLOSS = 2)
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE
	matter = list(MATERIAL_STEEL = 0.01)

/obj/item/projectile/bullet/pistol/rubber
	icon_state = "rubber"
	name = "rubber bullet"
	damage_types = list(BRUTE = 12, HALLOSS = 14)
	embed = FALSE
	sharp = FALSE
	wounding_mult = WOUNDING_SMALL
	matter = list(MATERIAL_PLASTIC = 0.05)

/obj/item/projectile/bullet/pistol/scrap
	armor_divisor = 0.8
	recoil = 3.5

//Carbines and rifles

// .20 rifle

/obj/item/projectile/bullet/srifle
	name = ".20 caliber bullet"
	damage_types = list(BRUTE = 24)
	armor_divisor = 1.5
	penetrating = 2
	can_ricochet = TRUE
	recoil = 3
	wounding_mult = WOUNDING_INTERMEDIATE
	matter = list(MATERIAL_STEEL = 0.1)

/obj/item/projectile/bullet/srifle/nomuzzle
	muzzle_type = null

/obj/item/projectile/bullet/srifle/practice
	name = "practice bullet"
	damage_types = list(BRUTE = 4, HALLOSS = 1)
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE
	matter = list(MATERIAL_STEEL = 0.02)

/obj/item/projectile/bullet/srifle/hv
	armor_divisor = 2
	step_delay = 0.75

/obj/item/projectile/bullet/srifle/rubber
	icon_state = "rubber"
	name = "rubber bullet"
	damage_types = list(BRUTE = 9, HALLOSS = 9)
	embed = FALSE
	sharp = FALSE
	wounding_mult = WOUNDING_SMALL
	matter = list(MATERIAL_PLASTIC = 0.1)

/obj/item/projectile/bullet/srifle/scrap
	armor_divisor = 1.2
	recoil = 5

// .25 caseless rifle

/obj/item/projectile/bullet/clrifle
	name = ".25 caliber bullet"
	damage_types = list(BRUTE = 21)
	armor_divisor = 1.5
	penetrating = 2
	can_ricochet = FALSE //to reduce collateral damage and FF, since IH use it in their primary firearm
	recoil = 3.5
	step_delay = 0.9 //intermediate between .20 and .30, but easy to use
	matter = list(MATERIAL_STEEL = 0.2) // as the casing costs nothing, the bullet costs twice as much.

/obj/item/projectile/bullet/clrifle/practice
	name = "practice bullet"
	damage_types = list(BRUTE = 3, HALLOSS = 2)
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE
	matter = list(MATERIAL_STEEL = 0.02)

/obj/item/projectile/bullet/clrifle/hv
	armor_divisor = 2
	step_delay = 0.7
	can_ricochet = TRUE

/obj/item/projectile/bullet/clrifle/rubber
	icon_state = "rubber"
	name = "rubber bullet"
	damage_types = list(BRUTE = 11, HALLOSS = 10)
	embed = FALSE
	sharp = FALSE
	can_ricochet = TRUE
	wounding_mult = WOUNDING_SMALL
	matter = list(MATERIAL_PLASTIC = 0.2)

/obj/item/projectile/bullet/clrifle/scrap
	armor_divisor = 1.2
	recoil = 4.5

// .30 rifle

/obj/item/projectile/bullet/lrifle
	name = ".30 caliber bullet"
	damage_types = list(BRUTE = 18)
	armor_divisor = 1.5
	penetrating = 2
	can_ricochet = TRUE
	recoil = 4.5
	wounding_mult = WOUNDING_WIDE
	matter = list(MATERIAL_STEEL = 0.15)

/obj/item/projectile/bullet/lrifle/practice
	name = "practice bullet"
	damage_types = list(BRUTE = 3, HALLOSS = 3)
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE
	matter = list(MATERIAL_STEEL = 0.03)

/obj/item/projectile/bullet/lrifle/hv
	armor_divisor = 2
	step_delay = 0.75

/obj/item/projectile/bullet/lrifle/rubber
	icon_state = "rubber"
	name = "rubber bullet"
	damage_types = list(BRUTE = 8, HALLOSS = 8)
	embed = FALSE
	sharp = FALSE
	wounding_mult = WOUNDING_NORMAL
	matter = list(MATERIAL_PLASTIC = 0.15)

/obj/item/projectile/bullet/lrifle/scrap
	armor_divisor = 1.2
	recoil = 5.5

//Revolvers and high-caliber pistols .40
/obj/item/projectile/bullet/magnum
	name = " .40 caliber bullet"
	damage_types = list(BRUTE = 21)
	armor_divisor = 1
	can_ricochet = TRUE
	penetrating = 2
	recoil = 6
	wounding_mult = WOUNDING_WIDE
	matter = list(MATERIAL_STEEL = 0.1)

/obj/item/projectile/bullet/magnum/practice
	name = "practice bullet"
	damage_types = list(BRUTE = 5, HALLOSS = 4)
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE
	matter = list(MATERIAL_STEEL = 0.02)

/obj/item/projectile/bullet/magnum/hv
	armor_divisor = 1.5
	step_delay = 0.75

/obj/item/projectile/bullet/magnum/rubber
	icon_state = "rubber"
	name = "rubber bullet"
	damage_types = list(BRUTE = 10, HALLOSS = 11)
	embed = FALSE
	sharp = FALSE
	wounding_mult = WOUNDING_NORMAL
	matter = list(MATERIAL_PLASTIC = 0.1)

/obj/item/projectile/bullet/magnum/scrap
	armor_divisor = 0.8
	recoil = 7

//Sniper rifles .60
/obj/item/projectile/bullet/antim
	name = ".60 caliber bullet"
	damage_types = list(BRUTE = 18)
	armor_divisor = 3
	penetrating = 2
	step_delay = 0.8
	recoil = 15 // Good luck shooting these from a revolver
	wounding_mult = WOUNDING_EXTREME
	matter = list(MATERIAL_PLASTEEL = 1)

/obj/item/projectile/bullet/antim/emp
	damage_types = list(BRUTE = 16)
	armor_divisor = 2
	matter = list(MATERIAL_STEEL = 1, MATERIAL_IRON = 1, MATERIAL_URANIUM = 1)

/obj/item/projectile/bullet/antim/emp/on_hit(atom/target, blocked = FALSE)
	. = ..()
	empulse(target, 0, 0)
	matter [MATERIAL_IRON] = 0
	matter [MATERIAL_URANIUM] = 0

/obj/item/projectile/bullet/antim/uranium
	damage_types = list(BRUTE = 16)
	armor_divisor = 5
	irradiate = 200
	matter = list(MATERIAL_PLASTEEL = 1, MATERIAL_URANIUM = 1)

/obj/item/projectile/bullet/antim/breach
	damage_types = list(BRUTE = 16, HALLOSS = 20)
	armor_divisor = 2
	penetrating = -5
	nocap_structures = TRUE
	kill_count = 30
	matter = list(MATERIAL_PLASTEEL = 2)

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
	matter = list(MATERIAL_STEEL = 1) // cheap bullets don't contain plasteel
	armor_divisor = 2
	recoil = 20

//Shotguns .50
/obj/item/projectile/bullet/shotgun
	name = "slug"
	icon_state = "slug"
	damage_types = list(BRUTE = 25)
	armor_divisor = 1
	knockback = 1
	step_delay = 1
	recoil = 8
	wounding_mult = WOUNDING_EXTREME
	matter = list(MATERIAL_STEEL = 0.5)

/obj/item/projectile/bullet/shotgun/scrap
	armor_divisor = 0.8
	recoil = 10

/obj/item/projectile/bullet/shotgun/beanbag
	name = "beanbag"
	icon_state = "buckshot"
	check_armour = ARMOR_BULLET //neverforget
	damage_types = list(BRUTE = 10, HALLOSS = 20)
	embed = FALSE
	sharp = FALSE
	wounding_mult = WOUNDING_WIDE

/obj/item/projectile/bullet/shotgun/beanbag/scrap
	damage_types = list(BRUTE = 9, HALLOSS = 20)
	recoil = 10

/obj/item/projectile/bullet/shotgun/practice
	name = "practice slug"
	damage_types = list(BRUTE = 4, HALLOSS = 6)
	embed = FALSE
	knockback = 0

/obj/item/projectile/bullet/shotgun/incendiary
	damage_types = list(BRUTE = 38)
	knockback = 0

	var/fire_stacks = 4
	matter = list(MATERIAL_STEEL = 0.5, MATERIAL_PLASMA = 0.5)

/obj/item/projectile/bullet/shotgun/incendiary/on_hit(atom/target, blocked = FALSE)
	matter[MATERIAL_PLASMA] = 0
	. = ..()
	if(iscarbon(target))
		var/mob/living/carbon/M = target
		M.adjust_fire_stacks(fire_stacks)
		M.IgniteMob()

//Overall less damage than slugs vs armor for more damage to unarmored
//Has a small wounding modifier due to /bullet/pellet
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	icon_state = "birdshot-1"
	damage_types = list(BRUTE = 21)
	armor_divisor = 1
	pellets = 6
	range_step = 1
	spread_step = 10
	pellet_to_knockback_ratio = 2
	recoil = 5
	matter = list(MATERIAL_STEEL = 0.6)

/obj/item/projectile/bullet/pellet/shotgun/Initialize()
	. = ..()
	icon_state = "birdshot-[rand(1,4)]"

/obj/item/projectile/bullet/pellet/shotgun/scrap
	armor_divisor = 0.8
	recoil = 5

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
	icon_state = "SpearFlight"
	name = "bolt"
	damage_types = list(BRUTE = 27)
	armor_divisor = 2
	embed = FALSE
	can_ricochet = TRUE
	recoil = 3
	wounding_mult = WOUNDING_EXTREME
	matter = list(MATERIAL_STEEL = 1)

/obj/item/projectile/bullet/bolt/on_hit(mob/living/target, def_zone = BP_CHEST)
    if(istype(target))
        var/obj/item/ammo_casing/crossbow/bolt/R = new(null)
        target.embed(R, def_zone)
