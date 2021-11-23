/obj/item/projectile/plasma
	name = "plasma bolt"
	icon_state = "plasma_bolt"
	mob_hit_sound = list('sound/effects/gore/sear.ogg')
	hitsound_wall = 'sound/weapons/guns/misc/laser_searwall.ogg'
	armor_penetration = 25
	check_armour = ARMOR_ENERGY
	damage_types = list(BURN = 33)


	muzzle_type = /obj/effect/projectile/plasma/muzzle
	impact_type = /obj/effect/projectile/plasma/impact

/obj/item/projectile/plasma/light
	name = "light plasma bolt"
	armor_penetration = 0

/obj/item/projectile/plasma/heavy
	name = "heavy plasma bolt"
	armor_penetration = 50

/obj/item/projectile/plasma/stun
	name = "stun plasma bolt"
	taser_effect = 1
	agony = 30
	damage_types = list(HALLOSS = 30,BURN = 5)
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/projectile/plasma/check_penetrate(var/atom/A)
	if(istype(A, /obj/item/shield))
		var/obj/item/shield/S = A
		var/loss = min(round(armor_penetration * 2 / S.shield_integrity * 1.8), 1)
		for(var/i in damage_types)
			damage_types[i] *= loss

		A.visible_message(SPAN_WARNING("\The [src] is weakened by the \the [A]!"))
		playsound(A.loc, 'sound/weapons/shield/shielddissipate.ogg', 50, 1)
		return 1
	else if(istype(A, /obj/structure/barricade) || istype(A, /obj/structure/table) || istype(A, /obj/structure/low_wall))
		return 0

	return 1