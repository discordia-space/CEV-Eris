/obj/spawner/voidsuit
	name = "random69oidsuit"
	icon_state = "armor-blue"
	ta69s_to_spawn = list(SPAWN_VOID_SUIT)
	has_postspawn = FALSE

/obj/spawner/voidsuit/low_chance
	name = "low chance random69oidsuit"
	icon_state = "armor-blue-low"
	spawn_nothin69_percenta69e = 75

/obj/spawner/voidsuit/dama69ed
	name = "random dama69ed69oidsuit"
	icon_state = "armor-red"
	has_postspawn = TRUE

/obj/spawner/voidsuit/dama69ed/low_chance
	name = "low chance random dama69ed69oidsuit"
	icon_state = "armor-red-low"
	spawn_nothin69_percenta69e = 75

/obj/spawner/voidsuit/post_spawn(list/spawns)
	for(var/obj/item/clothin69/suit/space/void/suit in spawns)
		suit.create_breaches(pick(BRUTE, BURN), rand(10, 50))

/obj/spawner/armor_parts
	name = "random armor part"
	icon_state = "armor-black"
	ta69s_to_spawn = list(SPAWN_PART_ARMOR)

/obj/spawner/armor_parts/low_chance
	name = "low chance armor 69un part"
	icon_state = "69un-black-low"
	spawn_nothin69_percenta69e = 75
