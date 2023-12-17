/obj/item/projectile/bullet/pellet/fragment
	damage_types = list(
		ARMOR_BULLET = list(
			DELEM(BRUTE,15)
		)
	)
	range_step = 2

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	silenced = TRUE //embedding messages are still produced so it's kind of weird when enabled.
	no_attack_log = 1
	muzzle_type = null

	can_ricochet = TRUE
	ricochet_ability = 10

/obj/item/projectile/bullet/pellet/fragment/strong
	damage_types = list(
		ARMOR_BULLET = list(
			DELEM(BRUTE,25)
		)
	)

/obj/item/projectile/bullet/pellet/fragment/weak
	damage_types = list(
		ARMOR_BULLET = list(
			DELEM(BRUTE,10)
		)
	)

/obj/item/projectile/bullet/pellet/fragment/rubber
	icon_state = "rubber"
	name = "stinger"
	damage_types = list(
		ARMOR_BULLET = list(
			DELEM(BRUTE,8),
			DELEM(HALLOSS, 15)
		)
	)
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/pellet/fragment/rubber/weak
	icon_state = "rubber"
	name = "stinger"
	damage_types = list(
		ARMOR_BULLET = list(
			DELEM(BRUTE,4),
			DELEM(HALLOSS, 10)
			)
	)
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/pellet/fragment/invisible
	name = "explosion"
	icon_state = "invisible"
	embed = 0
	damage_types = list(
		ARMOR_BULLET = list(
			DELEM(BRUTE,30)
		)
	)

/obj/item/projectile/bullet/pellet/fragment/ember
	name = "phosphorous ember"
	icon = 'icons/obj/projectiles_64x64.dmi'
	icon_state = "phosphorus_ember"
	damage_types = list(
		ARMOR_CHEM = list(
			DELEM(BURN , 10)
		),
		ARMOR_ENERGY = list(
			DELEM(BURN , 10)
		)
	)
	embed = 0
	pellets = 1
	range_step = 5
	can_ricochet = FALSE

/obj/item/projectile/bullet/pellet/fragment/ember/on_hit(atom/target)
	var/datum/effect/effect/system/smoke_spread/white_phosphorous/S = new /datum/effect/effect/system/smoke_spread/white_phosphorous
	S.set_up(1, 0, get_turf(src))
	S.start()
	return TRUE
