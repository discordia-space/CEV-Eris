/obj/random/powercell
	name = "random powercell"
	icon_state = "battery-green"

/obj/random/powercell/item_to_spawn()
	return pickweight(list(/obj/spawner/powercell/large = 7,\
				/obj/spawner/powercell/medium = 8,\
				/obj/spawner/powercell/small = 10))

/obj/random/powercell/low_chance
	name = "low chance random powercell"
	icon_state = "battery-green-low"
	spawn_nothing_percentage = 60

/obj/spawner/powercell
	name = "random powercell"
	icon_state = "battery-green"
	tags_to_spawn = SPAWN_POWERCELL

/obj/spawner/powercell/small
	name = "random powercell"
	icon_state = "battery-green"
	tags_to_spawn = SPAWN_SMALL_POWERCELL

/obj/spawner/powercell/medium
	name = "random powercell"
	icon_state = "battery-green"
	tags_to_spawn = SPAWN_MEDIUM_POWERCELL

/obj/spawner/powercell/large
	name = "random powercell"
	icon_state = "battery-green"
	tags_to_spawn = SPAWN_LARGE_POWERCELL