/obj/item/projectile/bullet/pellet/fragment
	damage_types = list(BRUTE = 10)
	range_step = 2

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	silenced = TRUE //embedding messages are still produced so it's kind of weird when enabled.
	no_attack_log = 1
	muzzle_type = null

	can_ricochet = TRUE
	ricochet_ability = 10

/obj/item/projectile/bullet/pellet/fragment/strong
	damage_types = list(BRUTE = 15)

/obj/item/projectile/bullet/pellet/fragment/weak
	damage_types = list(BRUTE = 5)

/obj/item/projectile/bullet/pellet/fragment/rubber
	icon_state = "rubber"
	name = "stinger"
	damage_types = list(BRUTE = 5, HALLOSS = 25)
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/pellet/fragment/rubber/weak
	icon_state = "rubber"
	name = "stinger"
	damage_types = list(BRUTE = 3, HALLOSS = 20)
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/pellet/fragment/invisible
	name = "explosion"
	icon_state = "invisible"
	embed = 0
	damage_types = list(BRUTE = 20)
	check_armour = ARMOR_BOMB
