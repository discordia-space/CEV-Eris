/obj/item/weapon/grenade/frag
	name = "FS FG \"Cobb\""
	desc = "A fragmentation grenade, optimized for harming personnel without causing massive structural damage."
	icon_state = "frag"
	item_state = "frggrenade"
	loadable = TRUE

	var/fragment_type = /obj/item/projectile/bullet/pellet/fragment/strong
	var/num_fragments = 250  //total number of fragments produced by the grenade
	var/fragment_damage = 10
	var/damage_step = 2      //projectiles lose a fragment each time they travel this distance. Can be a non-integer.
	var/explosion_size = 0   //size of the center explosion

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

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
	if(explosion_size)
		explosion(O, round(explosion_size/2), explosion_size, explosion_size*2)
	else
		explosion(O, -1, -1, 1, 10)

/obj/item/weapon/grenade/frag/explosive
	name = "FS HEG \"Zoe\""
	desc = "A military High Explosive grenade, designed wreak havoc in certan radius."
	icon_state = "explosive"

	explosion_size = 2
	num_fragments = 0
