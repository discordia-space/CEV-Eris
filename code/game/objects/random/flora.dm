/obj/spawner/flora
	name = "random flora"
	icon_state = "nature-purple"
	alpha = 128
	tags_to_spawn = list(SPAWN_FLORA)

/obj/spawner/flora/low_chance
	name = "low chance random flora"
	icon_state = "nature-purple-low"
	spawn_nothing_percentage = 83

/obj/spawner/tree
	name = "random tree"
	icon_state = "nature-purple"
	alpha = 128

/obj/spawner/tree/low_chance
	name = "low chance random tree"
	icon_state = "nature-purple-low"
	spawn_nothing_percentage = 83

/obj/spawner/tree/item_to_spawn()
	return pick(
		/obj/structure/tree,
		/obj/structure/tree/dead)

/obj/spawner/cold_tree
	name = "random cold weather tree"
	icon_state = "nature-purple"
	color = "#5294ff"
	alpha = 128

/obj/spawner/cold_tree/low_chance
	name = "low chance random cold weather tree"
	icon_state = "nature-purple-low"
	spawn_nothing_percentage = 83

/obj/spawner/tree/item_to_spawn()
	return pick(
		/obj/structure/cold_tree/pine,
		/obj/structure/cold_tree/dead)