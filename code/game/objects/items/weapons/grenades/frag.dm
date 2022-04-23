/obj/item/grenade/frag
	name = "NT DFG \"Pomme\""
	desc = "A military-grade defensive fragmentation grenade, designed to be thrown from cover."
	icon_state = "frag"
	item_state = "fraggrenade"
	matter = list(MATERIAL_STEEL = 3, MATERIAL_PLASTEEL = 2, MATERIAL_PLASMA = 1)

	var/fragment_type = /obj/item/projectile/bullet/pellet/fragment
	var/num_fragments = 50  //total number of fragments produced by the grenade
	var/fragment_damage = 15
	var/damage_step = 8      //projectiles lose a fragment each time they travel this distance. Can be a non-integer.
	var/blast_radius = 2// they still create a small , weak blast around

	//The radius of the circle used to launch projectiles. Lower values mean less projectiles are used but if set too low gaps may appear in the spread pattern
	var/spread_range = 7

/obj/item/grenade/frag/prime()
	set waitfor = 0
	..()

	var/turf/O = get_turf(src)
	if(!O) return

	if(num_fragments)
		var/ontop = FALSE
		if(isturf(src.loc))
			for(var/mob/living/M in O)
				ontop = TRUE
				break

		if(!ontop)
			fragment_explosion(O, spread_range, fragment_type, num_fragments, fragment_damage, damage_step)
		else
			fragment_explosion(O, 0, fragment_type, num_fragments, fragment_damage, damage_step)
	if(blast_radius)
		explosion(O, 0, 0, blast_radius, adminlog = "Frag nade explosion", z_transfer = FALSE)

	qdel(src)

/obj/item/grenade/frag/pipebomb
	name = "improvised pipebomb"
	desc = "A jury rigged medium cell filled with plasma. Throw at authorities."
	icon_state = "frag_pipebomb"
	item_state = "fraggrenade_pipebomb"
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTEEL = 2, MATERIAL_PLASMA = 2, MATERIAL_PLASTIC = 3, MATERIAL_SILVER = 2)
	num_fragments = 25
	fragment_damage = 10
	blast_radius = 2
	damage_step = 7

/obj/item/grenade/frag/sting
	name = "FS SG \"Hornet\""
	desc = "A high-grade Frozen Star sting grenade, for use against unruly crowds."
	icon_state = "sting_ih"
	item_state = "fraggrenade"
	fragment_type = /obj/item/projectile/bullet/pellet/fragment/rubber
	num_fragments = 25
	fragment_damage = 5
	blast_radius = 0
	damage_step = 12
	spread_range = 7

/obj/item/grenade/frag/sting/AG
	name = "AG SG \"Mosquito\""
	desc = "A standard-issue Asters Guild sting grenade, for use against unruly crowds."
	icon_state = "sting_ag"
	item_state = "fraggrenade"
	fragment_type = /obj/item/projectile/bullet/pellet/fragment/rubber/weak
	num_fragments = 25
	fragment_damage = 10
	blast_radius = 0
	damage_step = 8
	spread_range = 7
