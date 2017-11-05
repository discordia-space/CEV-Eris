/obj/item/projectile/bullet/c9mm
	damage = 18
	sharp = 0

/obj/item/projectile/bullet/c9mmr
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
	damage = 35

/obj/item/projectile/bullet/cl32r
	damage = 20
	sharp = 0

/obj/item/projectile/bullet/cl32
	damage = 6
	agony = 30
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/a357
	damage = 60

/obj/item/projectile/bullet/c38
	damage = 40

/obj/item/projectile/bullet/c38r
	damage = 8
	agony = 40
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/cl44
	damage = 51

/obj/item/projectile/bullet/cl44r
	damage = 10
	agony = 80
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/c45
	damage = 55

/obj/item/projectile/bullet/c45p
	damage = 7
	agony = 7
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/c45r
	damage = 10
	agony = 85
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/a50
	damage = 65

/obj/item/projectile/bullet/a50r
	damage = 10
	agony = 85
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/a762
	damage = 25
	armor_penetration = 20
	penetrating = 1

/obj/item/projectile/bullet/a556
	damage = 35
	armor_penetration = 20
	penetrating = 1

/obj/item/projectile/bullet/a556p
	damage = 10
	agony = 10
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/c65
	damage = 24
	armor_penetration = 20
	penetrating = 1
	sharp = 0

/obj/item/projectile/bullet/c65r
	damage = 8
	agony = 24
	embed = 0
	sharp = 0

/obj/item/projectile/bullet/a145
	damage = 80
	stun = 3
	weaken = 3
	penetrating = 5
	armor_penetration = 80
	hitscan = 1 //so the PTR isn't useless as a sniper weapon

/* Shotguns */

/obj/item/projectile/bullet/shotgun
	name = "slug"
	damage = 50
	armor_penetration = 15

/obj/item/projectile/bullet/shotgun/beanbag		//because beanbags are not bullets
	name = "beanbag"
	check_armour = "melee"
	damage = 15
	agony = 60
	embed = 0
	sharp = 0

//Should do about 80 damage at 1 tile distance (adjacent), and 50 damage at 3 tiles distance.
//Overall less damage than slugs in exchange for more damage at very close range and more embedding
/obj/item/projectile/bullet/pellet/shotgun
	name = "shrapnel"
	damage = 13
	pellets = 6
	range_step = 1
	spread_step = 10

/obj/item/projectile/bullet/shotgun/practice
	name = "practice"
	damage = 5

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
