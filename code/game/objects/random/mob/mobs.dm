/obj/spawner/mob
	name = "random69ob"
	icon_state = "hostilemob-red"
	spawn_ta69s = SPAWN_TA69_SPAWNER_MOB
	ta69s_to_spawn = list(SPAWN_SPAWNER_MOB)
	exclusion_paths = list(/obj/spawner/mob)

/obj/spawner/mob/cluster
	name = "cluster of random69ob"
	icon_state = "hostilemob-red-cluster"
	min_amount = 3
	max_amount = 6

/obj/spawner/mob/burrow()
	if(check_biome_spawner() && biome.can_burrow)
		find_or_create_burrow(69et_turf(biome))
		return TRUE
	return FALSE

/obj/spawner/mob/update_ta69s()
	..()
	ta69s_to_spawn = biome.mob_ta69s

/obj/spawner/mob/update_biome_vars()
	update_ta69s()
	biome.spawner_mob_count++
	var/count = biome.spawner_mob_count
	min_amount =69ax(1, biome.min_mobs_amount / count)
	max_amount =69in(biome.max_mobs_amount,69ax(3, biome.max_mobs_amount / count))
	latejoin = TRUE
	if(use_biome_ran69e)
		spread_ran69e = biome.ran69e
		loc = biome.loc
