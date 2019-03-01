//Hivemind special objects stored here, like projectiles, wreckages or artifacts


//toxic shot, turret's ability use it
/obj/item/projectile/goo
	name = "toxic goo"
	icon = 'icons/obj/hivemind.dmi'
	icon_state = "goo_proj"
	damage = 15
	damage_type = BURN
	check_armour = "energy"
	step_delay = 2


/obj/item/projectile/goo/on_hit(atom/target, var/blocked = 0)
	. = ..()
	if(isliving(target) && !issilicon(target) && !blocked)
		var/mob/living/L = target
		L.apply_damage(10, TOX)
	if(!(locate(/obj/effect/decal/cleanable/spiderling_remains) in target.loc))
		var/obj/effect/decal/cleanable/spiderling_remains/goo = new /obj/effect/decal/cleanable/spiderling_remains(target.loc)
		goo.name = "green goo"
		goo.desc = "An unidentifiable liquid. It smells awful."