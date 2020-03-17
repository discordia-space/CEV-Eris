/obj/item/projectile/bullet/batonround
	name = "baton round"
	icon_state = "slug"                           //PLACEHOLDER
	damage = 10
	agony = 80                                   //Work more on number. Check armor?
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
/obj/item/projectile/bullet/grenade
	name = "grenade shell"
	icon_state "slug"
	damage = 20
	armor_penetration = 0
	embed = FALSE
	sharp = FALSE
	check_armour = ARMOR_BULLET
obj/item/projectile/bullet/grenade/on_hit(atom/target)
	grenade_effect(target)
/obj/item/projectile/bullet/grenade/blast

