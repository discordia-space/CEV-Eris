//Damage multipliers
#define HIGH_VELOCITY_MULTIPLIER 1.2 //Determines the damage, agony, & armor_penetration values from base damage & armor_penetration.
#define RUBBER_DAMAGE_MULTIPLIER 0.15 //Determines the damage value from base damage.
#define RUBBER_AGONY_MULTIPLIER 0.85 //Determines the agony value from base damage.
#define RUBBER_PENETRATION_MULTIPLIER 0 //Determines the armor_penetration value from base armor_penetration.
#define PRACTICE_DAMAGE_MULTIPLIER 0 //Determines the damage value from base damage.
#define PRACTICE_AGONY_MULTIPLIER 0.1 //Determines the agony value from base damage.
#define PRACTICE_PENETRATION_MULTIPLIER 0.2 //Determines the armor_penetration value from base armor_penetration.

//Step delays //Default value is 1. Lower value makes bullet go faster, higher value makes bullet go slower.
#define HIGH_VELOCITY_STEP_DELAY 0.75

//Low-caliber pistols and SMGs
#define ARMOR_PENETRATION_LOW_CALIBER_PISTOL 5
#define DAMAGE_PISTOL 22
#define DAMAGE_PISTOL 26

//Carbines and rifles
#define DAMAGE_SRIFLE 16
#define ARMOR_PENETRATION_SRIFLE 25
#define DAMAGE_CLRIFLE 18
#define ARMOR_PENETRATION_CLRIFLE 15
#define DAMAGE_LRIFLE 20
#define ARMOR_PENETRATION_LRIFLE 15

//Revolvers and high-caliber pistols
#define ARMOR_PENETRATION_REVOLVER	12
#define ARMOR_PENETRATION_HIGH_CALIBER_PISTOL 10
#define DAMAGE_MAGNUM 45

//Sniper rifles
#define ARMOR_PENETRATION_SNIPER 80
#define DAMAGE_ANTIM 70

//Shotguns
#define DAMAGE_SLUG 50
#define ARMOR_PENETRATION_SLUG 12
#define DAMAGE_BEANBAG 10
#define AGONY_BEANBAG 60
#define ARMOR_PENETRATION_BEANBAG 0

//Low-caliber pistols and SMGs
/obj/item/projectile/bullet/pistol
	damage = DAMAGE_PISTOL
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL
	can_ricochet = TRUE

/obj/item/projectile/bullet/pistol/hv
	damage = DAMAGE_PISTOL * HIGH_VELOCITY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * HIGH_VELOCITY_MULTIPLIER
	penetrating = 1
	step_delay = HIGH_VELOCITY_STEP_DELAY

/obj/item/projectile/bullet/pistol/practice
	name = "practice bullet"
	damage = DAMAGE_PISTOL * PRACTICE_DAMAGE_MULTIPLIER
	agony = DAMAGE_PISTOL * PRACTICE_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * PRACTICE_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/pistol/rubber
	name = "rubber bullet"
	damage = DAMAGE_PISTOL * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_PISTOL * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE

//Carbines and rifles
/obj/item/projectile/bullet/srifle
	damage = DAMAGE_SRIFLE
	armor_penetration = ARMOR_PENETRATION_SRIFLE
	penetrating = 2
	can_ricochet = TRUE

/obj/item/projectile/bullet/srifle/nomuzzle
	muzzle_type = null

/obj/item/projectile/bullet/srifle/practice
	name = "practice bullet"
	damage = DAMAGE_SRIFLE * PRACTICE_DAMAGE_MULTIPLIER
	agony = DAMAGE_SRIFLE * PRACTICE_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_SRIFLE * PRACTICE_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/clrifle
	damage = DAMAGE_CLRIFLE
	armor_penetration = ARMOR_PENETRATION_SRIFLE
	penetrating = 1
	sharp = FALSE
	can_ricochet = TRUE

/obj/item/projectile/bullet/clrifle/rubber
	name = "rubber bullet"
	damage = DAMAGE_CLRIFLE * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_CLRIFLE * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_SRIFLE * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/lrile
	damage = DAMAGE_LRIFLE
	armor_penetration = ARMOR_PENETRATION_LRIFLE
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/lrifle/hv
	damage = DAMAGE_LRIFLE * HIGH_VELOCITY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LRIFLE * HIGH_VELOCITY_MULTIPLIER
	penetrating = 2
	step_delay = HIGH_VELOCITY_STEP_DELAY

//Revolvers and high-caliber pistols
/obj/item/projectile/bullet/magnum
	damage = DAMAGE_MAGNUM
	armor_penetration = ARMOR_PENETRATION_HIGH_CALIBER_PISTOL
	can_ricochet = TRUE

/obj/item/projectile/bullet/magnum/hv
	damage = DAMAGE_MAGNUM * HIGH_VELOCITY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_REVOLVER * HIGH_VELOCITY_MULTIPLIER
	penetrating = 1
	step_delay = HIGH_VELOCITY_STEP_DELAY

/obj/item/projectile/bullet/magnum/rubber
	name = "rubber bullet"
	damage = DAMAGE_MAGNUM * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_MAGNUM * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_HIGH_CALIBER_PISTOL * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE


//Sniper rifles
/obj/item/projectile/bullet/antim
	damage = DAMAGE_ANTIM
	armor_penetration = ARMOR_PENETRATION_SNIPER
	stun = 3
	weaken = 3
	penetrating = 5
	hitscan = TRUE //so the PTR isn't useless as a sniper weapon

//Shotguns
/obj/item/projectile/bullet/shotgun
	name = "slug"
	icon_state = "slug"
	damage = DAMAGE_SLUG
	armor_penetration = ARMOR_PENETRATION_SLUG
	knockback = 1

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	icon_state = "buckshot"
	check_armour = ARMOR_MELEE
	damage = DAMAGE_BEANBAG
	agony = AGONY_BEANBAG
	armor_penetration = ARMOR_PENETRATION_BEANBAG
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/shotgun/practice
	name = "practice slug"
	damage = DAMAGE_SLUG * PRACTICE_DAMAGE_MULTIPLIER
	agony = DAMAGE_SLUG * PRACTICE_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_SLUG * PRACTICE_PENETRATION_MULTIPLIER
	embed = FALSE
	knockback = 0

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	icon_state = "birdshot-1"
	damage = 12
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

#undef HIGH_VELOCITY_MULTIPLIER
#undef RUBBER_DAMAGE_MULTIPLIER
#undef RUBBER_AGONY_MULTIPLIER
#undef RUBBER_PENETRATION_MULTIPLIER
#undef PRACTICE_DAMAGE_MULTIPLIER
#undef PRACTICE_AGONY_MULTIPLIER
#undef PRACTICE_PENETRATION_MULTIPLIER
#undef HIGH_VELOCITY_STEP_DELAY
#undef ARMOR_PENETRATION_LOW_CALIBER_PISTOL
#undef DAMAGE_30A
#undef DAMAGE_35A
#undef DAMAGE_10X24
#undef ARMOR_PENETRATION_10X24
#undef DAMAGE_20R
#undef ARMOR_PENETRATION_20R
#undef DAMAGE_225R
#undef ARMOR_PENETRATION_225R
#undef DAMAGE_25R
#undef ARMOR_PENETRATION_25R
#undef ARMOR_PENETRATION_REVOLVER
#undef DAMAGE_375SPL
#undef ARMOR_PENETRATION_HIGH_CALIBER_PISTOL
#undef DAMAGE_40M
#undef ARMOR_PENETRATION_SNIPER
#undef DAMAGE_50AM
#undef DAMAGE_SLUG
#undef ARMOR_PENETRATION_SLUG
#undef DAMAGE_BEANBAG
#undef AGONY_BEANBAG
#undef ARMOR_PENETRATION_BEANBAG
