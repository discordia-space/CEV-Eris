#define HV_MULT 1.2
//Low damage pistols and smgs
#define damage_32 20
#define damage_9mm 22
#define damage_10mm 24
#define damage_45 26
//Carbines and rifles
#define damage_556 16
#define AP_556 25
#define damage_65 18
#define AP_65 20
#define damage_762 20
#define AP_762 15
//Revolvers and high-caliber pistols
#define damage_38 35
#define damage_357 40
#define damage_44 45
#define damage_50 50
//Other
#define damage_12g_slug 50
/obj/item/projectile/bullet/c9mm
	damage = damage_9mm
	can_ricochet = TRUE

/obj/item/projectile/bullet/c9mmh
	damage = HV_MULT*damage_9mm
	armor_penetration = 10
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/c9mmr
	name = "rubber bullet"
	damage = 4
	agony = 20
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/c9mmp
	damage = 5
	agony = 5
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/a10mm
	damage = damage_10mm
	can_ricochet = TRUE

/obj/item/projectile/bullet/a10mmh
	damage = HV_MULT*damage_10mm
	armor_penetration = 10
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/cl32
	damage = damage_32
	can_ricochet = TRUE

/obj/item/projectile/bullet/cl32r
	name = "rubber bullet"
	damage = 5
	agony = 30
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/a357
	damage = damage_357
	can_ricochet = TRUE

/obj/item/projectile/bullet/a357h
	damage = HV_MULT*damage_357
	armor_penetration = 10
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/c38
	damage = damage_38
	can_ricochet = TRUE

/obj/item/projectile/bullet/c38r
	name = "rubber bullet"
	damage = 6
	agony = 55
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/cl44
	damage = damage_44
	can_ricochet = TRUE

/obj/item/projectile/bullet/cl44r
	name = "rubber bullet"
	damage = 8
	agony = 65
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/c45
	damage = damage_45
	can_ricochet = TRUE

/obj/item/projectile/bullet/c45p
	damage = 7
	agony = 7
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/c45r
	name = "rubber bullet"
	damage = 5
	agony = 40
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/a50
	damage = damage_50
	can_ricochet = TRUE

/obj/item/projectile/bullet/a50r
	name = "rubber bullet"
	damage = 10
	agony = 75
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/a762
	damage = damage_762
	armor_penetration = AP_762
	penetrating = 1
	can_ricochet = TRUE

/obj/item/projectile/bullet/a762h
	damage = HV_MULT*damage_762
	armor_penetration = HV_MULT*AP_762
	penetrating = 2
	can_ricochet = TRUE

/obj/item/projectile/bullet/a556
	damage = damage_556
	armor_penetration = AP_556
	penetrating = 2
	can_ricochet = TRUE

/obj/item/projectile/bullet/a556p
	damage = 10
	agony = 10
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/c65
	damage = damage_65
	armor_penetration = AP_65
	penetrating = 1
	sharp = 0
	can_ricochet = TRUE

/obj/item/projectile/bullet/c65r
	name = "rubber bullet"
	damage = 5
	agony = 27
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/c10x24
	damage = 30
	armor_penetration = 10
	penetrating = 1
	sharp = 0
	can_ricochet = TRUE

/obj/item/projectile/bullet/a145
	damage = 70
	stun = 3
	weaken = 3
	penetrating = 5
	armor_penetration = 80
	hitscan = 1 //so the PTR isn't useless as a sniper weapon

/* Shotguns */

/obj/item/projectile/bullet/shotgun
	name = "slug"
	damage = damage_12g_slug

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	check_armour = "melee"
	damage = 10
	agony = 60
	embed = 0
	sharp = 0

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
	damage = 5
	embed = 0

/* Miscellaneous */

/obj/item/projectile/bullet/blank
	invisibility = 101
	damage = 1
	embed = 0

/obj/item/projectile/bullet/cap
	name = "cap"
	damage_type = HALLOSS
	damage = 0
	nodamage = 1
	embed = 0
	sharp = 0

#undef HV_MULT
#undef damage_32
#undef damage_9mm
#undef damage_10mm
#undef damage_45
#undef damage_556
#undef AP_556
#undef damage_65
#undef AP_65
#undef damage_762
#undef AP_762
#undef damage_38
#undef damage_357
#undef damage_44
#undef damage_50
#undef damage_12g_slug