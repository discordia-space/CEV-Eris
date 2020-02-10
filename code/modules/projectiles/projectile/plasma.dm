/obj/item/projectile/plasma
	name = "plasma bolt"
	icon_state = "plasma_bolt"
	mob_hit_sound = list('sound/effects/gore/sear.ogg')
	hitsound_wall = 'sound/weapons/guns/misc/laser_searwall.ogg'
	damage = 30
	armor_penetration = 10
	damage_type = BURN

	muzzle_type = /obj/effect/projectile/muzzle/plasma_cutter
	impact_type = /obj/effect/projectile/impact/plasma_cutter

/obj/item/projectile/plasma/light
	name = "light plasma bolt"
	damage = 20

/obj/item/projectile/plasma/heavy
	name = "heavy plasma bolt"
	damage = 40