/obj/item/projectile/bullet/pellet/fragment
	damage_types = list(BRUTE = 15) // Blocked by heavy armor
	range_step = 2

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	silenced = TRUE //embedding messages are still produced so it's kind of weird when enabled.
	no_attack_log = 1
	muzzle_type = null

	can_ricochet = TRUE
	ricochet_ability = 10

/obj/item/projectile/bullet/pellet/fragment/strong
	damage_types = list(BRUTE = 20)

/obj/item/projectile/bullet/pellet/fragment/weak
	damage_types = list(BRUTE = 10) // Blocked by most armor

/obj/item/projectile/bullet/pellet/fragment/rubber
	icon_state = "rubber"
	name = "stinger"
	damage_types = list(BRUTE = 8, HALLOSS = 12)
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/pellet/fragment/rubber/weak
	icon_state = "rubber"
	name = "stinger"
	damage_types = list(BRUTE = 8, HALLOSS = 10)
	embed = FALSE
	sharp = FALSE

/obj/item/projectile/bullet/pellet/fragment/invisible
	name = "explosion"
	icon_state = "invisible"
	embed = 0
	damage_types = list(BRUTE = 30)
	check_armour = ARMOR_BOMB
