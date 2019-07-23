//Hivemind special objects stored here, like projectiles, wreckages or artifacts


//toxic shot, turret's ability use it
/obj/item/projectile/goo
	name = "acrid goo"
	icon = 'icons/obj/hivemind.dmi'
	icon_state = "goo_proj"
	damage = 15
	damage_type = BURN
	check_armour = ARMOR_BIO
	step_delay = 2


/obj/item/projectile/goo/on_hit(atom/target)
	. = ..()
	if( isliving(target) && !issilicon(target) )
		var/mob/living/L = target
		L.damage_through_armor(10, TOX, attack_flag = ARMOR_RAD)
	if(!(locate(/obj/effect/decal/cleanable/spiderling_remains) in target.loc))
		var/obj/effect/decal/cleanable/spiderling_remains/goo = new /obj/effect/decal/cleanable/spiderling_remains(target.loc)
		goo.name = "acrid goo"
		goo.desc = "An unknown, bubbling liquid. The fumes smell awful."
