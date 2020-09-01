//Hivemind special objects stored here, like projectiles, wreckages or artifacts


//toxic shot, turret's ability use it
/obj/item/projectile/goo
	name = "electrolyzed goo"
	icon = 'icons/obj/hivemind.dmi'
	icon_state = "goo_proj"
	damage_types = list(BURN = 15)
	check_armour = ARMOR_ENERGY //Unlike Bio, it's not either 0% or 100%. Strong Energy armour isn't common, But most of armour has some protection against energy.
	step_delay = 2


/obj/item/projectile/goo/on_hit(atom/target)
	. = ..()
	if( isliving(target) && !issilicon(target) )
		var/mob/living/L = target
		L.damage_through_armor(15, TOX, attack_flag = ARMOR_RAD)
	if(!(locate(/obj/effect/decal/cleanable/spiderling_remains) in target.loc))
		var/obj/effect/decal/cleanable/spiderling_remains/goo = new /obj/effect/decal/cleanable/spiderling_remains(target.loc)
		goo.name = "electrolyzed goo" //from "acrid goo" to "acidic goo", and from "acidic goo" to "electrolyzed goo"
		goo.desc = "An unknown, bubbling liquid. The fumes smell awful with a hint of ozone."
