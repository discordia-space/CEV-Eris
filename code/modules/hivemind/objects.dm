//Hivemind special objects stored here, like projectiles, wreckages or artifacts


//toxic shot, turret's ability use it
/obj/item/projectile/goo
	name = "electrolyzed goo"
	icon = 'icons/obj/hivemind.dmi'
	icon_state = "goo_proj"
	damage_types = list(BURN = 15)
	check_armour = ARMOR_ENERGY
	step_delay = 2

/obj/item/projectile/goo/weak
	name = "weakened electrolyzed goo"
	damage_types = list(BURN = 5)


/obj/item/projectile/goo/on_hit(atom/target)
	. = ..()
	if( isliving(target) && !issilicon(target) )
		var/mob/living/L = target
		L.damage_through_armor(10, TOX, attack_flag = ARMOR_ENERGY)
	if(!(locate(/obj/effect/decal/cleanable/spiderling_remains) in target.loc))
		var/obj/effect/decal/cleanable/spiderling_remains/goo = new /obj/effect/decal/cleanable/spiderling_remains(target.loc)
		goo.name = "electrolyzed goo"
		goo.desc = "An unknown, bubbling liquid. The fumes smell awful with a hint of ozone."
