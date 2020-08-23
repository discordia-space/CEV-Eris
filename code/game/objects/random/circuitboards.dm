/obj/item/weapon/electronics
	spawn_tags = SPAWN_TAG_ELECTRONICS
	spawn_blacklisted = FALSE
	rarity_value = 20
	spawn_frequency = 10
	bad_types = /obj/item/weapon/electronics

/obj/spawner/electronics
	name = "random circuitboard"
	icon_state = "tech-blue"
	tags_to_spawn = list(SPAWN_ELECTRONICS)

/obj/spawner/electronics/low_chance
	name = "low chance random circuitboard"
	icon_state = "tech-blue-low"
	spawn_nothing_percentage = 60
