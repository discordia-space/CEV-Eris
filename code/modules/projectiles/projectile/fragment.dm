/obj/item/projectile/bullet/pellet/fragment
	damage = 10
	range_step = 2
	armor_penetration = 15

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	silenced = 1 //embedding messages are still produced so it's kind of weird when enabled.
	no_attack_log = 1
	muzzle_type = null

/obj/item/projectile/bullet/pellet/fragment/strong
	damage = 15
	armor_penetration = 25

/obj/item/projectile/bullet/pellet/fragment/weak
	damage = 5
	armor_penetration = 10

/obj/item/projectile/bullet/pellet/fragment/invisible
	name = "explosion"
	icon_state = "invisible"
	embed = 0
	damage = 20
	armor_penetration = 30
	check_armour = ARMOR_BOMB