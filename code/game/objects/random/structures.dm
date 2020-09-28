/obj/spawner/structures
	name = "random structure"
	icon_state = "machine-black"
	tags_to_spawn = list(SPAWN_STRUCTURE)

/obj/spawner/structures/common
	name = "random common structure"
	icon_state = "machine-black"
	tags_to_spawn = list(SPAWN_MACHINE_FRAME, SPAWN_STRUCTURE_COMMON, SPAWN_REAGENT_DISPENSER, SPAWN_SALVAGEABLE)

/obj/spawner/structures/common/low_chance
	name = "low chance random structures"
	icon_state = "machine-black-low"
	spawn_nothing_percentage = 60

/obj/spawner/structures/os
	name = "random os structure"
	allow_blacklist = TRUE
	tags_to_spawn = list(SPAWN_SALVAGEABLE_OS)

