/obj/spawner/lowkeyrandom //Absolutly random things
	name = "random stuff"
	icon_state = "radnomstuff-green"
	tags_to_spawn = list(SPAWN_ITEM)
	top_price = 800
	low_price = 1
	restricted_tags = list(SPAWN_ORE, SPAWN_MATERIAL_RESOURCES)
	include_paths = list(/obj/spawner/pack/rare)

/obj/spawner/lowkeyrandom/low_chance
	name = "low chance random stuff"
	icon_state = "radnomstuff-green-low"
	spawn_nothing_percentage = 60
