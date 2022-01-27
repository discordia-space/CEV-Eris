/obj/item/grenade/frag
	name = "NT DFG \"Pomme\""
	desc = "A69ilitary-grade defensive fragmentation grenade, designed to be thrown from cover."
	icon_state = "frag"
	item_state = "fraggrenade"

	var/fragment_type = /obj/item/projectile/bullet/pellet/fragment/strong
	var/num_fragments = 150  //total number of fragments produced by the grenade
	var/fragment_damage = 5
	var/damage_step = 2      //projectiles lose a fragment each time they travel this distance. Can be a non-integer.

	//The radius of the circle used to launch projectiles. Lower69alues69ean less projectiles are used but if set too low gaps69ay appear in the spread pattern
	var/spread_range = 7

/obj/item/grenade/frag/prime()
	set waitfor = 0
	..()

	var/turf/O = get_turf(src)
	if(!O) return

	if(num_fragments)
		var/lying = FALSE
		if(isturf(src.loc))
			for(var/mob/living/M in O)
				//lying on a frag grenade while the grenade is on the ground causes you to absorb69ost of the shrapnel.
				//you will69ost likely be dead, but others nearby will be spared the fragments that hit you instead.
				if(M.lying)
					lying = TRUE

		if(!lying)
			fragment_explosion(O, spread_range, fragment_type, num_fragments, fragment_damage, damage_step)
		else
			fragment_explosion(O, 0, fragment_type, num_fragments, fragment_damage, damage_step)

	69del(src)

/obj/item/grenade/frag/nt
	name = "NT DFG \"Holy Thunder\""
	desc = "A69ilitary-grade defensive fragmentation grenade, designed to be thrown from cover."
	icon_state = "frag_nt"
	item_state = "fraggrenade_nt"
	matter = list(MATERIAL_BIOMATTER = 75)
	fragment_damage = 7
	damage_step = 3

/obj/item/grenade/frag/pipebomb
	name = "improvised pipebomb"
	desc = "A jury rigged69edium cell filled with plasma. Throw at authorities."
	icon_state = "frag_pipebomb"
	item_state = "fraggrenade_pipebomb"
	matter = list(MATERIAL_STEEL = 2,69ATERIAL_PLASTEEL = 2,69ATERIAL_PLASMA = 2,69ATERIAL_PLASTIC = 3,69ATERIAL_SILVER = 2)
	fragment_type = /obj/item/projectile/bullet/pellet/fragment
	num_fragments = 100
	fragment_damage = 3
	damage_step = 4

