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
	var/explosion_power = 100
	var/explosion_falloff = 40

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
	if(explosion_power)
		explosion(O, explosion_power, explosion_falloff, adminlog = "Frag nade explosion")

	qdel(src)

/obj/item/grenade/frag/pipebomb
	name = "improvised pipebomb"
	desc = "A jury rigged medium cell filled with plasma. Throw at authorities."
	icon_state = "frag_pipebomb"
	item_state = "fraggrenade_pipebomb"
	matter = list(MATERIAL_STEEL = 2, MATERIAL_PLASTEEL = 2, MATERIAL_PLASMA = 2, MATERIAL_PLASTIC = 3, MATERIAL_SILVER = 2)
	num_fragments = 25
	fragment_damage = 10
	damage_step = 7

/obj/item/grenade/frag/sting
	name = "FS SG \"Hornet\""
	desc = "A high-grade Frozen Star sting grenade, for use against unruly crowds."
	icon_state = "sting_ih"
	item_state = "fraggrenade"
	fragment_type = /obj/item/projectile/bullet/pellet/fragment/rubber
	num_fragments = 25
	fragment_damage = 5
	explosion_power = 0
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
	explosion_power = 0
	damage_step = 8
	spread_range = 7

/obj/item/grenade/frag/white_phosphorous
	name = "SA WPG \"Sabac \""
	desc = "A modernized incendiary hailing popular use within assault troops of all kinds. Use with care, highly flammable."
	icon_state = "white_phos"
	item_state = "fraggrenade"
	fragment_type = /obj/item/projectile/bullet/pellet/fragment/ember
	num_fragments = 10
	fragment_damage = 5
	explosion_power = 0
	damage_step = 5
	spread_range = 7
	var/datum/effect/effect/system/smoke_spread/white_phosphorous/smoke

/obj/item/grenade/frag/white_phosphorous/prime()
	playsound(loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	smoke.set_up(5, 0, usr.loc)
	smoke.set_up(5, 0, get_turf(loc))
	smoke.start()
	..()

/obj/item/grenade/frag/white_phosphorous/New()
	..()
	smoke = new
	smoke.attach(src)

/obj/item/grenade/frag/white_phosphorous/Destroy()
	qdel(smoke)
	smoke = null
	return ..()
