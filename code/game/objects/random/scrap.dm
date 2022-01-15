//RANDOM SCRAP PILE GENERATOR
/obj/spawner/scrap
	name = "Random trash"
	icon_state = "junk-red"
	desc = "This is a random trash."
	spawn_tags = SPAWN_TAG_SPAWNER_SCRAP
	tags_to_spawn = list(SPAWN_SPAWNER_SCRAP)
	exclusion_paths = list(/obj/spawner/scrap)

/obj/spawner/scrap/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothing_percentage = 70
	spawn_blacklisted = TRUE
	spawn_frequency = 0

/obj/spawner/scrap/sparse
	name = "Random sparse trash"
	rarity_value = 5
	tags_to_spawn = list(SPAWN_SCRAP)
	restricted_tags = list(SPAWN_SCRAP_LARGE)

/obj/spawner/scrap/sparse/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothing_percentage = 70
	spawn_blacklisted = TRUE
	spawn_frequency = 0

/obj/spawner/scrap/dense
	name = "Random dense trash"
	rarity_value = 10
	price_tag = 100		// for trade program
	spawn_tags = SPAWN_TAG_SPAWNER_SCRAP_LARGE
	tags_to_spawn = list(SPAWN_SCRAP_LARGE)

/obj/spawner/scrap/dense/low_chance
	name = "low chance random trash"
	icon_state = "junk-red-low"
	spawn_nothing_percentage = 70
	spawn_blacklisted = TRUE
	spawn_frequency = 0

/obj/spawner/scrap/beacon
	name = "Random beacon trash"
	spawn_blacklisted = TRUE
	exclusion_paths = list(/obj/spawner/scrap/beacon)
	restricted_tags = list(SPAWN_SPAWNER_SCRAP_LARGE)
	allow_blacklist = TRUE
	rarity_value = 10

/obj/spawner/scrap/beacon/dense
	name = "Random dense beacon trash"
	tags_to_spawn = list(SPAWN_SCRAP_BEACON)
