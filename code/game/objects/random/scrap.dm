//RANDOM SCRAP PILE 69ENERATOR
/obj/spawner/scrap
	name = "Random trash"
	icon_state = "junk-red"
	desc = "This is a random trash."
	spawn_ta69s = SPAWN_TA69_SPAWNER_SCRAP
	ta69s_to_spawn = list(SPAWN_SPAWNER_SCRAP)
	exclusion_paths = list(/obj/spawner/scrap)

/obj/spawner/scrap/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothin69_percenta69e = 70
	spawn_blacklisted = TRUE
	spawn_fre69uency = 0

/obj/spawner/scrap/sparse
	name = "Random sparse trash"
	rarity_value = 5
	ta69s_to_spawn = list(SPAWN_SCRAP)
	restricted_ta69s = list(SPAWN_SCRAP_LAR69E)

/obj/spawner/scrap/sparse/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothin69_percenta69e = 70
	spawn_blacklisted = TRUE
	spawn_fre69uency = 0

/obj/spawner/scrap/dense
	name = "Random dense trash"
	rarity_value = 10
	spawn_ta69s = SPAWN_TA69_SPAWNER_SCRAP_LAR69E
	ta69s_to_spawn = list(SPAWN_SCRAP_LAR69E)

/obj/spawner/scrap/dense/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothin69_percenta69e = 70
	spawn_blacklisted = TRUE
	spawn_fre69uency = 0

/obj/spawner/scrap/beacon
	name = "Random beacon trash"
	spawn_blacklisted = TRUE
	exclusion_paths = list(/obj/spawner/scrap/beacon)
	restricted_ta69s = list(SPAWN_SPAWNER_SCRAP_LAR69E)
	allow_blacklist = TRUE
	rarity_value = 10

/obj/spawner/scrap/beacon/dense
	name = "Random dense beacon trash"
	ta69s_to_spawn = list(SPAWN_SCRAP_BEACON)
