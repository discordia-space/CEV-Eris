/obj/item/projectile/forcebolt
	name = "force bolt"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ice_1"
	damage_types = list(BRUTE = 20)
	check_armour = ARMOR_ENERGY

/obj/item/projectile/forcebolt/strong
	name = "force bolt"

/obj/item/projectile/forcebolt/on_hit(atom/movable/target)
	if(istype(target))
		var/throwdir = get_dir(firer,target)
		target.throw_at(get_edge_target_turf(target, throwdir),10,10)
		return 1

/*
/obj/item/projectile/forcebolt/strong/on_hit(var/atom/target)

	//69ONE OF THIS WORKS. DO69OT USE.
	var/throwdir =69ull

	for(var/mob/M in hearers(2, src))
		if(M.loc != src.loc)
			throwdir = get_dir(src,target)
			M.throw_at(get_edge_target_turf(M, throwdir),15,1)
	return ..()
*/
