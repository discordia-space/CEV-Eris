//Hivemind special objects stored here, like projectiles, wreckages or artifacts


//toxic shot, turret's ability use it
/obj/item/projectile/goo
	name = "electrolyzed goo"
	icon = 'icons/obj/hivemind.dmi'
	icon_state = "goo_proj"
	damage_types = list(
		ARMOR_ENERGY = list(
			DELEM(BURN, 15),
			DELEM(TOX, 15)
		)
	)
	step_delay = 2

/obj/item/projectile/goo/weak
	name = "weakened electrolyzed goo"
	damage_types = list(
		ARMOR_ENERGY = list(
			DELEM(BURN, 5),
			DELEM(TOX, 10)
		)
	)


/obj/item/projectile/goo/on_hit(atom/target)
	. = ..()
	if(!(locate(/obj/effect/decal/cleanable/spiderling_remains) in target.loc))
		var/obj/effect/decal/cleanable/spiderling_remains/goo = new /obj/effect/decal/cleanable/spiderling_remains(target.loc)
		goo.name = "electrolyzed goo"
		goo.desc = "An unknown, bubbling liquid. The fumes smell awful with a hint of ozone."
