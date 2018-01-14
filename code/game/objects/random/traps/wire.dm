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
