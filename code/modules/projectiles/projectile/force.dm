/obj/item/projectile/forcebolt
	name = "force bolt"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "ice_1"
	damage_types = list(BRUTE = 20)
	check_armour = ARMOR_ENERGY
	recoil = 20 // Newton reference

/obj/item/projectile/forcebolt/strong
	name = "force bolt"

/obj/item/projectile/forcebolt/on_hit(atom/movable/target)
	if(istype(target))
		var/throwdir = get_dir(firer,target)
		target.throw_at(get_edge_target_turf(target, throwdir),10,10)
		return 1

/*
/obj/item/projectile/forcebolt/strong/on_hit(var/atom/target)

	// NONE OF THIS WORKS. DO NOT USE.
	var/throwdir = null

	for(var/mob/M in hearers(2, src))
		if(M.loc != src.loc)
			throwdir = get_dir(src,target)
			M.throw_at(get_edge_target_turf(M, throwdir),15,1)
	return ..()
*/

/obj/item/projectile/forcebolt/jet
	name = "jet"
	icon_state = "laser"
	mob_hit_sound = list('sound/effects/gore/sear.ogg')
	hitsound_wall = 'sound/weapons/guns/misc/laser_searwall.ogg'
	damage_types = list(BRUTE = 60)
	check_armour = ARMOR_ENERGY
	armor_divisor = ARMOR_PEN_MAX
	var/jet_range = 3 // Max range before it dissipates
	penetrating = 5
	can_ricochet = FALSE
	hitscan = TRUE
	invisibility = 101	//Works like beams
	style_damage = 101 // Shouldn't have gotten hit by an RPG

	muzzle_type = /obj/effect/projectile/xray/muzzle
	tracer_type = /obj/effect/projectile/xray/tracer
	impact_type = /obj/effect/projectile/xray/impact

/obj/item/projectile/forcebolt/jet/before_move()
	jet_range--
	damage_types[BRUTE] -= 10
	if(!jet_range)
		kill_count = 0
	..()

/obj/item/projectile/forcebolt/jet/on_hit(atom/movable/target)
	if(isliving(target))
		var/throwdir = get_dir(firer,target)
		target.throw_at(get_edge_target_turf(target, throwdir),4,2,firer)
	return TRUE
