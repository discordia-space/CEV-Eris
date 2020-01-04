/obj/item/projectile/plasma
	name = "plasma bolt"
	icon_state = "plasma_bolt"
	mob_hit_sound = list('sound/effects/gore/sear.ogg')
	hitsound_wall = 'sound/weapons/guns/misc/laser_searwall.ogg'
	damage = 30
	armor_penetration = 10
	damage_type = BURN

	muzzle_type = /obj/effect/projectile/plasma/muzzle
	impact_type = /obj/effect/projectile/plasma/impact

/obj/item/projectile/plasma/light
	name = "light plasma bolt"
	icon_state = "plasma_bolt_pink"

	muzzle_type = /obj/effect/projectile/plasma/muzzle/light
	impact_type = /obj/effect/projectile/plasma/impact/light
	damage = 20

/obj/item/projectile/plasma/heavy
	name = "heavy plasma bolt"
	icon_state = "plasma_bolt_blue"

	muzzle_type = /obj/effect/projectile/plasma/muzzle/heavy
	impact_type = /obj/effect/projectile/plasma/impact/heavy
	damage = 40