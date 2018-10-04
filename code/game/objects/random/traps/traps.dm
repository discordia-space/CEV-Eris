/obj/random/traps/item_to_spawn()
	pickweight(list(
	/obj/structure/wire_splicing = 1,
	/obj/item/device/assembly/mousetrap/armed = 1,
	/obj/item/weapon/beartrap/armed = 0.5))

/obj/random/traps/low_chance
	spawn_nothing_percentage = 70

/obj/random/traps/wire_splicing
	name = "wire splicing"
	icon_state = "trap-orange"
	alpha = 128

/obj/random/traps/wire_splicing/item_to_spawn()
	return (/obj/structure/wire_splicing)

/obj/random/traps/wire_splicing/low_chance
	name = "low chance wire splicing"
	icon_state = "trap-orange-low"
	spawn_nothing_percentage = 70
