//Hivemind special objects stored here, like projectiles, wreckages or artifacts


//toxic shot, turret's ability use it
/obj/item/projectile/goo
	name = "toxic goo"
	icon = 'icons/obj/hivemind.dmi'
	icon_state = "goo_proj"
	damage = 10
	damage_type = TOX
	check_armour = "bullet"
	step_delay = 2

	on_hit(var/atom/target, var/blocked = 0)
		..()
		if(!(locate(/obj/effect/decal/cleanable/spiderling_remains) in target.loc))
			var/obj/effect/decal/cleanable/spiderling_remains/goo = new /obj/effect/decal/cleanable/spiderling_remains(target.loc)
			goo.name = "green goo"
			goo.desc = "Phe-e-e-ew..."