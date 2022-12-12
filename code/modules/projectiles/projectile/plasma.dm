/obj/item/projectile/plasma
	name = "plasma bolt"
	icon_state = "plasma_bolt"
	mob_hit_sound = list('sound/effects/gore/sear.ogg')
	hitsound_wall = 'sound/weapons/guns/misc/laser_searwall.ogg'
	armor_divisor = 2
	check_armour = ARMOR_ENERGY
	damage_types = list(BURN = 27)
	recoil = 4 // .20 level

	muzzle_type = /obj/effect/projectile/plasma/muzzle
	impact_type = /obj/effect/projectile/plasma/impact

/obj/item/projectile/plasma/light
	name = "light plasma bolt"
	armor_divisor = 2
	damage_types = list(BURN = 23)
	recoil = 2

/obj/item/projectile/plasma/heavy
	name = "heavy plasma bolt"
	armor_divisor = 2
	damage_types = list(BURN = 34)
	recoil = 6

/obj/item/projectile/plasma/stun
	name = "stun plasma bolt"
	taser_effect = 1
	damage_types = list(HALLOSS = 30, BURN = 5)
	impact_type = /obj/effect/projectile/stun/impact

/obj/item/projectile/plasma/stun/heavy
	damage_types = list(HALLOSS = 30, BURN = 42)
	recoil = 6

/obj/item/projectile/plasma/aoe
	name = "default plasma aoe"
	icon_state = "ion"
	armor_divisor = 1
	damage_types = list(BURN = 0)

	var/aoe_strong = 0
	var/aoe_weak = 0 // Should be greater or equal to strong
	var/heat_damage = 0 // FALSE or 0 to disable
	var/emp_strength = 0 // Divides the effects by this amount, FALSE or 0 to disable

	var/fire_stacks = FALSE

/obj/item/projectile/plasma/aoe/on_hit(atom/target)
	if(emp_strength)
		empulse(target, aoe_strong, aoe_weak, strength=emp_strength)
	if(heat_damage)
		heatwave(target, aoe_strong, aoe_weak, heat_damage, fire_stacks, armor_divisor)
	..()

/obj/item/projectile/plasma/aoe/ion
	name = "ion-plasma bolt"
	icon_state = "ion"
	armor_divisor = 1
	damage_types = list(BURN = 23)
	recoil = 8

	aoe_strong = 1
	aoe_weak = 1
	heat_damage = 20
	emp_strength = 2

	fire_stacks = FALSE

/obj/item/projectile/plasma/aoe/ion/light
	name = "light ion-plasma bolt"
	armor_divisor = 1
	damage_types = list(BURN = 19)
	recoil = 6

	aoe_strong = 0
	aoe_weak = 1
	heat_damage = 20
	emp_strength = 3

	fire_stacks = FALSE

/obj/item/projectile/plasma/aoe/heat
	name = "high-temperature plasma blast"
	armor_divisor = 3
	damage_types = list(BURN = 19)
	recoil = 12

	aoe_strong = 1
	aoe_weak = 1
	heat_damage = 20
	emp_strength = 0

	fire_stacks = TRUE

/obj/item/projectile/plasma/aoe/heat/strong
	name = "high-temperature plasma blast"
	armor_divisor = 2
	damage_types = list(BURN = 27)
	recoil = 18

	aoe_strong = 1
	aoe_weak = 2
	heat_damage = 30
	emp_strength = 0

	fire_stacks = TRUE

/obj/item/projectile/plasma/check_penetrate(var/atom/A)
	if(istype(A, /obj/item/shield))
		var/obj/item/shield/S = A
		var/loss = round(S.shield_integrity / armor_divisor / 8)
		block_damage(loss, A)

		A.visible_message(SPAN_WARNING("\The [src] is weakened by the \the [A]!"))
		playsound(A.loc, 'sound/weapons/shield/shielddissipate.ogg', 50, 1)
		return 1
	else if(istype(A, /obj/structure/barricade) || istype(A, /obj/structure/table) || istype(A, /obj/structure/low_wall))
		return 0

	return 1
