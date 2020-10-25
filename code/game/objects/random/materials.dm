/obj/spawner/material
	name = "random material"
	icon_state = "material-grey"
	tags_to_spawn = list(SPAWN_MATERIAL)
	restricted_tags = list(SPAWN_MATERIAL_JUNK)

/obj/spawner/material/building
	name = "random building material"
	icon_state = "material-grey"
	tags_to_spawn = list(SPAWN_MATERIAL_BUILDING)

/obj/spawner/material/building/low_chance
	name = "low chance random building material"
	icon_state = "material-grey-low"
	spawn_nothing_percentage = 60

/obj/spawner/material/resources
	name = "random resource material"
	icon_state = "material-green"
	tags_to_spawn = list(SPAWN_MATERIAL_RESOURCES)

/obj/spawner/material/resources/low_chance
	name = "low chance random resource material"
	icon_state = "material-green-low"
	spawn_nothing_percentage = 60

/obj/spawner/material/resources/rare
	name = "random rare material"
	icon_state = "material-orange"
	tags_to_spawn = list(SPAWN_MATERIAL_RESOURCES_RARE)

/obj/spawner/material/resources/rare/low_chance
	name = "low chance random rare material"
	icon_state = "material-orange-low"
	spawn_nothing_percentage = 60

/obj/spawner/material/ore
	name = "random ore"
	icon_state = "material-black"
	tags_to_spawn = list(SPAWN_ORE)
	restricted_tags = list()

/obj/spawner/material/ore/low_chance
	name = "low chance random ore"
	icon_state = "material-black-low"
	spawn_nothing_percentage = 60
