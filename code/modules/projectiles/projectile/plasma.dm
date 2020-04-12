/obj/item/projectile/plasma
	name = "plasma bolt"
	icon_state = "plasma_bolt"
	mob_hit_sound = list('sound/effects/gore/sear.ogg')
	hitsound_wall = 'sound/weapons/guns/misc/laser_searwall.ogg'
	damage = 33
	armor_penetration = 25
	damage_type = BURN
	check_armour = ARMOR_ENERGY

	muzzle_type = /obj/effect/projectile/plasma/muzzle
	impact_type = /obj/effect/projectile/plasma/impact

/obj/item/projectile/plasma/light
	name = "light plasma bolt"
	damage = 33
	armor_penetration = 0

/obj/item/projectile/plasma/heavy
	name = "heavy plasma bolt"
	damage = 33
	armor_penetration = 50