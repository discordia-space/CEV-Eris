/obj/item/weapon/grenade/frag
	name = "NT DFG \"Pomme\""
	desc = "A military-grade defensive fragmentation grenade, designed to be thrown from cover."
	icon_state = "frag"
	item_state = "frggrenade"
	loadable = TRUE

	var/fragment_type = /obj/item/projectile/bullet/pellet/fragment/strong
	var/num_fragments = 150  //total number of fragments produced by the grenade
	var/fragment_damage = 5
	var/damage_step = 2      //projectiles lose a fragment each time they travel this distance. Can be a non-integer.

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

	var/devastation_range = -1
	var/heavy_range = -1
	var/weak_range = 1
	var/flash_range = -1

/obj/item/weapon/grenade/frag/prime()
	set waitfor = 0
	..()

	var/turf/O = get_turf(src)
	if(!O) return

	on_explosion(O)

	if(num_fragments)
		var/lying = FALSE
		if(isturf(src.loc))
			for(var/mob/living/M in O)
				//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
				//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
				if(M.lying)
					lying = TRUE

		if(!lying)
			fragment_explosion(O, spread_range, fragment_type, num_fragments, fragment_damage, damage_step)
		else
			fragment_explosion(O, 0, fragment_type, num_fragments, fragment_damage, damage_step)

	qdel(src)

/obj/item/weapon/grenade/frag/proc/on_explosion(var/turf/O)
	explosion(O, devastation_range, heavy_range, weak_range, flash_range)

/obj/item/weapon/grenade/frag/explosive
	name = "NT OBG \"Cracker\""
	desc = "A military-grade offensive blast grenade, designed to be thrown by assaulting troops."
	icon_state = "explosive"

	fragment_type = /obj/item/projectile/bullet/pellet/fragment/invisible
	spread_range = 4
	num_fragments = 4
	fragment_damage = 30
	damage_step = 20

	devastation_range = -1
	heavy_range = 1
	weak_range = 4
	flash_range = 10