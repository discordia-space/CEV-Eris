/obj/random/voidsuit
	name = "random voidsuit"
	icon_state = "armor-blue"

	var/damaged = FALSE
	has_postspawn = TRUE


/obj/random/voidsuit/item_to_spawn()
	return pickweight(list(/obj/item/clothing/suit/space/void = 2,
		/obj/item/clothing/suit/space/void/engineering = 2,
		/obj/item/clothing/suit/space/void/mining = 2,
		/obj/item/clothing/suit/space/void/medical = 2.3,
		/obj/item/clothing/suit/space/void/security = 1,
		/obj/item/clothing/suit/space/void/atmos = 1.5,
		/obj/item/clothing/suit/space/void/merc = 0.5))

/obj/random/voidsuit/low_chance
	name = "low chance random voidsuit"
	icon_state = "armor-blue-low"
	spawn_nothing_percentage = 80




/obj/random/voidsuit/damaged
	name = "random damaged voidsuit"
	damaged = TRUE
	icon_state = "armor-red"

/obj/random/voidsuit/damaged/low_chance
	name = "low chance random damaged voidsuit"
	icon_state = "armor-red-low"
	spawn_nothing_percentage = 80


/obj/random/voidsuit/post_spawn(var/list/spawns)
	for (var/obj/item/clothing/suit/space/void/suit in spawns)
		new /obj/item/clothing/shoes/magboots(loc)
		if (damaged)
			suit.create_breaches(pick(BRUTE, BURN), rand(10, 50))
