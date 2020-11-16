/obj/spawner/voidsuit
	name = "random voidsuit"
	icon_state = "armor-blue"
	tags_to_spawn = list(SPAWN_VOID_SUIT)
	has_postspawn = FALSE

/obj/spawner/voidsuit/low_chance
	name = "low chance random voidsuit"
	icon_state = "armor-blue-low"
	spawn_nothing_percentage = 75

/obj/spawner/voidsuit/damaged
	name = "random damaged voidsuit"
	icon_state = "armor-red"
	has_postspawn = TRUE

/obj/spawner/voidsuit/damaged/low_chance
	name = "low chance random damaged voidsuit"
	icon_state = "armor-red-low"
	spawn_nothing_percentage = 75

/obj/spawner/voidsuit/post_spawn(list/spawns)
	for(var/obj/item/clothing/suit/space/void/suit in spawns)
		suit.create_breaches(pick(BRUTE, BURN), rand(10, 50))
