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
#define DAMAGE_10MM 24
#define DAMAGE_9MM 22
#define DAMAGE_32 20
#define DAMAGE_45 26

//Carbines and rifles
#define DAMAGE_10X24 30
#define ARMOR_PENETRATION_10X24 10
#define DAMAGE_556 16
#define ARMOR_PENETRATION_556 25
#define DAMAGE_65 18
#define ARMOR_PENETRATION_65 15
#define DAMAGE_762 20
#define ARMOR_PENETRATION_762 15

//Revolvers and high-caliber pistols
#define ARMOR_PENETRATION_REVOLVER 12
#define DAMAGE_357 40
#define DAMAGE_38 30
#define ARMOR_PENETRATION_HIGH_CALIBER_PISTOL 10
#define DAMAGE_44 45
#define DAMAGE_50 50

//Sniper rifles
#define ARMOR_PENETRATION_SNIPER 80
#define DAMAGE_145 70

//Shotguns
#define DAMAGE_SLUG 50
#define ARMOR_PENETRATION_SLUG 12
#define DAMAGE_BEANBAG 10
#define AGONY_BEANBAG 60
#define ARMOR_PENETRATION_BEANBAG 0

//Low-caliber pistols and SMGs
/obj/item/projectile/bullet/c9mm
	damage = DAMAGE_9MM
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL
	can_ricochet = TRUE

/obj/item/projectile/bullet/c9mm/hv
	damage = DAMAGE_9MM * HIGH_VELOCITY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * HIGH_VELOCITY_MULTIPLIER
	penetrating = 1
	step_delay = HIGH_VELOCITY_STEP_DELAY

/obj/item/projectile/bullet/c9mm/practice
	name = "practice bullet"
	damage = DAMAGE_9MM * PRACTICE_DAMAGE_MULTIPLIER
	agony = DAMAGE_9MM * PRACTICE_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * PRACTICE_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/c9mm/rubber
	name = "rubber bullet"
	damage = DAMAGE_9MM * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_9MM * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/a10mm
	damage = DAMAGE_10MM
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL
	can_ricochet = TRUE

/obj/item/projectile/bullet/a10mm/rubber
	name = "rubber bullet"
	damage = DAMAGE_10MM * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_10MM * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/a10mm/hv
	damage = DAMAGE_10MM * HIGH_VELOCITY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * HIGH_VELOCITY_MULTIPLIER
	penetrating = 1
	step_delay = HIGH_VELOCITY_STEP_DELAY

/obj/item/projectile/bullet/cl32
	damage = DAMAGE_32
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL
	can_ricochet = TRUE

/obj/item/projectile/bullet/cl32/rubber
	name = "rubber bullet"
	damage = DAMAGE_32 * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_32 * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/c45
	damage = DAMAGE_45
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL
	can_ricochet = TRUE

/obj/item/projectile/bullet/c45/practice
	name = "practice bullet"
	damage = DAMAGE_45 * PRACTICE_DAMAGE_MULTIPLIER
	agony = DAMAGE_45 * PRACTICE_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * PRACTICE_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/c45/rubber
	name = "rubber bullet"
	damage = DAMAGE_45 * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_45 * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_LOW_CALIBER_PISTOL * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE

//Carbines and rifles
/obj/item/projectile/bullet/c10x24
	damage = DAMAGE_10X24
	armor_penetration = ARMOR_PENETRATION_10X24
	penetrating = 1
	sharp = FALSE
	can_ricochet = TRUE

/obj/item/projectile/bullet/a556
	damage = DAMAGE_556
	armor_penetration = ARMOR_PENETRATION_556
	penetrating = 2
	can_ricochet = TRUE

/obj/item/projectile/bullet/a556/nomuzzle
	muzzle_type = null

/obj/item/projectile/bullet/a556/practice
	name = "practice bullet"
	damage = DAMAGE_556 * PRACTICE_DAMAGE_MULTIPLIER
	agony = DAMAGE_556 * PRACTICE_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_556 * PRACTICE_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE
	can_ricochet = FALSE

/obj/item/projectile/bullet/c65
	damage = DAMAGE_65
	armor_penetration = ARMOR_PENETRATION_65
	penetrating = 1
	sharp = FALSE
	can_ricochet = TRUE

/obj/item/projectile/bullet/c65/rubber
	name = "rubber bullet"
	damage = DAMAGE_65 * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_65 * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_65 * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/a762
	damage = DAMAGE_762
	armor_penetration = ARMOR_PENETRATION_762
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/a762/hv
	damage = DAMAGE_762 * HIGH_VELOCITY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_762 * HIGH_VELOCITY_MULTIPLIER
	penetrating = 2
	step_delay = HIGH_VELOCITY_STEP_DELAY

//Revolvers and high-caliber pistols
/obj/item/projectile/bullet/a357
	damage = DAMAGE_357
	armor_penetration = ARMOR_PENETRATION_REVOLVER
	can_ricochet = TRUE

/obj/item/projectile/bullet/a357/hv
	damage = DAMAGE_357 * HIGH_VELOCITY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_REVOLVER * HIGH_VELOCITY_MULTIPLIER
	penetrating = 1
	step_delay = HIGH_VELOCITY_STEP_DELAY

/obj/item/projectile/bullet/c38
	damage = DAMAGE_38
	armor_penetration = ARMOR_PENETRATION_REVOLVER
	can_ricochet = TRUE

/obj/item/projectile/bullet/c38/rubber
	name = "rubber bullet"
	damage = DAMAGE_38 * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_38 * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_REVOLVER * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/cl44
	damage = DAMAGE_44
	armor_penetration = ARMOR_PENETRATION_HIGH_CALIBER_PISTOL
	can_ricochet = TRUE

/obj/item/projectile/bullet/cl44/rubber
	name = "rubber bullet"
	damage = DAMAGE_44 * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_44 * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_HIGH_CALIBER_PISTOL * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/a50
	damage = DAMAGE_50
	armor_penetration = ARMOR_PENETRATION_HIGH_CALIBER_PISTOL * RUBBER_PENETRATION_MULTIPLIER
	can_ricochet = TRUE

/obj/item/projectile/bullet/a50/rubber
	name = "rubber bullet"
	damage = DAMAGE_50 * RUBBER_DAMAGE_MULTIPLIER
	agony = DAMAGE_50 * RUBBER_AGONY_MULTIPLIER
	armor_penetration = ARMOR_PENETRATION_HIGH_CALIBER_PISTOL * RUBBER_PENETRATION_MULTIPLIER
	embed = FALSE
	sharp = FALSE

//Sniper rifles
/obj/item/projectile/bullet/a145
	damage = DAMAGE_145
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

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	icon_state = "birdshot-1"
	damage = 12
	pellets = 6
	range_step = 1
	spread_step = 10

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
#undef DAMAGE_10MM
#undef DAMAGE_9MM
#undef DAMAGE_32
#undef DAMAGE_45
#undef DAMAGE_10X24
#undef ARMOR_PENETRATION_10X24
#undef DAMAGE_556
#undef ARMOR_PENETRATION_556
#undef DAMAGE_65
#undef ARMOR_PENETRATION_65
#undef DAMAGE_762
#undef ARMOR_PENETRATION_762
#undef ARMOR_PENETRATION_REVOLVER
#undef DAMAGE_357
#undef DAMAGE_38
#undef ARMOR_PENETRATION_HIGH_CALIBER_PISTOL
#undef DAMAGE_44
#undef DAMAGE_50
#undef ARMOR_PENETRATION_SNIPER
#undef DAMAGE_145
#undef DAMAGE_SLUG
#undef ARMOR_PENETRATION_SLUG
#undef DAMAGE_BEANBAG
#undef AGONY_BEANBAG
#undef ARMOR_PENETRATION_BEANBAG
