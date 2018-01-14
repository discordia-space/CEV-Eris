/obj/item/projectile/bullet/pellet/fragment
	damage = 10
	range_step = 2

	base_spread = 0 //causes it to be treated as a shrapnel explosion instead of cone
	spread_step = 20

	silenced = 1 //embedding messages are still produced so it's kind of weird when enabled.
	no_attack_log = 1
	muzzle_type = null

/obj/item/projectile/bullet/pellet/fragment/strong
	damage = 15

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

	if(explosion_size)
		on_explosion(O)

	if(num_fragments)
		var/list/target_turfs = getcircle(O, spread_range)
		var/fragments_per_projectile = round(num_fragments/target_turfs.len)
		for(var/turf/T in target_turfs)
			sleep(0)
			var/obj/item/projectile/bullet/pellet/fragment/P = new fragment_type(O)

			P.damage = fragment_damage
			P.pellets = fragments_per_projectile
			P.range_step = damage_step
			P.shot_from = src.name

			P.launch(T)

			//Make sure to hit any mobs in the source turf
			for(var/mob/living/M in O)
				//lying on a frag grenade while the grenade is on the ground causes you to absorb most of the shrapnel.
				//you will most likely be dead, but others nearby will be spared the fragments that hit you instead.
				if(M.lying && isturf(src.loc))
					P.attack_mob(M, 0, 0)
				else
					P.attack_mob(M, 0, 100) //otherwise, allow a decent amount of fragments to pass

	qdel(src)

/obj/item/weapon/grenade/frag/proc/on_explosion(var/turf/O)
	if(explosion_size)
		explosion(O, round(explosion_size/2), explosion_size, explosion_size*2)

/obj/item/weapon/grenade/frag/explosive
	name = "FS HEG \"Zoe\""
	desc = "A military High Explosive grenade, designed wreak havoc in certan radius."
	icon_state = "explosive"

	explosion_size = 2
	num_fragments = 0
