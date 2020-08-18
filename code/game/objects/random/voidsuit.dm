/obj/spawner/voidsuit
	name = "random voidsuit"
	icon_state = "armor-blue"
	has_postspawn = TRUE
	tags_to_spawn = list(SPAWN_VOID_SUIT)


/obj/spawner/voidsuit/item_to_spawn()
	return pickweight(list(/obj/item/clothing/suit/space/void = 2,
		/obj/item/clothing/suit/space/void/engineering = 2,
		/obj/item/clothing/suit/space/void/mining = 2,
		/obj/item/clothing/suit/space/void/medical = 2.3,
		/obj/item/clothing/suit/space/void/atmos = 1.5,
		/obj/item/clothing/suit/space/void/merc = 0.2))

/obj/spawner/voidsuit/low_chance
	name = "low chance random voidsuit"
	icon_state = "armor-blue-low"
	spawn_nothing_percentage = 80




/obj/spawner/voidsuit/damaged
	name = "random damaged voidsuit"
	damaged = TRUE
	icon_state = "armor-red"

/obj/spawner/voidsuit/damaged/low_chance
	name = "low chance random damaged voidsuit"
	icon_state = "armor-red-low"
	spawn_nothing_percentage = 80


/obj/spawner/voidsuit/post_spawn(list/spawns)
	for (var/obj/item/clothing/suit/space/void/suit in spawns)
		if (damaged)
			suit.create_breaches(pick(BRUTE, BURN), rand(10, 50))
