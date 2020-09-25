/obj/spawner/lowkeyrandom //Absolutly random things
	name = "random stuff"
	icon_state = "radnomstuff-green"
	tags_to_spawn = list(SPAWN_ITEM)
	top_price = 500
	low_price = 10
	restricted_tags = list(SPAWN_ORE, SPAWN_MATERIAL_RESOURCES)

// /obj/item/clothing/accessory/badge/marshal = 0.1, //Antag item //recuerda esto

/obj/spawner/lowkeyrandom/low_chance
	name = "low chance random stuff"
	icon_state = "radnomstuff-green-low"
	spawn_nothing_percentage = 60
