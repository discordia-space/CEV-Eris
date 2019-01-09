/obj/random/flora
	name = "random flora"
	icon_state = "nature-purple"
	alpha = 128

//More will be added later, for now just shrooms
/obj/random/flora/item_to_spawn()
	return /obj/effect/spawner/maintshroom/delayed

/obj/random/flora/low_chance
	name = "low chance random flora"
	icon_state = "nature-purple-low"
	spawn_nothing_percentage = 83
