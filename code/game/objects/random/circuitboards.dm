/obj/spawner/electronics
	name = "random circuitboard"
	icon_state = "tech-blue"
	tags_to_spawn = list(SPAWN_ELECTRONICS)
	include_paths = list(/obj/spawner/pack/rare)

/obj/spawner/electronics/low_chance
	name = "low chance random circuitboard"
	icon_state = "tech-blue-low"
	spawn_nothing_percentage = 60
