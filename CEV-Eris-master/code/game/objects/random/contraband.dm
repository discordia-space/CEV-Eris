/obj/spawner/contraband
	name = "random illegal item"
	icon_state = "box-red"
	allow_blacklist = TRUE
	tags_to_spawn = list(SPAWN_CONTRABAND)
	include_paths = list(/obj/spawner/pack/rare)

/obj/spawner/contraband/low_chance
	name = "low chance random illegal item"
	icon_state = "box-red-low"
	spawn_nothing_percentage = 60
