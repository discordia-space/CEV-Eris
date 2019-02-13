//Damage multipliers
#define HV_MULT 1.2 //high-velocity damage & armor_penetration multiplier
#define RD_MULT 0.2 //rubber damage multiplier
#define RA_MULT 1.5 //rubber agony multiplier
#define PT_MULT 0.1 //practice damage & agony multiplier
//Low-caliber pistols and SMGs
#define DAMAGE_9mm 22
#define DAMAGE_10mm 24
#define DAMAGE_32 20
#define DAMAGE_45 26
//Carbines and rifles
#define DAMAGE_10x24 30
#define AP_10x24 10
#define DAMAGE_556 16
#define AP_556 25
#define DAMAGE_65 18
#define AP_65 20
#define DAMAGE_762 20
#define AP_762 15
//Revolvers and high-caliber pistols
#define DAMAGE_357 40
#define DAMAGE_38 35
#define DAMAGE_44 45
#define DAMAGE_50 50
//Sniper rifles
#define AP_SNIPER 80
#define DAMAGE_145 70
//Shotguns
#define DAMAGE_SLUG 50

//bullet-type parents
/obj/item/projectile/bullet/hv
	step_delay = 0.75

/obj/item/projectile/bullet/rubber
	name = "rubber bullet"
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/practice
	embed = FALSE
	sharp = FALSE

//Low-caliber pistols and SMGs
/obj/item/projectile/bullet/c9mm
	damage = DAMAGE_9mm
	can_ricochet = TRUE

/obj/item/projectile/bullet/hv/c9mm
	damage = DAMAGE_9mm * HV_MULT
	armor_penetration = 10
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/rubber/c9mm
	damage = DAMAGE_9mm * RD_MULT
	agony = DAMAGE_9mm * RA_MULT

/obj/item/projectile/bullet/practice/c9mm
	damage = DAMAGE_9mm * PT_MULT
	agony = DAMAGE_9mm * PT_MULT

/obj/item/projectile/bullet/a10mm
	damage = DAMAGE_10mm
	can_ricochet = TRUE

/obj/item/projectile/bullet/hv/a10mm
	damage = DAMAGE_10mm * HV_MULT
	armor_penetration = 10
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/cl32
	damage = DAMAGE_32
	can_ricochet = TRUE

/obj/item/projectile/bullet/rubber/cl32
	damage = DAMAGE_32 * RD_MULT
	agony = DAMAGE_32 * RA_MULT

/obj/item/projectile/bullet/c45
	damage = DAMAGE_45
	can_ricochet = TRUE

/obj/item/projectile/bullet/rubber/c45
	damage = DAMAGE_45 * RD_MULT
	agony = DAMAGE_45 * RA_MULT

/obj/item/projectile/bullet/practice/c45
	damage = DAMAGE_45 * PT_MULT
	agony = DAMAGE_45 * PT_MULT

//Carbines and rifles
/obj/item/projectile/bullet/c10x24
	damage = DAMAGE_10x24
	armor_penetration = AP_10x24
	penetrating = 1
	sharp = FALSE
	can_ricochet = TRUE

/obj/item/projectile/bullet/a556
	damage = DAMAGE_556
	armor_penetration = AP_556
	penetrating = 2
	can_ricochet = TRUE

/obj/item/projectile/bullet/practice/a556
	damage = DAMAGE_556 * PT_MULT
	agony = DAMAGE_556 * PT_MULT

/obj/item/projectile/bullet/c65
	damage = DAMAGE_65
	armor_penetration = AP_65
	penetrating = 1
	sharp = FALSE
	can_ricochet = TRUE

/obj/item/projectile/bullet/rubber/c65
	damage = DAMAGE_65 * RD_MULT
	agony = DAMAGE_65 * RA_MULT

/obj/item/projectile/bullet/a762
	damage = DAMAGE_762
	armor_penetration = AP_762
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/hv/a762
	damage = DAMAGE_762 * HV_MULT
	armor_penetration = AP_762 * HV_MULT
	penetrating = 2
	can_ricochet = TRUE

//Revolvers and high-caliber pistols
/obj/item/projectile/bullet/a357
	damage = DAMAGE_357
	can_ricochet = TRUE

/obj/item/projectile/bullet/hv/a357
	damage = DAMAGE_357 * HV_MULT
	armor_penetration = 10
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/c38
	damage = DAMAGE_38
	can_ricochet = TRUE

/obj/item/projectile/bullet/rubber/c38
	damage = DAMAGE_38 * RD_MULT
	agony = DAMAGE_38 * RA_MULT

/obj/item/projectile/bullet/cl44
	damage = DAMAGE_44
	can_ricochet = TRUE

/obj/item/projectile/bullet/rubber/cl44
	damage = DAMAGE_44 * RD_MULT
	agony = DAMAGE_44 * RA_MULT

/obj/item/projectile/bullet/a50
	damage = DAMAGE_50
	can_ricochet = TRUE

/obj/item/projectile/bullet/rubber/a50
	damage = DAMAGE_50 * RD_MULT
	agony = DAMAGE_50 * RA_MULT

//Sniper rifles
/obj/item/projectile/bullet/a145
	damage = DAMAGE_145
	armor_penetration = AP_SNIPER
	stun = 3
	weaken = 3
	penetrating = 5
	hitscan = TRUE //so the PTR isn't useless as a sniper weapon

//Shotguns
/obj/item/projectile/bullet/shotgun
	name = "slug"
	damage = DAMAGE_SLUG

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	check_armour = "melee"
	damage = 10
	agony = 60
	embed = FALSE
	sharp = FALSE

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	damage = 12
	pellets = 6
	range_step = 1
	spread_step = 10

/obj/item/projectile/bullet/shotgun/practice
	name = "practice"
	damage = DAMAGE_SLUG * PT_MULT
	embed = FALSE

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

#undef HV_MULT
#undef RD_MULT
#undef RA_MULT
#undef PT_MULT
#undef DAMAGE_9mm
#undef DAMAGE_10mm
#undef DAMAGE_32
#undef DAMAGE_45
#undef DAMAGE_10x24
#undef AP_10x24
#undef DAMAGE_556
#undef AP_556
#undef DAMAGE_65
#undef AP_65
#undef DAMAGE_762
#undef AP_762
#undef DAMAGE_357
#undef DAMAGE_38
#undef DAMAGE_44
#undef DAMAGE_50
#undef AP_SNIPER
#undef DAMAGE_145
#undef DAMAGE_SLUG