/obj/spawner/boxes
	name = "random box"
	icon_state = "box-blue"
	tags_to_spawn = list(SPAWN_BOX)
	include_paths = list(/obj/spawner/pack/rare)

/obj/spawner/boxes/low_chance
	name = "low chance box"
	icon_state = "box-blue-low"
	spawn_nothing_percentage = 60
